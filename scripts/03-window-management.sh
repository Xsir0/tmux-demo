#!/usr/bin/env bash
# 03-window-management.sh
# 目的：演示窗口级别操作：新增窗口、切换窗口、发送命令、关闭窗口。
# 用法：
#   ./03-window-management.sh
#   KEEP_SESSION=1 ./03-window-management.sh
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

# 统一使用仓库临时目录，避免 tmux socket 创建失败
TMUX_TMPDIR="${TMUX_TMPDIR:-${SCRIPT_DIR}/../.tmux-tmp}"
mkdir -p "$TMUX_TMPDIR"
export TMUX_TMPDIR

SESSION="tmux-win-${RANDOM}"
KEEP_SESSION="${KEEP_SESSION:-0}"

cleanup() {
  # 默认清会话；KEEP_SESSION=1 可手工在 tmux 里观察窗口结果
  if [[ "${KEEP_SESSION}" != "1" ]]; then
    tmux kill-session -t "$SESSION" 2>/dev/null || true
  fi
}
trap cleanup EXIT

# 建立会话和两个窗口
tmux new-session -d -s "$SESSION" -n "base" -c ~
tmux new-window -t "$SESSION" -n "server" -c ~ "printf 'window: server\\n'"
tmux new-window -t "$SESSION" -n "logs" -c ~ "printf 'window: logs\\n'"

# 各窗口写入不同内容，模拟“服务端窗口”和“日志窗口”
tmux send-keys -t "$SESSION:server" "printf 'start server logic\\n' && date" C-m
tmux send-keys -t "$SESSION:logs" "printf 'tail placeholder\\n' && date" C-m

# 查看窗口列表与窗口内输出
tmux list-windows -t "$SESSION"
tmux capture-pane -p -t "$SESSION:server" | sed -n '1,5p'
tmux send-keys -t "$SESSION:server" "printf 'switch test\\n'" C-m

# 演示窗口切换后再关闭窗口
tmux select-window -t "$SESSION:logs"
tmux kill-window -t "$SESSION:server"
tmux list-windows -t "$SESSION"
