# 本地 XDG 存储适配

此 skill 的运行时与目录探测已做本地适配。不要通过设置 `HOME` 或在主目录建立 `.quarkclouddrive` 链接来改变路径。

| 内容 | 目录 | 未设置或为空时的默认值 |
|---|---|---|
| 登录配置（包含敏感凭据） | `$XDG_CONFIG_HOME/quarkclouddrive/<agent>/config.json` | `~/.config/quarkclouddrive/<agent>/config.json` |
| 上传、下载断点，SDK 状态，重命名撤销记录 | `$XDG_STATE_HOME/quarkclouddrive/<agent>/` | `~/.local/state/quarkclouddrive/<agent>/` |
| 日志 | `$XDG_STATE_HOME/quarkclouddrive/logs/` | `~/.local/state/quarkclouddrive/logs/` |
| 搜索结果、二维码、目录探测及其历史 | `$XDG_CACHE_HOME/quarkclouddrive/<agent>/` | `~/.cache/quarkclouddrive/<agent>/` |

只接受绝对路径的 XDG 环境变量；相对路径按未设置处理。新建目录权限为 `0700`，新写入的登录配置权限为 `0600`。已有目录权限保持不变。无法写入指定目录时报告权限问题，不回退到工作目录或主目录下的隐藏目录。用户明确指定的下载目标、重命名记录文件位置不变。

旧配置作为只读迁移来源：已有可解析的 XDG 配置优先（包括空账号配置）；否则依次读取 skill 安装目录的 `<agent>/config.json`、工作目录的 `.quarkclouddrive/<agent>/config.json`、旧工作目录的 `.quarkclouddrive/config.json`、`~/.quarkclouddrive/<agent>/config.json`。有有效登录态时运行时会写入 XDG 配置，保留源文件。注销后保留不含账号凭据的空配置，避免下次运行重新导入旧登录态。旧任务记录不会自动搬迁；续传或撤销时仍使用原命令返回的记录文件路径。实际写入前须遵守当前任务的文件权限范围，不能因迁移而绕过权限限制。

`xdg/apply.cjs` 保留在 `scripts/` 外。安装脚本在执行 CLI 前检查适配，并在安装下载的脚本前重新应用适配；找不到预期上游结构时停止更新，保留已安装版本。保留这个目录，不要用上游 zip 手工覆盖整个 skill。更新 skill 仍通过 `scripts/install.sh`，更新后重新阅读 SKILL.md 和本文。

本次修改不迁移或删除已有用户数据。迁移任务记录或清理旧目录应作为单独、明确授权的操作。

规范：[XDG Base Directory Specification](https://specifications.freedesktop.org/basedir/latest/)。
