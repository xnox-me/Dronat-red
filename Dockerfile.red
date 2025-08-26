# Dockerfile for Dronat Red - Red Team Operations & Offensive Security Environment
FROM ubuntu:24.04

# Set non-interactive frontend for package installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Update package repositories and install essential dependencies
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
        curl \
        wget \
        unzip \
        git \
        sudo \
        ripgrep \
        fd-find \
        python3 \
        python3-pip \
        python3-venv \
        pkg-config \
        build-essential \
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
        vim \
        nano \
        htop \
        tree \
        which \
        man-db \
        manpages-dev \
        ca-certificates \
        gnupg \
        lsb-release \
        software-properties-common

# Install Node.js 22 LTS
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs

# Install Docker CE for red team container operations
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io

# Install red team and offensive security tools
RUN apt-get install -y \
    nmap \
    masscan \
    zmap \
    unicornscan \
    hping3 \
    netcat-openbsd \
    socat \
    tcpdump \
    wireshark \
    tshark \
    dnsutils \
    whois \
    traceroute \
    arp-scan \
    fping \
    nikto \
    dirb \
    wfuzz \
    gobuster \
    dirbuster \
    sqlmap \
    commix \
    xsser \
    beef-xss \
    metasploit-framework \
    armitage \
    social-engineer-toolkit \
    king-phisher \
    maltego \
    recon-ng \
    theharvester \
    fierce \
    dmitry \
    enum4linux \
    smbclient \
    nbtscan \
    onesixtyone \
    snmpwalk \
    hydra \
    medusa \
    patator \
    crowbar \
    john \
    hashcat \
    crunch \
    cewl \
    rsmangler \
    cupp \
    aircrack-ng \
    kismet \
    wifite \
    reaver \
    pixiewps \
    bully \
    hostapd-wpe \
    dnsmasq \
    bridge-utils \
    macchanger \
    ethtool \
    wireless-tools \
    iw \
    rfkill

# Install additional penetration testing tools via GitHub
RUN git clone https://github.com/SecureAuthCorp/impacket.git /opt/impacket && \
    cd /opt/impacket && pip3 install . && \
    git clone https://github.com/CoreSecurity/impacket.git /opt/impacket-core && \
    git clone https://github.com/SpiderLabs/Responder.git /opt/Responder && \
    git clone https://github.com/lgandx/Responder.git /opt/Responder-lgandx && \
    git clone https://github.com/byt3bl33d3r/CrackMapExec.git /opt/CrackMapExec && \
    git clone https://github.com/PowerShellMafia/PowerSploit.git /opt/PowerSploit && \
    git clone https://github.com/samratashok/nishang.git /opt/nishang && \
    git clone https://github.com/trustedsec/ptf.git /opt/ptf && \
    git clone https://github.com/trustedsec/social-engineer-toolkit.git /opt/set && \
    git clone https://github.com/bettercap/bettercap.git /opt/bettercap-src

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update && \
    apt-get install -y gh

# Create a non-root user with sudo privileges
RUN useradd -m -s /bin/bash -G sudo,docker devuser && \
    echo "devuser:redteam2024" | chpasswd && \
    echo "devuser ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

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

# Copy red team specific requirements and installer
COPY requirements-red.txt /tmp/requirements.txt
COPY install_packages_red.py /tmp/install_packages.py

# Install Python packages for red team operations
RUN /home/devuser/anaconda3/bin/python /tmp/install_packages.py && \
    rm /tmp/requirements.txt /tmp/install_packages.py

# Install red team specific Python packages
RUN /home/devuser/anaconda3/bin/pip install --no-cache-dir \
    scapy \
    requests \
    beautifulsoup4 \
    selenium \
    paramiko \
    pycrypto \
    cryptography \
    impacket \
    python-nmap \
    shodan \
    censys \
    dnspython \
    netaddr \
    ipaddress \
    pwntools \
    ropper \
    capstone \
    keystone-engine \
    unicorn \
    angr \
    z3-solver \
    yara-python \
    pymetasploit3 \
    empire-bc \
    pystemon \
    volatility3 \
    rekall \
    distorm3 \
    pefile \
    pyelftools \
    python-magic \
    sslyze \
    tlslite-ng \
    pyopenssl \
    colorama \
    termcolor \
    rich \
    click \
    typer \
    fire

# Install Bettercap (Go-based)
RUN sudo apt-get install -y golang-go && \
    go install github.com/bettercap/bettercap@latest && \
    sudo cp /home/devuser/go/bin/bettercap /usr/local/bin/

# Install n8n for red team workflow automation
RUN npm config set prefix '/home/devuser/.npm-global' && \
    echo 'export PATH="/home/devuser/.npm-global/bin:$PATH"' >> /home/devuser/.bashrc && \
    npm install -g n8n
ENV PATH="/home/devuser/.npm-global/bin:${PATH}"

# Install C2 framework components
RUN git clone https://github.com/EmpireProject/Empire.git /home/devuser/Empire && \
    git clone https://github.com/cobbr/Covenant.git /home/devuser/Covenant && \
    git clone https://github.com/Ne0nd0g/merlin.git /home/devuser/merlin && \
    git clone https://github.com/BishopFox/sliver.git /home/devuser/sliver

# Set up red team directories
RUN mkdir -p /home/devuser/redteam && \
    mkdir -p /home/devuser/payloads && \
    mkdir -p /home/devuser/c2 && \
    mkdir -p /home/devuser/phishing && \
    mkdir -p /home/devuser/persistence && \
    mkdir -p /home/devuser/privesc && \
    mkdir -p /home/devuser/lateral && \
    mkdir -p /home/devuser/exfiltration && \
    mkdir -p /home/devuser/reports && \
    mkdir -p /home/devuser/wordlists && \
    mkdir -p /home/devuser/exploits

# Download red team specific wordlists and payloads
RUN sudo mkdir -p /usr/share/wordlists && \
    sudo git clone https://github.com/danielmiessler/SecLists.git /usr/share/wordlists/SecLists || true && \
    sudo wget -O /usr/share/wordlists/rockyou.txt.gz https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt.gz || true && \
    git clone https://github.com/swisskyrepo/PayloadsAllTheThings.git /home/devuser/PayloadsAllTheThings && \
    git clone https://github.com/foospidy/payloads.git /home/devuser/payloads-repo

# Install Neovim
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz && \
    tar -xzf nvim-linux64.tar.gz && \
    mkdir -p /home/devuser/.local/share && \
    mv nvim-linux64 /home/devuser/.local/share/ && \
    rm nvim-linux64.tar.gz
ENV PATH="/home/devuser/.local/share/nvim-linux64/bin:${PATH}"

# Set up Shellngn Pro for red team remote access
RUN mkdir -p /home/devuser/shellngn-data

# Copy Neovim configuration and red team menu script
COPY --chown=devuser:devuser nvim /home/devuser/.config/nvim
COPY --chown=devuser:devuser menu-red.sh /home/devuser/menu.sh

# Add red team specific aliases and environment
RUN echo 'alias msfconsole="sudo msfconsole"' >> /home/devuser/.bashrc && \
    echo 'alias armitage="sudo armitage"' >> /home/devuser/.bashrc && \
    echo 'alias beef="sudo beef-xss"' >> /home/devuser/.bashrc && \
    echo 'alias empire="cd /home/devuser/Empire && sudo python3 empire"' >> /home/devuser/.bashrc && \
    echo 'alias responder="sudo python3 /opt/Responder/Responder.py"' >> /home/devuser/.bashrc && \
    echo 'alias cme="sudo crackmapexec"' >> /home/devuser/.bashrc && \
    echo 'alias nmap-stealth="nmap -sS -O -T2"' >> /home/devuser/.bashrc && \
    echo 'alias nmap-vuln="nmap --script vuln"' >> /home/devuser/.bashrus && \
    echo 'export METASPLOIT_DATABASE=postgresql://msf:msf@localhost/msf' >> /home/devuser/.bashrc

# Pre-install Neovim plugins
RUN nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' || true
RUN nvim --headless -c 'Lazy sync' +qa

# Set proper permissions for red team tools
RUN sudo chown -R devuser:devuser /home/devuser && \
    sudo chmod +x /home/devuser/menu.sh

# Create red team specific configuration files
RUN echo "[Unit]" > /home/devuser/redteam-setup.service && \
    echo "Description=Red Team Environment Setup" >> /home/devuser/redteam-setup.service && \
    echo "[Service]" >> /home/devuser/redteam-setup.service && \
    echo "Type=oneshot" >> /home/devuser/redteam-setup.service && \
    echo "ExecStart=/home/devuser/setup-redteam.sh" >> /home/devuser/redteam-setup.service

# Health check for red team environment
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD python3 -c "import scapy, nmap, requests; print('Red team environment healthy')" || exit 1

# Set the entrypoint to the red team menu script
ENTRYPOINT ["/home/devuser/menu.sh"]