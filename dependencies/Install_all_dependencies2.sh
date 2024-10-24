#!/bin/bash

#if [ -z "$1" ]; then
#    echo "Please provide your name of the conda environment: bash $0 <conda environment>"
#    exit 1
#fi

# 设置环境名称
#ENV_NAME=$1

#conda activate "$ENV_NAME"
# 列出要安装的包及其版本
declare -A packages=(
    ["Rcorrector"]="Rcorrector"
    ["Trimmomatic"]="trimmomatic=0.36"
    ["Bowtie2"]="bowtie2=2.3.3"
    ["FastQC"]="fastqc=0.11.6"
    ["Trinity"]="trinity=2.5.1"
    ["Transrate"]="transrate=1.0.3"
    ["Salmon"]="salmon=0.9.1"
    ["TransDecoder"]="transdecoder=5.3.0"
    ["cd-hit"]="cd-hit=4.6.8"
    ["MCL"]="mcl=14-137"
    ["TreeShrink"]="treeshink=1.3.2"
    ["RAxML"]="raxml=8.2.11"
    ["mafft"]="mafft=7.487"
    ["Gblocks"]="gblocks=0.91b"
    ["FastTree"]="fasttree=2.1.10"
    ["Pasta"]="pasta=1.8.2"
    ["Prank"]="prank=170427"
)

# 检查包是否已安装的函数
function is_package_installed {
    package_name=$1
    if conda list | grep -q "$package_name"; then
        return 0  # 已安装
    else
        return 1  # 未安装
    fi
}

# 用于跟踪成功和失败的安装
declare -A install_status

# 安装所有包
for package in "${!packages[@]}"; do
    version=${packages[$package]}
    if is_package_installed "$version"; then
        echo "$package version $version is already installed. Skipping..."
        install_status["$package"]="Already Installed"
    else
        echo "Installing $package version $version..."
        if conda install $version -y; then
            install_status["$package"]="Installed Successfully"
        else
            install_status["$package"]="Installation Failed"
        fi
    fi
done

# 输出安装结果
echo -e "\nInstallation Summary:"
for package in "${!install_status[@]}"; do
    echo "$package: ${install_status[$package]}"
done

echo "All specified packages checked and installed where necessary."
