# shellcheck shell=sh

set -eu

# shellcheck disable=SC3040
[ -n "$($SHELL -c 'echo "$BASH_VERSION"')" ] && set -o pipefail

[ -n "${VERBOSE+x}" ] && set -x

run()
{
  if [ -n "${VERBOSE+x}" ]; then
   "$@"
  else
   "$@" >/dev/null 2>&1
  fi
}

export PROJECT_ROOT
export SRC_DIR
export BUILD_DIR
export TOOLS_DIR
export OS_NAME

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC_DIR="$PROJECT_ROOT/src"
BUILD_DIR="$PROJECT_ROOT/build"
TOOLS_DIR="$PROJECT_ROOT/tools"
OS_NAME="mango"

