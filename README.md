# nvimdronat

This repository contains a Dockerfile to build a complete, portable development environment with an interactive menu.

## Included Tools

*   Neovim (with custom configuration)
*   Anaconda
*   Meson
*   Node.js & npm
*   GitHub CLI (`gh`)
*   n8n
*   Lean
*   OpenBB (Open Source Investment Research Platform)
*   ShellGPT (AI-powered command line assistant)
*   Shellngn Pro (SSH/SFTP/VNC/RDP Web Client)
*   **ML/AI Development Suite:**
    *   TensorFlow & Keras
    *   PyTorch & Torchvision
    *   Scikit-learn, XGBoost, LightGBM, CatBoost
    *   Hugging Face Transformers & Diffusers
    *   JupyterLab & Jupyter Notebook
    *   Computer Vision (OpenCV, Pillow, Albumentations)
    *   NLP (NLTK, spaCy, TextBlob, Gensim)
    *   MLOps (MLflow, Weights & Biases, TensorBoard)
    *   AutoML (Optuna, Hyperopt)
    *   Model Deployment (FastAPI, Gradio, Streamlit)
*   Docker (for containerized services)
*   Tmux
*   Essential build tools

## Docker

### Build the Image

```bash
docker build -t nvimmer_dronatxxx .
```

### Run the Container

```bash
docker run -it -p 5678:5678 -p 8080:8080 -p 8888:8888 -p 6006:6006 -p 7860:7860 -p 8501:8501 -p 5000:5000 nvimmer_dronatxxx
```

Port mappings:
- **5678**: n8n workflow editor
- **8080**: Shellngn Pro SSH/SFTP/VNC/RDP client
- **8888**: JupyterLab/Jupyter Notebook
- **6006**: TensorBoard
- **7860**: Gradio ML demos
- **8501**: Streamlit ML apps
- **5000**: MLflow tracking UI

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

### 5. OpenBB

OpenBB is an open source investment research platform that provides financial data and analytics.

```bash
# Install OpenBB using pip
pip install openbb
```

### 6. ShellGPT

ShellGPT is an AI-powered command line assistant that helps with various terminal tasks.

```bash
# Install ShellGPT using pip
pip install shell-gpt

# Set up API key (optional - you can use it without API key with limited functionality)
# sgpt --install-integration
```

### 8. Shellngn Pro

Shellngn Pro is a web-based SSH/SFTP/VNC/RDP client that runs as a Docker container.

```bash
# Install Docker (if not already installed)
sudo apt-get update
sudo apt-get install docker.io

# Pull and run Shellngn Pro
docker pull shellngn/pro
docker run -d --name shellngn -p 8080:8080 -v $(pwd)/shellngn-data:/data shellngn/pro

# Access via browser at http://localhost:8080
```

### 9. ML/AI Development Suite

Comprehensive machine learning and artificial intelligence development environment.

```bash
# Core ML frameworks
pip install tensorflow torch torchvision scikit-learn

# Data science tools
pip install pandas numpy matplotlib seaborn plotly scipy

# Jupyter ecosystem
pip install jupyterlab notebook jupyterlab-git

# Deep learning and transformers
pip install keras transformers accelerate diffusers

# Computer vision
pip install opencv-python pillow albumentations

# Natural language processing
pip install nltk spacy textblob gensim

# MLOps and experiment tracking
pip install mlflow wandb tensorboard

# AutoML and hyperparameter tuning
pip install optuna hyperopt

# Model deployment and serving
pip install fastapi uvicorn gradio streamlit

# Additional ML tools
pip install xgboost lightgbm catboost ipywidgets tqdm joblib
```

### 10. GitHub CLI

The official command-line tool for GitHub.

```bash
# Install the GitHub CLI
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh
```
