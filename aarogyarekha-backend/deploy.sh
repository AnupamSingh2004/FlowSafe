#!/bin/bash

# Azure deployment script for Django backend
echo "🔧 Azure Deployment Script"

# Copy files to wwwroot if needed
if [ "$DEPLOYMENT_SOURCE" ]; then
    echo "📁 Copying from $DEPLOYMENT_SOURCE to $DEPLOYMENT_TARGET"
    cp -r "$DEPLOYMENT_SOURCE/." "$DEPLOYMENT_TARGET/"
fi

# Set up Python environment
if [ -f "$DEPLOYMENT_TARGET/requirements.txt" ]; then
    echo "📦 Installing Python dependencies..."
    cd "$DEPLOYMENT_TARGET"
    pip install -r requirements.txt
fi

echo "✅ Deployment script completed"
