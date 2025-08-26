# Dockerfile for a complete development environment
FROM ubuntu:24.04

# Set non-interactive frontend for package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies and build tools (without nodejs/npm from apt)
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    wget \
    unzip \
    git \
    sudo \
    ripgrep \
    fd-find \
    python3-pip \
    python3-venv \
    python3-dev \
    python3-full \
    pkg-config \
    libhdf5-dev \
    libssl-dev \
    libffi-dev \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libxml2-dev \
    libxslt1-dev \
    libopenblas-dev \
    liblapack-dev \
    tmux \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 22 LTS (required for n8n)
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | tee /usr/share/keyrings/githubcli-archive-keyring.gpg > /dev/null     && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg     && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null     && apt-get update     && apt-get install gh -y

# Create a non-root user
RUN useradd -m -s /bin/bash -G sudo devuser
RUN echo "devuser:devuser" | chpasswd
USER devuser
WORKDIR /home/devuser

# Install Anaconda 2024.10
RUN curl -O https://repo.anaconda.com/archive/Anaconda3-2024.10-1-Linux-x86_64.sh && \
    bash Anaconda3-2024.10-1-Linux-x86_64.sh -b -p /home/devuser/anaconda3 && \
    rm Anaconda3-2024.10-1-Linux-x86_64.sh

# Set up Anaconda environment
ENV PATH="/home/devuser/anaconda3/bin:${PATH}"
ENV CONDA_PREFIX="/home/devuser/anaconda3"

# Initialize conda and update base environment
RUN /home/devuser/anaconda3/bin/conda init bash && \
    /home/devuser/anaconda3/bin/conda update -n base -c defaults conda -y

# Copy installation scripts
COPY requirements.txt /tmp/requirements.txt
COPY install_packages.py /tmp/install_packages.py

# Install Python packages with robust error handling using the dedicated installer
RUN /home/devuser/anaconda3/bin/python /tmp/install_packages.py && \
    rm /tmp/requirements.txt /tmp/install_packages.py

# Install n8n for the user (not globally)
RUN npm config set prefix '/home/devuser/.npm-global' \
    && echo 'export PATH="/home/devuser/.npm-global/bin:$PATH"' >> /home/devuser/.bashrc \
    && npm install -g n8n
ENV PATH="/home/devuser/.npm-global/bin:${PATH}"

# Set up Shellngn Pro (SSH/SFTP/VNC/RDP web client)
# Create directory for Shellngn data persistence
RUN mkdir -p /home/devuser/shellngn-data

# Add alias for easy Shellngn Pro container management
RUN echo 'alias shellngn-start="docker run -d --name shellngn -p 8080:8080 -v /home/devuser/shellngn-data:/data shellngn/pro"' >> /home/devuser/.bashrc \
    && echo 'alias shellngn-stop="docker stop shellngn && docker rm shellngn"' >> /home/devuser/.bashrc \
    && echo 'alias shellngn-logs="docker logs shellngn"' >> /home/devuser/.bashrc

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
