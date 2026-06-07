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

## 学习闭环建议（实战检验）
完整流程建议：
1. 先跑 `00-安装与环境确认`
2. 完成 `01 ~ 07` 的命令
3. 选 `08 ~ 09` 做你当前场景版本
4. 每章都保留你自己的 `/tmp/tmux-*.log` 输出，形成自己的“调试字典”

如果你愿意，我下一步可以按你的工作场景（前端开发、后端服务、日志追踪、数据分析）再给你一套“完整模板脚本”。

## 可运行脚本

`scripts/10-troubleshooting.sh`
