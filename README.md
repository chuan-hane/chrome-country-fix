# Chrome 国家字段修复脚本

适用：64 位 Windows，Windows 自带的 PowerShell 5.1。无需管理员权限、安装软件或联网。

`Fix-ChromeCountry.ps1` 是自包含脚本，已内置 Zstandard 1.5.7 压缩库；只使用 Windows 自带的系统库。`Run-Fix.cmd` 是方便双击的启动器，两者放在同一个文件夹即可。脚本也可以单独带走使用。

## 日常使用

1. 关闭所有 Chrome 窗口。若 Chrome 仍在后台运行，先退出后台进程；脚本会检查 `chrome.exe`，发现仍在运行就停止，不会强制结束它。
2. 双击 **Run-Fix.cmd**。
3. 看到 **SUCCESS** 后，再打开 Chrome。若已经修复，会显示 **No changes needed**，不会重写文件。

以后这些文件被 Chrome 更新后，重复上述步骤即可。此工具是手动修复器，不会定时运行或监控文件。

默认目录：`%LOCALAPPDATA%\Google\Chrome\User Data`。默认处理当前 Windows 用户的数据目录。

## 替换范围

只将代表客户端所在国家、且完整值等于 `cn` 或 `CN` 的值改成 `us`。

`Local State` 会检查四个顶层字段：

- `variations_country`
- `variations_permanent_consistency_country`：只改 `[版本号, 国家]` 的第二项
- `variations_safe_seed_session_consistency_country`
- `variations_safe_seed_permanent_consistency_country`

缺少的字段不会补建；已经是 `us` 的值和其他国家值不变。

`VariationsSeedV2`、`VariationsSafeSeedV2` 会先解压，再解析 `StoredSeedInfo` 的顶层 protobuf 字段：

- 字段 6：`session_country_code`
- 字段 7：`permanent_country_code`

这两个字段就是之前检查发现的本机国家元数据。V2 内的服务器实验规则可能也包含国家名单；它们属于签名覆盖的 seed 内容，含义与本机国家不同，脚本保留这些规则。签名、版本、时间戳、其他元数据及未知字段保持原始内容。JSON 不重新序列化，只替换目标值对应的文本位置，保留其余格式和内容。

文件格式不符合预期、国家字段格式异常、文件被占用或无法备份时，脚本会报错停止。写入前先解析全部文件；写入时独占锁定文件，保存原始备份，回读并再次校验。写入失败会尝试从内存还原本次操作前的内容。

## 只检查

在本文件夹打开 PowerShell，执行：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Fix-ChromeCountry.ps1 -Check
```

会列出国家字段和计划替换数量，不会写入 Chrome 文件。这个模式可以在 Chrome 运行时使用，但结果仅代表读取当时的文件状态。

## 自定义目录

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Fix-ChromeCountry.ps1 -UserDataDirectory 'D:\ChromeData'
```

参数指向包含 `Local State` 和 V2 文件的 **User Data 根目录**，不是 `Default` 或 `Profile 1` 子目录。

## 备份与恢复

每次实际修改前，脚本会把本次存在的文件完整备份到脚本旁的 `Backups\日期时间-随机编号` 文件夹，并写入包含 SHA-256 的 `manifest.json`。运行结果会显示该备份目录的完整路径。

恢复前关闭 Chrome，指定某次备份的目录：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Fix-ChromeCountry.ps1 -RestoreBackup '.\Backups\某次备份目录'
```

自定义 User Data 路径时，恢复也要传入相同的 `-UserDataDirectory`。恢复会校验备份所属目录及内容哈希，并再次备份当前文件。

可以通过 `-BackupDirectory 'D:\ChromeCountryBackups'` 更改备份存放位置。

## 验证与适用范围

已在 Windows 自带 PowerShell 5.1 上验证四种 JSON 国家字段、只检查模式、重复运行不重写、精确备份恢复、异常格式停止及缺失字段不补建。V2 文件经解压和逐字节对比，实验内容、签名和非目标字段保持不变。

脚本仅修改本地客户端国家元数据。Google 账号资格、功能开关和后续服务器下发仍可能影响 Gemini 入口。脚本不会启动 Chrome 或调整 Chrome 更新服务。

## 文件说明

- `Fix-ChromeCountry.ps1`：自包含修复脚本，包含 C# 处理代码及压缩库。
- `Run-Fix.cmd`：双击启动器，自动选择 64 位 Windows PowerShell。
- `Zstandard-LICENSE.txt`：内置压缩库的许可。

备份可能包含个人浏览器数据，请保留在本机，勿上传到公开仓库。

## 压缩库许可

内置 Zstandard 1.5.7 采用 BSD-3-Clause 许可，完整许可见 `Zstandard-LICENSE.txt`，脚本自身也包含完整许可。
