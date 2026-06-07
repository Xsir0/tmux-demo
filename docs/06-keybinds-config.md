# 06. 按键与配置文件：把重复动作标准化

## 目标
把高频操作固化到 `.tmux.conf`，提高稳定性和团队一致性。

## 示例 1：创建一个最小配置
```bash
cat > ~/.tmux.conf <<'EOF'
set -g mouse on
set -g history-limit 50000
set -g base-index 1
setw -g pane-base-index 1
set -g prefix C-a
unbind C-b
bind C-a send-prefix
bind r source-file ~/.tmux.conf \; display "tmux config reloaded"
bind -n C-l send-keys C-l
EOF
```

> 这里只展示“思路”，生产环境请按你喜好补充，不要直接替换默认风格导致习惯中断。

## 示例 2：重载配置
```bash
tmux source-file ~/.tmux.conf
```

进入 tmux 后也可以：
```bash
tmux set -g prefix C-a
```

## 示例 3：常见有用键位映射（可选）
```bash
# 在一个 pane 内快速水平与垂直分屏
tmux bind-key | split-window -h
tmux bind-key - split-window -v
# 切换到上一个/下一个窗口
tmux bind-key -n M-h previous-window
tmux bind-key -n M-l next-window
```

如果不想影响现有会话，先在 `.tmux.conf` 写好后重启一个新 server 验证：
```bash
tmux kill-server
tmux new -s config-test
```

## 示例 4：状态栏微调（高频可视化）
```bash
tmux set -g status-interval 2
tmux set -g status-left-length 40
tmux set -g status-left '#[bg=blue,fg=white] #S '
tmux set -g status-right '#[fg=yellow]%Y-%m-%d %H:%M #[fg=green]#h'
```

### 命令解读
- `cat > ~/.tmux.conf <<'EOF' ... EOF`
  - 写入 tmux 全局配置文件（用户主目录），后续新会话会按此文件加载。
- `tmux source-file ~/.tmux.conf`
  - 重新加载当前 tmux 配置，生效新增设置。
- `set -g ... / setw -g ... / set -g ...`
  - `-g` 表示全局生效（对 session/window 之外）
- `tmux bind-key` / `bind-key -n`
  - 自定义快捷键，`-n` 表示无前缀也可触发，`bind-key` 通常要配合前缀键。
- `tmux kill-server`
  - 停掉当前 tmux 服务器，通常用于验证新配置不会污染现有长期会话。
- `tmux set -g status-interval/status-left-length/status-left/status-right`
  - 状态栏时间刷新、左侧/右侧显示模板设置。

## 下一步
把这些配置能力用于复杂自动化流程，见 [07 脚本化工作流](./07-scripted-workflows.md)

## 可运行脚本

`scripts/06-keybinds-config.sh`
