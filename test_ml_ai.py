#!/usr/bin/env python3
"""
Comprehensive test script for ML/AI tools installation and functionality
"""

import sys
import subprocess
import importlib
from typing import Dict, List, Tuple

# Color codes for output
class Colors:
    RED = '\033[0;31m'
    GREEN = '\033[0;32m'
    YELLOW = '\033[1;33m'
    BLUE = '\033[0;34m'
    PURPLE = '\033[0;35m'
    CYAN = '\033[0;36m'
    NC = '\033[0m'  # No Color

def log_info(message: str):
    print(f"{Colors.BLUE}[INFO]{Colors.NC} {message}")

def log_success(message: str):
    print(f"{Colors.GREEN}[SUCCESS]{Colors.NC} {message}")

def log_warning(message: str):
    print(f"{Colors.YELLOW}[WARNING]{Colors.NC} {message}")

def log_error(message: str):
    print(f"{Colors.RED}[ERROR]{Colors.NC} {message}")

def test_package_import(package_name: str, display_name: str = None) -> Tuple[bool, str]:
    """Test if a package can be imported and return version if available."""
    if display_name is None:
        display_name = package_name
    
    try:
        module = importlib.import_module(package_name)
        version = getattr(module, '__version__', 'unknown')
        return True, version
    except ImportError as e:
        return False, str(e)

def test_ml_frameworks() -> Dict[str, bool]:
    """Test core ML/AI frameworks."""
    log_info("Testing ML/AI Frameworks...")
    
    frameworks = {
        'TensorFlow': 'tensorflow',
        'PyTorch': 'torch',
        'scikit-learn': 'sklearn',
        'Keras': 'keras',
        'XGBoost': 'xgboost',
        'LightGBM': 'lightgbm',
        'CatBoost': 'catboost'
    }
    
    results = {}
    for name, package in frameworks.items():
        success, version = test_package_import(package, name)
        if success:
            log_success(f"✓ {name} {version}")
            results[name] = True
        else:
            log_error(f"✗ {name} failed to import")
            results[name] = False
    
    return results

def test_data_science_tools() -> Dict[str, bool]:
    """Test data science and analysis tools."""
    log_info("Testing Data Science Tools...")
    
    tools = {
        'NumPy': 'numpy',
        'Pandas': 'pandas',
        'Matplotlib': 'matplotlib',
        'Seaborn': 'seaborn',
        'Plotly': 'plotly',
        'SciPy': 'scipy'
    }
    
    results = {}
    for name, package in tools.items():
        success, version = test_package_import(package, name)
        if success:
            log_success(f"✓ {name} {version}")
            results[name] = True
        else:
            log_error(f"✗ {name} failed to import")
            results[name] = False
    
    return results

def test_deep_learning_tools() -> Dict[str, bool]:
    """Test deep learning and transformer tools."""
    log_info("Testing Deep Learning & Transformer Tools...")
    
    tools = {
        'Transformers': 'transformers',
        'Accelerate': 'accelerate',
        'Diffusers': 'diffusers',
        'Torchvision': 'torchvision',
        'Torchaudio': 'torchaudio'
    }
    
    results = {}
    for name, package in tools.items():
        success, version = test_package_import(package, name)
        if success:
            log_success(f"✓ {name} {version}")
            results[name] = True
        else:
            log_error(f"✗ {name} failed to import")
            results[name] = False
    
    return results

def test_computer_vision_tools() -> Dict[str, bool]:
    """Test computer vision tools."""
    log_info("Testing Computer Vision Tools...")
    
    tools = {
        'OpenCV': 'cv2',
        'Pillow': 'PIL',
        'Albumentations': 'albumentations'
    }
    
    results = {}
    for name, package in tools.items():
        success, version = test_package_import(package, name)
        if success:
            log_success(f"✓ {name} {version}")
            results[name] = True
        else:
            log_error(f"✗ {name} failed to import")
            results[name] = False
    
    return results

def test_nlp_tools() -> Dict[str, bool]:
    """Test natural language processing tools."""
    log_info("Testing NLP Tools...")
    
    tools = {
        'NLTK': 'nltk',
        'spaCy': 'spacy',
        'TextBlob': 'textblob',
        'Gensim': 'gensim'
    }
    
    results = {}
    for name, package in tools.items():
        success, version = test_package_import(package, name)
        if success:
            log_success(f"✓ {name} {version}")
            results[name] = True
        else:
            log_error(f"✗ {name} failed to import")
            results[name] = False
    
    return results

def test_mlops_tools() -> Dict[str, bool]:
    """Test MLOps and experiment tracking tools."""
    log_info("Testing MLOps & Experiment Tracking Tools...")
    
    tools = {
        'MLflow': 'mlflow',
        'Weights & Biases': 'wandb',
        'TensorBoard': 'tensorboard'
    }
    
    results = {}
    for name, package in tools.items():
        success, version = test_package_import(package, name)
        if success:
            log_success(f"✓ {name} {version}")
            results[name] = True
        else:
            log_error(f"✗ {name} failed to import")
            results[name] = False
    
    return results

def test_automl_tools() -> Dict[str, bool]:
    """Test AutoML and hyperparameter tuning tools."""
    log_info("Testing AutoML & Hyperparameter Tuning Tools...")
    
    tools = {
        'Optuna': 'optuna',
        'Hyperopt': 'hyperopt'
    }
    
    results = {}
    for name, package in tools.items():
        success, version = test_package_import(package, name)
        if success:
            log_success(f"✓ {name} {version}")
            results[name] = True
        else:
            log_error(f"✗ {name} failed to import")
            results[name] = False
    
    return results

def test_deployment_tools() -> Dict[str, bool]:
    """Test model deployment and serving tools."""
    log_info("Testing Model Deployment & Serving Tools...")
    
    tools = {
        'FastAPI': 'fastapi',
        'Uvicorn': 'uvicorn',
        'Gradio': 'gradio',
        'Streamlit': 'streamlit'
    }
    
    results = {}
    for name, package in tools.items():
        success, version = test_package_import(package, name)
        if success:
            log_success(f"✓ {name} {version}")
            results[name] = True
        else:
            log_error(f"✗ {name} failed to import")
            results[name] = False
    
    return results

def test_jupyter_tools() -> Dict[str, bool]:
    """Test Jupyter ecosystem tools."""
    log_info("Testing Jupyter Ecosystem...")
    
    commands = {
        'JupyterLab': 'jupyter-lab --version',
        'Jupyter Notebook': 'jupyter-notebook --version',
        'IPython': 'ipython --version'
    }
    
    results = {}
    for name, command in commands.items():
        try:
            result = subprocess.run(
                command.split(), 
                capture_output=True, 
                text=True, 
                timeout=10
            )
            if result.returncode == 0:
                version = result.stdout.strip()
                log_success(f"✓ {name} {version}")
                results[name] = True
            else:
                log_error(f"✗ {name} command failed")
                results[name] = False
        except Exception as e:
            log_error(f"✗ {name} error: {e}")
            results[name] = False
    
    return results

def test_basic_functionality():
    """Test basic ML/AI functionality with simple examples."""
    log_info("Testing Basic ML/AI Functionality...")
    
    try:
        # Test NumPy
        import numpy as np
        arr = np.array([1, 2, 3, 4, 5])
        assert arr.sum() == 15
        log_success("✓ NumPy basic operations work")
        
        # Test Pandas
        import pandas as pd
        df = pd.DataFrame({'A': [1, 2, 3], 'B': [4, 5, 6]})
        assert len(df) == 3
        log_success("✓ Pandas DataFrame operations work")
        
        # Test scikit-learn
        from sklearn.datasets import make_classification
        from sklearn.model_selection import train_test_split
        from sklearn.ensemble import RandomForestClassifier
        
        X, y = make_classification(n_samples=100, n_features=4, random_state=42)
        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
        clf = RandomForestClassifier(n_estimators=10, random_state=42)
        clf.fit(X_train, y_train)
        score = clf.score(X_test, y_test)
        assert score > 0.5
        log_success(f"✓ scikit-learn model training works (accuracy: {score:.3f})")
        
        return True
        
    except Exception as e:
        log_error(f"✗ Basic functionality test failed: {e}")
        return False

def show_usage_examples():
    """Show usage examples for ML/AI tools."""
    print(f"\n{Colors.CYAN}{'='*60}")
    print("🤖 ML/AI Development Environment Usage Examples")
    print(f"{'='*60}{Colors.NC}")
    
    examples = [
        ("🐍 Interactive ML Python", "python3 -c \"import tensorflow as tf; import torch; import IPython; IPython.embed()\""),
        ("📊 JupyterLab", "jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root"),
        ("📓 Jupyter Notebook", "jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root"),
        ("📈 TensorBoard", "tensorboard --logdir=./logs --host=0.0.0.0 --port=6006"),
        ("🎨 Gradio Demo", "python3 -c \"import gradio as gr; gr.Interface(lambda x: x, 'text', 'text').launch()\""),
        ("🌐 Streamlit App", "streamlit run your_app.py --server.address 0.0.0.0 --server.port 8501"),
        ("📊 MLflow UI", "mlflow ui --host 0.0.0.0 --port 5000"),
    ]
    
    for name, command in examples:
        print(f"\n{Colors.YELLOW}{name}:{Colors.NC}")
        print(f"  {command}")
    
    print(f"\n{Colors.PURPLE}🔧 Quick ML Pipeline Example:{Colors.NC}")
    print("""
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score

# Load data
data = pd.read_csv('your_dataset.csv')
X = data.drop('target', axis=1)
y = data['target']

# Split data
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

# Train model
model = RandomForestClassifier()
model.fit(X_train, y_train)

# Evaluate
predictions = model.predict(X_test)
accuracy = accuracy_score(y_test, predictions)
print(f'Accuracy: {accuracy:.3f}')
""")

def main():
    """Run comprehensive ML/AI tools test suite."""
    print(f"{Colors.PURPLE}🤖 Testing ML/AI Development Environment{Colors.NC}")
    print("=" * 60)
    
    # Run all test categories
    test_functions = [
        test_ml_frameworks,
        test_data_science_tools,
        test_deep_learning_tools,
        test_computer_vision_tools,
        test_nlp_tools,
        test_mlops_tools,
        test_automl_tools,
        test_deployment_tools,
        test_jupyter_tools
    ]
    
    all_results = {}
    total_tests = 0
    passed_tests = 0
    
    for test_func in test_functions:
        results = test_func()
        all_results.update(results)
        print("")
    
    # Count results
    for name, passed in all_results.items():
        total_tests += 1
        if passed:
            passed_tests += 1
    
    # Test basic functionality
    log_info("Running Basic Functionality Tests...")
    basic_test_passed = test_basic_functionality()
    total_tests += 1
    if basic_test_passed:
        passed_tests += 1
    
    # Summary
    print("=" * 60)
    print(f"📊 Test Results: {passed_tests}/{total_tests} tests passed")
    
    if passed_tests == total_tests:
        log_success("🎉 All ML/AI tools tests passed! Environment is ready for machine learning development.")
        show_usage_examples()
    elif passed_tests > total_tests * 0.7:
        log_warning(f"⚠️  Most tests passed ({passed_tests}/{total_tests}). Some optional tools may be missing.")
        show_usage_examples()
    else:
        log_error("❌ Many tests failed. Please check ML/AI tools installation.")
    
    # Failed tools summary
    failed_tools = [name for name, passed in all_results.items() if not passed]
    if failed_tools:
        print(f"\n{Colors.YELLOW}📋 Failed tools:{Colors.NC}")
        for tool in failed_tools:
            print(f"  • {tool}")

if __name__ == "__main__":
    main()