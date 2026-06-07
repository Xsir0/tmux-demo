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

### 命令解读（示例1）
- `tmux new-session -d -s copy-demo "for i in {1..200}; do echo line-$i; done"`
  - 目的：在后台创建一个包含大量行的会话，用于验证历史记录。
- `tmux attach -t copy-demo`
  - 目的：附着到会话并人工测试 `C-b [` 等快捷键。
  - 常见报错：`no server running on ...` 表示会话已结束。

## 示例 2：非交互抓取内容到 stdout
```bash
tmux new-session -d -s copy-cmd "printf 'hello\\n'; printf 'error: fail\\n'; printf 'done\\n'"
tmux capture-pane -p -t copy-cmd | sed -n '1,5p'
tmux capture-pane -J -p -t copy-cmd
tmux kill-session -t copy-cmd
```

`-J` 会把换行折叠更友好，`-p` 直接打印。

### 命令解读（示例2）
- `tmux new-session -d -s copy-cmd "printf ..."`
  - 目的：生成示例输出（含普通行与错误语义行）放入 pane。
- `tmux capture-pane -p -t copy-cmd | sed -n '1,5p'`
  - 目的：把 pane 可见内容导出到标准输出，再用 `sed` 取首 5 行。
- `tmux capture-pane -J -p -t copy-cmd`
  - 目的：抓取并将软换行折叠，便于阅读/拼接。
- `tmux kill-session -t copy-cmd`
  - 结果：示例结束后清理。

## 示例 3：搜索关键字
```bash
tmux new-session -d -s search-demo "seq 1 120 | tee /tmp/search-demo.log"
tmux capture-pane -p -S -200 -t search-demo | grep -n "10"
tmux kill-session -t search-demo
```

`-S -200` 表示从后往前拿 200 行（可按需调整）。

### 命令解读（示例3）
- `tmux new-session -d -s search-demo "seq 1 120 | tee /tmp/search-demo.log"`
  - 目的：生成连续数字并保存原始日志，便于后续检索。
- `tmux capture-pane -p -S -200 -t search-demo | grep -n "10"`
  - 目的：抓取最近 200 行并找包含 `10` 的记录。
  - 结果：你会看到 `10,100,110...` 等匹配行。
- `tmux kill-session -t search-demo`
  - 结果：清理会话与日志进程。

## 示例 4：复制到系统剪贴板（Linux/macOS 下按需调整）
```bash
tmux new-session -d -s copybuf
tmux send-keys -t copybuf "echo 'copy me' > /tmp/copybuf.txt" C-m
tmux showb -b 0
tmux kill-session -t copybuf
```

> 实际粘贴到系统剪贴板通常需要配合 `set-clipboard`、`reattach-to-user-namespace`（macOS）或 `xclip/xsel`（Linux）等环境配置，详情见下一章配置部分。

### 命令解读（示例4）
- `tmux new-session -d -s copybuf`
  - 目的：创建一个用于验证 copy buffer 的小会话。
- `tmux send-keys -t copybuf "echo 'copy me' > /tmp/copybuf.txt" C-m`
  - 目的：在会话里产生可复制文本并落盘，便于和系统剪贴板流程对照。
- `tmux showb -b 0`
  - 结果：查看编号为 0 的 tmux 复制缓冲内容。
  - 常见误区：`showb` 展示的是 tmux 内缓冲，不等于系统剪贴板。
- `tmux kill-session -t copybuf`
  - 结果：清理会话。

## 下一步
下一章：把 tmux 变成自己的工具界面（按键和配置）[06 配置篇](./06-keybinds-config.md)

## 可运行脚本

`scripts/05-copy-mode.sh`
