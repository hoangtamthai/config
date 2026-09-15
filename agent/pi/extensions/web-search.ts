import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

interface SearchResult {
  title: string;
  url: string;
  content: string;
}

interface OllamaSearchResponse {
  results: SearchResult[];
}

function getOllamaHost(): string {
  return process.env.OLLAMA_HOST || "http://localhost:11434";
}

async function ollamaSearch(
  pi: ExtensionAPI,
  query: string,
  numResults: number = 10
): Promise<SearchResult[]> {
  const host = getOllamaHost();

  const response = await pi.exec("curl", [
    "-s",
    "-L",
    "-X", "POST",
    "-H", "Content-Type: application/json",
    "-d", JSON.stringify({
      query,
      max_results: numResults,
    }),
    `${host}/api/experimental/web_search`
  ], { timeout: 60000 });

  if (response.code !== 0) {
    throw new Error(`Search error (code ${response.code}): ${response.stderr || "Unknown error"}`);
  }

  if (!response.stdout || response.stdout.trim() === "") {
    throw new Error("Empty response from search API");
  }

  try {
    const result = JSON.parse(response.stdout) as OllamaSearchResponse;
    if (!result.results || !Array.isArray(result.results)) {
      throw new Error("Unexpected response format from search API");
    }
    return result.results;
  } catch (e) {
    if (e instanceof SyntaxError) {
      throw new Error(`Failed to parse search response: ${response.stdout.substring(0, 500)}`);
    }
    throw e;
  }
}

function formatSearchResults(results: SearchResult[], query: string): string {
  return results.map((r, i) => {
    const snippet = r.content ? r.content.substring(0, 300) : "";
    return `${i + 1}. **${r.title}**\n   🔗 ${r.url}\n   ${snippet ? `   📝 ${snippet}` : ""}`;
  }).join("\n\n");
}

export default function (pi: ExtensionAPI) {
  // Main web search command
  pi.registerCommand("web-search", {
    description: "Web search using Ollama's built-in web search. Usage: /web-search <query> [numResults]",
    handler: async (args, ctx) => {
      const parts = args.trim().split(" ");
      let numResults = 10;

      const lastArg = parts[parts.length - 1];
      if (/^\d+$/.test(lastArg)) {
        numResults = Math.min(parseInt(lastArg, 10), 20);
        parts.pop();
      }

      const query = parts.join(" ");

      if (!query) {
        ctx.ui.notify("Usage: /web-search <search query> [numResults]", "error");
        return;
      }

      try {
        const results = await ollamaSearch(pi, query, numResults);
        if (results.length === 0) {
          pi.sendMessage({
            customType: "web-search",
            content: `No results found for: "${query}"`,
            display: true,
          });
          return;
        }
        pi.sendMessage({
          customType: "web-search",
          content: `🔍 **Search results for "${query}"**\n\n${formatSearchResults(results, query)}`,
          display: true,
        });
      } catch (error) {
        ctx.ui.notify(
          `Search failed: ${error instanceof Error ? error.message : "Unknown error"}`,
          "error"
        );
      }
    }
  });

  // Alias: ws
  pi.registerCommand("ws", {
    description: "Quick web search (alias for /web-search). Usage: /ws <query>",
    handler: async (args, ctx) => {
      const query = args.trim();
      if (!query) {
        ctx.ui.notify("Usage: /ws <search query>", "error");
        return;
      }
      try {
        const results = await ollamaSearch(pi, query, 5);
        if (results.length === 0) {
          pi.sendMessage({
            customType: "web-search",
            content: `No results found for: "${query}"`,
            display: true,
          });
          return;
        }
        pi.sendMessage({
          customType: "web-search",
          content: `🔍 **Results for "${query}"**\n\n${formatSearchResults(results, query)}`,
          display: true,
        });
      } catch (error) {
        ctx.ui.notify(
          `Search failed: ${error instanceof Error ? error.message : "Unknown error"}`,
          "error"
        );
      }
    }
  });

  // Deep research command
  pi.registerCommand("deep", {
    description: "Deep web research (more results). Usage: /deep <query>",
    handler: async (args, ctx) => {
      const query = args.trim();
      if (!query) {
        ctx.ui.notify("Usage: /deep <search query>", "error");
        return;
      }
      try {
        const results = await ollamaSearch(pi, query, 20);
        if (results.length === 0) {
          pi.sendMessage({
            customType: "web-search",
            content: `No results found for: "${query}"`,
            display: true,
          });
          return;
        }
        pi.sendMessage({
          customType: "web-search",
          content: `🔍 **Deep search results for "${query}"**\n\n${formatSearchResults(results, query)}`,
          display: true,
        });
      } catch (error) {
        ctx.ui.notify(
          `Deep search failed: ${error instanceof Error ? error.message : "Unknown error"}`,
          "error"
        );
      }
    }
  });

  // Fast search command
  pi.registerCommand("fast", {
    description: "Quick web search (fewer results, lower latency). Usage: /fast <query>",
    handler: async (args, ctx) => {
      const query = args.trim();
      if (!query) {
        ctx.ui.notify("Usage: /fast <search query>", "error");
        return;
      }
      try {
        const results = await ollamaSearch(pi, query, 5);
        if (results.length === 0) {
          pi.sendMessage({
            customType: "web-search",
            content: `No results found for: "${query}"`,
            display: true,
          });
          return;
        }
        pi.sendMessage({
          customType: "web-search",
          content: `🔍 **Fast results for "${query}"**\n\n${formatSearchResults(results, query)}`,
          display: true,
        });
      } catch (error) {
        ctx.ui.notify(
          `Fast search failed: ${error instanceof Error ? error.message : "Unknown error"}`,
          "error"
        );
      }
    }
  });

  // Help command
  pi.registerCommand("help-search", {
    description: "Show web search help",
    handler: async (_args, ctx) => {
      pi.sendMessage({
        customType: "web-search",
        content: `🔍 **Web Search Commands**

Available commands:
- \`/web-search <query> [num]\` - Search the web (default 10 results)
- \`/ws <query>\` - Quick search (5 results)
- \`/fast <query>\` - Fast search (5 results, lower latency)
- \`/deep <query>\` - Deep research (20 results)
- \`/help-search\` - Show this help

Examples:
  /web-search react hooks best practices
  /web-search python tutorials 5
  /ws javascript array methods
  /deep machine learning trends
  /fast how to center div

Powered by Ollama's web search API (no API key needed)`,
        display: true,
      });
    }
  });
}
