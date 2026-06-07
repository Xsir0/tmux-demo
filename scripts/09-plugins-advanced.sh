#!/usr/bin/env bash
# 09-plugins-advanced.sh
# 目的：提供插件方案的参考路径（TPM 检测、插件片段生成），可选不联网模式。
# 用法：
#   ALLOW_NETWORK=1 ./09-plugins-advanced.sh   # 允许自动 clone TPM
#   ./09-plugins-advanced.sh                   # 只输出配置片段
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

# 用仓库内目录存放插件，避免用户主目录权限/安全策略限制
TMUX_TMPDIR="${TMUX_TMPDIR:-${SCRIPT_DIR}/../.tmux-tmp}"
mkdir -p "$TMUX_TMPDIR"
export TMUX_TMPDIR

PLUGIN_DIR="${TMUX_PLUGIN_DIR:-${SCRIPT_DIR}/../.tmux-plugins}"
mkdir -p "$PLUGIN_DIR"
TPM_DIR="${PLUGIN_DIR}/tpm"
TPM_URL="https://github.com/tmux-plugins/tpm"
ALLOW_NETWORK="${ALLOW_NETWORK:-0}"

# 如果无 TPM 并且允许联网，就自动安装；否则只提示
if [ ! -d "$TPM_DIR" ] && [ "$ALLOW_NETWORK" = "1" ]; then
  git clone "$TPM_URL" "$TPM_DIR"
  echo "已安装 TPM 到 $TPM_DIR"
elif [ ! -d "$TPM_DIR" ]; then
  echo "未安装 TPM，若需要自动安装请设置 ALLOW_NETWORK=1"
else
  echo "TPM 已存在: $TPM_DIR"
fi

# 生成一段可直接贴到 ~/.tmux.conf 的示例文本
tmpconf=$(mktemp)
cat > "$tmpconf" <<EOF
set -g @plugin 'tmux-plugins/tmux-copycat'
set -g @plugin 'tmux-plugins/tpm'
run '${TPM_DIR}/tpm'
EOF
echo "示例插件配置片段已写入: $tmpconf"
echo "无网络时可直接用替代方案进行日志截取："
echo "tmux pipe-pane -o 'cat >> ${TMUX_TMPDIR}/tmux.log'"
