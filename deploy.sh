#!/bin/bash

# Custom deployment script for AarogyaRekha on Azure
echo "🚀 Custom deployment script starting..."

# Get deployment source and target
DEPLOYMENT_SOURCE=${DEPLOYMENT_SOURCE:-"$DEPLOYMENT_TEMP"}
DEPLOYMENT_TARGET=${DEPLOYMENT_TARGET:-"/home/site/wwwroot"}

echo "📂 Source: $DEPLOYMENT_SOURCE"
echo "📂 Target: $DEPLOYMENT_TARGET"

# Copy backend files to the web root
echo "📋 Copying backend files..."
cp -r "$DEPLOYMENT_SOURCE/aarogyarekha-backend/"* "$DEPLOYMENT_TARGET/"

# Copy startup script to web root
echo "📋 Copying startup script..."
cp "$DEPLOYMENT_SOURCE/startup.sh" "$DEPLOYMENT_TARGET/"

# Copy minimal requirements for faster startup
echo "📋 Copying minimal requirements..."
cp "$DEPLOYMENT_SOURCE/requirements-minimal.txt" "$DEPLOYMENT_TARGET/" 2>/dev/null || echo "⚠️ No minimal requirements found"

# Make startup script executable
chmod +x "$DEPLOYMENT_TARGET/startup.sh"

echo "📁 Deployment target contents:"
ls -la "$DEPLOYMENT_TARGET"

echo "✅ Custom deployment completed successfully"
