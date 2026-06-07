# 01. 快速入门：会话的创建与返回

## 目标
理解 tmux “会话（session）”是什么，并能在 shell 中反复创建、分离和返回。

## 示例 1：交互式创建会话
```bash
tmux new -s basic-demo
```
进入后，执行任意命令再分离：
```bash
echo "hello tmux"
```
在会话内按 `C-b d` 分离。

### 结果
你会回到原始 shell，`tmux` 进程继续运行该会话。

### 命令解读
- `tmux new -s basic-demo`
  - `new` 等价于 `new-session`，会新建会话并进入，`-s` 指定会话名。
- `echo "hello tmux"`
  - 在 tmux 会话中执行普通 shell 命令，用于确认会话内执行链路正常。

## 示例 2：从外部列表会话并重新连接
```bash
tmux ls
tmux attach -t basic-demo
```

连接后按 `C-b d` 回到原 Shell。

### 命令解读
- `tmux ls`
  - 查看所有会话，确认 `basic-demo` 是否存在。
- `tmux attach -t basic-demo`
  - `attach` 回到指定会话，`-t` 后接目标名字。

## 示例 3：后台方式创建（脚本友好）
```bash
tmux new-session -d -s basic-bg-demo "bash -lc 'echo background start && sleep 1 && echo background end'"
tmux ls
tmux attach -t basic-bg-demo
tmux kill-session -t basic-bg-demo
```

### 结果
第三条命令会以 `-d` 在后台启动并运行 shell 命令，适合你把任务放到可恢复会话中。

### 命令解读
- `tmux new-session -d -s basic-bg-demo "bash -lc '...'"`
  - 同时设置 `-d` 后台启动，并运行一段一次性命令。
  - `-s` 定义会话名，便于后续 `attach` 和清理。
- `tmux attach -t basic-bg-demo`
  - 进入已在后台运行的会话。
- `tmux kill-session -t basic-bg-demo`
  - 结束示例会话，避免后台残留。

## 下一步
会话除了“创建/连接”之外，还有重命名、批量管理等场景，见：
[02 会话管理](./02-session-management.md)

## 可运行脚本

`scripts/01-session-basic.sh`
