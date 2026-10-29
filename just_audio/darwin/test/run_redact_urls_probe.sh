#!/bin/bash
# Proves DLCTRedactUrls (just_audio/Sources/just_audio/AudioPlayer.m) — the
# function that strips URLs, which can carry a signed access token, from the
# exception reason handleMethodCall reports. It compiles the function as it is
# in AudioPlayer.m (extracted, never copied) and runs it on fixed cases.
# Exit 0 = every case passed · 1 = a case failed · 2 = could not run (no clang,
# or the function is missing from AudioPlayer.m).
set -u
here="$(cd "$(dirname "$0")" && pwd)"
source_file="$here/../just_audio/Sources/just_audio/AudioPlayer.m"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

command -v clang >/dev/null 2>&1 || { echo "COULD NOT VERIFY — clang not found"; exit 2; }
awk '/^static NSString \*DLCTRedactUrls/,/^}/' "$source_file" > "$work/fn.inc"
grep -q 'DLCTRedactUrls' "$work/fn.inc" || { echo "COULD NOT VERIFY — DLCTRedactUrls not found in AudioPlayer.m"; exit 2; }

cp "$here/redact_urls_probe.m" "$work/probe.m"
clang -fobjc-arc -framework Foundation "$work/probe.m" -o "$work/probe" || { echo "COULD NOT VERIFY — the probe did not compile"; exit 2; }
"$work/probe" || exit 1
