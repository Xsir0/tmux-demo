#!/usr/bin/env bash
# 08-remote-shared.sh
# 目的：演示独立 socket 的共享会话创建与清理；并给出 SSH 场景的命令模板。
# 用法：
#   ./08-remote-shared.sh
#   REMOTE_HOST=user@host ./08-remote-shared.sh
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

# 共享 socket 写在脚本目录旁可写路径
TMUX_TMPDIR="${TMUX_TMPDIR:-${SCRIPT_DIR}/../.tmux-tmp}"
mkdir -p "$TMUX_TMPDIR"
export TMUX_TMPDIR

SOCK="${TMUX_TMPDIR}/tmux-shared-demo-$$.sock"
SESSION="shared-demo"
REMOTE_HOST="${REMOTE_HOST:-}"

cleanup() {
  # 删除临时 socket 文件并尝试关闭对应 server
  if [ -e "$SOCK" ]; then
    rm -f "$SOCK"
  fi
  tmux -S "$SOCK" kill-server >/dev/null 2>&1 || true
}
trap cleanup EXIT

# 1) 本地共享 socket 示例（非破坏性）
tmux -S "$SOCK" new -d -s "$SESSION" "printf 'local shared socket ready\\n'"
tmux -S "$SOCK" ls
tmux -S "$SOCK" list-clients
tmux -S "$SOCK" kill-server

# 2) 如果设置 REMOTE_HOST，给出可复制的远端恢复命令
if [ -n "$REMOTE_HOST" ]; then
  echo "检测到 REMOTE_HOST=$REMOTE_HOST，尝试执行 SSH 断线续连示例（如需可执行）。"
  echo "ssh $REMOTE_HOST \"tmux new-session -d -s remote-demo 'cd ~ && bash'\""
  echo "ssh $REMOTE_HOST \"tmux ls\""
else
  echo "未设置 REMOTE_HOST，已跳过真实 SSH 示例。"
fi
