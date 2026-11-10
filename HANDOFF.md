# 项目交接

更新时间：2026-11-10（UTC）

## 项目定位

- 项目：中文手机待办网页「今天的小清单」。
- 仓库：https://github.com/r08032144-dot/NO.1
- 当前工作目录：`/workspace/NO.1`；分支：`work`。
- 应用入口：`todo/index.html`；不需要构建、付费 API 或服务端数据库。
- 本轮开始时的远端提交：`335b73a1573f51c390221b03123292378b56da8c`。
- 本文随代码提交，当前准确版本请运行 `git rev-parse HEAD`，不在本文中填写自身提交号。

## 已有功能

新增待办、过滤空白、完成/取消完成、删除，以及浏览器 localStorage 保存。
页面适配手机，测试覆盖 390px/320px 宽度和输入内容按文本显示。

## 本轮工作

- 从现有远端提交恢复本地项目，保留应用原有功能。
- 补充 README 的运行、检查和恢复入口。
- 建立 AGENTS 协作约定、技术决策记录、备份/恢复说明和 `.gitignore`。
- 提供 `bash scripts/backup.sh`，导出已提交 Git 历史、交接记录及校验文件。

## 实际验证

- Bash 语法、Git 差异空白及文档相对链接检查通过。
- 在临时副本中提交后导出备份，外部与包内 SHA-256 校验均通过。
- 从 bundle 独立克隆，提交号、Git 历史和全部 10 个跟踪文件逐一一致，恢复后工作区干净。
- 有未提交修改或未跟踪文件时拒绝导出；输出目录位于仓库内时拒绝导出。
- 本轮未改变应用行为，未重跑浏览器功能检查。

## 启动与检查

```sh
cd /workspace/NO.1
python -m http.server 8765 --directory todo --bind 0.0.0.0
```

另开终端：`python tests/check.py`。需要 Playwright 和 `/usr/bin/chromium`。
手机访问需使用平台支持的端口转发或托管网址，云端 localhost 不是手机 localhost。

## 保存边界与待办

- Git 和离线包保存代码与项目记录；真实待办仍只存在于访问者的浏览器中。
- 当前尚无待办导入/导出或跨设备同步，不能从代码仓库恢复个人待办。
- 离线包默认在 `/workspace/backups/`，需要下载到自己的设备或独立存储。
- 未配置定时自动备份；后续每次任务按 AGENTS 约定更新记录，定期提交、推送并导出。
- 下一步由用户指定功能方向；若需要备份实际待办，可另行开发 JSON 导入/导出。

## 可复制到新对话或自行保存到邮件的内容

> 请继续开发仓库 https://github.com/r08032144-dot/NO.1 的 work 分支。这是一个中文手机待办静态网页，入口 todo/index.html。先读取 AGENTS.md、README.md、HANDOFF.md 和 docs/DECISIONS.md，检查 Git 状态及最新提交，再继续用户指定的任务。启动命令为 python -m http.server 8765 --directory todo --bind 0.0.0.0。项目进度以仓库文件为准；Git 备份不包含浏览器内的真实待办。若没有仓库访问权限，请先恢复提供的离线备份。
