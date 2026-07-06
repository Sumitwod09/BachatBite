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
Write-Host "Starting Git deployment to web_landing branch..." -ForegroundColor Yellow

$gitRemote = git remote get-url origin
$tempRepo = Join-Path $env:TEMP "BachatBite-Deploy-$(Get-Random)"

try {
    Write-Host "Cloning repository to temporary folder: $tempRepo" -ForegroundColor Cyan
    # Clone locally to avoid copying large files
    git clone --no-checkout . $tempRepo

    # Store current location and change to temp repo
    Push-Location $tempRepo

    # Set remote to actual GitHub remote URL
    git remote set-url origin $gitRemote

    Write-Host "Checking out web_landing branch..." -ForegroundColor Cyan
    git fetch origin | Out-Null
    
    $branchExists = git branch -r --list "origin/web_landing"
    if ($branchExists) {
        git checkout web_landing
        # Clear existing tracked files in the branch
        git rm -rf .
    } else {
        # Create a new clean orphan branch
        git checkout --orphan web_landing
    }

    # Copy files from dist to temp repo
    Write-Host "Copying deployment files..." -ForegroundColor Cyan
    Copy-Item -Path "$distPath\*" -Destination . -Recurse -Force

    # Stage, commit, and push
    Write-Host "Staging files..." -ForegroundColor Cyan
    git add -A

    Write-Host "Committing changes..." -ForegroundColor Cyan
    git commit -m "deploy: update landing page, web planner under /app, and BachatBite.apk"

    Write-Host "Pushing to GitHub (web_landing branch)..." -ForegroundColor Cyan
    git push origin web_landing -f

    Write-Host "Deployment completed successfully! Vercel should now deploy your landing page." -ForegroundColor Green
}
catch {
    Write-Host "An error occurred during Git deployment: $_" -ForegroundColor Red
    throw $_
}
finally {
    # Restore original location
    Pop-Location

    # Clean up temp repo
    if (Test-Path $tempRepo) {
        Remove-Item $tempRepo -Recurse -Force -ErrorAction SilentlyContinue
    }

    # Remove dist folder
    if (Test-Path $distPath) {
        Remove-Item -Path $distPath -Recurse -Force -ErrorAction SilentlyContinue
    }
}
