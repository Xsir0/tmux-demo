#!/usr/bin/env bash
# 05-copy-mode.sh
# 目的：演示 tmux 历史抓取到 stdout、落盘与检索。
# 用法：
#   ./05-copy-mode.sh
#   KEEP_SESSION=1 ./05-copy-mode.sh
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

# 固定会话/日志目录，兼容无权限环境
TMUX_TMPDIR="${TMUX_TMPDIR:-${SCRIPT_DIR}/../.tmux-tmp}"
mkdir -p "$TMUX_TMPDIR"
export TMUX_TMPDIR

SESSION="tmux-copy-${RANDOM}"
LOG_FILE="${TMUX_TMPDIR}/tmux-copy-demo-$(date +%s).log"
KEEP_SESSION="${KEEP_SESSION:-0}"

cleanup() {
  # 默认删除导出文件和演示会话，防止工作区留垃圾
  if [[ "${KEEP_SESSION}" != "1" ]]; then
    rm -f "$LOG_FILE"
    tmux kill-session -t "$SESSION" 2>/dev/null || true
  fi
}
trap cleanup EXIT

# 建立一个有 120 行输出的会话，便于复制模式抓取演示
tmux new-session -d -s "$SESSION" "for i in {1..120}; do echo \"line-$i\"; done"
sleep 0.5

# 抓取最近内容输出到终端 + 持久化到文件
tmux capture-pane -p -t "$SESSION" | sed -n '1,20p'
tmux capture-pane -p -t "$SESSION" > "$LOG_FILE"
echo "已导出历史到: $LOG_FILE"
grep -n "line-10" "$LOG_FILE"
