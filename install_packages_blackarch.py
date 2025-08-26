#!/usr/bin/env python3
"""
Dronat BlackArch Package Installer
Handles installation of security research and penetration testing packages
Optimized for BlackArch Linux (Arch-based) environment
"""

import subprocess
import sys
import logging
import os
from typing import List, Dict, Optional

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# Check if we're in BlackArch/Arch environment
USE_CONDA = os.path.exists('/home/devuser/anaconda3/bin/conda')

# Package groups optimized for security research
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
    "penetration_testing": [
        "impacket", "python-nmap", "pwntools", "ropper"
    ],
    "binary_analysis": [
        "capstone", "keystone-engine", "unicorn", "angr", "z3-solver"
    ],
    "web_security": [
        "selenium", "flask", "fastapi", "aiohttp", "httpx"
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
    "network_analysis": [
        "pyshark", "dpkt", "pcapy-ng", "python-libnmap"
    ],
    "cryptography": [
        "pycryptodome", "passlib", "bcrypt"
    ],
    "file_analysis": [
        "python-magic", "pefile", "pyelftools"
    ],
    "web_scraping": [
        "scrapy", "lxml", "xmltodict"
    ],
    "utilities": [
        "tqdm", "rich", "typer", "fire", "click", "colorama"
    ],
    "monitoring": [
        "psutil", "loguru"
    ]
}

# Special packages that may need different handling on BlackArch
SPECIAL_PACKAGES = {
    "volatility3": {"skip_on_error": True},
    "yara-python": {"fallback": "yara"},
    "shodan": {"skip_on_error": True},
    "censys": {"skip_on_error": True},
    "netfilterqueue": {"skip_on_error": True},
    "pcapy-ng": {"fallback": "pcapy"},
    "angr": {"skip_on_error": True},  # Complex dependencies
    "z3-solver": {"fallback": "z3"},
    "keystone-engine": {"skip_on_error": True},
    "unicorn": {"skip_on_error": True}
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

def run_pip_install(packages: List[str], allow_failures: bool = False) -> bool:
    """Install packages using pip with error handling."""
    if not packages:
        return True
    
    # Use conda pip if available, otherwise system pip
    if os.path.exists('/home/devuser/anaconda3/bin/pip'):
        pip_cmd = ['/home/devuser/anaconda3/bin/pip']
    else:
        pip_cmd = [sys.executable, "-m", "pip"]
    
    cmd = pip_cmd + ["install", "--no-cache-dir"] + packages
    
    try:
        logger.info(f"Installing with pip: {', '.join(packages)}")
        result = subprocess.run(cmd, check=True, capture_output=True, text=True)
        logger.info("Pip installation successful")
        return True
    except subprocess.CalledProcessError as e:
        logger.error(f"Pip installation failed: {e}")
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
        logger.warning(f"Conda failed for {package}, trying pip...")
    
    # Use pip for most security packages
    return run_pip_install([package], allow_failures=allow_failures)

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
                logger.warning(f"Attempting complex package: {package}")
                results[package] = install_package(package, allow_failures=True)
                continue
        
        # Try normal installation
        results[package] = install_package(package, allow_failures=True)
    
    return results

def main():
    """Main installation process for BlackArch security environment."""
    logger.info("Starting Dronat BlackArch security package installation...")
    
    all_results = {}
    
    # Install package groups in order of importance for security research
    group_priority = [
        "core_system", "core_data_science", "security_frameworks", 
        "penetration_testing", "web_security", "visualization", "jupyter",
        "network_analysis", "cryptography", "file_analysis", "utilities",
        "binary_analysis", "ml_security", "data_processing", "deployment",
        "web_scraping", "monitoring"
    ]
    
    for group_name in group_priority:
        if group_name in PACKAGE_GROUPS:
            group_results = install_package_group(group_name, PACKAGE_GROUPS[group_name])
            all_results.update(group_results)
    
    # Summary
    successful = sum(1 for success in all_results.values() if success)
    total = len(all_results)
    failed_packages = [pkg for pkg, success in all_results.items() if not success]
    
    logger.info(f"BlackArch installation complete: {successful}/{total} packages successful")
    
    if failed_packages:
        logger.warning(f"Failed packages: {', '.join(failed_packages)}")
        logger.info("Failed packages are typically complex security tools that can be installed manually if needed")
    
    # Check critical security packages
    critical_packages = PACKAGE_GROUPS["core_system"] + PACKAGE_GROUPS["core_data_science"] + PACKAGE_GROUPS["security_frameworks"]
    critical_failures = [pkg for pkg in critical_packages if not all_results.get(pkg, False)]
    
    if critical_failures:
        logger.error(f"Critical security packages failed: {', '.join(critical_failures)}")
        logger.warning("Continuing despite critical failures - some tools may not be available")
    else:
        logger.info("All critical security packages installed successfully!")
    
    logger.info("Dronat BlackArch security environment ready for penetration testing!")
    sys.exit(0)

if __name__ == "__main__":
    main()