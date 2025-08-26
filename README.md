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

## ✨ Features

### 🛡️ Security Tools
- **Network Reconnaissance**: nmap, masscan, gobuster, dirb, nikto
- **Web Application Security**: burpsuite, sqlmap, OWASP ZAP, wfuzz  
- **Password Cracking**: john, hashcat, hydra, medusa
- **Wireless Security**: aircrack-ng, kismet, wifite, reaver
- **Exploit Development**: metasploit, gdb, radare2, ropper
- **Binary Analysis**: capstone, keystone, unicorn, angr

### 🧠 ML/AI Security Research
- **Machine Learning**: TensorFlow, PyTorch, scikit-learn
- **Adversarial ML**: Tools for creating adversarial examples
- **Network Traffic Analysis**: Scapy with ML integration
- **Malware Analysis**: AI-powered static and dynamic analysis

### 🐍 Python Security Libraries
- **Exploitation**: pwntools, ropper, impacket
- **Network**: scapy, python-nmap, netaddr
- **Cryptography**: cryptography, pycryptodome, passlib
- **Web**: requests, beautifulsoup4, selenium
- **File Analysis**: python-magic, pefile, pyelftools

### 🔧 Development Environment
- **Neovim**: Enhanced security-focused IDE configuration
- **Anaconda 2024.10**: Complete Python data science stack
- **Node.js 22 LTS**: Modern JavaScript runtime
- **JupyterLab**: Interactive security research environment

## 🚀 Quick Start

### Prerequisites
- Docker installed and running
- At least 8GB RAM recommended
- 20GB free disk space

### Method 1: Quick Start Script (Recommended)
```bash
# Clone the repository
git clone https://github.com/xnox-me/Dronat-Black.git
cd Dronat-Black

# Make the start script executable
chmod +x start-blackarch.sh

# Build, test, and run everything
./start-blackarch.sh all
```

### Method 2: Manual Build
```bash
# Build the BlackArch container
docker build -f Dockerfile.blackarch -t dronat-blackarch:latest .

# Run with all security capabilities
docker run -it --rm \
  --name dronat-blackarch \
  -p 8888:8888 -p 5678:5678 -p 8080:8080 \
  --cap-add=NET_ADMIN --cap-add=NET_RAW \
  -v $(pwd)/workspace:/home/devuser/workspace \
  dronat-blackarch:latest
```

### Method 3: Docker Compose
```bash
# Start with full orchestration
docker-compose -f docker-compose-blackarch.yml up -d

# Access the environment
docker exec -it dronat-blackarch-dev bash
```

## 🎛️ Interactive Menu

The container starts with an interactive menu providing access to:

1. **📝 Neovim Security IDE** - Enhanced editor with security plugins
2. **🔄 n8n Workflow Editor** - Automation for security workflows  
3. **💻 Bash Shell** - Direct shell access with all tools
4. **🔍 Network Reconnaissance** - Scanning and enumeration tools
5. **🌐 Web Security Testing** - Web application security tools
6. **🔓 Password Cracking** - Hash and password recovery tools
7. **📡 Wireless Security** - WiFi and wireless security testing
8. **🕷️ Exploit Development** - Binary analysis and exploit creation
9. **🧠 ML/AI Security Research** - Machine learning security tools
10. **🌐 Shellngn Pro** - Web-based remote access
11. **🔧 System Tools** - System utilities and monitoring
12. **📚 Help & Documentation** - Comprehensive help system

## 🌐 Service Ports

- **8888**: JupyterLab (ML/AI Security Research)
- **5678**: n8n Workflow Automation  
- **8080**: Shellngn Pro Web Interface
- **6006**: TensorBoard (ML Model Visualization)
- **7860**: Gradio (ML Model Interfaces)
- **8501**: Streamlit (Security Dashboards)
- **5000**: MLflow (ML Experiment Tracking)

## 🧪 Testing

```bash
# Test the environment
./test_blackarch_environment.sh

# Quick test with start script
./start-blackarch.sh test
```

## 📋 Common Security Testing Workflows

### Network Penetration Testing
```bash
# Network discovery
nmap -sn 192.168.1.0/24

# Port scanning  
nmap -sS -sV -O target_ip

# Service enumeration
gobuster dir -u http://target -w /usr/share/wordlists/SecLists/Discovery/Web-Content/common.txt
```

### Web Application Testing
```bash
# Directory bruteforcing
gobuster dir -u http://target -w /usr/share/wordlists/SecLists/Discovery/Web-Content/directory-list-2.3-medium.txt

# SQL injection testing
sqlmap -u "http://target/page.php?id=1" --batch --random-agent

# Web vulnerability scanning
nikto -h http://target
```

### Password Cracking
```bash
# Hash cracking with hashcat
hashcat -m 0 -a 0 hashes.txt /usr/share/wordlists/rockyou.txt

# Network login bruteforce
hydra -l admin -P passwords.txt ssh://target

# John the Ripper
john --wordlist=/usr/share/wordlists/rockyou.txt hashes.txt
```

## 🧠 ML/AI Security Research Examples

### Adversarial Machine Learning
```python
import tensorflow as tf
import numpy as np

# Create adversarial examples
def create_adversarial_example(model, input_image, epsilon=0.1):
    with tf.GradientTape() as tape:
        tape.watch(input_image)
        prediction = model(input_image)
        loss = tf.keras.losses.categorical_crossentropy(target_label, prediction)
    
    gradient = tape.gradient(loss, input_image)
    signed_grad = tf.sign(gradient)
    adversarial_image = input_image + epsilon * signed_grad
    
    return adversarial_image
```

### Network Traffic Analysis
```python
from scapy.all import *
import pandas as pd
from sklearn.ensemble import IsolationForest

# Capture and analyze network traffic
def analyze_traffic(pcap_file):
    packets = rdpcap(pcap_file)
    features = extract_features(packets)
    
    # Anomaly detection
    model = IsolationForest(contamination=0.1)
    anomalies = model.fit_predict(features)
    
    return anomalies
```

## 🗂️ Directory Structure

```
/home/devuser/
├── pentest/          # Penetration testing workspace
├── wordlists/        # Custom wordlists and dictionaries
├── exploits/         # Exploit code and PoCs
├── reports/          # Security assessment reports
├── .config/nvim/     # Neovim configuration
└── anaconda3/        # Python environment
```

## 🔧 Advanced Usage

### Custom Python Security Environment
```python
# Security research Python environment with all tools
import scapy.all as scapy
import requests
from pwn import *
import impacket
import cryptography
import angr
import capstone
import keystone
import unicorn
```

### Network Tools with Privileges
```bash
# Run with network capabilities
docker run --privileged --net=host dronat-blackarch
```

## 📚 Documentation

- [Complete User Guide](README-BLACKARCH.md)
- [Security Tools Reference](README-BLACKARCH.md#security-tools-reference)
- [Quick Start Guide](start-blackarch.sh)
- [Testing Guide](test_blackarch_environment.sh)

## 🔒 Security & Ethics

### ⚠️ **IMPORTANT LEGAL NOTICE**
This tool contains powerful security testing capabilities. Users must:

- **Only test systems you own or have explicit written permission to test**
- **Follow responsible disclosure practices for any vulnerabilities found**
- **Comply with all applicable local, state, and federal laws**
- **Respect privacy and data protection regulations**
- **Use for educational and authorized testing purposes only**

### Best Practices
- Run in isolated lab environments
- Document all testing activities
- Obtain proper authorization before testing
- Follow ethical hacking guidelines
- Regularly update tools and knowledge

## 🛠️ Troubleshooting

### Common Issues

1. **Network tools require privileges**
   ```bash
   docker run --privileged --net=host dronat-blackarch
   ```

2. **Package installation failures**
   - Check installation logs
   - Verify network connectivity
   - Update package databases

3. **Memory issues**
   - Ensure at least 8GB RAM
   - Close unnecessary applications
   - Use resource limits if needed

### Getting Help
- Use the built-in help system (option 12 in menu)
- Check tool documentation with `man toolname`
- Visit project issues on GitHub

## 🤝 Contributing

1. Fork the repository
2. Create feature branches for new tools or capabilities
3. Test thoroughly in isolated environments
4. Submit pull requests with detailed descriptions
5. Follow security-first development practices

## 📄 License

This project is provided for educational and authorized security testing purposes only. See [LICENSE](LICENSE) for more details.

## 🙏 Acknowledgments

- **BlackArch Linux** team for the security-focused distribution
- **Security community** for tool development and research
- **Open source contributors** for frameworks and libraries

---

🔒 **Remember: With great power comes great responsibility. Use these tools ethically and legally.**

**⭐ If this project helps your security research, please consider starring the repository!**