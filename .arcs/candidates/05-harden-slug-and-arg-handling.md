# harden-slug-and-arg-handling
from: 23-roast-arcs-method-and-cli

Input handling sweep: slugify on creation (new-arc/new-goal/candidate) - spaces/'/' break globs; escape supersede's raw sed (corrupts arc.md on &|\); ${2:-} guards for -g sites under set -u; guard 'shift 2' under set -e.
