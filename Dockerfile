# Dockerfile for a complete development environment
FROM ubuntu:22.04

# Set non-interactive frontend for package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies and build tools
RUN apt-get update && apt-get install -y     build-essential     curl     wget     unzip     git     sudo     ripgrep     fd-find     python3-pip     python3-venv     tmux     nodejs     npm     && rm -rf /var/lib/apt/lists/*

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | tee /usr/share/keyrings/githubcli-archive-keyring.gpg > /dev/null     && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg     && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null     && apt-get update     && apt-get install gh -y

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

# Install n8n
RUN npm install -g n8n

# Install Lean
RUN curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh -s -- -y
ENV PATH="/home/devuser/.elan/bin:${PATH}"

# Install Neovim
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz &&     tar -xzf nvim-linux64.tar.gz &&     mv nvim-linux64 /home/devuser/.local/share/ &&     rm nvim-linux64.tar.gz
ENV PATH="/home/devuser/.local/share/nvim-linux64/bin:${PATH}"

# Copy Neovim configuration and menu script
COPY --chown=devuser:devuser nvim /home/devuser/.config/nvim
COPY --chown=devuser:devuser menu.sh /home/devuser/menu.sh

# Pre-install Neovim plugins
RUN nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' || true
RUN nvim --headless -c 'Lazy sync' +qa

# Set the entrypoint to the menu script
ENTRYPOINT ["/home/devuser/menu.sh"]
