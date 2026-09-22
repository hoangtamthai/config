---
name: tinyfish-lite
description: ALWAYS Use TinyFish for WEB search and fetching URLs. Use whenever the user asks to search, find, look up, research, fetch page content, or get information from the web.
---

# TinyFish Lite

TinyFish Lite provides web search and URL fetching without browser automation. For agent/browser control, use the `use-tinyfish` skill.

If not installed: `npm install -g @tiny-fish/cli`
If not authenticated: `tinyfish auth login --source openclaw` or set `TINYFISH_API_KEY` env var.

---

## When This Skill Should Trigger

Use TinyFish Lite for:

- **Search**: find URLs, current facts, docs, pricing, product details, news, research, comparisons.
- **Fetch**: read, summarize, extract content from known URLs.

Do NOT use for page interaction (clicking, forms, navigation) — use `use-tinyfish` instead.

---

## Tools

| Tool | When to use |
|------|-------------|
| **search** | Find URLs, facts, docs, pricing, comparisons, source-backed answers |
| **fetch** | Read clean content from known URLs |

Escalation path for this skill: **search → fetch**. For dynamic/interactive pages, escalate to `use-tinyfish`.

---

## Commands

### `tinyfish search query`

Web search. Returns ranked results with titles, URLs, and snippets.

```bash
tinyfish search query "<query>" [--location <hint>] [--language <hint>] [--pretty]
```

- Returns 10 results by default
- Use `--location` and `--language` for geo-targeted results
- Default output is JSON; `--pretty` for human-readable

```bash
tinyfish search query "best pho in Ho Chi Minh City" --location "Vietnam" --language "en"
```

### `tinyfish fetch content get`

Fetch clean, extracted content from one or more URLs. Strips ads, nav, boilerplate.

```bash
tinyfish fetch content get <urls...> [--format markdown|html|json] [--links] [--image-links] [--pretty]
```

- Accepts **multiple URLs** in parallel server-side
- `--format markdown` (default) — clean readable text
- `--format json` — structured document tree
- `--links` — include extracted links
- `--image-links` — include extracted image URLs

```bash
tinyfish fetch content get --format markdown "https://example.com/article"
tinyfish fetch content get --links "https://site-a.com" "https://site-b.com"
```

---

## Common Patterns

**Research: search → fetch**
Search for a topic, then fetch the best results for full content.

```bash
# 1. Find URLs
tinyfish search query "best React state management libraries 2026"

# 2. Read top results
tinyfish fetch content get --format markdown "https://result1.com" "https://result2.com"
```

---

## General Notes

- **Match the user's language**: Respond in whatever language the user writes.
- All commands support `--pretty` for human-readable output. Default is JSON.
- Use `--debug` on the root command or set `TINYFISH_DEBUG=1` to log HTTP requests to stderr.
- For browser automation, agent run, or browser sessions, use the `use-tinyfish` skill.
