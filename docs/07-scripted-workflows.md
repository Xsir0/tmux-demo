# 07. 非交互脚本化工作流（高级）

## 目标
用一条命令组装“会话 + 多窗口 + 多面板 + 自动命令”，做到可重复执行。

## 示例 1：一条命令生成开发环境布局
```bash
tmux new-session -d -s dev-env -c ~/work
tmux new-window -t dev-env -n editor
tmux split-window -h -t dev-env:editor
tmux split-window -v -t dev-env:editor.0
tmux send-keys -t dev-env:editor.0 "cd ~/work && printf 'pane-0:server\\n'" C-m
tmux send-keys -t dev-env:editor.1 "cd ~/work && printf 'pane-1:tests\\n'" C-m
tmux send-keys -t dev-env:editor.2 "cd ~/work && printf 'pane-2:shell\\n'" C-m
tmux list-panes -t dev-env:editor
```

现在有一个会话和三个可复用面板。

### 命令解读（示例1）
- `tmux new-session -d -s dev-env -c ~/work`
  - 目的：创建会话并设置初始目录，方便脚本在固定路径执行命令。
- `tmux new-window -t dev-env -n editor`
  - 结果：在 `dev-env` 下增加 `editor` 窗口，默认用于日常操作。
- `tmux split-window -h -t dev-env:editor`
  - 目的：在编辑器窗口做水平分割，形成并行 pane。
- `tmux split-window -v -t dev-env:editor.0`
  - 目的：针对 pane 0 再做垂直分割，得到3个面板。
- `tmux send-keys -t dev-env:editor.0 "cd ~/work && printf 'pane-0:server\\n'" C-m`
  - 结果：给 pane 0 发送首条初始化命令。
- `tmux send-keys -t dev-env:editor.1 "cd ~/work && printf 'pane-1:tests\\n'" C-m`
  - 结果：给 pane 1 发送测试相关输出命令。
- `tmux send-keys -t dev-env:editor.2 "cd ~/work && printf 'pane-2:shell\\n'" C-m`
  - 结果：给 pane 2 留一个 shell 面板。
- `tmux list-panes -t dev-env:editor`
  - 结果：验证pane数量和布局是否符合预期。

## 示例 2：在多个窗口启动不同任务
```bash
tmux new-window -t dev-env -n frontend -c ~/work/frontend "npm --version"
tmux new-window -t dev-env -n backend -c ~/work/backend "go version"
tmux new-window -t dev-env -n logs "tail -f /tmp/dev.log"
tmux list-windows -t dev-env
```

### 命令解读（示例2）
- `tmux new-window -t dev-env -n frontend -c ~/work/frontend "npm --version"`
  - 目的：在 frontend 工作树启动版本检查窗口。
  - 常见报错：`No such file or directory` 常见于路径写错。
- `tmux new-window -t dev-env -n backend -c ~/work/backend "go version"`
  - 目的：在 backend 目录启动版本检查窗口。
- `tmux new-window -t dev-env -n logs "tail -f /tmp/dev.log"`
  - 目的：新建持续输出日志窗口便于观察后台状态。
- `tmux list-windows -t dev-env`
  - 结果：看到窗口树，确认 3 个窗口都已创建。

## 示例 3：脚本化进入/输出（适配 CI 调试）
```bash
tmux capture-pane -p -t dev-env:frontend > /tmp/tmux-frontend.txt
tmux send-keys -t dev-env:logs "echo after capture" C-m
```

> `capture-pane` 常用于 CI/调试后自动归档最近屏幕输出。

### 命令解读（示例3）
- `tmux capture-pane -p -t dev-env:frontend > /tmp/tmux-frontend.txt`
  - 目的：把 `frontend` 窗口当前内容抓到离线文件。
- `tmux send-keys -t dev-env:logs "echo after capture" C-m`
  - 目的：在 logs 窗口打一个分界标记，便于回溯。

## 示例 4：将命令打包成一个可重复脚本
```bash
tmux new-session -d -s bundle-demo -c ~/work
tmux set-window-option -t bundle-demo:0 remain-on-exit on
tmux send-keys -t bundle-demo "printf 'job start\\n'" C-m
tmux pipe-pane -t bundle-demo -o "cat >> /tmp/bundle-demo.log"
```

`-o` 表示只在 pane 有新输出时触发一次管道，适合逐步构建日志收集链路。

### 命令解读（示例4）
- `tmux new-session -d -s bundle-demo -c ~/work`
  - 目的：创建一个固定目录的会话，作为可复用脚本模板。
- `tmux set-window-option -t bundle-demo:0 remain-on-exit on`
  - 目的：窗口任务结束后保留窗口，方便看最后输出。
- `tmux send-keys -t bundle-demo "printf 'job start\\n'" C-m`
  - 结果：执行初始化命令并开始日志链路。
- `tmux pipe-pane -t bundle-demo -o "cat >> /tmp/bundle-demo.log"`
  - 结果：将 pane 输出追加进日志文件，供后续审核。

## 示例 5：清理测试会话
```bash
tmux kill-session -t dev-env
tmux kill-session -t bundle-demo
```

### 命令解读（示例5）
- `tmux kill-session -t dev-env`
  - 目的：清理主开发环境模拟会话。
- `tmux kill-session -t bundle-demo`
  - 目的：清理脚本打包会话，避免资源残留。

## 下一步
更进一步是跨主机、远程会话和共享场景，见：[08 远程与共享](./08-remote-shared-workflows.md)

## 可运行脚本

`scripts/07-scripted-workflows.sh`
