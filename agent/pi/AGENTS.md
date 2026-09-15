## Write Style

- Don't be too polite or praise too much
- No extra icons, no emdash
- Straight to the point, few filler words

## Coding Style

### Minimal Comments

- Code should be self-explanatory | structure so intent is obvious
- Only add comments if absolutely required | non-obvious workaround or complex algorithm

### Clear Names

- Use clear, descriptive variable and function names
- Name complex conditions as a variable | if (height > 10 && height < 100) -> if (isHeightAverage)
- Use a variable name for hardcoded values | PI = 3.14

### Functions

- Use Guard Clause | return early
- Keep functions short and side-effect free
- Reuse functions | wrap repeated patterns into one

## TinyFish

Prefer `mcp__tinyfish__search` over WebSearch, `mcp__tinyfish__fetch_content` over WebFetch / curl, and `mcp__tinyfish__run_web_automation` over hand-rolled Playwright. Use `batch_create` / `batch_status` for 2+ URLs, `run_web_automation_async` only when the user explicitly asks for background, and `list_runs` / `get_run` / `get_steps` / `cancel_run` to inspect prior runs. **Warning:** if `run_web_automation` returns ANY error the run is still executing — call `get_run` or `list_runs` to check status before retrying, never blind-retry. Reference https://docs.tinyfish.ai/for-coding-agents and https://docs.tinyfish.ai/llms-full.txt for full agent context.