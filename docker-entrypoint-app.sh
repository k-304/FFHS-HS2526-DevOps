#!/bin/sh
set -e

# 1. Initialize the database schema
echo "Running database initialization..."
# Execute your initialization script (scripts/init_db.py)
python scripts/init_db.py

# 2. Execute the web server
echo "Starting Gunicorn server..."
exec gunicorn -b 0.0.0.0:5000 app:app