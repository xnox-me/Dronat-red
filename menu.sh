#!/bin/bash

# Interactive menu for the Dronat development environment
# Enhanced version with improved UX and additional features

# Color codes for enhanced UX
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# System information
get_system_info() {
    echo -e "${CYAN}📊 System Information:${NC}"
    echo -e "  🐧 OS: $(lsb_release -d | cut -f2)"
    echo -e "  🖥️  CPU: $(nproc) cores"
    echo -e "  💾 Memory: $(free -h | awk '/^Mem:/ {print $2}') total"
    echo -e "  🐍 Python: $(python3 --version 2>/dev/null || echo 'Not available')"
    echo -e "  📦 Node.js: $(node --version 2>/dev/null || echo 'Not available')"
    echo -e "  📝 Neovim: $(nvim --version | head -1 | cut -d' ' -f2 2>/dev/null || echo 'Not available')"
    echo ""
}

# Check service status
check_services() {
    echo -e "${PURPLE}🔍 Service Status:${NC}"
    
    # Check for running services
    services=("n8n:5678" "jupyter:8888" "tensorboard:6006" "gradio:7860" "streamlit:8501" "mlflow:5000")
    for service in "${services[@]}"; do
        name=$(echo $service | cut -d':' -f1)
        port=$(echo $service | cut -d':' -f2)
        if netstat -tuln 2>/dev/null | grep -q ":$port "; then
            echo -e "  ✅ $name running on port $port"
        else
            echo -e "  ⭕ $name not running"
        fi
    done
    
    # Check Shellngn Pro Docker container
    if docker ps 2>/dev/null | grep -q "shellngn"; then
        echo -e "  ✅ Shellngn Pro container running"
    else
        echo -e "  ⭕ Shellngn Pro container not running"
    fi
    echo ""
}

# --- Functions ---
show_menu() {
    clear
    echo -e "${BOLD}${BLUE}════════════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}${CYAN}    🚀 Welcome to Dronat Development Environment    ${NC}"
    echo -e "${BOLD}${BLUE}════════════════════════════════════════════════════════════${NC}"
    echo ""
    
    get_system_info
    check_services
    
    echo -e "${BOLD}${GREEN}📋 Available Options:${NC}"
    echo -e "  ${YELLOW}1.${NC} 📝 Start Neovim (Enhanced IDE)"
    echo -e "  ${YELLOW}2.${NC} 🔄 Start n8n Workflow Editor"
    echo -e "  ${YELLOW}3.${NC} 💻 Open a Bash Shell"
    echo -e "  ${YELLOW}4.${NC} 🎯 Start a new Lean Project"
    echo -e "  ${YELLOW}5.${NC} 📈 Start OpenBB Terminal"
    echo -e "  ${YELLOW}6.${NC} 🤖 Start ShellGPT Interactive Mode"
    echo -e "  ${YELLOW}7.${NC} 🌐 Start Shellngn Pro (SSH/SFTP/VNC/RDP)"
    echo -e "  ${YELLOW}8.${NC} 🧠 ML/AI Development Environment"
    echo -e "  ${YELLOW}9.${NC} 🔧 System Tools & Utilities"
    echo -e "  ${YELLOW}10.${NC} 📚 Help & Documentation"
    echo -e "  ${YELLOW}11.${NC} 🚪 Exit"
    echo -e "${BOLD}${BLUE}════════════════════════════════════════════════════════════${NC}"
    echo ""
}

start_neovim() {
    clear
    echo "Starting Neovim..."
    nvim
}

start_n8n() {
    clear
    echo "Starting n8n..."
    echo "You can access the n8n editor at http://localhost:5678"
    echo "Press Ctrl+C to stop n8n."
    n8n
}

open_shell() {
    clear
    echo "Starting Bash shell..."
    bash
}

start_lean_project() {
    clear
    echo "Starting a new Lean project..."
    echo "Please enter a name for your new Lean project:"
    read -r project_name
    if [ -z "$project_name" ]; then
        echo "Project name cannot be empty."
        sleep 2
        return
    fi
    lake new "$project_name"
    echo "New Lean project '$project_name' created."
    echo "You can now open it in Neovim."
    sleep 2
}

start_openbb() {
    clear
    echo "Starting OpenBB Terminal..."
    echo "Loading financial data platform..."
    echo "Type 'exit' or use Ctrl+C to return to the main menu."
    python3 -c "import openbb; openbb.obb.account.login_guest(); from openbb import obb; print('OpenBB Terminal Ready!'); import IPython; IPython.embed()"
}

start_shellgpt() {
    clear
    echo "Starting ShellGPT Interactive Mode..."
    echo "AI-powered command line assistant ready!"
    echo "Examples:"
    echo "  sgpt 'list all files in current directory'"
    echo "  sgpt --code 'create a python script to read CSV'"
    echo "  sgpt --shell 'find all .py files modified today'"
    echo "Type 'exit' or use Ctrl+C to return to the main menu."
    echo ""
    echo "Starting interactive shell with sgpt available..."
    bash
}

start_shellngn() {
    clear
    echo "Starting Shellngn Pro (SSH/SFTP/VNC/RDP Web Client)..."
    echo "======================================================"
    echo ""
    
    # Check if Docker is available
    if ! command -v docker &> /dev/null; then
        echo "❌ Docker is not available. Shellngn Pro requires Docker to run."
        echo "   Please ensure Docker is installed and running."
        sleep 3
        return
    fi
    
    # Check if Shellngn container is already running
    if docker ps | grep -q "shellngn"; then
        echo "ℹ️  Shellngn Pro is already running!"
        echo "   Access it at: http://localhost:8080"
    else
        echo "🚀 Starting Shellngn Pro container..."
        # Pull the latest image if not available
        docker pull shellngn/pro
        
        # Start Shellngn Pro container
        docker run -d --name shellngn -p 8080:8080 -v "$(pwd)/shellngn-data:/data" shellngn/pro
        
        if [ $? -eq 0 ]; then
            echo "✅ Shellngn Pro started successfully!"
            echo ""
            echo "🌐 Access Shellngn Pro at: http://localhost:8080"
            echo "📁 Data persistence: $(pwd)/shellngn-data"
            echo ""
            echo "Features available:"
            echo "  • SSH/Telnet Terminal Access"
            echo "  • SFTP File Transfer & Browser"
            echo "  • VNC/RDP Remote Desktop"
            echo "  • Multi-session Management"
            echo "  • Device & Identity Management"
        else
            echo "❌ Failed to start Shellngn Pro container."
        fi
    fi
    
    echo ""
    echo "Management commands:"
    echo "  • Stop:  docker stop shellngn && docker rm shellngn"
    echo "  • Logs:  docker logs shellngn"
    echo "  • Status: docker ps | grep shellngn"
    echo ""
    echo "Press Enter to return to main menu..."
    read -r
}

start_ml_ai_env() {
    clear
    echo "🤖 ML/AI Development Environment"
    echo "================================="
    echo ""
    echo "Choose your ML/AI tool:"
    echo "1. JupyterLab (Full-featured notebook environment)"
    echo "2. Jupyter Notebook (Classic notebook interface)"
    echo "3. Python ML/AI REPL (Interactive Python with ML libraries)"
    echo "4. TensorBoard (Experiment visualization)"
    echo "5. Gradio Demo Server (Create ML demos)"
    echo "6. Streamlit App Server (Build ML web apps)"
    echo "7. MLflow UI (Experiment tracking)"
    echo "8. Return to main menu"
    echo ""
    read -p "Enter your choice [1-8]: " ml_choice
    
    case $ml_choice in
        1)
            echo "🚀 Starting JupyterLab..."
            echo "Access at: http://localhost:8888"
            echo "Token will be displayed below:"
            jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root
            ;;
        2)
            echo "🚀 Starting Jupyter Notebook..."
            echo "Access at: http://localhost:8888"
            echo "Token will be displayed below:"
            jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root
            ;;
        3)
            echo "🐍 Starting Python ML/AI REPL..."
            echo "Available libraries: TensorFlow, PyTorch, scikit-learn, pandas, numpy, etc."
            echo "Type 'exit()' to return to menu."
            echo ""
            python3 -c "
import sys
print('🤖 ML/AI Python Environment Ready!')
print('📚 Available libraries:')
try:
    import tensorflow as tf
    print(f'  ✓ TensorFlow {tf.__version__}')
except: print('  ✗ TensorFlow not available')
try:
    import torch
    print(f'  ✓ PyTorch {torch.__version__}')
except: print('  ✗ PyTorch not available')
try:
    import sklearn
    print(f'  ✓ scikit-learn {sklearn.__version__}')
except: print('  ✗ scikit-learn not available')
try:
    import pandas as pd
    print(f'  ✓ pandas {pd.__version__}')
except: print('  ✗ pandas not available')
try:
    import numpy as np
    print(f'  ✓ numpy {np.__version__}')
except: print('  ✗ numpy not available')
print('\n💡 Quick start examples:')
print('  import tensorflow as tf')
print('  import torch')
print('  import pandas as pd')
print('  import numpy as np')
print('  from sklearn.datasets import load_iris')
print('')
import IPython
IPython.embed()
"
            ;;
        4)
            echo "📊 Starting TensorBoard..."
            echo "Access at: http://localhost:6006"
            echo "Monitoring logs in: ./logs"
            mkdir -p ./logs
            tensorboard --logdir=./logs --host=0.0.0.0 --port=6006
            ;;
        5)
            echo "🎨 Starting Gradio Demo Server..."
            echo "Creating a sample ML demo..."
            python3 -c "
import gradio as gr
import numpy as np
from sklearn.datasets import load_iris
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split

# Load and train a simple model
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
    title='🌸 Iris Species Classifier',
    description='Enter flower measurements to predict the iris species'
)

print('🎨 Gradio demo ready at: http://localhost:7860')
interface.launch(server_name='0.0.0.0', server_port=7860)
"
            ;;
        6)
            echo "🌐 Starting Streamlit App Server..."
            echo "Creating a sample ML app..."
            cat > /tmp/ml_streamlit_app.py << 'EOF'
import streamlit as st
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.datasets import load_iris, load_wine
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, classification_report

st.set_page_config(page_title='🤖 ML Dashboard', page_icon='🤖')

st.title('🤖 Machine Learning Dashboard')
st.sidebar.title('📊 Dataset Selection')

# Dataset selection
dataset_name = st.sidebar.selectbox('Choose Dataset', ['Iris', 'Wine'])

if dataset_name == 'Iris':
    data = load_iris()
else:
    data = load_wine()

df = pd.DataFrame(data.data, columns=data.feature_names)
df['target'] = data.target

st.subheader(f'📈 {dataset_name} Dataset Overview')
st.write(f'**Shape:** {df.shape}')
st.write(f'**Features:** {len(data.feature_names)}')
st.write(f'**Classes:** {len(data.target_names)}')

# Display data
if st.checkbox('Show raw data'):
    st.write(df.head())

# Visualizations
st.subheader('📊 Data Visualization')
col1, col2 = st.columns(2)

with col1:
    fig, ax = plt.subplots()
    sns.histplot(data=df, x=df.columns[0], hue='target', ax=ax)
    st.pyplot(fig)

with col2:
    fig, ax = plt.subplots()
    sns.scatterplot(data=df, x=df.columns[0], y=df.columns[1], hue='target', ax=ax)
    st.pyplot(fig)

# Model training
st.subheader('🤖 Model Training')
test_size = st.slider('Test Size', 0.1, 0.5, 0.2)
n_estimators = st.slider('Number of Estimators', 10, 200, 100)

X_train, X_test, y_train, y_test = train_test_split(
    data.data, data.target, test_size=test_size, random_state=42
)

model = RandomForestClassifier(n_estimators=n_estimators, random_state=42)
model.fit(X_train, y_train)
y_pred = model.predict(X_test)

accuracy = accuracy_score(y_test, y_pred)
st.write(f'**Accuracy:** {accuracy:.3f}')

if st.checkbox('Show classification report'):
    report = classification_report(y_test, y_pred, target_names=data.target_names)
    st.text(report)
EOF
            streamlit run /tmp/ml_streamlit_app.py --server.address 0.0.0.0 --server.port 8501
            ;;
        7)
            echo "📈 Starting MLflow UI..."
            echo "Access at: http://localhost:5000"
            echo "Tracking experiments in: ./mlruns"
            mkdir -p ./mlruns
            mlflow ui --host 0.0.0.0 --port 5000
            ;;
        8)
            return
            ;;
        *)
            echo "Invalid option. Please try again."
            sleep 2
            start_ml_ai_env
            ;;
    esac
    
    echo ""
    echo "Press Enter to return to ML/AI menu..."
    read -r
    start_ml_ai_env
}

# System tools and utilities
start_system_tools() {
    clear
    echo -e "${BOLD}${PURPLE}🔧 System Tools & Utilities${NC}"
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    echo ""
    echo -e "${GREEN}Available Tools:${NC}"
    echo -e "  ${YELLOW}1.${NC} 📊 System Monitor (htop)"
    echo -e "  ${YELLOW}2.${NC} 📁 File Manager (ranger)"
    echo -e "  ${YELLOW}3.${NC} 🌐 Network Tools"
    echo -e "  ${YELLOW}4.${NC} 📋 Git Operations"
    echo -e "  ${YELLOW}5.${NC} 🐳 Docker Management"
    echo -e "  ${YELLOW}6.${NC} 📦 Package Management"
    echo -e "  ${YELLOW}7.${NC} 📋 Environment Information"
    echo -e "  ${YELLOW}8.${NC} 🔙 Return to main menu"
    echo ""
    read -p "Enter your choice [1-8]: " tools_choice
    
    case $tools_choice in
        1)
            echo "Starting htop..."
            htop || (echo "htop not available, installing..." && apt-get update && apt-get install -y htop && htop)
            ;;
        2)
            echo "Starting file manager..."
            ranger || (echo "ranger not available, using basic file browser..." && ls -la && bash)
            ;;
        3)
            echo -e "${CYAN}🌐 Network Information:${NC}"
            echo "IP Addresses:"
            ip addr show | grep "inet " | awk '{print "  " $2}'
            echo ""
            echo "Active connections:"
            netstat -tuln 2>/dev/null | head -10 || ss -tuln | head -10
            echo ""
            read -p "Press Enter to continue..."
            ;;
        4)
            echo -e "${CYAN}📋 Git Status:${NC}"
            if git status 2>/dev/null; then
                echo ""
                echo "Recent commits:"
                git log --oneline -5 2>/dev/null || echo "No git repository found"
            else
                echo "Not in a git repository"
            fi
            echo ""
            read -p "Press Enter to continue..."
            ;;
        5)
            echo -e "${CYAN}🐳 Docker Status:${NC}"
            if command -v docker &> /dev/null; then
                echo "Running containers:"
                docker ps
                echo ""
                echo "Available images:"
                docker images | head -10
            else
                echo "Docker not available"
            fi
            echo ""
            read -p "Press Enter to continue..."
            ;;
        6)
            echo -e "${CYAN}📦 Package Information:${NC}"
            echo "Python packages (showing first 20):"
            pip list | head -20
            echo ""
            echo "Node.js packages:"
            npm list -g --depth=0 2>/dev/null | head -10 || echo "No global npm packages found"
            echo ""
            read -p "Press Enter to continue..."
            ;;
        7)
            echo -e "${CYAN}📋 Environment Information:${NC}"
            echo "PATH directories:"
            echo $PATH | tr ':' '\n' | head -10
            echo ""
            echo "Environment variables (showing key ones):"
            env | grep -E "(HOME|USER|SHELL|TERM|LANG)" | sort
            echo ""
            read -p "Press Enter to continue..."
            ;;
        8)
            return
            ;;
        *)
            echo "Invalid option. Please try again."
            sleep 2
            ;;
    esac
    
    if [ "$tools_choice" != "8" ]; then
        start_system_tools
    fi
}

# Help and documentation
show_help() {
    clear
    echo -e "${BOLD}${CYAN}📚 Help & Documentation${NC}"
    echo -e "${BLUE}══════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${GREEN}🚀 Dronat Development Environment${NC}"
    echo ""
    echo -e "${YELLOW}Quick Start Guide:${NC}"
    echo -e "  • Option 1: Launch Neovim with enhanced IDE features"
    echo -e "  • Option 8: Access comprehensive ML/AI development tools"
    echo -e "  • Option 9: System utilities and monitoring tools"
    echo ""
    echo -e "${YELLOW}Key Features:${NC}"
    echo -e "  📝 ${BOLD}Enhanced Neovim IDE:${NC}"
    echo -e "      • LSP support for Python, JavaScript, Lua, and more"
    echo -e "      • AI-powered coding with GitHub Copilot integration"
    echo -e "      • Advanced debugging with DAP"
    echo -e "      • Git integration and project management"
    echo ""
    echo -e "  🧠 ${BOLD}ML/AI Development:${NC}"
    echo -e "      • TensorFlow, PyTorch, scikit-learn"
    echo -e "      • JupyterLab, Gradio, Streamlit"
    echo -e "      • MLflow experiment tracking"
    echo -e "      • Complete data science stack"
    echo ""
    echo -e "  🔄 ${BOLD}Workflow Automation:${NC}"
    echo -e "      • n8n for visual workflow creation"
    echo -e "      • OpenBB for financial analysis"
    echo -e "      • ShellGPT for AI-assisted commands"
    echo ""
    echo -e "  🌐 ${BOLD}Remote Access:${NC}"
    echo -e "      • Shellngn Pro for SSH/SFTP/VNC/RDP"
    echo -e "      • Web-based interfaces for all tools"
    echo ""
    echo -e "${YELLOW}Port Mappings:${NC}"
    echo -e "  • 5678: n8n workflow editor"
    echo -e "  • 8080: Shellngn Pro web client"
    echo -e "  • 8888: JupyterLab/Jupyter Notebook"
    echo -e "  • 6006: TensorBoard"
    echo -e "  • 7860: Gradio ML demos"
    echo -e "  • 8501: Streamlit ML apps"
    echo -e "  • 5000: MLflow tracking UI"
    echo ""
    echo -e "${YELLOW}Tips:${NC}"
    echo -e "  • Use Ctrl+C to exit most tools and return to menu"
    echo -e "  • Check service status in main menu to see what's running"
    echo -e "  • Access web interfaces from your host machine browser"
    echo -e "  • Use system tools (Option 9) for monitoring and management"
    echo ""
    echo -e "${YELLOW}Keyboard Shortcuts in Neovim:${NC}"
    echo -e "  • <leader>e: Toggle file explorer"
    echo -e "  • <leader>ff: Find files"
    echo -e "  • <leader>fg: Live grep search"
    echo -e "  • <leader>ca: Code actions"
    echo -e "  • <C-\\>: Toggle terminal"
    echo ""
    read -p "Press Enter to return to main menu..."
}

# --- Main Loop ---
while true; do
    show_menu
    read -p "Enter your choice [1-11]: " choice

    case $choice in
        1)
            start_neovim
            ;;
        2)
            start_n8n
            ;;
        3)
            open_shell
            ;;
        4)
            start_lean_project
            ;;
        5)
            start_openbb
            ;;
        6)
            start_shellgpt
            ;;
        7)
            start_shellngn
            ;;
        8)
            start_ml_ai_env
            ;;
        9)
            start_system_tools
            ;;
        10)
            show_help
            ;;
        11)
            echo -e "${GREEN}👋 Thank you for using Dronat!${NC}"
            echo -e "${CYAN}Happy coding! 🚀${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid option. Please try again.${NC}"
            sleep 2
            ;;
    esac
done
