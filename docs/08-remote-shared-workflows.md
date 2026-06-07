# 08. 远程开发与会话共享（高级）

## 目标
让 tmux 能穿透 SSH 与共享终端，满足多人协作或断线续连的高频场景。

## 示例 1：SSH 里启动会话并断线续连
```bash
ssh user@remote-server "tmux new-session -d -s remote-demo 'cd ~/project && bash'"
ssh user@remote-server "tmux ls"
ssh -t user@remote-server "tmux attach -t remote-demo"
```

你断网/掉线后再次登录可继续 `attach`。

## 示例 2：本地 socket 共享（高级实验）
```bash
tmux -S /tmp/shared.sock new -d -s shared-demo
tmux -S /tmp/shared.sock ls
tmux -S /tmp/shared.sock attach -t shared-demo
```

共享同一个 socket 的方式可让两个用户/终端同时观察同一会话。

## 示例 3：会话权限与可见性收束
```bash
tmux -S /tmp/shared.sock list-clients
tmux -S /tmp/shared.sock list-sessions
```

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

## 下一步
想进一步加生态能力（session 记录、会话自动保存、状态面板），见：[09 插件与高阶增强](./09-plugins-advanced.md)

## 可运行脚本

`scripts/08-remote-shared.sh`
