#!/usr/bin/env bash
# Compile every `tests/*/test.typ` to SVG under `tests/*/out/`.
#
# Usage:
#   ./tests/run.sh             # compile all tests
#   ./tests/run.sh bus wire    # compile only specified suites
#
# Exits non-zero if any test fails to compile. Prints a summary at the end.
set -u

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
COMPILER="${COMPILER:-$ROOT/../tsc.js}"  # override with COMPILER=... to use another wrapper

if [ ! -x "$(command -v node)" ]; then
  echo "error: node is required" >&2
  exit 1
fi

if [ ! -f "$COMPILER" ]; then
  # Fall back to `typst` CLI if the node wrapper isn't present.
  if command -v typst >/dev/null 2>&1; then
    use_typst_cli=1
  else
    echo "error: neither $COMPILER nor typst CLI is available" >&2
    exit 1
  fi
else
  use_typst_cli=0
fi

# Collect suites to run.
suites=()
if [ $# -gt 0 ]; then
  for s in "$@"; do suites+=("$s"); done
else
  for d in "$SCRIPT_DIR"/*/; do
    name="$(basename "$d")"
    if [ -f "$d/test.typ" ]; then suites+=("$name"); fi
  done
fi

fail=0
pass=0
for s in "${suites[@]}"; do
  in="$SCRIPT_DIR/$s/test.typ"
  out_dir="$SCRIPT_DIR/$s/out"
  mkdir -p "$out_dir"
  # Per-page output: typst writes one SVG per page. The `{n}` template
  # expands to 1-based page numbers; required for multi-page test files.
  out="$out_dir/test-{n}.svg"
  if [ ! -f "$in" ]; then
    echo "SKIP  $s  (no test.typ)"
    continue
  fi
  if [ "$use_typst_cli" = "1" ]; then
    if typst compile --root "$ROOT" "$in" "$out" 2>/tmp/tsc-err.log; then
      echo "PASS  $s"
      pass=$((pass + 1))
    else
      echo "FAIL  $s"
      sed 's/^/      /' /tmp/tsc-err.log
      fail=$((fail + 1))
    fi
  else
    if NODE_PATH="${NODE_PATH:-}" node "$COMPILER" "$in" "$out" --workspace="$ROOT" 2>/tmp/tsc-err.log >/dev/null; then
      echo "PASS  $s"
      pass=$((pass + 1))
    else
      echo "FAIL  $s"
      sed 's/^/      /' /tmp/tsc-err.log
      fail=$((fail + 1))
    fi
  fi
done

echo ""
echo "$pass passed, $fail failed"
[ "$fail" -eq 0 ]
