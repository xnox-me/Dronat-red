# Dockerfile for a complete development environment
FROM ubuntu:22.04

# Set non-interactive frontend for package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies and build tools
RUN apt-get update && apt-get install -y     build-essential     curl     wget     unzip     git     sudo     ripgrep     fd-find     python3-pip     python3-venv     tmux     && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd -m -s /bin/bash -G sudo devuser
RUN echo "devuser:devuser" | chpasswd
USER devuser
WORKDIR /home/devuser

# Install Anaconda
RUN curl -O https://repo.anaconda.com/archive/Anaconda3-2024.02-1-Linux-x86_64.sh &&     bash Anaconda3-2024.02-1-Linux-x86_64.sh -b -p /home/devuser/anaconda3 &&     rm Anaconda3-2024.02-1-Linux-x86_64.sh
ENV PATH="/home/devuser/anaconda3/bin:${PATH}"

# Install Meson
RUN pip install meson

# Install Neovim
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz &&     tar -xzf nvim-linux64.tar.gz &&     mv nvim-linux64 /home/devuser/.local/share/ &&     rm nvim-linux64.tar.gz
ENV PATH="/home/devuser/.local/share/nvim-linux64/bin:${PATH}"

# Copy Neovim configuration
COPY --chown=devuser:devuser nvim /home/devuser/.config/nvim

# Pre-install Neovim plugins
RUN nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' || true
RUN nvim --headless -c 'Lazy sync' +qa

# Set the entrypoint to bash
CMD ["/bin/bash"]
