# iPhone Codex 最小验证项目

中文手机待办网页：新增、完成/取消完成、删除、浏览器 localStorage 保存。

## 运行

在仓库根目录执行：

```sh
python -m http.server 8765 --directory todo --bind 0.0.0.0
```

云端的 localhost 不代表 iPhone；手机访问需要受支持的端口转发或托管网址。
项目无依赖、无付费 API、无服务端数据库。数据保存在访问者当前浏览器，清除网站数据会丢失，不跨设备同步。

## 从手机继续

回到同一个 ChatGPT 会话，要求继续修改 `/workspace/NO.1/todo`。
若开启新任务，选择仓库 `r08032144-dot/NO.1`，先读取 `AGENTS.md` 和 `HANDOFF.md`，并核实远端最新提交。
云端工作区不是永久备份；本地 Git 提交也不等于上传 GitHub。

测试使用虚构事项；禁止放入银行内部资料或客户信息。

## 项目记录

- [HANDOFF.md](HANDOFF.md)：当前状态、验证结果和下一步；新对话先读这里。
- [AGENTS.md](AGENTS.md)：后续开发时的记录与交接约定。
- [docs/DECISIONS.md](docs/DECISIONS.md)：重要技术决定及原因。
- [docs/BACKUP.md](docs/BACKUP.md)：提交、远端备份、离线导出及恢复方法。

## 验证

保持上述 HTTP 服务运行，另开终端执行：

```sh
python tests/check.py
```

此检查需要 Python 的 `playwright` 包和 `/usr/bin/chromium`，运行应用本身不需要这些依赖。
它使用独立浏览器上下文中的虚构数据，验证新增、完成/取消、删除、刷新保存及手机布局，
并重写 `mobile-preview.png`。当前云环境已具备这些测试工具；其他环境需另行安装。

## 一键导出已提交项目

```sh
bash scripts/backup.sh
```

脚本要求先提交所有未忽略的更改，默认将含 Git 历史和交接记录的压缩包写入仓库旁的 `backups/`。
请下载到自己的设备或独立存储；同一云环境中的压缩包仍然只是本地副本。
压缩包不会包含浏览器里的待办事项，详见备份说明。
