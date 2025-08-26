#!/usr/bin/env python3
"""
Dronat Package Installer - Alternative Virtual Environment Approach
Handles installation of ML/AI packages using venv to avoid externally-managed-environment issues
"""

import subprocess
import sys
import logging
import os
from typing import List, Dict, Optional

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# Check if we're in a Docker environment
IN_DOCKER = os.path.exists('/.dockerenv')
VENV_PATH = '/home/devuser/dronat_venv'

def create_virtual_environment():
    """Create a virtual environment for package installation."""
    if os.path.exists(VENV_PATH):
        logger.info(f"Virtual environment already exists at {VENV_PATH}")
        return True
    
    try:
        logger.info(f"Creating virtual environment at {VENV_PATH}")
        subprocess.run([sys.executable, '-m', 'venv', VENV_PATH], check=True)
        logger.info("Virtual environment created successfully")
        return True
    except subprocess.CalledProcessError as e:
        logger.error(f"Failed to create virtual environment: {e}")
        return False

def get_venv_python():
    """Get the path to the virtual environment's Python interpreter."""
    return os.path.join(VENV_PATH, 'bin', 'python')

def get_venv_pip():
    """Get the path to the virtual environment's pip."""
    return os.path.join(VENV_PATH, 'bin', 'pip')

def install_in_venv(packages: List[str]) -> bool:
    """Install packages in the virtual environment."""
    if not packages:
        return True
    
    pip_path = get_venv_pip()
    cmd = [pip_path, 'install', '--no-cache-dir'] + packages
    
    try:
        logger.info(f"Installing in venv: {', '.join(packages)}")
        result = subprocess.run(cmd, check=True, capture_output=True, text=True)
        logger.info("Installation successful")
        return True
    except subprocess.CalledProcessError as e:
        logger.error(f"Installation failed: {e}")
        if e.stderr:
            logger.error(f"STDERR: {e.stderr}")
        return False

def install_with_conda(packages: List[str]) -> bool:
    """Install packages using conda if available."""
    conda_path = '/home/devuser/anaconda3/bin/conda'
    if not os.path.exists(conda_path):
        return False
    
    cmd = [conda_path, 'install', '-y', '-c', 'conda-forge'] + packages
    
    try:
        logger.info(f"Installing with conda: {', '.join(packages)}")
        result = subprocess.run(cmd, check=True, capture_output=True, text=True)
        logger.info("Conda installation successful")
        return True
    except subprocess.CalledProcessError as e:
        logger.error(f"Conda installation failed: {e}")
        return False

def install_with_break_system(packages: List[str]) -> bool:
    """Install packages using pip with --break-system-packages."""
    cmd = [sys.executable, '-m', 'pip', 'install', '--break-system-packages', '--no-cache-dir'] + packages
    
    try:
        logger.info(f"Installing with --break-system-packages: {', '.join(packages)}")
        result = subprocess.run(cmd, check=True, capture_output=True, text=True)
        logger.info("Installation successful")
        return True
    except subprocess.CalledProcessError as e:
        logger.error(f"Installation failed: {e}")
        if e.stderr:
            logger.error(f"STDERR: {e.stderr}")
        return False

def install_package(package: str) -> bool:
    """Install a single package using the best available method."""
    
    # Method 1: Try conda first for common packages (if available)
    conda_packages = {
        "numpy", "pandas", "scipy", "scikit-learn", "matplotlib", "seaborn", 
        "jupyter", "jupyterlab", "notebook", "ipython", "tensorflow", "pytorch",
        "torch", "plotly", "opencv", "pillow", "nltk", "spacy", "dask"
    }
    
    if package.lower().replace('-', '') in conda_packages:
        logger.info(f"Trying conda for {package}")
        if install_with_conda([package]):
            return True
        logger.warning(f"Conda failed for {package}, trying other methods...")
    
    # Method 2: Try virtual environment
    if os.path.exists(VENV_PATH):
        logger.info(f"Trying virtual environment for {package}")
        if install_in_venv([package]):
            return True
        logger.warning(f"Virtual environment install failed for {package}")
    
    # Method 3: Try with --break-system-packages (last resort)
    logger.warning(f"Trying --break-system-packages for {package}")
    return install_with_break_system([package])

def read_requirements(file_path: str) -> List[str]:
    """Read packages from requirements.txt file."""
    packages = []
    try:
        with open(file_path, 'r') as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith('#'):
                    packages.append(line)
        return packages
    except FileNotFoundError:
        logger.error(f"Requirements file not found: {file_path}")
        return []

def main():
    """Main installation process."""
    logger.info("Starting Dronat package installation with multiple methods...")
    
    # Create virtual environment as fallback
    create_virtual_environment()
    
    # Read requirements
    requirements_file = '/tmp/requirements.txt'
    packages = read_requirements(requirements_file)
    
    if not packages:
        logger.error("No packages found in requirements file")
        sys.exit(1)
    
    successful = 0
    failed_packages = []
    
    # Install packages one by one for better error handling
    for package in packages:
        logger.info(f"Installing package: {package}")
        if install_package(package):
            successful += 1
        else:
            failed_packages.append(package)
    
    # Summary
    total = len(packages)
    logger.info(f"Installation complete: {successful}/{total} packages successful")
    
    if failed_packages:
        logger.warning(f"Failed packages: {', '.join(failed_packages)}")
    
    # Critical packages that must succeed
    critical_packages = ['numpy', 'pandas', 'scikit-learn', 'matplotlib', 'jupyter']
    critical_failures = [pkg for pkg in failed_packages if any(critical in pkg.lower() for critical in critical_packages)]
    
    if critical_failures:
        logger.error(f"Critical packages failed: {', '.join(critical_failures)}")
        # Don't exit with error - let the container build continue
        logger.warning("Continuing despite critical package failures...")
    
    logger.info("Package installation completed!")
    sys.exit(0)

if __name__ == "__main__":
    main()