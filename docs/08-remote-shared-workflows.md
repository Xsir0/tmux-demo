# 08. 远程开发与会话共享（高级）

## 目标
让 tmux 能穿透 SSH 与共享终端，满足多人协作或断线续连的高频场景。

## 示例 1：SSH 里启动会话并断线续连
```bash
ssh user@remote-server "tmux new-session -d -s remote-demo 'cd ~/project && bash'"
ssh user@remote-server "tmux ls"
ssh -t user@remote-server "tmux attach -t remote-demo"
```
### 命令解读
- `ssh user@remote-server "tmux new-session -d -s remote-demo 'cd ~/project && bash'"`
  - 先连到远端创建一个后台会话，不占用当前 SSH 会话生命周期。
  - `-d` 确保远端会话不立刻附着。
  - 适合后端编译、长任务、日志采集。
- `ssh user@remote-server "tmux ls"`
  - 在远端查看会话列表，确认会话已存在。
- `ssh -t user@remote-server "tmux attach -t remote-demo"`
  - 带 `-t` 分配终端并 attach 到指定会话；远端 SSH 已断开也可重连。

你断网/掉线后再次登录可继续 `attach`。

## 示例 2：本地 socket 共享（高级实验）
```bash
tmux -S /tmp/shared.sock new -d -s shared-demo
tmux -S /tmp/shared.sock ls
tmux -S /tmp/shared.sock attach -t shared-demo
```
### 命令解读
- `tmux -S /tmp/shared.sock new -d -s shared-demo`
  - 用独立 socket 创建会话，避开默认 `~/.tmux/sock`。
- `tmux -S /tmp/shared.sock ls`
  - 查看该 socket 下的会话，确认创建成功。
- `tmux -S /tmp/shared.sock attach -t shared-demo`
  - 使用同一 socket attach，演示同机多观察端共享。
  - 常见误区：socket 文件权限不足会导致 attach 失败。

共享同一个 socket 的方式可让两个用户/终端同时观察同一会话。

## 示例 3：会话权限与可见性收束
```bash
tmux -S /tmp/shared.sock list-clients
tmux -S /tmp/shared.sock list-sessions
```
### 命令解读（示例 3）
- `tmux -S /tmp/shared.sock list-clients`
  - 列出连接到该 socket 的客户端，会话面板共享时有助于审计。
- `tmux -S /tmp/shared.sock list-sessions`
  - 查看该 socket 中的全部会话，确认共享范围。

当会话共享时，`set-option -g monitor-activity on` 会有更清晰的活动提示。

> 安全提醒：共享 socket 或多人 attach 前先确认工作机权限和数据敏感度，避免把生产凭据留在屏幕显示。

## 示例 4：断线保留 + 自动重连思路
在启动命令中尽量把任务放入 `tmux new-session -d`，会话生命周期与 SSH 生命周期解耦：
```bash
ssh -t user@remote-server "tmux new-session -d -s build 'cd ~/project && ./gradlew build'"
```

后续可随时：
```bash
ssh -t user@remote-server "tmux attach -t build"
```
### 命令解读（示例 4）
- `ssh -t user@remote-server "tmux new-session -d -s build 'cd ~/project && ./gradlew build'"`
  - 后端构建任务放到 tmux，网络抖动不会直接打断构建。
- `ssh -t user@remote-server "tmux attach -t build"`
  - 随时恢复到构建会话查看实时日志。

### 命令解读
- `ssh user@remote-server "tmux ..."`
  - 在远端执行 tmux 命令，常用于把任务与本地终端网络状态解耦。
- `tmux new-session -d -s remote-demo/build ...`
  - 远程后台会话，适合断线后继续跑。
- `ssh -t ... "tmux attach -t ..."`
  - `-t` 强制分配终端，使可交互会话重新连接。
- `tmux -S /tmp/shared.sock new/ls/attach ...`
  - `-S` 指定自定义 socket 文件，实现同机共享会话控制面。
- `tmux list-clients / list-sessions`
  - 查看哪个客户端在共享该 socket，以及当前所有会话。

## 下一步
想进一步加生态能力（session 记录、会话自动保存、状态面板），见：[09 插件与高阶增强](./09-plugins-advanced.md)

## 可运行脚本

`scripts/08-remote-shared.sh`
