#!/usr/bin/env bash

# -------------------------
# Placeholder for your server script name (e.g., main.py)
# Replace <SERVER_SCRIPT_NAME> with your actual server script (without .py if you're using the "module:app" form)
SERVER_SCRIPT="lyrix_backend.lyrix-server"

# Placeholder for your test script name (e.g., test_endpoints.py)
# Replace <TEST_SCRIPT_NAME>.py with the name of your test file
TEST_SCRIPT="test.py"
# -------------------------

# Start the server in the background using uvicorn
echo "Starting FastAPI server..."
py - m uvicorn "$SERVER_SCRIPT":app --reload
SERVER_PID=$!

# Wait a bit to ensure the server is up and running
sleep 3

# Run your test script
echo "Running test script..."
python "$TEST_SCRIPT"

# After tests finish, stop the server
echo "Stopping server..."
kill $SERVER_PID

echo "Done."
