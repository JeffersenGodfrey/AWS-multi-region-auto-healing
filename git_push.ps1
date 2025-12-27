<#
Safe git push helper for this repo.

Usage (run from PowerShell):
  .\git_push.ps1 -RemoteUrl https://github.com/JeffersenGodfrey/AWS-multi-region-auto-healing.git

The script will:
- cd into the inner repo folder
- show git status and remotes
- add or update `origin` remote
- untrack `7_terraform/terraform.tfstate` and backup if they are tracked
- stage `.gitignore` and other changes, commit if needed
- push the current branch to origin (attempts a pull --rebase if push is rejected)

This script only prepares and runs git commands locally; it does not have network-level privileges beyond your machine.
#>

param(
    [string]$RemoteUrl = 'https://github.com/JeffersenGodfrey/AWS-multi-region-auto-healing.git'
)

Set-StrictMode -Version Latest

try {
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    Write-Host "Script running from: $scriptDir"

    # Change to inner repo directory if needed
    $inner = Join-Path $scriptDir 'aws-multi-region-auto-healing'
    if (Test-Path $inner) {
        Set-Location $inner
        Write-Host "Changed directory to inner repo: $inner"
    } else {
        Write-Host "Inner repo folder not found; assuming current folder is repo root."
    }

    Write-Host "Current branch: $(git branch --show-current)"
    Write-Host "Git status:"
    git status

    Write-Host "Remotes before change:"
    git remote -v

    # Add or set origin
    $remotes = git remote
    if ($remotes -match 'origin') {
        Write-Host "Setting origin URL to $RemoteUrl"
        git remote set-url origin $RemoteUrl
    } else {
        Write-Host "Adding origin: $RemoteUrl"
        git remote add origin $RemoteUrl
    }

    Write-Host "Remotes after change:"
    git remote -v

    # Untrack terraform state files if they are tracked
    $statePath = '7_terraform/terraform.tfstate'
    $stateBackup = '7_terraform/terraform.tfstate.backup'
    if (git ls-files --error-unmatch $statePath 2>$null) {
        Write-Host "Untracking $statePath"
        git rm --cached --quiet $statePath
    } else {
        Write-Host "$statePath not tracked"
    }
    if (git ls-files --error-unmatch $stateBackup 2>$null) {
        Write-Host "Untracking $stateBackup"
        git rm --cached --quiet $stateBackup
    } else {
        Write-Host "$stateBackup not tracked"
    }

    # Stage and commit
    git add .gitignore
    git add -A
    $commitNeeded = $false
    if ((git status --porcelain) -ne '') { $commitNeeded = $true }
    if ($commitNeeded) {
        git commit -m "Remove terraform state from repo; add .gitignore"
    } else {
        Write-Host "No changes to commit"
    }

    # Push current branch
    $branch = git branch --show-current
    Write-Host "Pushing branch $branch to origin"
    try {
        git push -u origin $branch
        Write-Host "Push succeeded"
    } catch {
        Write-Warning "Initial push failed; attempting fetch+rebase then push"
        git fetch origin
        git pull --rebase origin $branch
        git push -u origin $branch
    }

    Write-Host "Done. If push still failed, inspect output above and run the suggested commands manually."
} catch {
    Write-Error "Script failed: $_"
    exit 1
}
