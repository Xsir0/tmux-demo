# 00. 安装与环境确认

## 目标
确认当前机器已安装 tmux，并理解基础使用前的环境约定。

## 示例 1：检查是否安装 tmux
```bash
tmux -V
```

### 命令解读
- `tmux -V`
  - 用途：确认 tmux 主程序是否可执行。
  - 说明：`-V` 是 version 的缩写，只返回版本号字符串。
  - 预期输出：`tmux 3.x`（或 `tmux 2.x/4.x`，按你本机版本）
  - 典型错误：`tmux: command not found` 表示未安装或未在 PATH。

预期：
```text
tmux 3.x
```

## 示例 2：确认 PATH 与可执行权限
```bash
command -v tmux
```

### 命令解读
- `command -v tmux`
  - 用途：确认当前 shell 能找到 `tmux` 可执行文件。
  - 说明：返回的是解析后的路径，不是版本。
  - 预期输出：如 `/usr/bin/tmux` 或 `/opt/homebrew/bin/tmux`。
  - 典型错误：无输出表示 `tmux` 不在可搜索路径。

预期：
```text
/usr/bin/tmux
```
（不同环境会有不同路径）

## 示例 3：检查端口冲突？（不需要端口，但检查终端是否支持）
创建一个最短会话并立刻分离验证：
```bash
tmux new-session -d -s tmux-hello
tmux ls
tmux kill-session -t tmux-hello
```

预期：
1. `tmux ls` 里能看到 `tmux-hello`。
2. kill 之后 `tmux ls` 不再显示该会话（若无其他会话则报错 `no server running` 是正常现象）。

### 命令解读
- `tmux new-session -d -s tmux-hello`
  - `new-session`：创建会话；`-d` 表示不自动进入；`-s` 指定会话名。
- `tmux ls`
  - 列出当前 tmux 服务器下的所有会话。
- `tmux kill-session -t tmux-hello`
  - 按 `-t` 目标名字 `tmux-hello` 删除会话，常用于清理示例。

## 示例 4：新手最常用的交互快捷键
进入会话前先熟记：
- `C-b`：前缀键（prefix）
- `C-b ?`：查看全部快捷键
- `C-b d`：分离到后台（detach）
- `C-b :`：命令行模式

接下来可以直接看下一章：[01 快速入门](./01-session-basic.md)

## 可运行脚本

`scripts/00-installation-check.sh`
