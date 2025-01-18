#!/bin/bash

# ============================================================
# NockApp Installer Script
# ============================================================
# This script installs NockApp along with all its dependencies.
# It provides clear progress indicators and handles
# dependency management automatically.
# ============================================================

# ----------------------------
# Define Colors for Output
# ----------------------------
PINK='\033[38;5;205m'
ORANGE='\033[38;5;214m'
RED='\033[38;5;196m'
GREEN='\033[38;5;46m'
BLUE='\033[38;5;51m'
BOLD='\033[1m'
NC='\033[0m'  # No Color

# ----------------------------
# Function: Display Messages
# ----------------------------
print_message() {
    local color="$1"
    local message="$2"
    echo -e "${color}${BOLD}${message}${NC}"
}

# ----------------------------
# Function: Display Progress Bar
# ----------------------------
complete_progress() {
    local task="$1"
    local bar_length=50
    local filled_length=$bar_length
    local empty_length=$((bar_length - filled_length))
    local filled_bar=$(printf "%0.s#" $(seq 1 $filled_length))
    local empty_bar=$(printf "%0.s " $(seq 1 $empty_length))
    printf "[%s%s] 100%% %s\n" "$filled_bar" "$empty_bar" "$task"
}

# ----------------------------
# Function: Check and Install Dependencies
# ----------------------------
install_dependencies() {
    local dependencies=("git" "cargo" "curl" "wget" "tput" "build-essential")
    missing_deps=()

    print_message "$ORANGE" "🔍 Checking for required dependencies..."

    for cmd in "${dependencies[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_deps+=("$cmd")
        fi
    done

    if [ ${#missing_deps[@]} -eq 0 ]; then
        print_message "$GREEN" "✔️  All dependencies are already installed."
    else
        print_message "$ORANGE" "⚠️  Missing dependencies detected: ${missing_deps[*]}"
        print_message "$ORANGE" "🔧 Installing missing dependencies..."

        for dep in "${missing_deps[@]}"; do
            case "$dep" in
                git)
                    install_git
                    complete_progress "Git installed successfully."
                    ;;
                cargo)
                    install_rust
                    complete_progress "Rust and Cargo installed successfully."
                    ;;
                curl)
                    install_curl
                    complete_progress "curl installed successfully."
                    ;;
                wget)
                    install_wget
                    complete_progress "wget installed successfully."
                    ;;
                tput)
                    install_tput
                    complete_progress "tput installed successfully."
                    ;;
                build-essential)
                    install_build_essential
                    complete_progress "build-essential installed successfully."
                    ;;
                *)
                    print_message "$RED" "❌  Unknown dependency: $dep"
                    ;;
            esac
        done
    fi
}

# ----------------------------
# Function: Install Git
# ----------------------------
install_git() {
    print_message "$BLUE" "🚀 Installing Git..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt-get update && sudo apt-get install git -y
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install git
    else
        print_message "$RED" "❌  Unsupported OS for automatic Git installation."
        exit 1
    fi
}

# ----------------------------
# Function: Install Rust and Cargo
# ----------------------------
install_rust() {
    print_message "$BLUE" "🚀 Installing Rust and Cargo..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
}

# ----------------------------
# Function: Install Curl
# ----------------------------
install_curl() {
    print_message "$BLUE" "🚀 Installing curl..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt-get update && sudo apt-get install curl -y
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install curl
    else
        print_message "$RED" "❌  Unsupported OS for automatic curl installation."
        exit 1
    fi
}

# ----------------------------
# Function: Install Wget
# ----------------------------
install_wget() {
    print_message "$BLUE" "🚀 Installing wget..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt-get update && sudo apt-get install wget -y
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install wget
    else
        print_message "$RED" "❌  Unsupported OS for automatic wget installation."
        exit 1
    fi
}

# ----------------------------
# Function: Install tput
# ----------------------------
install_tput() {
    print_message "$BLUE" "🚀 Installing tput..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt-get update && sudo apt-get install ncurses-bin -y
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install ncurses
    else
        print_message "$RED" "❌  Unsupported OS for automatic tput installation."
        exit 1
    fi
}

# ----------------------------
# Function: Install Build Essentials
# ----------------------------
install_build_essential() {
    print_message "$BLUE" "🚀 Installing build-essential..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt-get update && sudo apt-get install build-essential -y
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        xcode-select --install
    else
        print_message "$RED" "❌  Unsupported OS for automatic build-essential installation."
        exit 1
    fi
}

# ----------------------------
# Function: Create Cargo.toml
# ----------------------------
create_cargo_toml() {
    print_message "$ORANGE" "📄 Creating Cargo.toml..."
    cat <<EOL > Cargo.toml
[package]
name = "nockapp"
version = "0.1.0"
edition = "2021"

[dependencies]
crown = "0.1.0"
sword = "0.1.0"

[[bin]]
name = "choo"
path = "src/bin/choo.rs"

[[bin]]
name = "http-app"
path = "src/bin/http_app.rs"
EOL
}

# ----------------------------
# Function: Check and Create Project Structure
# ----------------------------
check_and_create_project_structure() {
    print_message "$ORANGE" "🔧 Checking project structure..."

    if [ ! -d "src/bin" ]; then
        mkdir -p src/bin
        complete_progress "Created directory src/bin."
    fi

    if [ ! -f "src/bin/choo.rs" ]; then
        print_message "$ORANGE" "📄 Creating choo.rs..."
        cat <<EOL > src/bin/choo.rs
fn main() {
    println!("Running the NockApp Choo binary...");
}
EOL
        complete_progress "choo.rs created successfully."
    fi

    if [ ! -f "src/bin/http_app.rs" ]; then
        print_message "$ORANGE" "📄 Creating http_app.rs..."
        cat <<EOL > src/bin/http_app.rs
fn main() {
    println!("Running the NockApp HTTP App binary...");
}
EOL
        complete_progress "http_app.rs created successfully."
    fi
}

# ----------------------------
# Function: Clone Repository
# ----------------------------
clone_repository() {
    print_message "$ORANGE" "🌐 Cloning the NockApp repository..."
    git clone --depth=1 https://github.com/zorp-corp/nockapp.git &> /dev/null
    if [ $? -ne 0 ]; then
        print_message "$RED" "❌  Failed to clone repository. Please check your internet connection and try again."
        exit 1
    fi
    complete_progress "Repository cloned successfully."
}

# ----------------------------
# Function: Build the Project
# ----------------------------
build_project() {
    print_message "$ORANGE" "🔨 Building NockApp..."
    cargo build --release &> /dev/null
    if [ $? -ne 0 ]; then
        print_message "$RED" "⚠️  Build failed! Attempting to clean and rebuild..."
        cargo clean &> /dev/null
        cargo build --release &> /dev/null
        if [ $? -ne 0 ]; then
            print_message "$RED" "❌  Rebuild failed. Please check the build logs for more details."
            exit 1
        fi
    fi
    complete_progress "NockApp built successfully."
}

# ----------------------------
# Function: Run NockApp Binary
# ----------------------------
run_nockapp() {
    print_message "$ORANGE" "🚀 Running the NockApp binary..."

    if [ -d "choo" ]; then
        cd choo || { print_message "$RED" "❌  Failed to navigate to choo directory."; exit 1; }
        cargo run --release hoon/lib/kernel.hoon &> /dev/null
        if [ $? -ne 0 ]; then
            print_message "$RED" "❌  Failed to run the Choo binary."
            exit 1
        fi
    elif [ -f "./target/release/http-app" ]; then
        ./target/release/http-app &> /dev/null
        if [ $? -ne 0 ]; then
            print_message "$RED" "❌  Failed to run the HTTP-App binary."
            exit 1
        fi
    else
        print_message "$RED" "⚠️  Neither 'choo' directory nor 'http-app' binary found."
        exit 1
    fi
    complete_progress "NockApp is now running."
}

# ----------------------------
# Main Installation Flow
# ----------------------------

# Welcome Message
print_message "$PINK" "${BOLD}🚀 WELCOME TO THE NOCKAPP INSTALLER 🚀${NC}"

# Install Dependencies
install_dependencies

# Remove old directory if exists
if [ -d "nockapp" ]; then
    print_message "$ORANGE" "🗑️  Removing existing nockapp directory..."
    rm -rf nockapp
    if [ $? -ne 0 ]; then
        print_message "$RED" "❌  Failed to remove existing nockapp directory."
        exit 1
    fi
    complete_progress "Old nockapp directory removed."
fi

# Clone the Repository
clone_repository

# Navigate to Project Directory
cd nockapp || { print_message "$RED" "❌  Failed to navigate to nockapp directory."; exit 1; }

# Create Cargo.toml if Missing or Empty
if [ ! -f "Cargo.toml" ] || [ ! -s "Cargo.toml" ]; then
    create_cargo_toml
    complete_progress "Cargo.toml created successfully."
fi

# Check and Create Project Structure
check_and_create_project_structure

# Install Project Dependencies
print_message "$ORANGE" "📦 Installing project dependencies..."
cargo install --path . &> /dev/null
if [ $? -ne 0 ]; then
    print_message "$RED" "❌  Failed to install project dependencies."
    exit 1
fi
complete_progress "Project dependencies installed successfully."

# Build the Project
build_project

# Run the NockApp Binary
run_nockapp

# Final Thank You Message
print_message "$PINK" "${BOLD}🎉 THANK YOU FOR INSTALLING AND RUNNING NOCKAPP! 🎉${NC}"
echo -en "\007"  # Beep sound

# Exit Successfully
exit 0
