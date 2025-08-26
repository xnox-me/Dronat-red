#!/usr/bin/env python3
"""
Dronat Package Installer
Handles installation of ML/AI packages with error handling and fallbacks
Uses conda/pip as appropriate to avoid externally-managed-environment issues
"""

import subprocess
import sys
import logging
import os
from typing import List, Dict, Optional

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# Check if we're in a Docker environment or need to use conda
USE_CONDA = os.path.exists('/home/devuser/anaconda3/bin/conda') or 'CONDA_PREFIX' in os.environ

# Package groups with fallback options
PACKAGE_GROUPS = {
    "core_system": [
        "meson", "openbb", "shell-gpt", "pip", "setuptools", "wheel"
    ],
    "core_ml": [
        "numpy", "pandas", "scipy", "scikit-learn"
    ],
    "deep_learning": [
        "tensorflow", "torch", "torchvision", "torchaudio", "keras"
    ],
    "advanced_ml": [
        "transformers", "accelerate", "diffusers", "peft", 
        "xgboost", "lightgbm", "catboost"
    ],
    "visualization": [
        "matplotlib", "seaborn", "plotly"
    ],
    "jupyter": [
        "jupyterlab", "notebook", "ipython", "ipywidgets"
    ],
    "computer_vision": [
        "opencv-python", "Pillow", "albumentations"
    ],
    "nlp": [
        "nltk", "spacy", "textblob", "gensim", "datasets", "tokenizers"
    ],
    "mlops": [
        "mlflow", "tensorboard", "wandb"
    ],
    "automl": [
        "optuna", "hyperopt"
    ],
    "deployment": [
        "fastapi", "uvicorn", "gradio", "streamlit"
    ],
    "data_engineering": [
        "dask", "polars", "pyarrow"
    ],
    "utilities": [
        "tqdm", "joblib", "rich", "typer", "fire"
    ]
}

# Problematic packages that need special handling
SPECIAL_PACKAGES = {
    "ray[tune]": {"fallback": "ray", "post_install": ["ray[tune]"]},
    "autosklearn": {"skip_on_error": True},
    "torch-geometric": {"skip_on_error": True},
    "stellargraph": {"skip_on_error": True},
    "dgl": {"skip_on_error": True},
    "ultralytics": {"skip_on_error": True},
    "clearml": {"skip_on_error": True},
    "bentoml": {"skip_on_error": True},
    "apache-beam": {"skip_on_error": True},
    "librosa": {"dependencies": ["soundfile"]},
    "prophet": {"skip_on_error": True},
    "sktime": {"skip_on_error": True},
    "tslearn": {"skip_on_error": True},
    "gymnasium": {"fallback": "gym"},
    "stable-baselines3": {"skip_on_error": True},
    "tianshou": {"skip_on_error": True},
    "jupyterlab-git": {"skip_on_error": True},
    "jupyterlab-vim": {"skip_on_error": True},
    "statsmodels": {"dependencies": ["patsy"]}
}

def run_conda_install(packages: List[str], allow_failures: bool = False) -> bool:
    """Install packages using conda with error handling."""
    if not packages:
        return True
        
    conda_path = '/home/devuser/anaconda3/bin/conda'
    if not os.path.exists(conda_path):
        return False
        
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

def run_pip_install(packages: List[str], allow_failures: bool = False, use_break_system: bool = False) -> bool:
    """Install packages using pip with error handling."""
    if not packages:
        return True
    
    # Use conda python and pip if available, fallback to system python
    if os.path.exists('/home/devuser/anaconda3/bin/pip'):
        pip_cmd = ['/home/devuser/anaconda3/bin/pip']
    else:
        pip_cmd = [sys.executable, "-m", "pip"]
    
    cmd = pip_cmd + ["install", "--no-cache-dir"]
    
    # Add break-system-packages flag if needed and requested
    if use_break_system:
        cmd.append("--break-system-packages")
    
    cmd.extend(packages)
    
    try:
        logger.info(f"Installing with pip: {', '.join(packages)}")
        result = subprocess.run(cmd, check=True, capture_output=True, text=True)
        logger.info("Pip installation successful")
        return True
    except subprocess.CalledProcessError as e:
        logger.error(f"Pip installation failed: {e}")
        if e.stdout:
            logger.error(f"STDOUT: {e.stdout}")
        if e.stderr:
            logger.error(f"STDERR: {e.stderr}")
        
        if allow_failures:
            logger.warning("Continuing despite failure...")
            return False
        else:
            return False

def install_package(package: str, allow_failures: bool = True) -> bool:
    """Install a single package using the best available method."""
    
    # Try conda first for common packages if available
    conda_packages = {
        "numpy", "pandas", "scipy", "scikit-learn", "matplotlib", "seaborn", 
        "jupyter", "jupyterlab", "notebook", "ipython", "tensorflow", "pytorch", 
        "torch", "plotly", "opencv", "pillow", "nltk", "spacy", "dask", "numba", "xgboost"
    }
    
    if USE_CONDA and package.lower().replace('-', '').replace('_', '') in conda_packages:
        logger.info(f"Trying conda for {package}")
        if run_conda_install([package], allow_failures=True):
            return True
        logger.warning(f"Conda failed for {package}, trying pip...")
    
    # Try pip with conda's pip first (if available)
    if run_pip_install([package], allow_failures=True):
        return True
    
    # If regular pip fails, try with --break-system-packages
    logger.warning(f"Regular pip failed for {package}, trying with --break-system-packages...")
    return run_pip_install([package], allow_failures=allow_failures, use_break_system=True)

def install_package_group(group_name: str, packages: List[str]) -> Dict[str, bool]:
    """Install a group of packages with individual fallback handling."""
    logger.info(f"Installing package group: {group_name}")
    results = {}
    
    # For important groups, try conda first if available
    if USE_CONDA and group_name in ["core_ml", "deep_learning", "visualization", "jupyter"]:
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
            
            # Install dependencies first if specified
            if "dependencies" in special_config:
                for dep in special_config["dependencies"]:
                    install_package(dep, allow_failures=True)
            
            # Try fallback if available
            if "fallback" in special_config:
                logger.info(f"Trying fallback for {package}: {special_config['fallback']}")
                if install_package(special_config["fallback"], allow_failures=True):
                    results[package] = True
                    continue
            
            # Skip if configured to do so
            if special_config.get("skip_on_error", False):
                logger.warning(f"Attempting problematic package: {package}")
                results[package] = install_package(package, allow_failures=True)
                continue
        
        # Try normal installation
        results[package] = install_package(package, allow_failures=True)
    
    return results

def main():
    """Main installation process."""
    logger.info("Starting Dronat package installation...")
    
    all_results = {}
    
    # Install package groups in order of importance
    for group_name, packages in PACKAGE_GROUPS.items():
        group_results = install_package_group(group_name, packages)
        all_results.update(group_results)
    
    # Summary
    successful = sum(1 for success in all_results.values() if success)
    total = len(all_results)
    failed_packages = [pkg for pkg, success in all_results.items() if not success]
    
    logger.info(f"Installation complete: {successful}/{total} packages successful")
    
    if failed_packages:
        logger.warning(f"Failed packages: {', '.join(failed_packages)}")
    
    # Return exit code based on critical package installation
    critical_packages = PACKAGE_GROUPS["core_system"] + PACKAGE_GROUPS["core_ml"]
    critical_failures = [pkg for pkg in critical_packages if not all_results.get(pkg, False)]
    
    if critical_failures:
        logger.error(f"Critical packages failed: {', '.join(critical_failures)}")
        sys.exit(1)
    else:
        logger.info("All critical packages installed successfully!")
        sys.exit(0)

if __name__ == "__main__":
    main()