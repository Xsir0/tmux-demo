# 10. 常见问题与排错

## 目标
把经常遇到的问题先定位到命令，再给出可执行修复。

## 示例 1：会话名冲突
```bash
tmux new-session -d -s demo
tmux new-session -d -s demo
```
冲突报错时通常会看到类似 `duplicate session name`，处理：
```bash
tmux kill-session -t demo
tmux new-session -d -s demo
```
### 命令解读（示例 1）
- `tmux new-session -d -s demo`
  - 首次创建会话：成功建立并返回新会话名 `demo`。
- 第二次再执行同名创建
  - 触发预期错误：`failed to create session: duplicate session name`，用于验证冲突路径。
- `tmux kill-session -t demo`
  - 清掉冲突会话，用于恢复测试环境。
- 再次 `tmux new-session -d -s demo`
  - 通过 cleanup 后再次创建，确认问题可恢复。

## 示例 2：前缀键无响应
```bash
tmux show-options -g prefix
tmux show -gv prefix
tmux source-file ~/.tmux.conf
```
### 命令解读（示例 2）
- `tmux show-options -g prefix`
  - 查看当前会话前缀配置的快照（含默认格式）。
- `tmux show -gv prefix`
  - 用 `-v` 只取值，便于和脚本/文本比较。
- `tmux source-file ~/.tmux.conf`
  - 主动重载后，判断键位异常是否由配置文件写入错误导致。

若你把前缀改了（例如 `C-a`），需保持统一：终端发送和输入法都别打断组合键。

## 示例 3：窗口/面板乱码或布局错位
```bash
tmux display-message -p '#{host} #{pane_width}x#{pane_height} #{terminal_name}'
tmux set -g default-terminal "screen-256color"
tmux set -ga terminal-overrides ",xterm-256color:Tc"
tmux refresh-client -S
```
### 命令解读（示例 3）
- `tmux display-message -p 'format'`
  - 输出终端/尺寸变量，先确认 `pane_width/pane_height`、终端类型。
- `tmux set -g default-terminal "screen-256color"`
  - 强制 tmux 通道终端能力定义，解决某些颜色/宽字符问题。
- `tmux set -ga terminal-overrides ",xterm-256color:Tc"`
  - 追加 true-color 覆盖，常见于终端颜色显示不准。
- `tmux refresh-client -S`
  - 强制刷新客户端，布局错位时立即重绘。

## 示例 4：tmux 无法启动 / 卡在旧 socket
```bash
ps -axo pid,command | grep -E 'tmux|tmux: server' | grep -v grep
tmux ls
tmux -L testserver ls
```

必要时杀掉旧 socket：
```bash
tmux kill-server
```
### 命令解读（示例 4）
- `ps -axo pid,command | grep -E 'tmux|tmux: server'`
  - 查找当前机器上的 tmux 服务进程。
- `tmux ls`
  - 查看默认 socket 下会话状态。
- `tmux -L testserver ls`
  - 使用备用 socket 名（`testserver`）规避默认 socket 资源冲突。
- `tmux kill-server`
  - 兜底手段：清理卡死服务端，会中断该 socket 下所有会话。

## 示例 5：查看完整配置与键位用于复现问题
```bash
tmux show-options -g
tmux list-keys
tmux list-commands
```
### 命令解读（示例 5）
- `tmux show-options -g`
  - 查看全局配置是否被覆盖。
- `tmux list-keys`
  - 列出当前有效键位映射，定位快捷键冲突。
- `tmux list-commands`
  - 列出可用命令清单，便于判断 `prefix` 命令是否正确识别。

> 你可以把 `tmux list-keys` 输出贴给我，我可以直接按你的环境帮你逐条排查冲突来源。

### 命令解读
- `tmux new-session -d -s demo` 后再重复创建
  - 通过故意触发验证“会话名重复”行为，确认清理策略。
- `tmux source-file ~/.tmux.conf`
  - 重载配置，快速确认是否由配置错误引起。
- `tmux display-message -p '...format...'`
  - 按 format string 输出运行时变量（终端、尺寸、主机名等）。
- `tmux set -g default-terminal "..."`
  - 设置终端能力定义，解决配色/宽高异位。
- `tmux set -ga terminal-overrides ",xterm-256color:Tc"`
  - `-a` 追加配置项，`-ga` 表示全局追加。
- `tmux refresh-client -S`
  - 强制刷新客户端绘制，常用于布局错位后立刻恢复显示。
- `ps -axo pid,command | grep -E 'tmux|tmux: server'`
  - 查旧服务进程；`kill -9` 可作为最后手段前清理。
- `tmux -L testserver ls`
  - 用 `-L` 指定备用 socket 名，避免默认 socket 冲突。
- `tmux list-keys / list-commands / show-options`
  - 查看当前所有键绑定、命令、配置用于定位冲突和默认值覆盖。
- `tmux kill-server`
  - 重置整个服务器状态（会终止所有会话），执行前确认任务已保存。

## 学习闭环建议（实战检验）
完整流程建议：
1. 先跑 `00-安装与环境确认`
2. 完成 `01 ~ 07` 的命令
3. 选 `08 ~ 09` 做你当前场景版本
4. 每章都保留你自己的 `/tmp/tmux-*.log` 输出，形成自己的“调试字典”

如果你愿意，我下一步可以按你的工作场景（前端开发、后端服务、日志追踪、数据分析）再给你一套“完整模板脚本”。

## 可运行脚本

`scripts/10-troubleshooting.sh`
