# tmux 学习手册（可运行示例版）

这套文档按“从最基础到高级”组织，每一章都是一个**独立用法文件**，并且都包含可直接运行的命令。  
建议顺序阅读：

1. [00. 安装与环境确认](./00-installation.md)
2. [01. 快速入门：建立会话并返回](./01-session-basic.md)
3. [02. 会话管理：列出/重命名/切换/清理](./02-session-management.md)
4. [03. 窗口（Window）管理](./03-window-management.md)
5. [04. 面板（Pane）分屏与布局](./04-pane-management.md)
6. [05. 复制模式与滚动历史](./05-copy-mode.md)
7. [06. 快捷键与配置文件（配置化你的 tmux）](./06-keybinds-config.md)
8. [07. 实战脚本：非交互脚本方式启动复杂布局](./07-scripted-workflows.md)
9. [08. 远程开发与会话共享](./08-remote-shared-workflows.md)
10. [09. 插件与高阶增强（可选）](./09-plugins-advanced.md)
11. [10. 常见问题与排错](./10-troubleshooting.md)
12. [11. agent 联动工作流示例](./11-agent-integration.md)

> 约定：所有示例默认使用 `C-b` 作为前缀键（即按 `Ctrl+b`）。
>  
> 你可以先在任意一节里单独运行，再回到总流程补齐概念链路。

每章脚本文件在 `scripts/` 目录，按编号一一对应（`00-installation-check.sh` 到 `11-agent-integration.sh`）。
脚本说明在 [`scripts/README.md`](../scripts/README.md)。

每一章现在都加了“命令解读”小节：看不懂某个参数时先读那一节，再执行。
