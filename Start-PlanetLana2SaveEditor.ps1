param(
  [ValidateSet("web", "electron", "build")]
  [string]$Mode = "web",
  [int]$Port = 8787,
  [switch]$NoOpen
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-PythonLauncher {
  if (Get-Command python -ErrorAction SilentlyContinue) { return "python" }
  if (Get-Command py -ErrorAction SilentlyContinue) { return "py" }
  return $null
}

function Ensure-Npm {
  if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    throw "npm was not found. Install Node.js first: https://nodejs.org/"
  }
}

function Ensure-ElectronDeps {
  if (-not (Test-Path (Join-Path $PSScriptRoot "node_modules"))) {
    Write-Host "[Setup] Installing npm dependencies..." -ForegroundColor Cyan
    Push-Location $PSScriptRoot
    try {
      npm install
    } finally {
      Pop-Location
    }
  }
}

switch ($Mode) {
  "web" {
    $python = Get-PythonLauncher
    if (-not $python) {
      throw "Python launcher not found. Install Python 3, then rerun this script."
    }
    $url = "http://127.0.0.1:$Port/index.html"
    Write-Host "[Web] Serving $PSScriptRoot on $url" -ForegroundColor Green
    Write-Host "[Web] Press Ctrl+C to stop." -ForegroundColor DarkGray
    if (-not $NoOpen) { Start-Process $url | Out-Null }
    Push-Location $PSScriptRoot
    try {
      if ($python -eq "py") {
        py -3 -m http.server $Port --bind 127.0.0.1
      } else {
        python -m http.server $Port --bind 127.0.0.1
      }
    } finally {
      Pop-Location
    }
    break
  }
  "electron" {
    Ensure-Npm
    Ensure-ElectronDeps
    Write-Host "[Electron] Launching desktop shell..." -ForegroundColor Green
    Push-Location $PSScriptRoot
    try {
      npm start
    } finally {
      Pop-Location
    }
    break
  }
  "build" {
    Ensure-Npm
    Ensure-ElectronDeps
    Write-Host "[Build] Building portable Windows package..." -ForegroundColor Green
    Push-Location $PSScriptRoot
    try {
      npm run build
    } finally {
      Pop-Location
    }
    break
  }
}
