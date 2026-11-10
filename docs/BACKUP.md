# 保存、备份与恢复

## 每次开发结束

1. 更新 `HANDOFF.md`；必要时补充 README 和 `docs/DECISIONS.md`。
2. 运行与改动相关的检查，查看 `git status` 和 `git diff`。
3. 按文件暂存修改，检查暂存内容后提交。例如：

   ```sh
   git add README.md HANDOFF.md
   git diff --cached
   git commit -m "Update project handoff"
   ```

4. 推送到已配置的远端，并核对本地与远端 work 分支的哈希一致：

   ```sh
   git push -u origin work
   git rev-parse HEAD
   git ls-remote origin refs/heads/work
   ```

   推送失败时只算本地保存，应记录失败原因。遇到远端新提交，先读取和整合，不使用强制推送覆盖。

现有远端是 `https://github.com/r08032144-dot/NO.1.git`。
访问权限及可见性由仓库设置决定，不应默认它是私有仓库。

## 导出离线副本

在仓库根目录执行：

```sh
bash scripts/backup.sh
# 或指定仓库外的输出目录：
bash scripts/backup.sh /workspace/shared/backups
```

需要 Git、Bash、tar、sha256sum。脚本不安装软件、不访问网络、不自动推送。
工作区存在未提交或未跟踪且未忽略的文件时拒绝导出。

默认在仓库旁的 `backups/` 创建时间戳压缩包及其 `.sha256` 文件，包含：

- `repository.bundle`：所有本地分支/标签可达的 Git 历史和已提交文件。
- `HANDOFF.md`、`README.md`：便于直接查看的交接信息。
- `BACKUP_INFO.txt`：准确的提交号、分支、UTC 时间及覆盖范围。
- `RESTORE.md`：恢复步骤；`SHA256SUMS`：包内文件校验。

请下载压缩包和外部 `.sha256` 文件到自己的设备或独立存储。
同一实例中的副本不能防止整个环境丢失。校验和用于检查文件完整性，不提供加密。

## 在另一环境恢复

先准备 Git、tar、sha256sum。在备份文件所在目录，将下面的时间戳换成实际文件名：

```sh
sha256sum -c NO.1-时间戳.tar.gz.sha256
tar -xzf NO.1-时间戳.tar.gz
cd NO.1-时间戳
sha256sum -c SHA256SUMS
git clone repository.bundle recovered-project
cd recovered-project
```

独立的 `git clone` 和包内校验用于验证可恢复性。恢复后的 origin 指向本地 bundle，
要继续使用原远端时再设置：

```sh
git remote set-url origin https://github.com/r08032144-dot/NO.1.git
git fetch origin
git status
```

对照 `BACKUP_INFO.txt` 中的提交号，读取 HANDOFF，然后按 README 启动。
若直接从 GitHub 恢复：

```sh
git clone --branch work https://github.com/r08032144-dot/NO.1.git
cd NO.1
```

## 不包含的内容

- 忽略文件、未提交更改、机器中安装的软件和运行中的服务。
- 浏览器 localStorage 中的实际待办。本项目尚未提供导入/导出，切换浏览器或网址可能看不到原记录。
- 未来若加入数据库或上传文件，需另设数据导出和恢复流程。

真实密钥应通过环境设置或密钥管理服务恢复，不放进 Git、交接摘要或邮件。
自行把 HANDOFF 的续接段落保存到 Gmail 可以帮助找回上下文；完整项目仍需仓库或离线包。
