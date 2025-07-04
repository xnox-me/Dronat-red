#!/bin/bash

# Interactive menu for the development environment

# --- Functions ---
show_menu() {
    clear
    echo "***********************************"
    echo "*   Welcome to nvimmer_dronatxxx  *"
    echo "***********************************"
    echo "1. Start Neovim"
    echo "2. Start n8n Workflow Editor"
    echo "3. Open a Bash Shell"
    echo "4. Start a new Lean Project"
    echo "5. Exit"
    echo "***********************************"
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
    lean4 new "$project_name"
    echo "New Lean project '$project_name' created."
    echo "You can now open it in Neovim."
    sleep 2
}

# --- Main Loop ---
while true; do
    show_menu
    read -p "Enter your choice [1-5]: " choice

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
            exit 0
            ;;
        *)
            echo "Invalid option. Please try again."
            sleep 2
            ;;
    esac
done
