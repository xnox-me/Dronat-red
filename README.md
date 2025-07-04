# nvimmer_dronatxxx

This repository contains a Dockerfile to build a complete, portable development environment with an interactive menu.

## Included Tools

*   Neovim (with custom configuration)
*   Anaconda
*   Meson
*   Node.js & npm
*   GitHub CLI (`gh`)
*   n8n
*   Tmux
*   Essential build tools

## Docker

### Build the Image

```bash
docker build -t nvimmer_dronatxxx .
```

### Run the Container

```bash
docker run -it -p 5678:5678 nvimmer_dronatxxx
```

When you run the container, you will be greeted with an interactive menu to launch the various tools.

## Manual Installation

This guide assumes you are on a Debian/Ubuntu-based Linux distribution.

### 1. Neovim

This will set up the Neovim configuration from this repository.

```bash
# First, ensure you have the necessary dependencies:
sudo apt-get update
sudo apt-get install -y git curl

# Then, run the one-click installer for the Neovim configuration:
curl -sSL https://raw.githubusercontent.com/eihabhala/nvim-config-backup/master/install.sh | bash
```

### 2. Anaconda

Anaconda is a distribution of the Python and R programming languages for scientific computing.

```bash
# Download the Anaconda installer
curl -O https://repo.anaconda.com/archive/Anaconda3-2024.02-1-Linux-x86_64.sh

# Run the installer script
bash Anaconda3-2024.02-1-Linux-x86_64.sh

# Follow the on-screen prompts. It is recommended to accept the default settings.
# After the installation is complete, restart your shell for the changes to take effect.
```

### 3. Meson

Meson is an open source build system.

```bash
# Install Meson using pip, which is included with Anaconda
pip install meson
```

### 4. n8n

n8n is a workflow automation tool.

```bash
# Install n8n using npm
npm install -g n8n
```

### 5. GitHub CLI

The official command-line tool for GitHub.

```bash
# Install the GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh
```
