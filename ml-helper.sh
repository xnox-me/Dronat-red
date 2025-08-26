#!/bin/bash
# Enhanced ML/AI Development Environment Helper Script v2.0
# Part of the Dronat development environment

set -euo pipefail

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1" >&2; }

show_help() {
    echo -e "${BOLD}${CYAN}🤖 Enhanced ML/AI Helper v2.0${NC}"
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    echo ""
    echo -e "${YELLOW}Services:${NC}"
    echo -e "  ${CYAN}jupyter${NC}      Start JupyterLab"
    echo -e "  ${CYAN}notebook${NC}     Start Jupyter Notebook"
    echo -e "  ${CYAN}tensorboard${NC}  Start TensorBoard"
    echo -e "  ${CYAN}gradio${NC}       Start Gradio demo"
    echo -e "  ${CYAN}streamlit${NC}    Start Streamlit app"
    echo -e "  ${CYAN}mlflow${NC}       Start MLflow UI"
    echo -e "  ${CYAN}repl${NC}         Enhanced Python REPL"
    echo ""
    echo -e "${YELLOW}Tools:${NC}"
    echo -e "  ${CYAN}test${NC}         Test environment"
    echo -e "  ${CYAN}examples${NC}     Create example projects"
    echo -e "  ${CYAN}env-info${NC}     Show environment info"
    echo ""
    echo -e "${YELLOW}Ports:${NC} Jupyter(8888) TensorBoard(6006) Gradio(7860) Streamlit(8501) MLflow(5000)"
}

start_jupyter() {
    log_info "Starting JupyterLab at http://localhost:8888"
    jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root
}

start_notebook() {
    log_info "Starting Jupyter Notebook at http://localhost:8888"
    jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root
}

start_tensorboard() {
    log_info "Starting TensorBoard at http://localhost:6006"
    mkdir -p ./logs
    tensorboard --logdir=./logs --host=0.0.0.0 --port=6006
}

start_gradio() {
    log_info "Starting Enhanced Gradio Demo at http://localhost:7860"
    python3 -c "
import gradio as gr
import numpy as np
from sklearn.datasets import load_iris
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split

iris = load_iris()
X_train, X_test, y_train, y_test = train_test_split(iris.data, iris.target, test_size=0.2)
model = RandomForestClassifier().fit(X_train, y_train)

def predict(sl, sw, pl, pw):
    pred = model.predict([[sl, sw, pl, pw]])[0]
    prob = model.predict_proba([[sl, sw, pl, pw]])[0].max()
    return f'{iris.target_names[pred]} (confidence: {prob:.2f})'

gr.Interface(
    fn=predict,
    inputs=[gr.Number(label=l) for l in iris.feature_names],
    outputs=gr.Text(label='Prediction'),
    title='🌸 Enhanced Iris Classifier'
).launch(server_name='0.0.0.0', server_port=7860)
"
}

start_streamlit() {
    log_info "Starting Enhanced Streamlit App at http://localhost:8501"
    cat > /tmp/ml_app.py << 'EOF'
import streamlit as st
import pandas as pd
import numpy as np
from sklearn.datasets import load_iris, load_wine
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
import plotly.express as px

st.title('🤖 Enhanced ML Dashboard')

dataset = st.selectbox('Dataset', ['Iris', 'Wine'])
data = load_iris() if dataset == 'Iris' else load_wine()

df = pd.DataFrame(data.data, columns=data.feature_names)
df['target'] = data.target

st.write(f'Dataset: {df.shape[0]} samples, {df.shape[1]-1} features')

if st.button('Train Model'):
    X_train, X_test, y_train, y_test = train_test_split(data.data, data.target, test_size=0.2)
    model = RandomForestClassifier().fit(X_train, y_train)
    acc = accuracy_score(y_test, model.predict(X_test))
    st.success(f'Accuracy: {acc:.3f}')
    
    # Feature importance
    imp_df = pd.DataFrame({'feature': data.feature_names, 'importance': model.feature_importances_})
    fig = px.bar(imp_df.sort_values('importance'), x='importance', y='feature', orientation='h')
    st.plotly_chart(fig)
EOF
    streamlit run /tmp/ml_app.py --server.address 0.0.0.0 --server.port 8501
}

start_mlflow() {
    log_info "Starting MLflow UI at http://localhost:5000"
    mkdir -p ./mlruns
    mlflow ui --host 0.0.0.0 --port 5000
}

start_repl() {
    log_info "Starting Enhanced ML/AI Python REPL"
    python3 -c "
print('🤖 Enhanced ML/AI Python Environment')
print('Available libraries:')
libs = [('TensorFlow', 'tensorflow'), ('PyTorch', 'torch'), ('Scikit-learn', 'sklearn'), 
        ('Pandas', 'pandas'), ('NumPy', 'numpy'), ('MLflow', 'mlflow')]
for name, module in libs:
    try:
        __import__(module)
        print(f'  ✓ {name}')
    except:
        print(f'  ✗ {name}')
print('\nPre-imported: pandas as pd, numpy as np')
import pandas as pd, numpy as np
import IPython; IPython.embed()
"
}

test_environment() {
    log_info "Testing ML/AI environment"
    python3 -c "
libs = ['numpy', 'pandas', 'sklearn', 'tensorflow', 'torch', 'mlflow', 'gradio', 'streamlit']
passed = failed = 0
for lib in libs:
    try:
        __import__(lib)
        print(f'✓ {lib}')
        passed += 1
    except:
        print(f'✗ {lib}')
        failed += 1
print(f'\nResult: {passed} passed, {failed} failed ({passed/(passed+failed)*100:.0f}% success)')
"
}

create_examples() {
    log_info "Creating ML example projects"
    mkdir -p ./ml_examples
    
    cat > ./ml_examples/classification.py << 'EOF'
from sklearn.datasets import load_iris
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, classification_report

iris = load_iris()
X_train, X_test, y_train, y_test = train_test_split(iris.data, iris.target, test_size=0.2)
model = RandomForestClassifier().fit(X_train, y_train)
y_pred = model.predict(X_test)

print(f'Accuracy: {accuracy_score(y_test, y_pred):.3f}')
print('\nClassification Report:')
print(classification_report(y_test, y_pred, target_names=iris.target_names))
EOF

    cat > ./ml_examples/deep_learning.py << 'EOF'
try:
    import tensorflow as tf
    from tensorflow.keras import layers
    
    # Simple neural network for MNIST
    (x_train, y_train), (x_test, y_test) = tf.keras.datasets.mnist.load_data()
    x_train, x_test = x_train / 255.0, x_test / 255.0
    
    model = tf.keras.Sequential([
        layers.Flatten(input_shape=(28, 28)),
        layers.Dense(128, activation='relu'),
        layers.Dense(10, activation='softmax')
    ])
    
    model.compile(optimizer='adam', loss='sparse_categorical_crossentropy', metrics=['accuracy'])
    model.fit(x_train, y_train, epochs=3, validation_split=0.1)
    
    test_loss, test_acc = model.evaluate(x_test, y_test, verbose=0)
    print(f'Test accuracy: {test_acc:.4f}')
except ImportError:
    print('TensorFlow not available')
EOF

    log_success "Examples created in ./ml_examples/"
}

show_env_info() {
    log_info "Environment Information"
    python3 -c "
import sys, platform
print(f'Python: {sys.version.split()[0]}')
print(f'Platform: {platform.platform()}')
print(f'Architecture: {platform.architecture()[0]}')
"
}

# Main execution
case "${1:-help}" in
    jupyter) start_jupyter ;;
    notebook) start_notebook ;;
    tensorboard) start_tensorboard ;;
    gradio) start_gradio ;;
    streamlit) start_streamlit ;;
    mlflow) start_mlflow ;;
    repl) start_repl ;;
    test) test_environment ;;
    examples) create_examples ;;
    env-info) show_env_info ;;
    help|*) show_help ;;
esac