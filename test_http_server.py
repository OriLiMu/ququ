#!/usr/bin/env python3
"""
Simple HTTP client to test ququ HTTP server
Can be used when the ququ app is running
"""

import requests
import json
import time
import sys

def test_health():
    """Test health endpoint"""
    try:
        response = requests.get("http://127.0.0.1:38765/api/health", timeout=5)
        print(f"✅ Health check: {response.status_code}")
        if response.status_code == 200:
            data = response.json()
            print(f"   Status: {data['data']['status']}")
            print(f"   Uptime: {data['data']['uptime']} seconds")
            return True
        else:
            print(f"   Response: {response.text}")
            return False
    except Exception as e:
        print(f"❌ Health check failed: {e}")
        return False

def test_status():
    """Test status endpoint"""
    try:
        response = requests.get("http://127.0.0.1:38765/api/status", timeout=5)
        print(f"✅ Status check: {response.status_code}")
        if response.status_code == 200:
            data = response.json()
            print(f"   Server: {data['data']['server']}")
            print(f"   Port: {data['data']['port']}")
            print(f"   Is recording: {data['data']['isRecording']}")
            return True
        else:
            print(f"   Response: {response.text}")
            return False
    except Exception as e:
        print(f"❌ Status check failed: {e}")
        return False

def test_start_recording():
    """Test start recording endpoint"""
    try:
        response = requests.post("http://127.0.0.1:38765/api/recording/start",
                               json={}, timeout=5)
        print(f"✅ Start recording: {response.status_code}")
        if response.status_code == 200:
            data = response.json()
            print(f"   Message: {data['data']['message']}")
            print(f"   Recording ID: {data['data']['recordingId']}")
            return True
        else:
            print(f"   Response: {response.text}")
            return False
    except Exception as e:
        print(f"❌ Start recording failed: {e}")
        return False

def test_stop_recording():
    """Test stop recording endpoint"""
    try:
        response = requests.post("http://127.0.0.1:38765/api/recording/stop",
                               json={}, timeout=5)
        print(f"✅ Stop recording: {response.status_code}")
        if response.status_code == 200:
            data = response.json()
            print(f"   Message: {data['data']['message']}")
            print(f"   Text: {data['data']['text']}")
            print(f"   Duration: {data['data']['duration']} ms")
            return True
        else:
            print(f"   Response: {response.text}")
            return False
    except Exception as e:
        print(f"❌ Stop recording failed: {e}")
        return False

def test_full_workflow():
    """Test complete workflow"""
    print("\n🔄 Testing complete workflow...")

    # Check current status
    if not test_status():
        return False

    # Start recording
    if not test_start_recording():
        return False

    print("\n🎤 Please speak something (waiting 3 seconds)...")
    time.sleep(3)

    # Stop recording
    if not test_stop_recording():
        return False

    print("\n✅ Complete workflow test passed!")
    return True

def main():
    """Main test function"""
    print("🚀 Testing ququ HTTP API")
    print("=" * 40)

    # Check if requests library is available
    try:
        import requests
    except ImportError:
        print("❌ requests library not found. Install with: pip install requests")
        return

    # Run basic tests
    tests = [
        ("Health check", test_health),
        ("Status check", test_status),
    ]

    passed = 0
    total = len(tests)

    for name, test_func in tests:
        print(f"\n📋 Running: {name}")
        if test_func():
            passed += 1

    print(f"\n📊 Results: {passed}/{total} passed")

    if passed == total:
        print("🎉 Basic tests passed! Ready for recording tests.")
        print("\n💡 Next steps:")
        print("   - Run: python test_http_server.py start")
        print("   - Speak something")
        print("   - Run: python test_http_server.py stop")
    else:
        print("⚠️  Some tests failed. Make sure ququ app is running.")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        command = sys.argv[1]
        if command == "start":
            test_start_recording()
        elif command == "stop":
            test_stop_recording()
        elif command == "status":
            test_status()
        elif command == "health":
            test_health()
        elif command == "full":
            test_full_workflow()
        else:
            print("Usage: python test_http_server.py [start|stop|status|health|full]")
    else:
        main()