#!/usr/bin/env python3
"""
Dronat Red Package Installer
Handles installation of red team and offensive security packages
Optimized for Ubuntu 24.04 LTS environment with PEP 668 compliance
"""

import subprocess
import sys
import logging
import os
from typing import List, Dict, Optional

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# Check if we're in the container environment
USE_CONDA = os.path.exists('/home/devuser/anaconda3/bin/conda')

# Package groups optimized for red team operations
PACKAGE_GROUPS = {
    "core_system": [
        "pip", "setuptools", "wheel"
    ],
    "core_data_science": [
        "numpy", "pandas", "scipy", "scikit-learn"
    ],
    "security_frameworks": [
        "scapy", "requests", "beautifulsoup4", "paramiko", "cryptography"
    ],
    "exploitation": [
        "pwntools", "ropper", "capstone", "keystone-engine", "unicorn"
    ],
    "offensive_security": [
        "impacket", "python-nmap", "shodan", "censys"
    ],
    "c2_frameworks": [
        "pymetasploit3", "empire-bc", "pystemon"
    ],
    "memory_analysis": [
        "volatility3", "rekall", "distorm3"
    ],
    "malware_analysis": [
        "pefile", "pyelftools", "python-magic", "yara-python"
    ],
    "web_security": [
        "selenium", "scrapy", "lxml", "mechanicalsoup"
    ],
    "network_security": [
        "pyshark", "dpkt", "pcapy-ng", "python-libnmap", "netfilterqueue"
    ],
    "crypto_security": [
        "pycryptodome", "passlib", "bcrypt", "pyotp", "sslyze"
    ],
    "osint": [
        "googlesearch-python", "phonenumbers", "python-whois", "twitter-scraper"
    ],
    "visualization": [
        "matplotlib", "seaborn", "plotly"
    ],
    "jupyter": [
        "jupyterlab", "notebook", "ipython", "ipywidgets"
    ],
    "ml_security": [
        "tensorflow", "torch", "transformers", "xgboost"
    ],
    "deployment": [
        "streamlit", "gradio", "dash"
    ],
    "data_processing": [
        "dask", "polars", "pyarrow"
    ],
    "steganography": [
        "stegano", "stepic", "pillow"
    ],
    "cloud_security": [
        "boto3", "azure-identity", "google-cloud-storage", "docker", "kubernetes"
    ],
    "ad_security": [
        "ldap3", "pyldap", "python-ldap", "pykerberos"
    ],
    "mobile_security": [
        "frida", "objection", "androguard"
    ],
    "wireless_security": [
        "rfcat", "hackrf", "rtlsdr"
    ],
    "utilities": [
        "rich", "typer", "fire", "click", "colorama", "tqdm"
    ],
    "monitoring": [
        "psutil", "loguru"
    ]
}

# Special packages that may need different handling
SPECIAL_PACKAGES = {
    "volatility3": {"skip_on_error": True},
    "rekall": {"skip_on_error": True},
    "yara-python": {"fallback": "yara"},
    "empire-bc": {"skip_on_error": True},
    "gophish": {"skip_on_error": True},
    "evilginx2": {"skip_on_error": True},
    "setoolkit": {"skip_on_error": True},
    "msfvenom": {"skip_on_error": True},
    "netfilterqueue": {"skip_on_error": True},
    "pcapy-ng": {"fallback": "pcapy"},
    "angr": {"skip_on_error": True},
    "z3-solver": {"fallback": "z3"},
    "keystone-engine": {"skip_on_error": True},
    "unicorn": {"skip_on_error": True},
    "rfcat": {"skip_on_error": True},
    "hackrf": {"skip_on_error": True},
    "rtlsdr": {"skip_on_error": True},
    "frida": {"skip_on_error": True},
    "objection": {"skip_on_error": True}
}

def run_conda_install(packages: List[str], allow_failures: bool = False) -> bool:
    """Install packages using conda with error handling."""
    if not packages or not USE_CONDA:
        return False
        
    conda_path = '/home/devuser/anaconda3/bin/conda'
    cmd = [conda_path, "install", "-y", "-c", "conda-forge"] + packages
    
    try:
        logger.info(f"Installing with conda: {', '.join(packages)}")
        result = subprocess.run(cmd, check=True, capture_output=True, text=True)
        logger.info("Conda installation successful")
        return True
    except subprocess.CalledProcessError as e:
        logger.error(f"Conda installation failed: {e}")
        if allow_failures:
            logger.warning("Continuing despite conda failure...")
            return False
        else:
            return False

def run_anaconda_pip_install(packages: List[str], allow_failures: bool = False) -> bool:
    """Install packages using Anaconda's pip."""
    if not packages:
        return True
    
    anaconda_pip = '/home/devuser/anaconda3/bin/pip'
    if not os.path.exists(anaconda_pip):
        return False
    
    cmd = [anaconda_pip, "install", "--no-cache-dir"] + packages
    
    try:
        logger.info(f"Installing with Anaconda pip: {', '.join(packages)}")
        result = subprocess.run(cmd, check=True, capture_output=True, text=True)
        logger.info("Anaconda pip installation successful")
        return True
    except subprocess.CalledProcessError as e:
        logger.error(f"Anaconda pip installation failed: {e}")
        if e.stderr:
            logger.error(f"STDERR: {e.stderr}")
        
        if allow_failures:
            logger.warning("Continuing despite failure...")
            return False
        else:
            return False

def run_system_pip_install(packages: List[str], allow_failures: bool = False) -> bool:
    """Install packages using system pip with --break-system-packages (PEP 668 compliance)."""
    if not packages:
        return True
    
    cmd = [sys.executable, "-m", "pip", "install", "--break-system-packages", "--no-cache-dir"] + packages
    
    try:
        logger.info(f"Installing with system pip (--break-system-packages): {', '.join(packages)}")
        result = subprocess.run(cmd, check=True, capture_output=True, text=True)
        logger.info("System pip installation successful")
        return True
    except subprocess.CalledProcessError as e:
        logger.error(f"System pip installation failed: {e}")
        if e.stderr:
            logger.error(f"STDERR: {e.stderr}")
        
        if allow_failures:
            logger.warning("Continuing despite failure...")
            return False
        else:
            return False

def install_package(package: str, allow_failures: bool = True) -> bool:
    """Install a single package using the best available method."""
    
    # Try conda first for data science packages
    conda_packages = {
        "numpy", "pandas", "scipy", "scikit-learn", "matplotlib", "seaborn", 
        "jupyter", "jupyterlab", "notebook", "ipython", "tensorflow", "pytorch", 
        "torch", "plotly", "dask"
    }
    
    if USE_CONDA and package.lower().replace('-', '').replace('_', '') in conda_packages:
        logger.info(f"Trying conda for {package}")
        if run_conda_install([package], allow_failures=True):
            return True
        logger.warning(f"Conda failed for {package}, trying Anaconda pip...")
    
    # Try Anaconda pip second
    if USE_CONDA:
        logger.info(f"Trying Anaconda pip for {package}")
        if run_anaconda_pip_install([package], allow_failures=True):
            return True
        logger.warning(f"Anaconda pip failed for {package}, trying system pip...")
    
    # Use system pip as fallback (with --break-system-packages for PEP 668)
    logger.warning(f"Trying system pip with --break-system-packages for {package}")
    return run_system_pip_install([package], allow_failures=allow_failures)

def install_package_group(group_name: str, packages: List[str]) -> Dict[str, bool]:
    """Install a group of packages with individual fallback handling."""
    logger.info(f"Installing package group: {group_name}")
    results = {}
    
    # For data science groups, try conda first if available
    if USE_CONDA and group_name in ["core_data_science", "visualization", "jupyter", "ml_security"]:
        logger.info(f"Trying conda for group: {group_name}")
        if run_conda_install(packages, allow_failures=True):
            for pkg in packages:
                results[pkg] = True
            return results
        logger.warning(f"Conda group installation failed for {group_name}, trying individual packages...")
    
    # Try individual packages
    for package in packages:
        if package in SPECIAL_PACKAGES:
            special_config = SPECIAL_PACKAGES[package]
            
            # Try fallback if available
            if "fallback" in special_config:
                logger.info(f"Trying fallback for {package}: {special_config['fallback']}")
                if install_package(special_config["fallback"], allow_failures=True):
                    results[package] = True
                    continue
            
            # Skip if configured to do so
            if special_config.get("skip_on_error", False):
                logger.warning(f"Attempting optional red team package: {package}")
                results[package] = install_package(package, allow_failures=True)
                continue
        
        # Try normal installation
        results[package] = install_package(package, allow_failures=True)
    
    return results

def main():
    """Main installation process for red team environment."""
    logger.info("Starting Dronat Red package installation...")
    
    all_results = {}
    
    # Install package groups in order of importance
    group_order = [
        "core_system",
        "core_data_science", 
        "security_frameworks",
        "exploitation",
        "offensive_security",
        "malware_analysis",
        "network_security",
        "crypto_security",
        "web_security",
        "osint",
        "c2_frameworks",
        "memory_analysis",
        "steganography",
        "cloud_security",
        "ad_security",
        "mobile_security",
        "wireless_security",
        "visualization",
        "jupyter",
        "ml_security",
        "deployment",
        "data_processing",
        "utilities",
        "monitoring"
    ]
    
    for group_name in group_order:
        if group_name in PACKAGE_GROUPS:
            packages = PACKAGE_GROUPS[group_name]
            group_results = install_package_group(group_name, packages)
            all_results.update(group_results)
    
    # Summary
    total_packages = sum(len(packages) for packages in PACKAGE_GROUPS.values())
    successful_packages = sum(1 for success in all_results.values() if success)
    failed_packages = [pkg for pkg, success in all_results.items() if not success]
    
    logger.info(f"Installation complete: {successful_packages}/{total_packages} packages successful")
    
    if failed_packages:
        logger.warning(f"Failed packages: {', '.join(failed_packages)}")
    
    # Critical packages for red team operations
    critical_packages = [
        'numpy', 'pandas', 'scapy', 'requests', 'paramiko', 'cryptography', 
        'pwntools', 'impacket', 'python-nmap'
    ]
    critical_failures = [pkg for pkg in failed_packages if any(critical in pkg.lower() for critical in critical_packages)]
    
    if critical_failures:
        logger.error(f"Critical red team packages failed: {', '.join(critical_failures)}")
        logger.warning("Some core red team functionality may be limited...")
    
    # Success threshold for red team environment
    success_rate = (successful_packages / total_packages) * 100 if total_packages > 0 else 0
    
    if success_rate >= 70:
        logger.info(f"Red team environment ready! ({success_rate:.1f}% packages installed)")
        sys.exit(0)
    else:
        logger.warning(f"Red team environment partially ready ({success_rate:.1f}% packages installed)")
        logger.warning("Some advanced features may not be available")
        sys.exit(0)  # Continue anyway for graceful degradation

if __name__ == "__main__":
    main()