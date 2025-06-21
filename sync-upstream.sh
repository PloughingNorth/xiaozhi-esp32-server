#!/bin/bash

# 同步上游项目脚本
# 用于自动同步 fork 项目与原始项目的最新更新

echo "🚀 开始同步上游项目..."
echo "======================================"

# 检查当前是否在 git 仓库中
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ 错误：当前目录不是一个 Git 仓库"
    exit 1
fi

# 检查是否配置了 upstream 远程仓库
if ! git remote | grep -q "upstream"; then
    echo "❌ 错误：未找到 upstream 远程仓库"
    echo "请先运行：git remote add upstream https://github.com/xinnan-tech/xiaozhi-esp32-server.git"
    exit 1
fi

# 保存当前分支
current_branch=$(git branch --show-current)
echo "📍 当前分支：$current_branch"

# 获取上游更新
echo "📥 正在获取上游更新..."
if ! git fetch upstream; then
    echo "❌ 获取上游更新失败"
    exit 1
fi

# 切换到 main 分支
echo "🔄 切换到 main 分支..."
if ! git checkout main; then
    echo "❌ 切换到 main 分支失败"
    exit 1
fi

# 检查是否有本地未提交的更改
if ! git diff-index --quiet HEAD --; then
    echo "⚠️  警告：检测到未提交的更改，请先提交或暂存"
    echo "是否继续？(y/N)"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        echo "❌ 用户取消操作"
        git checkout "$current_branch"
        exit 1
    fi
fi

# 合并上游更新
echo "🔀 正在合并上游更新..."
if git merge upstream/main; then
    echo "✅ 成功合并上游更新"
else
    echo "❌ 合并失败，可能存在冲突"
    echo "请手动解决冲突后运行：git add . && git commit"
    exit 1
fi

# 推送到自己的仓库
echo "📤 正在推送到您的 fork 仓库..."
if git push origin main; then
    echo "✅ 成功推送到您的 fork 仓库"
else
    echo "❌ 推送失败"
    exit 1
fi

# 恢复到原来的分支
if [[ "$current_branch" != "main" ]]; then
    echo "🔄 恢复到原分支：$current_branch"
    git checkout "$current_branch"
fi

echo "======================================"
echo "🎉 同步完成！您的 fork 已与上游项目保持同步"
echo "📊 查看最新的提交："
git log --oneline -5

echo ""
echo "💡 提示：如果您在其他分支工作，可能需要将这些更新合并到您的分支："
echo "   git checkout your-branch"
echo "   git merge main" 