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

### 命令解读（示例 1）
- `cat > ~/.tmux.conf <<'EOF' ... EOF`
  - 以 heredoc 方式直接写文件。
  - 典型用途：一次性生成 `.tmux.conf` 模板，后续再按环境微调。
  - 预期：`~/.tmux.conf` 文件被创建并含以下配置：
    - `mouse on`
    - `history-limit 50000`
    - `base-index 1`
    - `pane-base-index 1`
    - `prefix C-a`（将前缀改为 `Ctrl+a`）
    - `bind r source-file ...`（提供配置重载快捷键）
- 常见问题：
  - 覆盖后如果旧会话未重载，设置不生效。
  - `~/.tmux.conf` 路径写错会导致 tmux 找不到配置文件。

## 示例 2：重载配置
```bash
tmux source-file ~/.tmux.conf
```
### 命令解读（示例 2）
- `tmux source-file ~/.tmux.conf`
  - 作用：对当前 tmux 实例重新读取配置。
  - 结果：已生效的配置立即覆盖大部分会话行为（非重启也可生效）。
  - 常见报错：`can't open file`，通常是文件名路径错误或无读权限。

进入 tmux 后也可以：
```bash
tmux set -g prefix C-a
```
### 命令解读（示例 2.1）
- `tmux set -g prefix C-a`
  - 在不重启的当前 tmux 会话里临时改前缀。
  - `-g` 表示全局设置；重启后失效，除非保存到 `.tmux.conf`。

## 示例 3：常见有用键位映射（可选）
```bash
# 在一个 pane 内快速水平与垂直分屏
tmux bind-key | split-window -h
tmux bind-key - split-window -v
# 切换到上一个/下一个窗口
tmux bind-key -n M-h previous-window
tmux bind-key -n M-l next-window
```
### 命令解读（示例 3）
- `tmux bind-key | split-window -h`
  - 绑定竖线 `|`（在 `prefix` 后）到水平分屏命令。
- `tmux bind-key - split-window -v`
  - 绑定短横线 `-` 到垂直分屏命令。
- `tmux bind-key -n M-h previous-window`
  - `-n` 为无前缀键绑定；`M-h`（Alt+H）直接切到上个窗口。
- `tmux bind-key -n M-l next-window`
  - `M-l`（Alt+L）直接切到下个窗口。
- 结果：在高频切分场景下减少手指路径。
- 常见误解：使用 `-n` 后按键会与系统快捷键冲突。

如果不想影响现有会话，先在 `.tmux.conf` 写好后重启一个新 server 验证：
```bash
tmux kill-server
tmux new -s config-test
```
### 命令解读（示例 3 补充）
- `tmux kill-server`
  - 停掉当前 tmux 服务端与所有会话；有未保存任务时风险较大。
- `tmux new -s config-test`
  - 验证新配置最小影响的方式：建一个新会话先观察行为。

## 示例 4：状态栏微调（高频可视化）
```bash
tmux set -g status-interval 2
tmux set -g status-left-length 40
tmux set -g status-left '#[bg=blue,fg=white] #S '
tmux set -g status-right '#[fg=yellow]%Y-%m-%d %H:%M #[fg=green]#h'
```

### 命令解读（示例 4）
- `tmux set -g status-interval 2`
  - 设定状态栏刷新频率（秒）。
- `tmux set -g status-left-length 40`
  - 限制左侧状态显示长度，避免超宽文本挤压。
- `tmux set -g status-left '#[bg=blue,fg=white] #S '`
  - 左侧模板：显示会话名（`#S`），并设置颜色。
- `tmux set -g status-right '#[fg=yellow]%Y-%m-%d %H:%M #[fg=green]#h'`
  - 右侧模板：显示年月日时分和主机名（`#h`）。

## 下一步
把这些配置能力用于复杂自动化流程，见 [07 脚本化工作流](./07-scripted-workflows.md)

## 可运行脚本

`scripts/06-keybinds-config.sh`
