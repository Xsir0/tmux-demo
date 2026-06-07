#!/usr/bin/env bash
# 04-pane-management.sh
# 目的：演示面板分屏（水平/垂直）、向面板发送命令、布局切换。
# 用法：
#   ./04-pane-management.sh
#   KEEP_SESSION=1 ./04-pane-management.sh
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

# 使用可写目录作为 tmux socket 根目录
TMUX_TMPDIR="${TMUX_TMPDIR:-${SCRIPT_DIR}/../.tmux-tmp}"
mkdir -p "$TMUX_TMPDIR"
export TMUX_TMPDIR

SESSION="tmux-pane-${RANDOM}"
KEEP_SESSION="${KEEP_SESSION:-0}"

cleanup() {
  # 默认退出后清理演示会话；设置 KEEP_SESSION=1 可保留面板布局
  if [[ "${KEEP_SESSION}" != "1" ]]; then
    tmux kill-session -t "$SESSION" 2>/dev/null || true
  fi
}
trap cleanup EXIT

# 创建 1 个基准面板 + 2 个子面板
tmux new-session -d -s "$SESSION" "printf 'pane root\\n'"
tmux split-window -h -t "$SESSION" "printf 'pane right\\n'"
tmux split-window -v -t "$SESSION" "printf 'pane bottom\\n'"

# 给每个面板下发不同命令，形成可区分输出
tmux send-keys -t "$SESSION:.0" "printf 'cmd in pane-0\\n'" C-m
tmux send-keys -t "$SESSION:.1" "printf 'cmd in pane-1\\n'" C-m
tmux send-keys -t "$SESSION:.2" "printf 'cmd in pane-2\\n'" C-m

# 打印面板清单和尺寸，检查分屏是否成功
tmux list-panes -t "$SESSION"
tmux list-panes -t "$SESSION" -F '#{pane_index}: #{pane_width}x#{pane_height}'

# 切换布局，观察变化
tmux select-layout -t "$SESSION" even-horizontal
tmux select-layout -t "$SESSION" tiled
