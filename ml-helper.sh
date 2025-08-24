#!/bin/bash
# ML/AI Development Environment Helper Script

set -euo pipefail

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

show_help() {
    echo -e "${PURPLE}🤖 ML/AI Development Environment Helper${NC}"
    echo "============================================="
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo -e "  ${CYAN}jupyter${NC}      Start JupyterLab"
    echo -e "  ${CYAN}notebook${NC}     Start Jupyter Notebook"
    echo -e "  ${CYAN}tensorboard${NC}  Start TensorBoard"
    echo -e "  ${CYAN}gradio${NC}       Start Gradio demo"
    echo -e "  ${CYAN}streamlit${NC}    Start Streamlit app"
    echo -e "  ${CYAN}mlflow${NC}       Start MLflow UI"
    echo -e "  ${CYAN}repl${NC}         Start ML/AI Python REPL"
    echo -e "  ${CYAN}test${NC}         Test ML/AI environment"
    echo -e "  ${CYAN}examples${NC}     Create ML example projects"
    echo -e "  ${CYAN}help${NC}         Show this help message"
    echo ""
    echo "Port mappings:"
    echo "  • JupyterLab/Notebook: http://localhost:8888"
    echo "  • TensorBoard: http://localhost:6006"
    echo "  • Gradio: http://localhost:7860"
    echo "  • Streamlit: http://localhost:8501"
    echo "  • MLflow: http://localhost:5000"
}

start_jupyter() {
    echo -e "${BLUE}🚀 Starting JupyterLab...${NC}"
    echo -e "${YELLOW}Access at: http://localhost:8888${NC}"
    jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root
}

start_notebook() {
    echo -e "${BLUE}🚀 Starting Jupyter Notebook...${NC}"
    echo -e "${YELLOW}Access at: http://localhost:8888${NC}"
    jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root
}

start_tensorboard() {
    echo -e "${BLUE}📊 Starting TensorBoard...${NC}"
    echo -e "${YELLOW}Access at: http://localhost:6006${NC}"
    mkdir -p ./logs
    tensorboard --logdir=./logs --host=0.0.0.0 --port=6006
}

start_gradio() {
    echo -e "${BLUE}🎨 Starting Gradio Demo...${NC}"
    python3 -c "
import gradio as gr
import numpy as np
from sklearn.datasets import load_iris
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split

iris = load_iris()
X_train, X_test, y_train, y_test = train_test_split(iris.data, iris.target, test_size=0.2)
model = RandomForestClassifier()
model.fit(X_train, y_train)

def predict_iris(sepal_length, sepal_width, petal_length, petal_width):
    features = np.array([[sepal_length, sepal_width, petal_length, petal_width]])
    prediction = model.predict(features)[0]
    probability = model.predict_proba(features)[0]
    species = iris.target_names[prediction]
    confidence = max(probability)
    return f'Species: {species} (Confidence: {confidence:.2f})'

interface = gr.Interface(
    fn=predict_iris,
    inputs=[
        gr.Number(label='Sepal Length'),
        gr.Number(label='Sepal Width'),
        gr.Number(label='Petal Length'),
        gr.Number(label='Petal Width')
    ],
    outputs=gr.Text(label='Prediction'),
    title='🌸 Iris Species Classifier'
)

print('🎨 Gradio demo ready at: http://localhost:7860')
interface.launch(server_name='0.0.0.0', server_port=7860)
"
}

start_streamlit() {
    echo -e "${BLUE}🌐 Starting Streamlit App...${NC}"
    cat > /tmp/ml_streamlit_app.py << 'EOF'
import streamlit as st
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.datasets import load_iris, load_wine
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score

st.set_page_config(page_title='🤖 ML Dashboard', page_icon='🤖')
st.title('🤖 Machine Learning Dashboard')

dataset_name = st.sidebar.selectbox('Choose Dataset', ['Iris', 'Wine'])
data = load_iris() if dataset_name == 'Iris' else load_wine()

df = pd.DataFrame(data.data, columns=data.feature_names)
df['target'] = data.target

st.subheader(f'📊 {dataset_name} Dataset Overview')
st.write(f'Shape: {df.shape}')
st.write(f'Features: {len(data.feature_names)}')

if st.checkbox('Show raw data'):
    st.write(df.head())

test_size = st.slider('Test Size', 0.1, 0.5, 0.2)
n_estimators = st.slider('Number of Estimators', 10, 200, 100)

if st.button('Train Model'):
    X_train, X_test, y_train, y_test = train_test_split(
        data.data, data.target, test_size=test_size, random_state=42
    )
    model = RandomForestClassifier(n_estimators=n_estimators, random_state=42)
    model.fit(X_train, y_train)
    y_pred = model.predict(X_test)
    accuracy = accuracy_score(y_test, y_pred)
    st.write(f'Accuracy: {accuracy:.3f}')
EOF
    streamlit run /tmp/ml_streamlit_app.py --server.address 0.0.0.0 --server.port 8501
}

start_mlflow() {
    echo -e "${BLUE}📈 Starting MLflow UI...${NC}"
    echo -e "${YELLOW}Access at: http://localhost:5000${NC}"
    mkdir -p ./mlruns
    mlflow ui --host 0.0.0.0 --port 5000
}

start_repl() {
    echo -e "${BLUE}🐍 Starting ML/AI Python REPL...${NC}"
    python3 -c "
import sys
print('🤖 ML/AI Python Environment Ready!')
print('📚 Available libraries:')
libs = [('TensorFlow', 'tensorflow'), ('PyTorch', 'torch'), ('scikit-learn', 'sklearn'), ('Pandas', 'pandas'), ('NumPy', 'numpy')]
for name, module in libs:
    try:
        exec(f'import {module}')
        version = eval(f'{module}.__version__') if hasattr(eval(module), '__version__') else 'unknown'
        print(f'  ✓ {name} {version}')
    except:
        print(f'  ✗ {name} not available')
print('\\n💡 Quick start examples:')
print('  import tensorflow as tf; import torch; import pandas as pd')
import IPython; IPython.embed()
"
}

test_environment() {
    echo -e "${BLUE}🧪 Testing ML/AI Environment...${NC}"
    python3 /home/eboalking/Directories/nvimdronat/test_ml_ai.py
}

create_examples() {
    echo -e "${BLUE}📝 Creating ML example projects...${NC}"
    mkdir -p ./ml_examples
    
    cat > ./ml_examples/basic_classification.py << 'EOF'
import pandas as pd
import numpy as np
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, classification_report

# Load and train model
iris = load_iris()
X_train, X_test, y_train, y_test = train_test_split(iris.data, iris.target, test_size=0.2, random_state=42)
model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X_train, y_train)
y_pred = model.predict(X_test)

print(f"Accuracy: {accuracy_score(y_test, y_pred):.3f}")
print("\\nClassification Report:")
print(classification_report(y_test, y_pred, target_names=iris.target_names))
EOF

    echo -e "${GREEN}✅ Example projects created in ./ml_examples/${NC}"
}

# Main script logic
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
    help|--help|-h) show_help ;;
    *) echo -e "${RED}Unknown command: $1${NC}"; show_help; exit 1 ;;
esac