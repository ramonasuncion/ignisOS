# shellcheck shell=sh

set -eu

export SRC_DIR
export BUILD_DIR
export TOOLS_DIR

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC_DIR="$PROJECT_ROOT/src"
BUILD_DIR="$PROJECT_ROOT/build"
TOOLS_DIR="$PROJECT_ROOT/tools"

