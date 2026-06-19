# release-culture-and-checks
from: 23-roast-arcs-method-and-cli

Release culture: RELEASING.md + release-check script asserting VERSION == CHANGELOG-top == tag and CHANGELOG footer compare-links present. Update subsystem fixes: breaking floor read from tag not branch HEAD, don't stamp throttle on offline fetch, resolve default branch vs hardcoded origin/main, surface install.sh failures in 'arcs update'.
