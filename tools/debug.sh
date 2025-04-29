#!/bin/bash

# shellcheck source=tools/config.sh
. "$(dirname "$0")"/config.sh

cd "$SRC_DIR"

SESSION=debug-os
GDB_PATH="$HOME/opt/cross/bin/x86_64-elf-gdb"
tmux new-session -d -s "$SESSION" "make clean && make debug"
tmux split-window -h -t "$SESSION"
tmux send-keys -t "$SESSION".1 "$GDB_PATH $BUILD_DIR/kernel.elf" C-m
tmux attach-session -t "$SESSION"
cd -

