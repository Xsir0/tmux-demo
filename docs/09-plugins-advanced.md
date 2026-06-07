# 09. 插件与高阶增强（可选）

## 目标
把 tmux 从“终端管理器”升级到“工作流平台”。

## 示例 1：安装 TPM（Tmux Plugin Manager）
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```
### 命令解读（示例 1）
- `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`
  - 作用：把 TPM 拉到本地目录，作为后续插件管理入口。
  - 前置：需要网络与写权限；无权限时建议先退出有影响的代理。
  - 常见错误：权限不足时会提示 `Permission denied`。

然后在 `~/.tmux.conf` 加：
```tmux
# ~/.tmux.conf
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
run '~/.tmux/plugins/tpm/tpm'
```
### 命令解读（tmux.conf）
- `set -g @plugin 'tmux-plugins/tpm'`
  - 注册 TPM 插件源。
- `set -g @plugin 'tmux-plugins/tmux-sensible'`
  - 启用一组常用优化默认配置。
- `run '~/.tmux/plugins/tpm/tpm'`
  - tmux 启动时执行 TPM 脚本，接管后续插件安装。

进入 tmux 后按 `C-b I` 安装。

## 示例 2：安装并体验高频插件
示例（按你的环境选择）：
```bash
tmux set -g @plugin 'tmux-plugins/tmux-copycat'
tmux set -g @plugin 'tmux-plugins/tmux-pain-control'
tmux run-shell '~/.tmux/plugins/tpm/tpm'
```
### 命令解读（示例 2）
- `tmux set -g @plugin 'tmux-plugins/tmux-copycat'`
  - 加载 `copycat` 插件能力。
- `tmux set -g @plugin 'tmux-plugins/tmux-pain-control'`
  - 加载面板操作增强能力。
- `tmux run-shell '~/.tmux/plugins/tpm/tpm'`
  - 触发 TPM 安装/刷新，通常第一次在会话内按 `C-b I` 安装。

> 非必须：插件可以很实用，但建议你先熟悉无插件工作流后再渐进使用，避免快捷键冲突。

## 示例 3：无插件可复制到日志与文件（替代插件）
```bash
tmux new-session -d -s log-demo "printf 'hello\\n' && for i in {1..20}; do echo log-$i; done"
tmux pipe-pane -t log-demo -o 'cat >> /tmp/tmux.log'
tmux kill-session -t log-demo
tail -n 5 /tmp/tmux.log
```
### 命令解读（示例 3）
- `tmux new-session -d -s log-demo ...`
  - 后台创建演示会话并持续输出日志字符串。
- `tmux pipe-pane -t log-demo -o 'cat >> /tmp/tmux.log'`
  - 将 pane 输出追加入文件；`-o` 表示首次输出时开始重定向。
- `tmux kill-session -t log-demo`
  - 清理示例会话，防止后台残留。
- `tail -n 5 /tmp/tmux.log`
  - 只看日志尾部，验证“可复制到文件”链路。

这个“无插件方案”适合受限环境（无法改系统目录）时的长期可维护替代。

## 示例 4：用会话/插件组合做状态可观测
```bash
tmux new-session -d -s status-demo
tmux set-option -t status-demo status on
tmux set-option -t status-demo status-interval 5
tmux show-options -g status
tmux kill-session -t status-demo
```
### 命令解读（示例 4）
- `tmux new-session -d -s status-demo`
  - 创建会话用于观察状态栏设置效果。
- `tmux set-option -t status-demo status on`
  - 打开该会话的状态栏显示。
- `tmux set-option -t status-demo status-interval 5`
  - 设置 5 秒刷新频率。
- `tmux show-options -g status`
  - 输出最终生效的状态栏相关全局配置。
- `tmux kill-session -t status-demo`
  - 示例清理。

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
