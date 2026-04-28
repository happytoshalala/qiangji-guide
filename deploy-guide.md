# GitHub 一键部署指南

## 方案一：使用 GitHub CLI（推荐）

### 1. 安装 GitHub CLI
下载安装：https://github.com/cli/cli/releases/latest

或使用命令（管理员 PowerShell）：
```powershell
winget install --id GitHub.cli
```

### 2. 登录 GitHub
```powershell
gh auth login
```
按提示操作，选择 GitHub.com → HTTPS → 浏览器登录

### 3. 一键创建仓库并部署
```powershell
cd "c:/Users/Administrator/WorkBuddy/20260428183408"
gh repo create qiangji-guide --public --source=. --push --gitignore=none
```

### 4. 启用 GitHub Pages
```powershell
gh api -X POST /repos/{owner}/qiangji-guide/pages --field source.branch=main --field source.path=/
```

---

## 方案二：手动操作（无需安装额外工具）

### 1. 在 GitHub 创建新仓库
- 访问 https://github.com/new
- 仓库名：`qiangji-guide`（或你喜欢的名字）
- 选择 **Public**
- ✅ 勾选 **Add a README file**
- 点击 **Create repository**

### 2. 推送代码
```powershell
cd "c:/Users/Administrator/WorkBuddy/20260428183408"
git add "强基计划-广东历史类考生指南.html"
git commit -m "初始提交：强基计划广东历史类考生指南"
git remote add origin https://github.com/{你的用户名}/qiangji-guide.git
git push -u origin main
```

### 3. 启用 GitHub Pages
- 进入仓库 → Settings → Pages
- Source 选择 `main` 分支
- 点击 Save
- 等待 1-2 分钟，访问：`https://{你的用户名}.github.io/qiangji-guide/强基计划-广东历史类考生指南.html`

---

## 方案三：使用 Personal Access Token（自动化）

### 1. 创建 Token
访问：https://github.com/settings/tokens/new
- 名称：`workbuddy-deploy`
- 过期时间：30天
- 勾选：`repo`（完整仓库权限）
- 点击 **Generate token**
- **复制生成的 token**（只显示一次）

### 2. 运行部署脚本
将以下脚本保存为 `deploy.ps1`，替换 `{TOKEN}` 和 `{USERNAME}`：

```powershell
$ErrorActionPreference = "Stop"

$token = "{TOKEN}"
$username = "{USERNAME}"
$repo = "qiangji-guide"

# 配置 git
cd "c:/Users/Administrator/WorkBuddy/20260428183408"
git config user.name "$username"
git config user.email "$username@users.noreply.github.com"

# 提交
git add "强基计划-广东历史类考生指南.html"
git commit -m "初始提交"

# 创建仓库
Invoke-RestMethod -Uri "https://api.github.com/user/repos" `
  -Method Post `
  -Headers @{Authorization="token $token"} `
  -Body "`"name`":`"$repo`",`"public`":true" `
  -ContentType "application/json"

# 推送
git remote add origin "https://$username:$token@github.com/$username/$repo.git"
git push -u origin main

Write-Host "仓库已创建：https://github.com/$username/$repo"
```

---

## 推荐流程（最简单）

1. 访问 https://github.com/new 创建仓库（名：`qiangji-guide`）
2. 复制仓库 URL
3. 告诉我你的 GitHub 用户名和仓库名，我来帮你完成推送
