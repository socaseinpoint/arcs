Create a file named `balanced.py` in the current directory.

It must define a function `is_balanced(s: str) -> bool` that returns whether the
brackets in `s` are balanced and correctly nested. Three bracket pairs matter:
`()`, `[]`, `{}`. Any other character is ignored.

Examples:
    is_balanced("(a[b]{c})")  == True
    is_balanced("{[()]}")     == True
    is_balanced("")           == True
    is_balanced("(]")         == False
    is_balanced("(()")        == False
    is_balanced(")(")         == False
    is_balanced("([)]")       == False
