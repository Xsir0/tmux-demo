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

## 示例 2：前缀键无响应
```bash
tmux show-options -g prefix
tmux show -gv prefix
tmux source-file ~/.tmux.conf
```

若你把前缀改了（例如 `C-a`），需保持统一：终端发送和输入法都别打断组合键。

## 示例 3：窗口/面板乱码或布局错位
```bash
tmux display-message -p '#{host} #{pane_width}x#{pane_height} #{terminal_name}'
tmux set -g default-terminal "screen-256color"
tmux set -ga terminal-overrides ",xterm-256color:Tc"
tmux refresh-client -S
```

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

## 示例 5：查看完整配置与键位用于复现问题
```bash
tmux show-options -g
tmux list-keys
tmux list-commands
```

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
