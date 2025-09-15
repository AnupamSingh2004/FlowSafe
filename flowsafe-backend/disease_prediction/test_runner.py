#!/usr/bin/env python3
"""
Test runner for Disease Prediction API
Allows running specific test suites or individual tests
"""

import sys
import argparse
from test_api import *

def run_basic_tests():
    """Run basic functionality tests"""
    print("Running Basic Tests...")
    test_api()

def run_disease_tests():
    """Run disease-specific scenario tests"""
    print("Running Disease-Specific Tests...")
    test_disease_specific_scenarios()

def run_edge_tests():
    """Run edge case tests"""
    print("Running Edge Case Tests...")
    test_edge_cases()

def run_info_tests():
    """Run info endpoint tests"""
    print("Running Info Endpoint Tests...")
    test_info_endpoint()

def run_batch_tests():
    """Run batch processing tests"""
    print("Running Batch Processing Tests...")
    test_batch_edge_cases()

def run_invalid_tests():
    """Run invalid endpoint tests"""
    print("Running Invalid Endpoint Tests...")
    test_invalid_endpoints()

def run_all_tests():
    """Run all available tests"""
    print("Running All Tests...")
    run_basic_tests()
    run_disease_tests()
    run_edge_tests()
    run_info_tests()
    run_batch_tests()
    run_invalid_tests()
    print("\n" + "=" * 50)
    print("ALL TESTS COMPLETED")
    print("=" * 50)

def main():
    parser = argparse.ArgumentParser(description='Test runner for Disease Prediction API')
    parser.add_argument('--test', '-t', 
                       choices=['basic', 'disease', 'edge', 'info', 'batch', 'invalid', 'all'],
                       default='all',
                       help='Which test suite to run (default: all)')
    
    args = parser.parse_args()
    
    test_functions = {
        'basic': run_basic_tests,
        'disease': run_disease_tests,
        'edge': run_edge_tests,
        'info': run_info_tests,
        'batch': run_batch_tests,
        'invalid': run_invalid_tests,
        'all': run_all_tests
    }
    
    # Check if API is running
    print("Checking API availability...")
    try:
        response = requests.get(f"{BASE_URL}/health")
        if response.status_code == 200:
            print("✓ API is running and healthy")
        else:
            print("✗ API is not responding correctly")
            sys.exit(1)
    except Exception as e:
        print(f"✗ Cannot connect to API: {e}")
        print("Please make sure the API server is running on http://localhost:5001")
        sys.exit(1)
    
    # Run selected test suite
    test_functions[args.test]()

if __name__ == "__main__":
    main()
