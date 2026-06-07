# 03. 窗口（Window）管理：项目内逻辑分区

## 目标
学习如何在一个会话内管理多个窗口，相当于在一个“标签页”上切多个任务。

## 示例 1：新建窗口
```bash
tmux new-session -d -s work
tmux new-window -t work -n "server" -c ~/work
tmux new-window -t work -n "logs" -c ~/work
tmux list-windows -t work
```

`-n` 指定窗口名，`-c` 指定起始目录。
### 命令解读（示例1）
- `tmux new-session -d -s work`
  - 目的：先建立名为 `work` 的后台会话。
  - 关键参数：`-d` 不自动 attach；`-s` 指定会话名。
  - 结果：会话 `work` 创建成功后继续执行下一步命令。
- `tmux new-window -t work -n "server" -c ~/work`
  - 目的：在 `work` 下建 `server` 窗口，并进入 `~/work`。
  - 常见报错：`can't find session: work`（会话没建成功或已退出）。
- `tmux new-window -t work -n "logs" -c ~/work`
  - 目的：再建一个 `logs` 窗口。
- `tmux list-windows -t work`
  - 结果：确认 `work` 下窗口列表，通常返回窗口编号与名称。

## 示例 2：在窗口里跑不同命令
```bash
tmux send-keys -t work:server "cd ~/work && printf 'start server\\n' && python3 -m http.server 8000" C-m
tmux send-keys -t work:logs  "cd ~/work && ls -la" C-m
```

`C-m` 是 Enter 的模拟发送。
### 命令解读（示例2）
- `tmux send-keys -t work:server "cd ~/work && printf 'start server\\n' && python3 -m http.server 8000" C-m`
  - 目的：向 `server` 窗口发送一段“启动服务端”的命令链。
  - 关键参数：`-t` 指定目标窗口，`C-m` 等于回车。
- `tmux send-keys -t work:logs  "cd ~/work && ls -la" C-m`
  - 目的：向 `logs` 窗口发送一次性目录检查命令。
  - 常见误区：`send-keys` 只是“模拟输入”，并不显示完整交互过程。

## 示例 3：窗口间切换
```bash
tmux select-window -t work:server
tmux select-window -t work:logs
```

键盘方式：
- `C-b 0` / `C-b 1`：按窗口编号跳转
- `C-b n` / `C-b p`：下一个 / 上一个窗口
- `C-b w`：窗口列表选择器
### 命令解读（示例3）
- `tmux select-window -t work:server`
  - 目的：切到 `work` 会话里的 `server` 窗口。
- `tmux select-window -t work:logs`
  - 目的：切到 `logs` 窗口。
  - 结果：焦点从一个窗口移动到另一个窗口。

## 示例 4：重命名、移动与关闭
```bash
tmux rename-window -t work:server "http"
tmux swap-window -s work:logs -t work:server
tmux kill-window -t work:logs
tmux kill-session -t work
```

### 命令解读（示例4）
- `tmux rename-window -t work:server "http"`
  - 给窗口改名，便于可视化区分。
- `tmux swap-window -s work:logs -t work:server`
  - 将两个窗口交换顺序/位置。
- `tmux kill-window -t work:logs`
  - 只关闭某个窗口，不影响整个会话。
- `tmux kill-session -t work`
  - 关闭会话（包括其全部窗口）。

> `swap-window` 在复杂项目里很实用，比如临时把关键窗口移动到前面。

## 下一步
当一个窗口里任务更多时，用“面板（Pane）”分割，见：[04 面板管理](./04-pane-management.md)

## 可运行脚本

`scripts/03-window-management.sh`
