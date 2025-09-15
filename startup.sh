#!/bin/bash

# AarogyaRekha Django App Startup Script for Azure App Service
echo "🚀 Starting AarogyaRekha Django Application..."

# Log current state
echo "📍 Current directory: $(pwd)"
echo "📁 Directory contents:"
ls -la

# Azure should copy backend files to /home/site/wwwroot
cd /home/site/wwwroot

echo "📍 Changed to: $(pwd)"
echo "📁 Contents:"
ls -la

# Check if this is the Django directory (has manage.py)
if [ -f "manage.py" ]; then
    echo "✅ Found Django project in current directory"
else
    echo "❌ manage.py not found - deployment issue"
    echo "🔍 Searching for manage.py..."
    find /home -name "manage.py" 2>/dev/null || echo "No manage.py found"
    exit 1
fi

# Install Python dependencies
echo "📦 Installing essential Python dependencies..."
if [ -f "requirements-minimal.txt" ]; then
    pip install -r requirements-minimal.txt
    echo "✅ Essential dependencies installed"
elif [ -f "requirements.txt" ]; then
    echo "⚠️ Using full requirements.txt (may take longer)"
    pip install -r requirements.txt
    echo "✅ Dependencies installed"
else
    echo "❌ No requirements file found"
    exit 1
fi

# Set Django settings
export DJANGO_SETTINGS_MODULE=aarogyarekha_backend.settings

# Install gunicorn if not available
pip install gunicorn || echo "Gunicorn already installed"

# Collect static files
echo "� Collecting static files..."
python manage.py collectstatic --noinput || echo "⚠️ Static collection failed"

# Run migrations
echo "🗄️ Running migrations..."
python manage.py migrate --noinput || echo "⚠️ Migration failed"

# Start the application
echo "🌐 Starting Django with Gunicorn..."

# Install full requirements in background for ML features
if [ -f "requirements.txt" ] && [ -f "requirements-minimal.txt" ]; then
    echo "🔄 Installing full requirements in background for ML features..."
    nohup pip install -r requirements.txt > /tmp/pip-install.log 2>&1 &
fi

exec gunicorn aarogyarekha_backend.wsgi:application \
    --bind 0.0.0.0:8000 \
    --workers 2 \
    --timeout 600 \
    --access-logfile - \
    --error-logfile -
