# checklist-key-dots-break-matching
from: 02-cut-release-0.2.0

Checklist item key + closes: value don't round-trip when the key contains dots (e.g. 0.2.0): slugify maps 0.2.0 -> 0-2-0 and the '—' split appears to miss, so closes: cut-release-0.2.0 never matches the computed item key. Normalize both sides identically (slugify closes: the same way, or forbid/normalize dots in keys). Found dogfooding the 0.2.0 release.
