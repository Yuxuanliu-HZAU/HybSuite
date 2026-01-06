#!/bin/bash
set -eu

# HybSuite Dependency Installer
INSTALL_LOG="HybSuite_dependencies_install.log"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Error handling
fatal_error() {
    printf "${RED}%s${NC}\n" "$1" >&2
}

# Check conda
command -v conda >/dev/null 2>&1 || fatal_error "Conda not found. Install Miniconda/Anaconda first."

echo "Step1: Installing all conda dependencies in current environment..."

if conda list python | grep -q "^python *3\.9\.15"; then
    printf "${GREEN}Python 3.9.15 already installed, skipping.${NC}\n"
else
    printf "Installing python 3.9.15..."
    conda install conda-forge::python=3.9.15 -y >> "$INSTALL_LOG" 2>&1 ||
        fatal_error "Failed to install python 3.9.15"
    printf "${GREEN}Python 3.9.15 installed${NC}\n"
fi

# Install mamba
if conda list mamba | grep -q "^mamba"; then
    printf "${GREEN}Mamba already installed, skipping.${NC}\n"
else
    printf "${YELLOW}Mamba not found, installing...${NC}\n"
    conda install conda-forge::mamba=1.5.8 -y >> "$INSTALL_LOG" 2>&1 ||
        fatal_error "Failed to install mamba"
    printf "${GREEN}mamba installed${NC}\n"
fi

install_conda_deps() {
    package_name=$1
    version=$2
    channel=$3
    if conda list "$package_name" | grep -q "^$package_name *$version"; then
        printf "${GREEN}${package_name} already installed, skipping.${NC}\n"
    else
        printf "Installing %s..." "$package_name"
        mamba install -y "$channel::$package_name=$version" >> "$INSTALL_LOG" 2>&1 && printf "${GREEN}Success${NC}\n" || fatal_error "Failed to install $package_name"
    fi
}

install_conda_deps_without_version() {
    package_name=$1
    channel=$2
    if conda list "$package_name" | grep -q "^$package_name"; then
        printf "${GREEN}${package_name} already installed, skipping.${NC}\n"
    else
        printf "Installing %s..." "$package_name"
        conda install -y "$channel::$package_name" >> "$INSTALL_LOG" 2>&1 && printf "${GREEN}Success${NC}\n" || fatal_error "Failed to install $package_name"
    fi
}

install_conda_deps "hybpiper" "2.3.2" "bioconda"
install_conda_deps "paragone" "1.1.1" "bioconda"
install_conda_deps "sra-tools" "3.1.1" "bioconda"
install_conda_deps "trimmomatic" "0.39" "bioconda"
install_conda_deps "iqtree" "2.3.6" "bioconda"
install_conda_deps "raxml" "8.2.13" "bioconda"
install_conda_deps "raxml-ng" "1.2.2" "bioconda"
install_conda_deps "modeltest-ng" "0.1.7" "bioconda"
install_conda_deps "fasttree" "2.1.11" "bioconda"
install_conda_deps "newick_utils" "1.6" "bioconda"
install_conda_deps "amas" "1.0" "bioconda"
install_conda_deps_without_version "r-base" "conda-forge"
install_conda_deps_without_version "aster" "bioconda"
install_conda_deps_without_version "r-phytools" "conda-forge"
install_conda_deps_without_version "r-ape" "conda-forge"

install_python_deps() {
    package_name=$1
    if pip show "$package_name" >/dev/null 2>&1; then
        printf "${GREEN}${package_name} already installed, skipping.${NC}\n"
    else
        printf "Installing %s..." "$package_name"
        pip install $package_name >> "$INSTALL_LOG" 2>&1 && printf "${GREEN}Success${NC}\n" || fatal_error "Failed to install $package_name"
    fi
}

install_python_deps "pandas"
install_python_deps "seaborn"
install_python_deps "matplotlib"
install_python_deps "numpy"
install_python_deps "PyQt5"
install_python_deps "ete3"
install_python_deps "phylopypruner"
install_python_deps "plotly"

validate() {
    for cmd in "$@"; do
        printf "Checking %s..." "$cmd"
        type "$cmd" >/dev/null 2>&1 && printf "${GREEN}OK${NC}\n" || fatal_error "$cmd not found"
    done
}
printf "\n"
echo "Step2: Validating all dependencies in current environment..."
validate prefetch fasterq-dump hybpiper trimmomatic iqtree raxmlHPC paragone phylopypruner

printf "\n${GREEN}All dependencies for HybSuite installed successfully in the current environment!${NC}\n"
