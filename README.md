# nvim-and-friends

This repository contains my Neovim configuration, along with setup instructions for a complete development environment including Anaconda and Meson.

## Docker

This repository contains a Dockerfile to build a complete, portable development environment.

### Build the Image

```bash
docker build -t nvimmer_dronatxxx .
```

### Run the Container

```bash
docker run -it nvimmer_dronatxxx
```

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

## Usage

Once you have completed the installation steps, you will have a complete development environment with:

*   **Neovim:** A highly customized and powerful text editor.
*   **Anaconda:** A package manager and environment manager for Python.
*   **Meson:** A modern and fast build system.
