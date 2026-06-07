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

### 命令解读（示例1）
- `tmux new-session -d -s pane-demo`
  - 目的：创建测试会话，默认不自动 attach，便于安全验证。
- `tmux split-window -h -t pane-demo`
  - 目的：在默认 pane 上做水平分割，形成两个并列 pane。
  - 结果：得到 2 个 pane，便于并行查看输出。
- `tmux list-panes -t pane-demo`
  - 结果：列出 pane 编号和大小，后续可用于 `-t` 精准定位。
- `tmux kill-session -t pane-demo`
  - 结果：清理示例会话，避免 session 泄漏。

## 示例 2：上/下分屏并运行不同命令
```bash
tmux new-session -d -s pane-demo2
tmux send-keys -t pane-demo2 "printf 'A\\n'; sleep 3600" C-m
tmux split-window -v -t pane-demo2 "printf 'B\\n'; sleep 3600" 
tmux list-panes -t pane-demo2
tmux kill-session -t pane-demo2
```

### 命令解读（示例2）
- `tmux new-session -d -s pane-demo2`
  - 目的：创建一个后台会话作为脚本化多任务场景。
- `tmux send-keys -t pane-demo2 "printf 'A\\n'; sleep 3600" C-m`
  - 目的：向默认 pane 发送一条命令并执行，作为上方任务。
- `tmux split-window -v -t pane-demo2 "printf 'B\\n'; sleep 3600"`
  - 目的：在同一窗口下方新增 pane 并执行另一个任务。
- `tmux list-panes -t pane-demo2`
  - 结果：确认上下两个 pane 均已创建并运行。
- `tmux kill-session -t pane-demo2`
  - 结果：终止 sleep 进程并回收会话。

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

### 命令解读（示例3）
- `tmux new-session -d -s pane-cmd`
  - 目的：创建一个用于验证焦点和同步行为的会话。
- `tmux split-window -h -t pane-cmd`
  - 结果：左右两个 pane，适合对比焦点移动。
- `tmux select-pane -L -t pane-cmd`
  - 目的：把焦点移到左 pane。
- `tmux select-pane -R -t pane-cmd`
  - 目的：把焦点移到右 pane，检查左右切换是否顺畅。
- `tmux setw -g synchronize-panes on`
  - 目的：开启输入广播，所有 pane 接收同一按键。
  - 结果：`send-keys` 会在多个 pane 同时执行。
- `tmux send-keys -t pane-cmd "echo synced input" C-m`
  - 结果：用于快速验证同步是否生效。
- `tmux setw -g synchronize-panes off`
  - 目的：关闭广播，避免后续操作误同步。
- `tmux kill-session -t pane-cmd`
  - 结果：清理示例会话。

## 示例 4：切换布局
```bash
tmux select-layout -t pane-demo tiled
tmux select-layout -t pane-demo even-horizontal
tmux select-layout -t pane-demo even-vertical
tmux kill-session -t pane-demo
```

`tiled` 会尽量均分区域，`even-*` 系列强调等分。

### 命令解读（示例4）
- `tmux select-layout -t pane-demo tiled`
  - 目的：使用网格布局，适合统一观感和均分空间。
- `tmux select-layout -t pane-demo even-horizontal`
  - 目的：按横向等高排列，适合短输出并行对比。
- `tmux select-layout -t pane-demo even-vertical`
  - 目的：按纵向等宽排列，适合日志列式观察。
- `tmux kill-session -t pane-demo`
  - 结果：停止示例并清理资源。

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
