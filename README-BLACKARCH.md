# Dronat BlackArch - Penetration Testing Development Environment

🔒 **A specialized Docker container for penetration testing and security research based on BlackArch Linux**

## Overview

Dronat BlackArch is a comprehensive penetration testing environment that combines the power of BlackArch Linux with modern development tools. It provides a complete toolkit for security researchers, penetration testers, and cybersecurity professionals.

## Features

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

## Quick Start

### Building the Container

```bash
# Build the BlackArch version
docker build -f Dockerfile.blackarch -t dronat-blackarch:latest .
```

### Running the Container

```bash
# Start the interactive security environment
docker run -it --rm \
  --name dronat-blackarch \
  -p 8888:8888 \
  -p 5678:5678 \
  -p 8080:8080 \
  -v $(pwd)/workspace:/home/devuser/workspace \
  dronat-blackarch:latest
```

### Interactive Menu

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

## Security Research Workflows

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

### Binary Analysis
```bash
# Disassembly with radare2
r2 binary

# ROP gadget finding
ropper --file binary --search "pop rdi"

# Dynamic analysis with GDB
gdb ./binary
```

## ML/AI Security Research

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
import numpy as np
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

### Malware Classification
```python
import pefile
import numpy as np
from sklearn.ensemble import RandomForestClassifier

# Extract PE file features for malware classification
def extract_pe_features(file_path):
    pe = pefile.PE(file_path)
    features = []
    
    # Extract various PE characteristics
    features.append(pe.OPTIONAL_HEADER.AddressOfEntryPoint)
    features.append(len(pe.sections))
    features.append(pe.OPTIONAL_HEADER.SizeOfImage)
    
    return np.array(features)
```

## Port Mappings

- **8888**: JupyterLab (ML/AI Security Research)
- **5678**: n8n Workflow Automation  
- **8080**: Shellngn Pro Web Interface
- **6006**: TensorBoard (ML Model Visualization)
- **7860**: Gradio (ML Model Interfaces)
- **8501**: Streamlit (Security Dashboards)

## Directory Structure

```
/home/devuser/
├── pentest/          # Penetration testing workspace
├── wordlists/        # Custom wordlists and dictionaries
├── exploits/         # Exploit code and PoCs
├── reports/          # Security assessment reports
├── .config/nvim/     # Neovim configuration
└── anaconda3/        # Python environment
```

## Security Tools Reference

### Network Reconnaissance
- **nmap**: Network scanner and port discovery
- **masscan**: High-speed port scanner
- **gobuster**: Directory and file brute-forcer
- **recon-ng**: Web reconnaissance framework
- **theharvester**: Email and domain gathering

### Web Security
- **burpsuite**: Web application security testing
- **sqlmap**: Automated SQL injection testing
- **nikto**: Web server vulnerability scanner
- **dirb**: Web content scanner
- **wfuzz**: Web application fuzzer

### Exploitation
- **metasploit**: Exploitation framework
- **beef**: Browser exploitation framework
- **exploitdb**: Exploit database access
- **searchsploit**: Local exploit database search

### Password Security
- **john**: Password cracker
- **hashcat**: Advanced password recovery
- **hydra**: Network login cracker
- **medusa**: Parallel login brute-forcer
- **crackmapexec**: Post-exploitation tool

### Wireless Security
- **aircrack-ng**: WiFi security auditing suite
- **kismet**: Wireless network detector
- **wifite**: Automated WiFi cracking
- **reaver**: WPS attack tool
- **bettercap**: Network attack framework

## Advanced Usage

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

### Docker Compose Setup
```yaml
version: '3.8'
services:
  dronat-blackarch:
    build:
      context: .
      dockerfile: Dockerfile.blackarch
    ports:
      - "8888:8888"
      - "5678:5678" 
      - "8080:8080"
    volumes:
      - ./workspace:/home/devuser/workspace
      - ./reports:/home/devuser/reports
    environment:
      - DISPLAY=${DISPLAY}
    privileged: true  # Required for some network tools
```

## Best Practices

### Security Research Ethics
- **Only test systems you own or have explicit permission to test**
- **Follow responsible disclosure practices**
- **Document all security findings properly**
- **Respect privacy and data protection laws**

### Container Security
- **Run in isolated environments**
- **Use volume mounts for persistent data**
- **Regularly update the container image**
- **Monitor resource usage**

## Troubleshooting

### Common Issues

1. **Network tools require privileges**
   ```bash
   docker run --privileged --net=host dronat-blackarch
   ```

2. **GUI applications not displaying**
   ```bash
   docker run -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix dronat-blackarch
   ```

3. **Package installation failures**
   - Check the installation logs in `/tmp/`
   - Verify network connectivity
   - Update package databases with `pacman -Sy`

### Getting Help

- Use the built-in help system (option 12 in menu)
- Check tool documentation with `man toolname`
- Access online help: `toolname --help`

## Updates and Maintenance

### Updating BlackArch Packages
```bash
# Update package database
sudo pacman -Sy

# Update all packages
sudo pacman -Syu

# Update specific security tools
sudo pacman -S nmap metasploit burpsuite
```

### Updating Python Packages
```bash
# Update pip packages
pip install --upgrade package_name

# Update conda packages  
conda update package_name
```

## Contributing

To contribute to the Dronat BlackArch environment:

1. Fork the repository
2. Create feature branches for new tools or capabilities
3. Test thoroughly in isolated environments
4. Submit pull requests with detailed descriptions
5. Follow security-first development practices

## License

This project is provided for educational and authorized security testing purposes only. Users are responsible for complying with all applicable laws and regulations.

---

🔒 **Remember: With great power comes great responsibility. Use these tools ethically and legally.**