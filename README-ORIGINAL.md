# 🔒 Dronat BlackArch - Penetration Testing Development Environment

> **A specialized Docker container for penetration testing and security research based on BlackArch Linux**

[![Docker](https://img.shields.io/badge/Docker-Ready-blue)](https://www.docker.com/)
[![BlackArch](https://img.shields.io/badge/BlackArch-Linux-red)](https://blackarch.org/)
[![Security](https://img.shields.io/badge/Security-Research-green)](https://github.com/xnox-me/Dronat-Black)
[![License](https://img.shields.io/badge/License-Educational-yellow)](LICENSE)

## 🎯 Overview

Dronat BlackArch is a comprehensive penetration testing environment that combines the power of BlackArch Linux with modern development tools. It provides a complete toolkit for security researchers, penetration testers, and cybersecurity professionals.

### ⚠️ **Ethical Use Only**
This tool is designed for **authorized security testing and educational purposes only**. Users are responsible for complying with all applicable laws and regulations.

## 🛠 Included Tools

### Core Development
*   **Neovim** (Enhanced IDE with LSP, debugging, AI assistance)
*   **Anaconda 2024.10** (Complete Python data science stack)
*   **Node.js 22 LTS** & npm
*   **GitHub CLI** (`gh`)
*   **Lean** (Formal verification)
*   **Docker** (Containerization)
*   **Tmux** (Terminal multiplexer)

### AI-Powered Development
*   **GitHub Copilot** integration in Neovim
*   **ShellGPT** (AI-powered command line assistant)
*   **Enhanced LSP** with intelligent code completion

### ML/AI Development Suite
*   **Core Frameworks**: TensorFlow, PyTorch, Keras, Transformers
*   **Classical ML**: Scikit-learn, XGBoost, LightGBM, CatBoost
*   **Deep Learning**: Transformers, Diffusers, PEFT
*   **Computer Vision**: OpenCV, Pillow, Albumentations, Ultralytics
*   **NLP**: NLTK, spaCy, TextBlob, Gensim, Datasets, Tokenizers
*   **MLOps**: MLflow, Weights & Biases, TensorBoard, ClearML
*   **AutoML**: Optuna, Hyperopt, Ray Tune, AutoSklearn
*   **Deployment**: FastAPI, Gradio, Streamlit, BentoML
*   **Data Engineering**: Apache Beam, Dask, Polars, PyArrow
*   **Specialized AI**: Graph Neural Networks, Audio Processing, Time Series
*   **Reinforcement Learning**: Gymnasium, Stable-Baselines3

### Development Environment
*   **JupyterLab** & Jupyter Notebook
*   **Interactive Python** with ML libraries
*   **TensorBoard** (Experiment visualization)
*   **MLflow UI** (Experiment tracking)
*   **Enhanced debugging** with DAP

### Workflow & Automation
*   **n8n** (Visual workflow automation)
*   **OpenBB** (Financial data analysis)
*   **Shellngn Pro** (SSH/SFTP/VNC/RDP Web Client)

### System Tools
*   **System monitoring** (htop, resource usage)
*   **File management** and navigation
*   **Network utilities** and diagnostics
*   **Git operations** and repository management
*   **Docker management** tools
*   **Package management** overview

## 🐳 Docker

### 🔧 Build the Image

```bash
# Standard build
docker build -t dronat:latest .

# Build with progress output
docker build --progress=plain -t dronat:latest .

# Build with no cache (for clean build)
docker build --no-cache -t dronat:latest .
```

**Build Notes:**
- The build process uses a robust package installer that handles failures gracefully
- Some optional packages may be skipped if they fail to install
- Critical packages (NumPy, Pandas, TensorFlow, PyTorch) are required for successful build
- Build time: 15-30 minutes depending on your system and network speed

### 🚀 Run the Container

#### Quick Start (Recommended)
```bash
docker run -it \
  --name dronat-dev \
  -p 5678:5678 \
  -p 8080:8080 \
  -p 8888:8888 \
  -p 6006:6006 \
  -p 7860:7860 \
  -p 8501:8501 \
  -p 5000:5000 \
  dronat:latest
```

#### With Volume Persistence
```bash
# Create a persistent volume for your projects
docker volume create dronat-data

docker run -it \
  --name dronat-dev \
  -v dronat-data:/home/devuser/workspace \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -p 5678:5678 \
  -p 8080:8080 \
  -p 8888:8888 \
  -p 6006:6006 \
  -p 7860:7860 \
  -p 8501:8501 \
  -p 5000:5000 \
  dronat:latest
```

### 📌 Port Mappings

| Port | Service | Description |
|------|---------|-------------|
| **5678** | n8n | Workflow automation editor |
| **8080** | Shellngn Pro | SSH/SFTP/VNC/RDP web client |
| **8888** | JupyterLab | Interactive notebook environment |
| **6006** | TensorBoard | ML experiment visualization |
| **7860** | Gradio | ML model demos and interfaces |
| **8501** | Streamlit | ML web applications |
| **5000** | MLflow | Experiment tracking and model registry |

### 📋 Container Management

```bash
# Stop the container
docker stop dronat-dev

# Start existing container
docker start -i dronat-dev

# Remove container
docker rm dronat-dev

# View logs
docker logs dronat-dev

# Execute commands in running container
docker exec -it dronat-dev bash
```

When you run the container, you'll be greeted with an enhanced interactive menu to launch various tools and environments.

## 🛠 Manual Installation

This guide assumes you are on a Debian/Ubuntu-based Linux distribution (Ubuntu 24.04 LTS recommended).

### 🔄 Prerequisites

```bash
# Update system packages
sudo apt-get update && sudo apt-get upgrade -y

# Install essential dependencies
sudo apt-get install -y curl wget git build-essential
```

### 1. 📝 Enhanced Neovim Setup

This sets up Neovim with the enhanced configuration from this repository.

```bash
# Install Neovim (latest version)
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
tar -xzf nvim-linux64.tar.gz
sudo mv nvim-linux64 /opt/nvim
sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
rm nvim-linux64.tar.gz

# Clone and setup the enhanced Neovim configuration
git clone https://github.com/eihabhala/dronat.git
cp -r dronat/nvim ~/.config/nvim

# Install ripgrep and fd-find for better search
sudo apt-get install -y ripgrep fd-find
```

### 2. 🐍 Anaconda 2024.10

Comprehensive Python distribution for data science and ML.

```bash
# Download and install Anaconda 2024.10
curl -O https://repo.anaconda.com/archive/Anaconda3-2024.10-1-Linux-x86_64.sh
bash Anaconda3-2024.10-1-Linux-x86_64.sh

# Follow the on-screen prompts and restart your shell
source ~/.bashrc
```

### 3. 🚪 Node.js 22 LTS

Latest LTS version for optimal performance.

```bash
# Install Node.js 22 LTS
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verify installation
node --version
npm --version
```

### 4. 🔄 n8n Workflow Automation

```bash
# Install n8n globally
npm install -g n8n

# Run n8n (access at http://localhost:5678)
n8n
```

### 5. 📈 OpenBB Financial Platform

```bash
# Install OpenBB
pip install openbb

# Test installation
python -c "import openbb; print('OpenBB installed successfully')"
```

### 6. 🤖 ShellGPT AI Assistant

```bash
# Install ShellGPT
pip install shell-gpt

# Configure (optional - you can use it without API key with limited functionality)
# sgpt --install-integration
```

### 7. 🌐 Shellngn Pro Web Client

```bash
# Install Docker (if not already installed)
sudo apt-get update
sudo apt-get install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker

# Add your user to docker group
sudo usermod -aG docker $USER
# Log out and back in for group changes to take effect

# Run Shellngn Pro
docker run -d --name shellngn -p 8080:8080 \
  -v "$(pwd)/shellngn-data:/data" shellngn/pro

# Access via browser at http://localhost:8080
```

### 8. 🧠 Comprehensive ML/AI Development Suite

```bash
# Core ML frameworks
pip install tensorflow torch torchvision scikit-learn

# Data science and analysis
pip install pandas numpy matplotlib seaborn plotly scipy

# Jupyter ecosystem with enhancements
pip install jupyterlab notebook jupyterlab-git jupyterlab-vim

# Advanced ML and AI
pip install transformers accelerate diffusers peft datasets tokenizers

# Computer vision
pip install opencv-python pillow albumentations ultralytics

# Natural language processing
pip install nltk spacy textblob gensim

# MLOps and experiment tracking
pip install mlflow wandb tensorboard clearml

# AutoML and hyperparameter optimization
pip install optuna hyperopt ray[tune] autosklearn

# Model deployment and serving
pip install fastapi uvicorn gradio streamlit bentoml

# Data engineering and processing
pip install apache-beam dask polars pyarrow

# Specialized AI libraries
pip install torch-geometric stellargraph librosa soundfile
pip install statsmodels prophet sktime tslearn
pip install gymnasium stable-baselines3

# Additional productivity tools
pip install rich typer fire ipywidgets tqdm joblib
```

### 9. 💻 GitHub CLI

Official command-line tool for GitHub.

```bash
# Install GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
  sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
  sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh

# Authenticate with GitHub
gh auth login
```

### 10. 🎯 Lean Theorem Prover

```bash
# Install Lean
curl https://raw.githubusercontent.com/leanprover/elan/master/elan-init.sh -sSf | sh -s -- -y
source ~/.profile

# Create a new Lean project
lake new my_project
cd my_project
```

## 📊 System Requirements

### Minimum Requirements
- **OS**: Ubuntu 20.04+ or compatible Linux distribution
- **CPU**: 2 cores
- **RAM**: 4GB
- **Storage**: 15GB free space
- **Docker**: Version 20.0+ (for containerized deployment)

### Recommended Specifications
- **OS**: Ubuntu 24.04 LTS
- **CPU**: 4+ cores
- **RAM**: 8GB+ (16GB for intensive ML workflows)
- **Storage**: 25GB+ SSD storage
- **Network**: Stable internet connection for package downloads

## 📋 Usage Examples

### Quick Start with Docker
```bash
# Pull and run the container
docker run -it -p 8888:8888 dronat:latest

# Access JupyterLab at http://localhost:8888
# Select option 8 from menu, then option 1
```

### Development Workflow
```bash
# 1. Start the environment
docker run -it --name my-dev-env dronat:latest

# 2. Open Neovim (option 1) for coding
# 3. Use ML/AI tools (option 8) for data science
# 4. Use system tools (option 9) for monitoring
```

### ML/AI Project Example
```python
# Start JupyterLab and create a new notebook
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
import mlflow
import mlflow.sklearn

# Your ML workflow with built-in experiment tracking
with mlflow.start_run():
    # Load data, train model, log metrics
    pass
```

## 🔧 Troubleshooting

### Common Issues

### Common Issues

#### Container Build Fails
```bash
# Clear Docker cache and rebuild
docker system prune -f
docker build --no-cache -t dronat:latest .

# Build with verbose output to see detailed errors
docker build --progress=plain --no-cache -t dronat:latest .

# Check available disk space (build requires ~10GB free space)
df -h

# Check available memory (build requires ~4GB RAM)
free -h
```

#### Python Package Installation Fails
```bash
# The build uses a robust installer that skips problematic packages
# Check the build logs for "Failed packages" warnings
# Most failures are non-critical and won't affect core functionality

# If critical packages fail, check system requirements:
# - Ensure you have sufficient RAM (8GB+ recommended)
# - Ensure you have sufficient disk space (20GB+ recommended)
# - Check your internet connection stability
```

#### Memory Issues During Build
```bash
# Increase Docker memory limit to 6GB+
# On Docker Desktop: Settings > Resources > Memory

# Alternative: Build with memory-efficient options
DOCKER_BUILDKIT=1 docker build \
  --build-arg BUILDKIT_INLINE_CACHE=1 \
  -t dronat:latest .
```

#### Port Already in Use
```bash
# Check what's using the port
sudo netstat -tulpn | grep :8888

# Kill the process or use different ports
docker run -it -p 8889:8888 dronat:latest
```

#### Neovim Plugins Not Loading
```bash
# Inside the container, manually sync plugins
nvim --headless -c 'Lazy sync' +qa
```

#### Permission Issues with Docker
```bash
# Add your user to docker group
sudo usermod -aG docker $USER
# Log out and back in
```

### Getting Help
- Check the built-in help system (option 10 in menu)
- Review container logs: `docker logs nvimmer-dev`
- Ensure all required ports are available
- Verify system requirements are met

## 🔄 Updates and Maintenance

### Updating the Container
```bash
# Pull latest image
docker pull dronat:latest

# Stop and remove old container
docker stop dronat-dev && docker rm dronat-dev

# Run new container
docker run -it --name dronat-dev dronat:latest
```

### Backup and Restore
```bash
# Backup your work
docker cp dronat-dev:/home/devuser/workspace ./backup

# Restore to new container
docker cp ./backup dronat-dev:/home/devuser/workspace
```

## 🚀 Advanced Usage

### Docker Compose (Coming Soon)
Simplified orchestration with docker-compose.yml for multi-service setups.

### Custom Extensions
The environment is designed to be extensible. You can:
- Add new Python packages via pip
- Install additional Neovim plugins
- Extend the menu system with custom tools
- Mount additional volumes for project-specific needs

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Make your changes**
4. **Test thoroughly**
5. **Commit your changes**: `git commit -m 'Add amazing feature'`
6. **Push to the branch**: `git push origin feature/amazing-feature`
7. **Open a Pull Request**

### Development Guidelines
- Follow existing code style and conventions
- Update documentation for new features
- Test changes in both Docker and manual installations
- Ensure compatibility with Ubuntu 24.04 LTS

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- **Neovim** community for the amazing editor
- **Anaconda** for the comprehensive Python distribution
- **All the ML/AI frameworks** that make this environment possible
- **Docker** for containerization technology
- **Ubuntu** for the stable base system
- **Open source community** for continuous innovation

## 🔗 Related Projects

- [Neovim](https://neovim.io/) - Hyperextensible Vim-based text editor
- [n8n](https://n8n.io/) - Workflow automation tool
- [OpenBB](https://openbb.co/) - Open source investment research platform
- [JupyterLab](https://jupyterlab.readthedocs.io/) - Interactive development environment

---

🎆 **Happy coding with Dronat!** 🎆
