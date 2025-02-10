# -------------------------
# Placeholder for your server script name (e.g., main.py)
# Replace <SERVER_SCRIPT_NAME> with your actual server script (without .py if you're using the "module:app" form)
$SERVER_SCRIPT = "lyrix_backend.lyrix-server"

# Placeholder for your test script name (e.g., test_endpoints.py)
# Replace <TEST_SCRIPT_NAME>.py with the name of your test file
$TEST_SCRIPT = "lyrix_backend/test.py"
# -------------------------

Write-Host "Starting FastAPI server..."

# Start the server in a separate process. 
# -PassThru returns the Process object so we can capture the PID (process ID).
# Adjust the uvicorn command as needed (e.g., using "python -m uvicorn" if that’s how you run it). 
$process = Start-Process `
    -FilePath "py" `
    -ArgumentList @("-m", "uvicorn", "$($SERVER_SCRIPT):app", "--reload") `
    -NoNewWindow `
    -PassThru


# Wait a bit to ensure the server is up
Start-Sleep -Seconds 3

Write-Host "Running test script..."
py $TEST_SCRIPT

Write-Host "Stopping server..."
Stop-Process -Id $process.Id


Start-Sleep -Seconds 30
Write-Host "Done."
