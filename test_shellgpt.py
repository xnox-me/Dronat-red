#!/usr/bin/env python3
"""
Test script to verify ShellGPT installation and basic functionality
"""

import subprocess
import sys

def test_shellgpt_import():
    """Test if ShellGPT can be imported successfully"""
    try:
        import sgpt
        print("✓ ShellGPT successfully imported")
        return True
    except ImportError as e:
        print(f"✗ Failed to import ShellGPT: {e}")
        return False

def test_shellgpt_command():
    """Test if sgpt command is available"""
    try:
        result = subprocess.run(['sgpt', '--version'], 
                              capture_output=True, text=True, timeout=10)
        if result.returncode == 0:
            print(f"✓ ShellGPT command available: {result.stdout.strip()}")
            return True
        else:
            print(f"✗ ShellGPT command failed: {result.stderr}")
            return False
    except subprocess.TimeoutExpired:
        print("✗ ShellGPT command timed out")
        return False
    except FileNotFoundError:
        print("✗ sgpt command not found in PATH")
        return False
    except Exception as e:
        print(f"✗ Error running sgpt command: {e}")
        return False

def test_shellgpt_help():
    """Test if ShellGPT help works"""
    try:
        result = subprocess.run(['sgpt', '--help'], 
                              capture_output=True, text=True, timeout=10)
        if result.returncode == 0 and 'usage:' in result.stdout.lower():
            print("✓ ShellGPT help command works")
            return True
        else:
            print("✗ ShellGPT help command failed")
            return False
    except Exception as e:
        print(f"✗ Error running sgpt help: {e}")
        return False

def show_usage_examples():
    """Show usage examples for ShellGPT"""
    print("\n" + "=" * 50)
    print("ShellGPT Usage Examples:")
    print("=" * 50)
    print("# General queries:")
    print("sgpt 'explain what is docker'")
    print("")
    print("# Code generation:")
    print("sgpt --code 'create a python function to read CSV files'")
    print("")
    print("# Shell commands:")
    print("sgpt --shell 'find all Python files modified in last 24 hours'")
    print("")
    print("# Execute shell commands directly:")
    print("sgpt --shell 'list directory contents' --execute")
    print("")
    print("# Interactive mode:")
    print("sgpt --repl")
    print("")
    print("Note: For full functionality, you may need to configure an API key.")
    print("Run 'sgpt --install-integration' for setup instructions.")

def main():
    """Run all ShellGPT tests"""
    print("Testing ShellGPT installation and functionality...")
    print("=" * 50)
    
    tests = [
        test_shellgpt_import,
        test_shellgpt_command,
        test_shellgpt_help
    ]
    
    passed = 0
    total = len(tests)
    
    for test in tests:
        if test():
            passed += 1
    
    print("=" * 50)
    print(f"Test Results: {passed}/{total} tests passed")
    
    if passed == total:
        print("✓ All ShellGPT tests passed! Ready to use AI assistance in terminal.")
        show_usage_examples()
    else:
        print("✗ Some tests failed. Please check ShellGPT installation.")
        if passed > 0:
            show_usage_examples()

if __name__ == "__main__":
    main()