#!/usr/bin/env bash
# 07-scripted-workflows.sh
# 目的：用一个脚本构建“多窗口 + 多面板 + 自动命令”工作流。
# 用法：
#   ./07-scripted-workflows.sh
#   KEEP_SESSION=1 ./07-scripted-workflows.sh
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

# 使用固定工作区，避免依赖用户主目录权限
TMUX_TMPDIR="${TMUX_TMPDIR:-${SCRIPT_DIR}/../.tmux-tmp}"
mkdir -p "$TMUX_TMPDIR"
export TMUX_TMPDIR

SESSION="tmux-workflow-${RANDOM}"
KEEP_SESSION="${KEEP_SESSION:-0}"

cleanup() {
  # KEEP_SESSION=1 时保留，会话和命令面板可重复查看
  if [[ "${KEEP_SESSION}" != "1" ]]; then
    tmux kill-session -t "$SESSION" 2>/dev/null || true
  fi
}
trap cleanup EXIT

# 在 editor 窗口创建 3 个分屏（示意：后端、测试、交互）
tmux new-session -d -s "$SESSION" -c ~ -n editor
tmux split-window -h -t "$SESSION:editor"
tmux split-window -v -t "$SESSION:editor.0"

# 下发不同任务到每个面板
tmux send-keys -t "$SESSION:editor.0" "printf 'pane-0: server\\n'; date" C-m
tmux send-keys -t "$SESSION:editor.1" "printf 'pane-1: tests\\n'; date" C-m
tmux send-keys -t "$SESSION:editor.2" "printf 'pane-2: shell\\n'; date" C-m

# 新建额外工作窗口，演示会话内多窗口结构
tmux new-window -t "$SESSION" -n frontend -c ~ "printf 'frontend workspace\\n'"
tmux new-window -t "$SESSION" -n backend -c ~ "printf 'backend workspace\\n'"
tmux new-window -t "$SESSION" -n logs -c ~ "printf 'log workspace\\n'"

tmux list-windows -t "$SESSION"
tmux capture-pane -p -t "$SESSION:editor.0" | sed -n '1,5p'
