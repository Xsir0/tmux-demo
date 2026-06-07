#!/usr/bin/env bash
# 02-session-management.sh
# 目的：演示会话级别的创建、重命名、克隆、清理。
# 用法：
#   ./02-session-management.sh
#   KEEP_SESSION=1 ./02-session-management.sh   # 不自动清理会话
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

# 使用仓库目录下 tmux 临时目录，规避权限问题
TMUX_TMPDIR="${TMUX_TMPDIR:-${SCRIPT_DIR}/../.tmux-tmp}"
mkdir -p "$TMUX_TMPDIR"
export TMUX_TMPDIR

BASE="tmux-mgmt-${RANDOM}"
KEEP_SESSION="${KEEP_SESSION:-0}"

cleanup() {
  # 默认清掉本脚本创建的 3 个会话；KEEP_SESSION=1 仅保留手工排查
  if [[ "${KEEP_SESSION}" != "1" ]]; then
    tmux kill-session -t "${BASE}-work" 2>/dev/null || true
    tmux kill-session -t "${BASE}-template" 2>/dev/null || true
    tmux kill-session -t "${BASE}-copy" 2>/dev/null || true
  fi
}
trap cleanup EXIT

# 1) 用模板方式创建两个会话
tmux new-session -d -s "${BASE}-work" -c ~
tmux new-session -d -s "${BASE}-template" -c ~
# 2) 用现有会话作为模板创建克隆会话
tmux new-session -d -s "${BASE}-copy" -t "${BASE}-template"
echo "创建了会话: ${BASE}-work ${BASE}-template ${BASE}-copy"
tmux list-sessions

# 3) 重命名会话
tmux rename-session -t "${BASE}-work" "${BASE}-renamed"
echo "重命名: ${BASE}-renamed"
tmux list-sessions

# 4) 清理演示会话
tmux kill-session -t "${BASE}-renamed"
tmux kill-session -t "${BASE}-template"
tmux kill-session -t "${BASE}-copy"
echo "已清理示例会话（除非 KEEP_SESSION=1）"
