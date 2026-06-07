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

## 示例 2：在多个窗口启动不同任务
```bash
tmux new-window -t dev-env -n frontend -c ~/work/frontend "npm --version"
tmux new-window -t dev-env -n backend -c ~/work/backend "go version"
tmux new-window -t dev-env -n logs "tail -f /tmp/dev.log"
tmux list-windows -t dev-env
```

## 示例 3：脚本化进入/输出（适配 CI 调试）
```bash
tmux capture-pane -p -t dev-env:frontend > /tmp/tmux-frontend.txt
tmux send-keys -t dev-env:logs "echo after capture" C-m
```

> `capture-pane` 常用于 CI/调试后自动归档最近屏幕输出。

## 示例 4：将命令打包成一个可重复脚本
```bash
tmux new-session -d -s bundle-demo -c ~/work
tmux set-window-option -t bundle-demo:0 remain-on-exit on
tmux send-keys -t bundle-demo "printf 'job start\\n'" C-m
tmux pipe-pane -t bundle-demo -o "cat >> /tmp/bundle-demo.log"
```

`-o` 表示只在 pane 有新输出时触发一次管道，适合逐步构建日志收集链路。

## 示例 5：清理测试会话
```bash
tmux kill-session -t dev-env
tmux kill-session -t bundle-demo
```

## 下一步
更进一步是跨主机、远程会话和共享场景，见：[08 远程与共享](./08-remote-shared-workflows.md)

## 可运行脚本

`scripts/07-scripted-workflows.sh`
