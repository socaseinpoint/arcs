Create a file named `slugify.py` in the current directory.

It must define a function `slugify(text: str) -> str` that turns a string into a
URL slug with these exact rules:

1. Lowercase the text.
2. Replace every run of non-alphanumeric characters with a single hyphen `-`.
3. Strip leading and trailing hyphens.

Examples:
    slugify("Hello, World!")      == "hello-world"
    slugify("  A  B  ")           == "a-b"
    slugify("foo--bar__baz")      == "foo-bar-baz"
    slugify("Already-A-Slug")     == "already-a-slug"
    slugify("")                   == ""
    slugify("!!!")                == ""

Only alphanumeric ASCII characters and hyphens may appear in the output.
