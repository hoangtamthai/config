---
name: ketch-lite
description: Research public web sources with Ketch with web search, OSS code, library / code docs, URL scraping, site crawling, and saved sources. Not for local/private repos or authenticated pages.
---

# Ketch

Use Ketch for live public-source research. Prefer the fewest calls that answer the question.

## Route

- `search` — discover current web sources.
- `code` — find real usage in public OSS.
- `docs` — query library documentation.
- `scrape` — read known URLs.
- `crawl` — read multiple pages from one site.
- `tag` — reuse previously found sources.

Use Ketch MCP tools when available; otherwise use the CLI with `--json`. System/configuration operations remain CLI-only. The installed binary and `ketch config` outrank this skill.

## Rules

1. Bound unknown page fetches with `max_chars: 4000–8000` and `trim`. Bound crawls by pages/depth.
2. Prefer primary sources. Cite URLs for claims derived from research.
3. Inspect per-URL results from batch operations; individual fetches can fail inside a successful batch.
4. For `docs`, resolve the library, verify the match, then fetch it.
5. Do not repeat a search when you already have the URL or a useful tagged source.
6. Treat failures by their Ketch error class rather than blindly retrying.

For contested, multi-part, or explicitly deep research, read `references/verbs/ketch-research.md`.

For installation, missing configuration, or `[precondition]`, read `references/verbs/setup.md`. Propose mutations before applying them.

For exact flags, backends, errors, cache/tag behavior, or unusual surface behavior, read `references/surfaces.md`.

Do not load references unless the current branch needs them.

## Completion criterion

Done when the requested research is answered from appropriate sources, fetches were bounded, relevant failures are disclosed, and research claims are traceable to source URLs.

## Help page

> ketch -h

ketch is a blazing fast CLI for agentic search and scrape workflows. Search the web, scrape pages to clean markdown, or do both in one shot.

Usage:
ketch [flags]
ketch [command]

Available Commands:
browser Manage browser for JS-rendered page support
cache Show cache stats
code Search code across open-source repositories
completion Generate the autocompletion script for the specified shell
config Show or manage configuration
crawl Crawl a site and extract pages
docs Search library documentation
doctor Check the health of every backend, the browser, and the cache
extract Convert piped HTML to clean markdown
help Help about any command
mcp Run ketch as an MCP (Model Context Protocol) server
scrape Scrape URLs and extract clean markdown
search Search the web and return results
tag Bookmark research sources for later sessions
version Print ketch version information

Flags:
-h, --help help for ketch
--json output as JSON
-v, --version version for ketch

Use "ketch [command] --help" for more information about a command.
