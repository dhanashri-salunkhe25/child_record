#!/bin/bash

echo "🚀 Starting deployment process..."

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    exit 1
fi

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Build for web
echo "🔨 Building for web..."
flutter build web --release

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo "📁 Build files are in: build/web/"
    echo ""
    echo "🌐 To deploy to Netlify:"
    echo "1. Go to https://app.netlify.com/"
    echo "2. Drag and drop the 'build/web' folder"
    echo "3. Or connect your GitHub repository for automatic deployment"
    echo ""
    echo "📋 For GitHub deployment:"
    echo "1. Push your code to GitHub"
    echo "2. Connect your repository to Netlify"
    echo "3. Set build command: flutter build web --release"
    echo "4. Set publish directory: build/web"
else
    echo "❌ Build failed!"
    exit 1
fi 