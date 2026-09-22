// One-line tool rendering (pi-oneline-tools)
//
// Re-registers the built-in read/grep/find/ls/bash tools with
// `renderShell: "self"` and a one-line renderCall/renderResult, so a turn full
// of lookups stays one line per lookup instead of a screen of boxes. Expanding
// a row (ctrl+o) puts the full output back under the summary line.
//
// Because this replaces the builtin tool *definitions*, it conflicts with any
// other extension that overrides the same five tools; the last one loaded wins.

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import {
  createReadTool,
  createBashTool,
  createLsTool,
  createGrepTool,
  createFindTool,
  ToolExecutionComponent,
} from "@earendil-works/pi-coding-agent";
import { Container, Text, type Component } from "@earendil-works/pi-tui";
import path from "path";
import { Type, type TSchema } from "typebox";

// ── helpers ─────────────────────────────────────────────────────────────────

const cwd = process.cwd();

/**
 * The renderer contract, structurally. Pi's own types are not imported because
 * these are the only three shapes this file touches, and spelling them out
 * keeps the helper below independent of which of them pi exports.
 */
type RenderOptions = { expanded?: boolean; isPartial?: boolean };
type ThemeLike = { fg(style: string, text: string): string };
type ToolResultLike = { content?: unknown; isError?: boolean };
type RenderContextLike = { state?: RowRenderState };
type RowRenderState = { pending?: HideableText };

type ToolWithParameters = { parameters: { properties?: Record<string, TSchema> } };
type ContainerRender = (this: Container, width: number) => string[];
type SpacingPatch = {
  originalRender: ContainerRender;
  patchedRender: ContainerRender;
  users: number;
};

const ONE_LINE_TOOL_NAMES = new Set(["read", "grep", "find", "ls", "bash"]);
const SPACING_PATCH = Symbol.for("pi-oneline-tools.spacing-patch");

function oneLineToolName(component: Component): string | undefined {
  if (!(component instanceof ToolExecutionComponent)) return undefined;
  const name = (component as unknown as { toolName?: unknown }).toolName;
  return typeof name === "string" && ONE_LINE_TOOL_NAMES.has(name) ? name : undefined;
}

/**
 * Pi's self-rendering tool shell always prepends one blank line to every tool.
 * Group adjacent one-line rows by removing that line when the previous visible
 * sibling is the same tool. A different tool (or any visible non-tool content)
 * keeps the normal separator.
 *
 * Container has no per-instance renderer hook, so this is a small, ref-counted
 * prototype patch. Ref-counting keeps duplicate extension loads and /reload
 * teardown safe.
 */
function installGroupedToolSpacing(): () => void {
  const prototype = Container.prototype as Container & Record<symbol, unknown>;
  let patch = prototype[SPACING_PATCH] as SpacingPatch | undefined;

  if (!patch) {
    const originalRender = Container.prototype.render as ContainerRender;
    const patchedRender: ContainerRender = function (width) {
      const lines: string[] = [];
      let previousToolName: string | undefined;

      for (const child of this.children) {
        let childLines = child.render(width);
        const toolName = oneLineToolName(child);

        if (toolName && childLines.length > 0) {
          if (toolName === previousToolName && childLines[0] === "") {
            childLines = childLines.slice(1);
          }
          previousToolName = toolName;
        } else if (childLines.length > 0) {
          previousToolName = undefined;
        }

        lines.push(...childLines);
      }

      return lines;
    };

    patch = { originalRender, patchedRender, users: 0 };
    Object.defineProperty(prototype, SPACING_PATCH, {
      configurable: true,
      value: patch,
    });
    Container.prototype.render = patchedRender;
  }

  patch.users++;
  let installed = true;
  return () => {
    if (!installed) return;
    installed = false;
    patch.users--;
    if (patch.users === 0) {
      if (Container.prototype.render === patch.patchedRender) {
        Container.prototype.render = patch.originalRender;
      }
      delete prototype[SPACING_PATCH];
    }
  };
}

/**
 * Pi renders the call and result as two sibling slots. Keep the pending call in
 * the tree so it is visible while the tool runs, then hide it as soon as the
 * result slot renders. Otherwise completed tools show both `read path...` and
 * `read path (N lines)`.
 */
class HideableText extends Text {
  hidden = false;

  override render(width: number): string[] {
    return this.hidden ? [] : super.render(width);
  }
}

function rowState(context: RenderContextLike): RowRenderState {
  return (context.state ??= {});
}

function renderPendingRow(
  summary: string,
  theme: ThemeLike,
  context: RenderContextLike,
): HideableText {
  const state = rowState(context);
  const row = state.pending ?? new HideableText("", 0, 0);
  row.hidden = false;
  row.setText(theme.fg("dim", summary));
  state.pending = row;
  return row;
}

function withOptionalBashReason<T extends ToolWithParameters>(tool: T) {
  return {
    ...tool,
    parameters: Type.Object({
      ...(tool.parameters.properties ?? {}),
      reason: Type.Optional(
        Type.String({
          description:
            "One concise plain-language sentence explaining why this command needs approval and what it is expected to accomplish. Omit this for auto-approved commands.",
          minLength: 1,
          maxLength: 160,
        }),
      ),
    }),
  };
}

function compactPath(p: string): string {
  const resolved = path.resolve(cwd, p);
  return path.relative(cwd, resolved) || ".";
}

function textBlocks(content: unknown): string[] {
  if (!Array.isArray(content)) return [];
  const blocks: string[] = [];
  for (const block of content) {
    if (
      typeof block === "object" &&
      block !== null &&
      (block as Record<string, unknown>).type === "text" &&
      typeof (block as Record<string, unknown>).text === "string"
    ) {
      blocks.push((block as { text: string }).text);
    }
  }
  return blocks;
}

function countLines(content: unknown): number {
  const first = textBlocks(content)[0];
  return first === undefined ? 0 : first.split("\n").length;
}

function shortCmd(command: string, maxLen = 35): string {
  const firstLine = command.split("\n")[0]!.trim();
  if (firstLine.length <= maxLen) return firstLine;
  return firstLine.slice(0, maxLen - 3) + "...";
}

function arg(context: { args?: unknown } | undefined, name: string, fallback: string): string {
  const args = context?.args as Record<string, unknown> | undefined;
  return String(args?.[name] ?? fallback);
}

/**
 * The summary line, plus the tool's own output underneath it when expanded.
 *
 * The full output is reproduced here rather than delegated to the builtin
 * renderer because there is nothing to delegate to: the builtin tool
 * definitions carry no `renderResult` at all (pi renders results without one
 * generically, in tool-execution.ts), and pi uses *our* renderer
 * unconditionally once we define it. Delegating would render an empty
 * component, i.e. expanding a row would make it disappear.
 */
function renderRow(
  summary: string,
  result: ToolResultLike,
  options: RenderOptions,
  theme: ThemeLike,
  context: RenderContextLike,
): Text {
  const pending = rowState(context).pending;
  if (pending) pending.hidden = true;
  const line = theme.fg(result.isError ? "error" : "dim", summary);
  if (!options.expanded) return new Text(line, 0, 0);
  const body = textBlocks(result.content).join("\n");
  return new Text(body === "" ? line : `${line}\n${body}`, 0, 0);
}

// ── wiring ──────────────────────────────────────────────────────────────────

export default function (pi: ExtensionAPI) {
  const restoreToolSpacing = installGroupedToolSpacing();
  pi.on("session_shutdown", restoreToolSpacing);

  // ═══════════════════════════════════════════════════════════════════════════
  //  read — compact, no box
  // ═══════════════════════════════════════════════════════════════════════════
  pi.registerTool({
    ...createReadTool(cwd),
    renderShell: "self",
    renderCall(args, theme, context) {
      const p = compactPath(String((args as Record<string, unknown>).path ?? "?"));
      return renderPendingRow(`read ${p}...`, theme, context);
    },
    renderResult(result, options, theme, context) {
      const p = compactPath(arg(context, "path", "?"));
      const lines = countLines(result.content);
      const suffix = result.isError ? `— error (${lines} lines)` : `(${lines} lines)`;
      return renderRow(`read ${p} ${suffix}`, result, options, theme, context);
    },
  });

  // ═══════════════════════════════════════════════════════════════════════════
  //  grep — compact, no box
  // ═══════════════════════════════════════════════════════════════════════════
  pi.registerTool({
    ...createGrepTool(cwd),
    renderShell: "self",
    renderCall(args, theme, context) {
      const pattern = String((args as Record<string, unknown>).pattern ?? "?");
      return renderPendingRow(`grep "${pattern}"...`, theme, context);
    },
    renderResult(result, options, theme, context) {
      const pattern = arg(context, "pattern", "?");
      const lines = countLines(result.content);
      const suffix = result.isError ? `— error (${lines} lines)` : `(${lines} matches)`;
      return renderRow(`grep "${pattern}" ${suffix}`, result, options, theme, context);
    },
  });

  // ═══════════════════════════════════════════════════════════════════════════
  //  find — compact, no box
  // ═══════════════════════════════════════════════════════════════════════════
  pi.registerTool({
    ...createFindTool(cwd),
    renderShell: "self",
    renderCall(args, theme, context) {
      const pattern = String((args as Record<string, unknown>).pattern ?? "?");
      return renderPendingRow(`find "${pattern}"...`, theme, context);
    },
    renderResult(result, options, theme, context) {
      const pattern = arg(context, "pattern", "?");
      const lines = countLines(result.content);
      const suffix = result.isError ? `— error (${lines} lines)` : `(${lines} matches)`;
      return renderRow(`find "${pattern}" ${suffix}`, result, options, theme, context);
    },
  });

  // ═══════════════════════════════════════════════════════════════════════════
  //  ls — compact, no box
  // ═══════════════════════════════════════════════════════════════════════════
  pi.registerTool({
    ...createLsTool(cwd),
    renderShell: "self",
    renderCall(args, theme, context) {
      const p = compactPath(String((args as Record<string, unknown>).path ?? "."));
      return renderPendingRow(`ls ${p}...`, theme, context);
    },
    renderResult(result, options, theme, context) {
      const p = compactPath(arg(context, "path", "."));
      const lines = countLines(result.content);
      const suffix = result.isError ? `— error (${lines} lines)` : `(${lines} entries)`;
      return renderRow(`ls ${p} ${suffix}`, result, options, theme, context);
    },
  });

  // ═══════════════════════════════════════════════════════════════════════════
  //  bash — compact, no box
  //
  // Keep pi-plan's optional approval reason in this override. Pi-plan checks
  // the final bash schema at session start and leaves this renderer intact when
  // that field is present.
  // ═══════════════════════════════════════════════════════════════════════════
  pi.registerTool({
    ...withOptionalBashReason(createBashTool(cwd)),
    renderShell: "self",
    renderCall(args, theme, context) {
      const cmd = String((args as Record<string, unknown>).command ?? "bash");
      return renderPendingRow(`${shortCmd(cmd)}...`, theme, context);
    },
    renderResult(result, options, theme, context) {
      const cmd = arg(context, "command", "bash");
      const lines = countLines(result.content);
      const suffix = result.isError ? `— error (${lines} lines)` : `(${lines} lines)`;
      return renderRow(`${shortCmd(cmd)} ${suffix}`, result, options, theme, context);
    },
  });
}
