# 02. 会话管理（可运行）

## 目标
掌握会话的日常运维命令：创建、查找、重命名、转移到不同项目目录、清理。

## 示例 1：带项目目录创建会话
```bash
tmux new-session -d -s demo-project -c ~/work/project-a
tmux list-sessions
```

这里 `-c` 能把会话的初始路径固定到某个目录。

## 示例 2：会话重命名
```bash
tmux rename-session -t demo-project demo-a
tmux rename-session -t demo-a demo-project
```

> 注意：`tmux rename-session` 即时生效，无需重启服务。

## 示例 3：克隆会话（适合保留模板）
```bash
tmux new-session -d -s template
tmux new-session -d -s copy-of-template -t template
tmux ls
tmux kill-session -t template
tmux kill-session -t copy-of-template
```

## 命令解读
- `tmux new-session -d -s demo-project -c ~/work/project-a`
  - `-d` 后台创建；`-s` 会话名；`-c` 指定会话起始目录。
- `tmux list-sessions`
  - 列出会话，等价于 `tmux ls`。
- `tmux rename-session -t demo-project demo-a`
  - 把 `demo-project` 重命名为 `demo-a`，`-t` 是目标。
- `tmux new-session -d -s copy-of-template -t template`
  - 用 `-t` 复制模板会话布局，适合“标准面板模板”复用。
- `tmux kill-session -t xxx`
  - 终止指定会话。
- `tmux kill-server`
  - 停掉该用户当前 tmux 服务器下所有会话（全清理）。
- `tmux ls | awk -F: '{print $1}'`
  - 管道组合：先列会话再按 `:` 截取会话名，常用于脚本清理。

## 示例 4：按名称清理历史会话
```bash
tmux kill-session -t demo-project
```

要连同全部会话一起停止：
```bash
tmux kill-server
```

> `kill-server` 会结束当前 tmux 服务器管理下的全部会话。脚本里用前请确认不会中断正在工作的任务。

## 示例 5：只保留正在用的会话（命令配合过滤）
```bash
tmux ls | awk -F: '{print $1}'
```

输出里会列出会话名，适合你配合 grep 做自动化清理。

## 下一步
会话内再细分的是**窗口（Window）**，继续：[03 窗口管理](./03-window-management.md)

## 可运行脚本

`scripts/02-session-management.sh`
