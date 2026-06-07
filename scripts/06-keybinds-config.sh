#!/usr/bin/env bash
# 06-keybinds-config.sh
# 目的：用临时 tmux socket 演示配置片段（不污染用户 ~/.tmux.conf）。
# 用法：
#   ./06-keybinds-config.sh
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

# 用仓库内目录承载 socket，方便反复执行
TMUX_TMPDIR="${TMUX_TMPDIR:-${SCRIPT_DIR}/../.tmux-tmp}"
mkdir -p "$TMUX_TMPDIR"
export TMUX_TMPDIR

# 将配置先写入临时文件，脚本结束后清理
CONF_FILE=$(mktemp)
SOCK="tmux-conf-${RANDOM}"

cleanup() {
  # 只清理本脚本临时产物
  rm -f "$CONF_FILE"
  tmux -L "$SOCK" kill-server >/dev/null 2>&1 || true
}
trap cleanup EXIT

# 写入简化配置：鼠标、历史、前缀改为 C-a、窗口起始编号
cat > "$CONF_FILE" <<'EOF'
set -g mouse on
set -g history-limit 5000
set -g prefix C-a
unbind C-b
bind C-a send-prefix
set -g base-index 1
setw -g pane-base-index 1
EOF

# 用独立 socket 启动会话，确认配置是否生效
tmux -L "$SOCK" -f "$CONF_FILE" new-session -d -s conf-demo "printf 'config loaded\\n'"
echo "临时配置已加载到 socket: $SOCK"
tmux -L "$SOCK" show-options -g mouse
tmux -L "$SOCK" show-options -g prefix
tmux -L "$SOCK" list-keys | grep -E "^bind-key|bind" | head -n 5
