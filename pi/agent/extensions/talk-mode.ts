import type {
  ExtensionAPI,
  ExtensionContext,
} from "@earendil-works/pi-coding-agent";

const STATUS_KEY = "talk-mode";
const SHORTCUT = "shift-tab";
const COMMAND = "talk";

const TALK_MODE_PROMPT = `

[TALK MODE ACTIVE]

You are in Talk mode.

Purpose of Talk mode:
- Help the user think, discuss, and reason before acting.
- Answer questions directly.
- Evaluate tradeoffs and technical decisions.
- Research and inspect the codebase when useful.
- Help design an approach or make a plan.
- Review possible changes without applying them.
- Slow down implementation pressure and avoid jumping straight to code.

Hard restriction:
- Talk mode is not implementation mode.
- Do not edit, create, delete, move, or write files.
- Do not use edit or write tools.
- Do not run commands that modify files, git state, dependencies, services, or system state.
- Do not create temporary scripts, scratch files, or research files.
- Do not apply changes even if the user explicitly asks for a small tweak or direct implementation.
- If the user asks you to implement, modify, fix, apply, update, create, delete, or write something, tell them Talk mode is active and they need to disable Talk mode first.

Allowed:
- Read files.
- Search the codebase.
- Run read-only inspection commands.
- Analyze behavior.
- Explain options.
- Propose exact changes in prose.
- Provide patch snippets or code snippets for discussion only, without applying them.
- Make plans when requested.

Do not force a formal plan unless the user asks for one.`;

let enabled = false;
export default function talkModeExtension(pi: ExtensionAPI): void {
  function updateStatus(ctx: ExtensionContext): void {
    if (enabled) {
      ctx.ui.setStatus(STATUS_KEY, ctx.ui.theme.fg("accent", "talk"));
    } else {
      ctx.ui.setStatus(STATUS_KEY, undefined);
    }
    pi.events.emit("talk-mode:changed", enabled);
  }

  pi.registerCommand(COMMAND, {
    description: "Toggle Talk mode",
    handler: async (args, ctx) => {
      enabled = !enabled;
      updateStatus(ctx);
      ctx.ui.notify(enabled ? "[Talk]" : "[Not talk]", "info");
    },
  });

  pi.on("session_start", async (_event, ctx) => {
    updateStatus(ctx);
  });

  pi.on("before_agent_start", async (event) => {
    if (!enabled) return;
    return {
      systemPrompt: event.systemPrompt + TALK_MODE_PROMPT,
    };
  });
}
