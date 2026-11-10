#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
git -C "$repo_root" rev-parse --verify HEAD >/dev/null

if [[ -n "$(git -C "$repo_root" status --porcelain --untracked-files=all)" ]]; then
  echo '导出中止：请先检查并提交所有未忽略的更改；备份只包含已提交内容。' >&2
  exit 1
fi

output_dir="${1:-$(dirname -- "$repo_root")/backups}"
mkdir -p -- "$output_dir"
output_dir="$(cd -- "$output_dir" && pwd -P)"
case "$output_dir/" in
  "$repo_root/"*)
    echo '导出中止：请将备份输出到项目仓库以外的目录。' >&2
    exit 1
    ;;
esac

umask 077
timestamp="$(date -u +%Y%m%dT%H%M%SZ)"
project="$(basename -- "$repo_root")"
name="$project-$timestamp"
archive="$output_dir/$name.tar.gz"
if [[ -e "$archive" || -e "$archive.sha256" ]]; then
  echo '导出中止：同名备份已存在，请稍后重试或选择另一个目录。' >&2
  exit 1
fi

staging="$(mktemp -d)"
trap 'rm -rf -- "$staging"' EXIT
mkdir -- "$staging/$name"
payload="$staging/$name"
git -C "$repo_root" bundle create "$payload/repository.bundle" --all
git -C "$repo_root" bundle verify "$payload/repository.bundle"
git -C "$repo_root" show HEAD:HANDOFF.md > "$payload/HANDOFF.md"
git -C "$repo_root" show HEAD:README.md > "$payload/README.md"
commit="$(git -C "$repo_root" rev-parse HEAD)"
branch="$(git -C "$repo_root" branch --show-current)"
cat > "$payload/BACKUP_INFO.txt" <<EOF
项目：$project
导出时间（UTC）：$timestamp
提交：$commit
当前分支：${branch:-detached HEAD}
覆盖：本地分支/标签可达的已提交 Git 历史；不包含忽略文件或浏览器待办数据。
状态：这是本地导出，不能据此推断远端同步成功；请另行核实。
EOF
cat > "$payload/RESTORE.md" <<'EOF'
# 恢复

在本目录运行：

```sh
sha256sum -c SHA256SUMS
git clone repository.bundle recovered-project
cd recovered-project
git rev-parse HEAD
```

核对提交号与 BACKUP_INFO.txt 一致，先读取 AGENTS.md、HANDOFF.md 和 README.md。
Git origin 此时指向本地 bundle，原远端及后续同步步骤见 docs/BACKUP.md。
本包不包含浏览器中的实际待办，也不包含已安装的软件。
EOF
(
  cd -- "$payload"
  sha256sum repository.bundle HANDOFF.md README.md BACKUP_INFO.txt RESTORE.md > SHA256SUMS
)
tar -czf "$staging/archive.tar.gz" -C "$staging" "$name"
mv -- "$staging/archive.tar.gz" "$archive"
(
  cd -- "$output_dir"
  sha256sum "$name.tar.gz" > "$name.tar.gz.sha256"
)
printf '备份已导出：%s\n校验文件：%s.sha256\n请将两者下载到独立存储。\n' "$archive" "$archive"
