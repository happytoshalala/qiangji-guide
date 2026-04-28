param(
    [string]$Token,
    [string]$Username,
    [string]$Repo
)

$ErrorActionPreference = "Stop"

Write-Host "=== 开始部署到 GitHub ===" -ForegroundColor Cyan

# 1. 配置 git
cd "c:/Users/Administrator/WorkBuddy/20260428183408"
& "C:/Program Files/Git/cmd/git.exe" config user.name $Username
& "C:/Program Files/Git/cmd/git.exe" config user.email "$Username@users.noreply.github.com"

# 2. 添加文件并提交
& "C:/Program Files/Git/cmd/git.exe" add --all
$commitResult = & "C:/Program Files/Git/cmd/git.exe" commit -m "初始提交：强基计划广东历史类考生指南" 2>&1
Write-Host $commitResult

# 3. 添加远程仓库
$remoteUrl = "https://" + $Username + ":" + $Token + "@github.com/" + $Username + "/" + $Repo + ".git"
& "C:/Program Files/Git/cmd/git.exe" remote remove origin 2>$null
& "C:/Program Files/Git/cmd/git.exe" remote add origin $remoteUrl

# 4. 推送到 GitHub
Write-Host "正在推送到 GitHub..." -ForegroundColor Yellow
$pushResult = & "C:/Program Files/Git/cmd/git.exe" push -u origin master 2>&1
Write-Host $pushResult

# 5. 启用 GitHub Pages
Write-Host "正在启用 GitHub Pages..." -ForegroundColor Yellow
$pagesBody = '{"source":{"branch":"main","path":"/"}}'
$pagesResult = Invoke-RestMethod -Uri "https://api.github.com/repos/$Username/$Repo/pages" `
    -Method Post `
    -Headers @{Authorization="token $Token"; Accept="application/vnd.github.v3+json"} `
    -Body $pagesBody `
    -ContentType "application/json" `
    -ErrorAction SilentlyContinue

if ($pagesResult) {
    Write-Host "GitHub Pages 已启用！" -ForegroundColor Green
} else {
    Write-Host "GitHub Pages 可能需要手动启用，请访问仓库 Settings > Pages" -ForegroundColor Yellow
}

Write-Host "=== 部署完成 ===" -ForegroundColor Green
Write-Host "访问地址：https://$Username.github.io/$Repo/强基计划-广东历史类考生指南.html" -ForegroundColor Magenta
