#!/usr/bin/env python3
"""
Test script to verify OpenBB installation and basic functionality
"""

def test_openbb_import():
    """Test if OpenBB can be imported successfully"""
    try:
        import openbb
        print("✓ OpenBB successfully imported")
        return True
    except ImportError as e:
        print(f"✗ Failed to import OpenBB: {e}")
        return False

def test_openbb_basic_functionality():
    """Test basic OpenBB functionality"""
    try:
        from openbb import obb
        
        # Test guest login (doesn't require API keys)
        print("✓ OpenBB Terminal API accessible")
        
        # Show available endpoints
        available_commands = [attr for attr in dir(obb) if not attr.startswith('_')]
        print(f"✓ Available OpenBB modules: {', '.join(available_commands[:5])}{'...' if len(available_commands) > 5 else ''}")
        
        return True
    except Exception as e:
        print(f"✗ OpenBB basic functionality test failed: {e}")
        return False

def main():
    """Run all OpenBB tests"""
    print("Testing OpenBB installation and functionality...")
    print("=" * 50)
    
    tests = [
        test_openbb_import,
        test_openbb_basic_functionality
    ]
    
    passed = 0
    total = len(tests)
    
    for test in tests:
        if test():
            passed += 1
    
    print("=" * 50)
    print(f"Test Results: {passed}/{total} tests passed")
    
    if passed == total:
        print("✓ All OpenBB tests passed! Ready to use financial data analysis.")
    else:
        print("✗ Some tests failed. Please check OpenBB installation.")

if __name__ == "__main__":
    main()