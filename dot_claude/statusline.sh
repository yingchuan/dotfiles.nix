#!/bin/bash
# Claude Code 狀態欄配置 - 專為中文用戶優化
# 設計風格：簡潔專業，整合 tmux 工作流程

# 讀取 Claude Code 傳入的 JSON 數據
input=$(cat)

# 提取基本信息
current_dir=$(echo "$input" | jq -r '.workspace.current_dir' | sed "s|$HOME|~|")
model_name=$(echo "$input" | jq -r '.model.display_name')
output_style=$(echo "$input" | jq -r '.output_style.name')
user=$(whoami)
hostname=$(hostname -s)

# 簡化目錄顯示 (最多顯示2層)
if [[ ${#current_dir} -gt 40 ]]; then
    # 如果路徑太長，只顯示最後兩級目錄
    simplified_dir=$(echo "$current_dir" | awk -F/ '{
        if (NF > 3) {
            printf ".../%s/%s", $(NF-1), $NF
        } else {
            print $0
        }
    }')
else
    simplified_dir="$current_dir"
fi

# Git 信息獲取
git_info=""
if cd "$(echo "$input" | jq -r '.workspace.current_dir')" 2>/dev/null; then
    # 跳過 git 鎖定檢查，提高性能
    if git rev-parse --git-dir >/dev/null 2>&1; then
        branch=$(git branch --show-current 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
        if [[ -n "$branch" ]]; then
            # 檢查是否有未提交的更改
            if git diff-index --quiet HEAD -- 2>/dev/null; then
                git_status="✓"  # 乾淨狀態
            else
                git_status="●"  # 有更改
            fi
            
            # 檢查是否有未跟蹤的文件
            if [[ -n $(git ls-files --others --exclude-standard 2>/dev/null) ]]; then
                git_status="${git_status}+"
            fi
            
            git_info=" │ ${git_status} $branch"
        fi
    fi
fi

# 時間信息
current_time=$(date '+%H:%M')

# 輸出風格優化標記
style_indicator=""
case "$output_style" in
    "Explanatory") style_indicator=" 📝" ;;
    "Learning") style_indicator=" 🎓" ;;
    "Concise") style_indicator=" ⚡" ;;
    *) style_indicator="" ;;
esac

# 構建狀態欄
# 使用符合中文用戶習慣的分隔符和色彩
printf '\033[90m┌─\033[0m \033[36m%s@%s\033[0m \033[90m│\033[0m \033[34m%s\033[0m\033[33m%s\033[0m \033[90m│\033[0m \033[32m%s\033[0m \033[90m│\033[0m \033[35m%s\033[0m\033[36m%s\033[0m\n' \
    "$user" "$hostname" "$simplified_dir" "$git_info" "$current_time" "$model_name" "$style_indicator"