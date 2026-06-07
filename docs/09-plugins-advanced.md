# 09. 插件与高阶增强（可选）

## 目标
把 tmux 从“终端管理器”升级到“工作流平台”。

## 示例 1：安装 TPM（Tmux Plugin Manager）
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

然后在 `~/.tmux.conf` 加：
```tmux
# ~/.tmux.conf
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
run '~/.tmux/plugins/tpm/tpm'
```

进入 tmux 后按 `C-b I` 安装。

## 示例 2：安装并体验高频插件
示例（按你的环境选择）：
```bash
tmux set -g @plugin 'tmux-plugins/tmux-copycat'
tmux set -g @plugin 'tmux-plugins/tmux-pain-control'
tmux run-shell '~/.tmux/plugins/tpm/tpm'
```

> 非必须：插件可以很实用，但建议你先熟悉无插件工作流后再渐进使用，避免快捷键冲突。

## 示例 3：无插件可复制到日志与文件（替代插件）
```bash
tmux new-session -d -s log-demo "printf 'hello\\n' && for i in {1..20}; do echo log-$i; done"
tmux pipe-pane -t log-demo -o 'cat >> /tmp/tmux.log'
tmux kill-session -t log-demo
tail -n 5 /tmp/tmux.log
```

这个“无插件方案”适合受限环境（无法改系统目录）时的长期可维护替代。

## 示例 4：用会话/插件组合做状态可观测
```bash
tmux new-session -d -s status-demo
tmux set-option -t status-demo status on
tmux set-option -t status-demo status-interval 5
tmux show-options -g status
tmux kill-session -t status-demo
```

## 下一步
最后看“故障排查”，帮助你快速定位常见问题：[10 真实问题排查](./10-troubleshooting.md)

### 命令解读
- `git clone https://github.com/tmux-plugins/tpm ...`
  - 下载插件管理器到本地目录，后续 `~/.tmux/plugins/tpm/tpm` 由 tmux 调用。
- `set -g @plugin ...`
  - 在配置文件中声明要加载的 tmux 插件名。
- `run '~/.tmux/plugins/tpm/tpm'`
  - 让 tmux 在启动时执行 tpm 命令加载/管理插件。
- `tmux run-shell '<cmd>'`
  - 运行外部 shell 命令，常用于一次性刷新插件。
- `tmux pipe-pane -t <session> -o 'cat >> <path>'`
  - 把 pane 输出导入文件形成可追踪日志。
- `tmux set-option -t status-demo status on`
  - 打开状态栏；`status-interval` 控制刷新频率。
- `tmux show-options -g status`
  - 查看全局状态栏最终生效值，排查配置是否生效。

## 可运行脚本

`scripts/09-plugins-advanced.sh`
