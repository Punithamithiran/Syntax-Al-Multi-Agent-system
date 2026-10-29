#!/bin/bash

# Navigate to project directory
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PROJECT_DIR"

echo "========================================="
echo "       🚀 Starting Syntax AI Suite       "
echo "========================================="

# 1. Start Python AI Server (Port 8000)
source venv/bin/activate
python server.py &
PYTHON_PID=$!
echo "🟢 Python AI Server running on http://localhost:8000 (PID: $PYTHON_PID)"

# 2. Start Node.js API Gateway (Port 5003)
cd "$PROJECT_DIR/frontend"
node src/server.js &
NODE_PID=$!
echo "🟢 Node.js API Gateway running on http://localhost:5003 (PID: $NODE_PID)"

# Gracefully stop servers when terminal is closed or Ctrl+C is pressed
cleanup() {
  echo ""
  echo "🛑 Shutting down Syntax AI services..."
  kill $PYTHON_PID $NODE_PID 2>/dev/null
  exit 0
}
trap cleanup SIGINT SIGTERM EXIT

# 3. Start React Frontend (Port 3000)
echo "🟢 Starting React Frontend on http://localhost:3000..."
npm start
