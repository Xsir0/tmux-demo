# 11. 与 Agent 工作流联动（tmux 实战）

## 目标
把 tmux 用成“agent 运行区 + 日志观察区 + 人工输入区”的工作面板，适合 AI/自动化协作场景。

## 示例：一键启动 agent 工作区
```bash
TMUX_AGENT_SESSION=tmux-agent-demo KEEP_SESSION=1 scripts/11-agent-integration.sh
```

脚本会创建一个 `agent-control` 结构，包含：
- 面板 0：控制面（用于运行 agent 命令）
- 面板 1：日志尾随（`tail -f agent-demo-events.log`，默认在脚本临时目录）
- 面板 2：任务事件模拟写入（`{\"event\":\"task-*\"}`）

## 典型联动方式

### 方式 A：用现成的 `codex` 命令
```bash
export AGENT_CMD=codex
KEEP_SESSION=1 scripts/11-agent-integration.sh
tmux attach -t tmux-agent-*
```

### 方式 B：将命令替换为你自己的 Agent CLI
```bash
export AGENT_CMD="/path/to/your/agent-cli"
KEEP_SESSION=1 scripts/11-agent-integration.sh
```

在脚本中，`AGENT_CMD --help` 会先在控制面执行，便于确认 CLI 可用。

### 方式 C：只做日志观察面板（纯演示）
```bash
AGENT_CMD= scripts/11-agent-integration.sh
```

你可以将 `event` 生成器替换为真实的 agent 工具输出文件（例如：`/tmp/agent_events.log`），形成统一观察入口。

> 这个示例默认**不改变你的全局 tmux 配置**，适合和你现有会话直接叠加。

## 对应脚本
`scripts/11-agent-integration.sh`
