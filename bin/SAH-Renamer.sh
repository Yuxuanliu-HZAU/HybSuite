#!/bin/bash

# 检查是否提供了目录参数
if [ -z "$1" ]; then
  echo "请提供目标目录"
  exit 1
fi

TARGET_DIR="$1"

# 递归重命名所有文件中的名称（不处理目录）
rename_files() {
    find "$1" -type f | while read entry; do
        dir=$(dirname "$entry")
        base=$(basename "$entry")

        # 替换文件名中的字符串
        new_base=$(echo "$base" | sed 's/Spiraea_pilosa/Spiraea_pilosa_WGS/g')

        # 如果名称发生变化，进行重命名
        if [ "$base" != "$new_base" ]; then
            mv "$entry" "$dir/$new_base"
            echo "[SAH]  Renaming the filename: $entry -> $dir/$new_base"
        fi
    done
}

# 替换文件内容中的字符串
replace_content_in_files() {
    find "$1" -type f | while read file; do
        # 使用 sed 替换文件内容中的字符串
        sed -i 's/Spiraea_pilosa/Spiraea_pilosa_WGS/g' "$file"
        echo "[SAH]  Renaming contents of the file: $file"
    done
}

# 递归重命名所有目录中的名称
rename_dirs() {
    # 使用 -depth 选项确保先处理子目录，再处理父目录
    find "$1" -depth -type d | while read entry; do
        dir=$(dirname "$entry")
        base=$(basename "$entry")

        # 替换目录名中的字符串
        new_base=$(echo "$base" | sed 's/Spiraea_pilosa/Spiraea_pilosa_WGS/g')

        # 如果名称发生变化，进行重命名
        if [ "$base" != "$new_base" ]; then
            mv "$entry" "$dir/$new_base"
            echo "[SAH]  Renaming the directory: $entry -> $dir/$new_base"
        fi
    done
}

# 先处理文件内容替换
replace_content_in_files "$TARGET_DIR"

# 再重命名所有文件
rename_files "$TARGET_DIR"

# 最后重命名所有目录
rename_dirs "$TARGET_DIR"
