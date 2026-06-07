#!/usr/bin/env bash
# 01-session-basic.sh
# 目的：验证会话的创建、列出、查看历史和附着流程。
# 建议运行：
#   ./01-session-basic.sh
#   KEEP_SESSION=1 ./01-session-basic.sh   # 保留会话方便手动查看
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

# 避免依赖系统 tmux socket 目录，统一放在仓库可写目录
TMUX_TMPDIR="${TMUX_TMPDIR:-${SCRIPT_DIR}/../.tmux-tmp}"
mkdir -p "$TMUX_TMPDIR"
export TMUX_TMPDIR

# 会话名使用随机后缀，避免和你手工会话重复
SESSION="tmux-basic-${RANDOM}"
KEEP_SESSION="${KEEP_SESSION:-0}"

cleanup() {
  # 默认脚本结束自动清理；KEEP_SESSION=1 时保留观察
  if [[ "${KEEP_SESSION}" != "1" ]]; then
    tmux kill-session -t "$SESSION" 2>/dev/null || true
  fi
}

trap cleanup EXIT

if ! command -v tmux >/dev/null 2>&1; then
  echo "tmux 未安装"
  exit 1
fi

# 在后台启动一个最小会话并让它执行简单输出
tmux new-session -d -s "$SESSION" "printf 'basic-demo started\\n'; sleep 3"

# 查看会话是否出现
tmux ls
# 抽样读取 pane 内容，验证会话有可见输出
tmux capture-pane -p -t "$SESSION" | sed -n '1,3p'
tmux ls

# 输出给你可直接接管的指令
echo "脚本演示会话: $SESSION"
echo "可手动附着: tmux attach -t $SESSION"
echo "KEEP_SESSION=1 时脚本不会自动 kill-session"
