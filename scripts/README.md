# tmux 示例脚本

每章文档的可运行脚本在本目录，按章节编号一一对应：

- `00-installation-check.sh`
- `01-session-basic.sh`
- `02-session-management.sh`
- `03-window-management.sh`
- `04-pane-management.sh`
- `05-copy-mode.sh`
- `06-keybinds-config.sh`
- `07-scripted-workflows.sh`
- `08-remote-shared.sh`
- `09-plugins-advanced.sh`
- `10-troubleshooting.sh`
- `11-agent-integration.sh`

运行前建议先给脚本赋予可执行权限（首次安装后）：
```bash
chmod +x scripts/*.sh
```

常用环境变量：
- `KEEP_SESSION=1`：脚本执行完不自动销毁会话（便于你手工观察）。
- `AGENT_CMD`：`11-agent-integration.sh` 使用的 agent CLI 命令名（默认自动探测）。
- `REMOTE_HOST`：`08-remote-shared.sh` 时展示可选的 SSH 示例命令。
- `ALLOW_NETWORK=1`：`09-plugins-advanced.sh` 时允许 clone TPM。

每个脚本都尽量把命令写成可重复执行（session/window/pane 名都带随机后缀），不会覆盖你已有会话。

