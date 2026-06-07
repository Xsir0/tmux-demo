# 05. 复制模式与历史浏览：终端里的轻量“查找器”

## 目标
学会在 tmux 中查看滚动历史、查找内容、复制片段并粘贴到当前窗口。

## 示例 1：打开复制模式并滚动
```bash
tmux new-session -d -s copy-demo "for i in {1..200}; do echo line-$i; done"
tmux attach -t copy-demo
```

在交互模式中按：
- `C-b [`：进入 Copy mode
- `PageUp` / `PageDown`：滚动
- `q`：退出复制模式

## 示例 2：非交互抓取内容到 stdout
```bash
tmux new-session -d -s copy-cmd "printf 'hello\\n'; printf 'error: fail\\n'; printf 'done\\n'"
tmux capture-pane -p -t copy-cmd | sed -n '1,5p'
tmux capture-pane -J -p -t copy-cmd
tmux kill-session -t copy-cmd
```

`-J` 会把换行折叠更友好，`-p` 直接打印。

## 示例 3：搜索关键字
```bash
tmux new-session -d -s search-demo "seq 1 120 | tee /tmp/search-demo.log"
tmux capture-pane -p -S -200 -t search-demo | grep -n "10"
tmux kill-session -t search-demo
```

`-S -200` 表示从后往前拿 200 行（可按需调整）。

## 示例 4：复制到系统剪贴板（Linux/macOS 下按需调整）
```bash
tmux new-session -d -s copybuf
tmux send-keys -t copybuf "echo 'copy me' > /tmp/copybuf.txt" C-m
tmux showb -b 0
tmux kill-session -t copybuf
```

> 实际粘贴到系统剪贴板通常需要配合 `set-clipboard`、`reattach-to-user-namespace`（macOS）或 `xclip/xsel`（Linux）等环境配置，详情见下一章配置部分。

### 命令解读
- `tmux capture-pane -p -t <session>`
  - 把 pane 当前可见文本导出到标准输出，`-p` 直接打印。
- `tmux capture-pane -J -p -t <session>`
  - `-J` 合并换行，方便复制到文件。
- `tmux capture-pane -p -S -200 -t <session>`
  - `-S` 设置起始行，`-200` 表示从后往前取 200 行。
- `tmux send-keys -t copybuf "..." C-m`
  - 向 copybuf 面板输入内容并回车执行。
- `tmux showb -b 0`
  - 查看 tmux 复制缓冲区 0 的内容。
- `tmux new-session -d -s copy-demo ...`
  - 先创建示例会话；`attach` 让你进入会话体验 `C-b [`、`q` 的交互流程。

## 下一步
下一章：把 tmux 变成自己的工具界面（按键和配置）[06 配置篇](./06-keybinds-config.md)

## 可运行脚本

`scripts/05-copy-mode.sh`
