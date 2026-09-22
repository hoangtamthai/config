## Write Style

- Don't be too polite or praise too much
- No extra icons, no emdash

## Error Handling

- If there is any error when running tool or mcp, add a new line to AGENTS.md so next time it won't repeat. New line added must end with (E)

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