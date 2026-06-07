# 04. 面板（Pane）管理：一个窗口内多任务并行

## 目标
在一个窗口中同时并行处理多个终端任务：构建、日志、测试等。

## 示例 1：左右分屏
```bash
tmux new-session -d -s pane-demo
tmux split-window -h -t pane-demo
tmux list-panes -t pane-demo
tmux kill-session -t pane-demo
```

`-h` 表示水平（左右）分割；不加 `-h` 通常是垂直（上下）。

## 示例 2：上/下分屏并运行不同命令
```bash
tmux new-session -d -s pane-demo2
tmux send-keys -t pane-demo2 "printf 'A\\n'; sleep 3600" C-m
tmux split-window -v -t pane-demo2 "printf 'B\\n'; sleep 3600" 
tmux list-panes -t pane-demo2
tmux kill-session -t pane-demo2
```

## 示例 3：面板焦点切换与同步输入
```bash
tmux new-session -d -s pane-cmd
tmux split-window -h -t pane-cmd
tmux select-pane -L -t pane-cmd
tmux select-pane -R -t pane-cmd
tmux setw -g synchronize-panes on
tmux send-keys -t pane-cmd "echo synced input" C-m
tmux setw -g synchronize-panes off
tmux kill-session -t pane-cmd
```

`synchronize-panes on` 可让所有面板同步执行输入，适合重复命令批量下发。

## 示例 4：切换布局
```bash
tmux select-layout -t pane-demo tiled
tmux select-layout -t pane-demo even-horizontal
tmux select-layout -t pane-demo even-vertical
tmux kill-session -t pane-demo
```

`tiled` 会尽量均分区域，`even-*` 系列强调等分。

## 实战提示
你会用到的快捷键（默认前缀 `C-b`）：
- `C-b %`：垂直分割（左右）
- `C-b "`：水平分割（上下）
- `C-b o`：面板间跳转
- `C-b q`：显示面板编号，快速跳转

## 下一步
下一章使用复制模式处理历史日志与内容提取：[05 复制模式](./05-copy-mode.md)

## 可运行脚本

`scripts/04-pane-management.sh`
