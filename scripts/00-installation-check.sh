#!/usr/bin/env bash
# 00-installation-check.sh
# 目的：确认 tmux 安装可用，并验证会话创建/回收链路是否正常。
# 用法：
#   ./00-installation-check.sh
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

# 使用仓库内可写目录做 tmux socket，避免系统目录权限受限
TMUX_TMPDIR="${TMUX_TMPDIR:-${SCRIPT_DIR}/../.tmux-tmp}"
mkdir -p "$TMUX_TMPDIR"
export TMUX_TMPDIR

# 生成本次演示会话名（随机，避免和你现有会话冲突）
SESSION="tmux-install-${RANDOM}"

if ! command -v tmux >/dev/null 2>&1; then
  echo "tmux 未安装，请先安装 tmux 后再运行"
  exit 1
fi

# 打印版本，再创建一个短时会话验证“新建 + 列表 + 清理”闭环
echo "tmux version: $(tmux -V)"
tmux new-session -d -s "$SESSION" "printf 'tmux check session start\n'"
sleep 0.3
tmux ls

# 清理，避免脏会话
tmux kill-session -t "$SESSION"
echo "已创建并清理会话: $SESSION"
