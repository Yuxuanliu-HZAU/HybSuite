#!/bin/bash
set -eu

# HybSuite Dependency Installer (POSIX-compliant)
INSTALL_LOG="HybSuite_dependencies_install.log"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Initialize variables
CONDA_ENV1=""
CONDA_ENV2=""

# Dependency lists
ENV1_DEPS='
bioconda::sra-tools
conda-forge::pigz
bioconda::hybpiper
bioconda::trimmomatic=0.39
bioconda::iqtree
bioconda::raxml
bioconda::raxml-ng
bioconda::modeltest-ng
bioconda::fasttree
bioconda::newick_utils
conda-forge::r-base
conda-forge::r-phytools
conda-forge::r-ape
'

ENV2_DEPS='
bioconda::paragone
'

show_help() {
    printf "\nUsage: %s -conda1 <primary_env> -conda2 <paragone_env>\n" "$0"
    printf "\nRequired parameters:"
    printf "\n  -conda1\tPrimary environment name"
    printf "\n  -conda2\tParagone environment name"
    printf "\n\nExample: %s -conda1 hyb_main -conda2 pg_env\n\n" "$0"
    exit 0
}

# Error handling
fatal_error() {
    printf "${RED}%s${NC}\n" "$1" >&2
    exit 1
}

# Check if environment exists
env_exists() {
    conda env list | grep -qE "^${1}[[:space:]]"
}

# Install/verify mamba in target environment
ensure_mamba() {
    env_name="$1"
    python_version="$2"
    
    # Create environment if not exists
    if ! env_exists "$env_name"; then
        printf "Creating environment '%s'..." "$env_name"
        conda create -n "$env_name" -y python="${python_version}" >> "$INSTALL_LOG" 2>&1 || 
            fatal_error "Failed to create environment '$env_name'"
        printf "${GREEN}Created${NC}\n"
    fi

    # Check mamba installation
    printf "Checking mamba in '%s'..." "$env_name"
    if conda list -n "$env_name" | grep -qE '^mamba[[:space:]]'; then
        printf "${GREEN}Present${NC}\n"
    else
        printf "${YELLOW}Not found, installing...${NC}\n"
        conda install -n "$env_name" conda-forge::mamba -y >> "$INSTALL_LOG" 2>&1 ||
            fatal_error "Failed to install mamba in '$env_name'"
        printf "${GREEN}Mamba installed${NC}\n"
    fi
}

conda_activate() {
    local conda="$1"

    # Check whether conda is available
    if ! command -v conda &>/dev/null; then
        echo "Conda command not found. Please install Conda or ensure it's in your PATH."
        exit 1
    fi

    # Secure access to the current conda environment (compatible with set-u)
    local current_env="${CONDA_DEFAULT_ENV:-}"

    # Defines the function to load the conda hook
    load_conda_hook() {
        local current_shell=$(basename "$SHELL")
        case "$current_shell" in
            bash)
                eval "$(conda shell.bash hook)"
                echo "Bash shell detected. Conda hook loaded."
                ;;
            zsh)
                eval "$(conda shell.zsh hook)"
                echo "Zsh shell detected. Conda hook loaded."
                ;;
            sh)
                eval "$(conda shell.sh hook)"
                echo "Sh shell detected. Conda hook loaded."
                ;;
            fish)
                eval "(conda shell.fish hook)"
                echo "Fish shell detected. Conda hook loaded."
                ;;
            *)
                echo "Unsupported shell: $current_shell"
                exit 1
                ;;
        esac
    }
	# main logic
    if [ "$current_env" = "$conda" ]; then
        echo "${log_mode}" "Already in conda environment ${conda}. Skipping activation."
        echo ""
        return 0
    fi

    # Situations where an environment needs to be activated
    echo "Activating conda environment: ${conda}"

    # Turn off Strict mode temporarily
    set +u
    load_conda_hook

    # Execute activation command
    conda activate "${conda}"
    echo "conda activate ${conda}"

    # Verify activation result
    current_env="${CONDA_DEFAULT_ENV:-}"
    if [ "$current_env" = "$conda" ]; then
        echo "${log_mode}" "Successfully activated ${conda} environment"
        echo "${log_mode}" ""
    else
        echo "Failed to activate ${conda} environment"
        echo "Current environment: ${current_env:-none}"
        echo ""
        exit 1
    fi
}
# Install packages using environment's mamba
install_packages() {
    env_name="$1"
    packages="$2"
    
    echo "$packages" | while IFS= read -r dep; do
        [ -z "$dep" ] && continue
        
        channel=$(echo "$dep" | cut -d':' -f1-2)
        package=$(echo "$dep" | cut -d':' -f3-)
        
        printf "Checking ${package} in '%s'..." "$env_name"
        package="${package%%=*}"
        if conda list -n "$env_name" 2>/dev/null | grep -qE "^${package}\b" ; then
          printf "${GREEN}Present${NC}\n"
        else
          if [ "$channel" = "$dep" ]; then
            printf "\nInstalling %s in %s..." "$package" "$env_name"
            cmd="mamba install -y"
          else
            printf "\nInstalling %s (channel: %s) in %s..." "$package" "$channel" "$env_name"
            cmd="mamba install -y $channel"
          fi
          conda_activate "${env_name}"
          eval "${cmd}:${package}" >> "$INSTALL_LOG" 2>&1 && 
          printf "${GREEN}Success${NC}\n" || 
          fatal_error "Failed to install $dep in $env_name"
        fi
    done
}

# Main logic
main() {
    # Parse arguments
    while [ $# -gt 0 ]; do
        case "$1" in
            -conda1) CONDA_ENV1="$2"; shift 2 ;;
            -conda2) CONDA_ENV2="$2"; shift 2 ;;
            -h|--help) show_help ;;
            *) fatal_error "Invalid argument: $1" ;;
        esac
    done

    [ -z "$CONDA_ENV1" ] || [ -z "$CONDA_ENV2" ] && 
        fatal_error "Both -conda1 and -conda2 are required"

    # Verify conda
    command -v conda >/dev/null 2>&1 || 
        fatal_error "Conda not found. Install Miniconda/Anaconda first."

    # Process primary environment
    printf "\nProcessing primary environment '%s'\n" "$CONDA_ENV1"
    ensure_mamba "$CONDA_ENV1" "3.8"
    install_packages "$CONDA_ENV1" "$ENV1_DEPS"

    # Install Python packages
    printf "Installing Python packages in %s..." "$CONDA_ENV1"
    conda run -n "$CONDA_ENV1" pip install pandas seaborn matplotlib numpy PyQt5 ete3 phylopypruner >> "$INSTALL_LOG" 2>&1 &&
        printf "${GREEN}Success${NC}\n" ||
        fatal_error "Failed to install Python packages"

    # Process Paragone environment
    printf "\nProcessing Paragone environment '%s'\n" "$CONDA_ENV2"
    ensure_mamba "$CONDA_ENV2" "3.9.16"
    install_packages "$CONDA_ENV2" "$ENV2_DEPS"

    # Verify installations
    printf "\n${GREEN}Installation completed!${NC} Verifying...\n"
    validate() {
        env_name="$1"
        shift
        for cmd in "$@"; do
            if [ "${cmd}" = "raxml" ]; then
              cmd="raxmlHPC"
            fi
            printf "Checking %s in %s..." "$cmd" "$env_name"
            conda run -n "$env_name" command -v "$cmd" >/dev/null 2>&1 &&
                printf "${GREEN}OK${NC}\n" ||
                fatal_error "$cmd not found in $env_name"
        done
    }

    validate "$CONDA_ENV1" prefetch fasterq-dump hybpiper trimmomatic iqtree raxml
    validate "$CONDA_ENV2" paragone

    # Final message
    printf "\n${GREEN}Success!${NC} Use these parameters with HybSuite:\n"
    printf "  -conda1 %s -conda2 %s\n" "$CONDA_ENV1" "$CONDA_ENV2"
}

main "$@"
