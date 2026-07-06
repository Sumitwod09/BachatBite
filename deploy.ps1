# BachatBite Deployment Preparation & Branch Automation Script
# Runs Flutter Web and APK builds, copies landing page assets, and pushes the build to the 'production' branch.

$ErrorActionPreference = "Stop"

# 1. Store the current branch
$currentBranch = (git branch --show-current).Trim()
Write-Host "Current branch: $currentBranch" -ForegroundColor Cyan

# 2. Build Flutter Web
Write-Host "Building Flutter Web..." -ForegroundColor Yellow
Set-Location -Path "c:\Users\Ruby\Desktop\test\bachat_bite"
flutter build web --release

# 3. Build Flutter APK
Write-Host "Building Flutter APK..." -ForegroundColor Yellow
flutter build apk --release

# 4. Prepare temporary dist directory
Write-Host "Assembling distribution directory..." -ForegroundColor Yellow
$distPath = Join-Path (Get-Location) "dist"
if (Test-Path $distPath) {
    Remove-Item -Path $distPath -Recurse -Force
}
New-Item -ItemType Directory -Path $distPath -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $distPath "app") -Force | Out-Null

# Copy landing page files
Copy-Item -Path "web_landing\*" -Destination $distPath -Recurse -Force

# Copy Flutter web build to /app
Copy-Item -Path "build\web\*" -Destination (Join-Path $distPath "app") -Recurse -Force

# Copy APK to root of landing page
$apkSrc = "build\app\outputs\flutter-apk\app-release.apk"
Copy-Item -Path $apkSrc -Destination (Join-Path $distPath "BachatBite.apk") -Force

# Copy APK to workspace root for local convenience
Copy-Item -Path $apkSrc -Destination "c:\Users\Ruby\Desktop\test\BachatBite.apk" -Force

# Copy vercel.json to dist
Copy-Item -Path "vercel.json" -Destination $distPath -Force

# Copy .gitignore to dist to prevent staging build artifacts on production branch
Copy-Item -Path ".gitignore" -Destination $distPath -Force

Write-Host "Distribution folder assembled successfully at $distPath" -ForegroundColor Green
Write-Host "Also copied release APK to c:\Users\Ruby\Desktop\test\BachatBite.apk" -ForegroundColor Green

# 5. Git Branch Deployment
Write-Host "Starting Git deployment to production branch..." -ForegroundColor Yellow

# Ensure working directory is clean before changing branches
$status = git status --porcelain
if ($status) {
    Write-Host "Warning: You have uncommitted changes in your branch. Stashing them..." -ForegroundColor Gray
    git stash | Out-Null
}

try {
    # Check if production branch exists locally, if not create it
    $prodExists = git branch --list production
    if (-not $prodExists) {
        Write-Host "Creating production branch..." -ForegroundColor Cyan
        git branch production
    }

    # Copy dist contents to a temporary directory outside the repo so we don't lose it on checkout
    $tempDeploy = [System.IO.Path]::GetTempFileName()
    Remove-Item $tempDeploy
    New-Item -ItemType Directory -Path $tempDeploy -Force | Out-Null
    Copy-Item -Path "$distPath\*" -Destination $tempDeploy -Recurse -Force

    # Checkout production branch
    Write-Host "Checking out production branch..." -ForegroundColor Cyan
    git checkout production

    # Delete everything in the repo except untracked/ignored folders like .dart_tool by using git rm
    Write-Host "Clearing production branch contents using git rm..." -ForegroundColor Cyan
    git rm -rf .

    # Copy files from temp deploy back to root
    Write-Host "Copying deployment files..." -ForegroundColor Cyan
    Copy-Item -Path "$tempDeploy\*" -Destination . -Recurse -Force

    # Clean up temp folder
    Remove-Item $tempDeploy -Recurse -Force

    # Add and commit
    Write-Host "Committing changes..." -ForegroundColor Cyan
    git add -A
    git commit -m "deploy: update landing page, web planner under /app, and BachatBite.apk"

    # Push to origin
    Write-Host "Pushing to GitHub (production branch)..." -ForegroundColor Cyan
    git push origin production

    Write-Host "Deployment completed successfully! Vercel should now deploy your landing page." -ForegroundColor Green
}
catch {
    Write-Host "An error occurred during Git deployment: $_" -ForegroundColor Red
    throw $_
}
finally {
    # Checkout original branch
    Write-Host "Restoring your original branch: $currentBranch" -ForegroundColor Cyan
    git checkout $currentBranch

    if ($status) {
        Write-Host "Restoring stashed changes..." -ForegroundColor Gray
        git stash pop | Out-Null
    }
    
    # Remove dist folder
    if (Test-Path $distPath) {
        Remove-Item -Path $distPath -Recurse -Force
    }
}
