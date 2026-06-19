# Ask

User: a closed arc should have a file in output/ describing what was done — `arcs close`
should require it, not just rename.

Verbatim (ru): "если арка закрыта то в output должен быть как будто бы файл рассказывающий
что сделано, не?"

## Why it matters
The method's core: an arc closes with a **self-contained `output/`** (the public interface).
Closing an arc with an empty `output/` violates encapsulation — the next step / another
agent has nothing to read. The CLI must guard this.

## Design
- `arcs close` refuses when `output/` is empty: clear error telling the user to write the
  result first. Override with `-f` / `--force` for the rare intentional case.
- Document the guard in skill + spec (close = write output/ then close).
