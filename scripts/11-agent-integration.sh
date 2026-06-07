#!/usr/bin/env bash
# 11-agent-integration.sh
# 目的：用 tmux 组织 agent 控制面 + 日志面 + 任务面，适合与你的 Agent CLI 联动。
# 用法：
#   KEEP_SESSION=1 ./11-agent-integration.sh
#   AGENT_CMD=codex KEEP_SESSION=1 ./11-agent-integration.sh
#   TMUX_AGENT_SESSION=tmux-agent-demo KEEP_SESSION=1 ./11-agent-integration.sh
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

# 保证临时目录可控，日志文件不落到系统 /tmp
TMUX_TMPDIR="${TMUX_TMPDIR:-${SCRIPT_DIR}/../.tmux-tmp}"
mkdir -p "$TMUX_TMPDIR"
export TMUX_TMPDIR

SESSION="${TMUX_AGENT_SESSION:-tmux-agent-${RANDOM}}"
WORKDIR="${WORKDIR:-$HOME}"
KEEP_SESSION="${KEEP_SESSION:-0}"
EVENT_LOG="${TMUX_TMPDIR}/agent-demo-events.log"

# 自动探测可用 Agent CLI，未探测到时降级提示
AGENT_CMD="${AGENT_CMD:-}"
if [ -z "$AGENT_CMD" ]; then
  for c in codex awb agent-studio agent; do
    if command -v "$c" >/dev/null 2>&1; then
      AGENT_CMD="$c"
      break
    fi
  done
fi

cleanup() {
  # 默认退出后杀掉演示会话并清除事件日志
  if [[ "${KEEP_SESSION}" != "1" ]]; then
    tmux kill-session -t "$SESSION" 2>/dev/null || true
    rm -f "$EVENT_LOG"
  fi
}
trap cleanup EXIT

# 创建一个窗口，拆分两个功能面板：
# - agent-control.0: 控制面（执行 agent 命令）
# - agent-control.1: 日志 tail（观察事件文件）
# - agent-control.2: 模拟任务事件写入源
tmux new-session -d -s "$SESSION" -c "$WORKDIR" -n "agent-control"
tmux split-window -h -t "$SESSION:agent-control" "bash -lc 'tail -f \"$EVENT_LOG\"'"
tmux split-window -v -t "$SESSION:agent-control.0" "bash -lc 'printf \"agent-output\\n\"'"

# 生产模拟事件，让日志面看到结构化时间戳输出
tmux send-keys -t "$SESSION:agent-control.0" "rm -f \"$EVENT_LOG\"; touch \"$EVENT_LOG\"; for i in $(seq 1 5); do printf '{\"ts\":\"%s\",\"event\":\"task-%s\"}\\n' \"\\$(date -u +%Y-%m-%dT%H:%M:%SZ)\" \"$i\" >> \"$EVENT_LOG\"; sleep 1; done" C-m

# 如果探测到 Agent 命令，先验证 help 是否可执行；否则给出提示
if [ -n "$AGENT_CMD" ]; then
  tmux send-keys -t "$SESSION:agent-control.2" "$AGENT_CMD --help" C-m
else
  tmux send-keys -t "$SESSION:agent-control.2" "echo '未检测到 agent 可执行命令，请将 AGENT_CMD 设置为你的 CLI 命令路径'" C-m
fi

sleep 2
echo "事件日志: $EVENT_LOG"
tmux list-windows -t "$SESSION"
tmux list-panes -t "$SESSION" -F '#{pane_index}: #{pane_title}'

if [[ "$KEEP_SESSION" == "1" ]]; then
  echo "会话保留中：tmux attach -t $SESSION"
else
  echo "默认脚本会自动清理会话；如需保留，请设置 KEEP_SESSION=1"
fi
