# Chrome 国家字段修复工具 · macOS

支持 macOS 13 及更新版本、Intel 和 Apple Silicon，无需安装依赖或联网。

## 使用

1. 解压到自己的可写目录。
2. 在 Chrome 中按 **Command-Q** 完全退出。
3. 双击 **Run-Fix.command**，看到 **SUCCESS** 后重新打开 Chrome。

`No changes needed` 表示无需修改。运行期间保持 Chrome 退出，不要使用 `sudo`。

工具只将 `Local State` 和两个 V2 种子文件中的本机国家值 `cn`（不区分大小写）改为 `us`，保留其他配置、实验规则和签名。缺失字段不会补建。

## 检查与恢复

在终端进入本工具文件夹后执行：

```bash
# 只检查，不修改文件
./Fix-ChromeCountry --check

# 恢复指定备份，执行前退出 Chrome
./Fix-ChromeCountry --restore-backup "./Backups/某次备份目录"

# 查看自定义数据目录、备份目录等参数
./Fix-ChromeCountry --help
```

默认处理 `~/Library/Application Support/Google/Chrome`。每次实际修改或恢复前，自动备份到程序旁的 `Backups`，终端会显示路径。恢复自定义数据目录时须同时传入原来的 `--user-data-directory`。

## 打开问题

若转存后丢失执行权限，在终端进入本工具文件夹后执行：

```bash
chmod u+x ./Run-Fix.command ./Fix-ChromeCountry
```

首次运行需要完成以下授权：

- 在 **设置 → 隐私与安全性 → 安全性** 中，分别放行程序 `Fix-ChromeCountry` 和启动器 `Run-Fix.command`。此工具未经 Apple 开发者证书签名和公证，系统可能分别拦截这两个文件。
- 允许**终端访问 Chrome 的文件与文件夹**；出现访问提示时选择允许，并检查终端的相关访问权限。

已完成两架构编译与静态检查，用户已在 Mac 上实际测试并确认修复成功。首次使用仍建议先运行 `--check`。断电或强制终止时可能需要从备份恢复；本地国家字段修改不保证 Gemini 等服务器控制功能出现。

第三方许可合并保存在 `LICENSE.txt`。
