#!/usr/bin/env bash
# 10-troubleshooting.sh
# 目的：将常见故障做成可复现的检查命令清单，便于快速定位。
# 用法：
#   ./10-troubleshooting.sh
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

# 在可控目录执行检查，避免临时文件写到系统受限位置
TMUX_TMPDIR="${TMUX_TMPDIR:-${SCRIPT_DIR}/../.tmux-tmp}"
mkdir -p "$TMUX_TMPDIR"
export TMUX_TMPDIR

echo "1) 检查 tmux 安装"
tmux -V

echo "2) 查看当前会话"
tmux ls || true

echo "3) 会话名冲突模拟（预期失败）"
SESSION="tmux-dup-${RANDOM}"
# 先创建一个会话，再故意重复创建同名会话验证报错路径
tmux new-session -d -s "$SESSION" "printf 'dup test\\n'"
if tmux new-session -d -s "$SESSION" "printf 'dup test\\n'" 2>"${TMUX_TMPDIR}/tmux-dup.err"; then
  echo "意外：重复创建未报错"
else
  echo "重复创建报错符合预期：$(cat "${TMUX_TMPDIR}/tmux-dup.err")"
fi
rm -f "${TMUX_TMPDIR}/tmux-dup.err"

echo "4) 前缀键与窗口键位"
tmux show-options -g prefix
tmux show -gv prefix
# 查看前 20 个键位，用于快速比对冲突
tmux list-keys | head -n 20

echo "5) 编码与终端环境"
tmux display-message -p '#{host} #{pane_width}x#{pane_height} #{terminal_name}'
# 建议先观察并确认再决定是否改 terminal 设置
tmux set -g default-terminal "screen-256color"

tmux kill-session -t "$SESSION"
echo "故障排查脚本完成"
