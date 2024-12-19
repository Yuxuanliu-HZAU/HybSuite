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
    ["mafft"]="mafft=7.307"
    ["Gblocks"]="gblocks=0.91b"
    ["FastTree"]="fasttree=2.1.10"
    ["Pasta"]="pasta=1.8.2"
    ["Prank"]="prank=170427"
)

# 安装所有包
for package in "${!packages[@]}"; do
    version=${packages[$package]}
    echo "Installing $package version $version..."
    conda install $version -y
done

echo "All packages installed successfully."