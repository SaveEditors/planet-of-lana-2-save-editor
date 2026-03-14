param(
  [int]$Port = 8799,
  [string]$Output = "assets/readme-screenshot.png"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-PythonLauncher {
  if (Get-Command python -ErrorAction SilentlyContinue) { return "python" }
  if (Get-Command py -ErrorAction SilentlyContinue) { return "py" }
  throw "Python was not found. Install Python 3 to capture screenshots."
}

function Get-BrowserPath {
  $paths = @(
    "C:\Program Files\Microsoft\Edge\Application\msedge.exe",
    "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe",
    "C:\Program Files\Google\Chrome\Application\chrome.exe",
    "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
  )
  foreach ($path in $paths) {
    if (Test-Path $path) { return $path }
  }
  throw "No supported browser found (Edge or Chrome)."
}

$root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$python = Get-PythonLauncher
$browser = Get-BrowserPath
$outputPath = Join-Path $root $Output
$outputDir = Split-Path $outputPath -Parent
if (-not (Test-Path $outputDir)) { New-Item -Path $outputDir -ItemType Directory | Out-Null }

$serverArgs = if ($python -eq "py") {
  @("-3", "-m", "http.server", "$Port", "--bind", "127.0.0.1")
} else {
  @("-m", "http.server", "$Port", "--bind", "127.0.0.1")
}

$server = Start-Process -FilePath $python -ArgumentList $serverArgs -WorkingDirectory $root -PassThru -WindowStyle Hidden
try {
  Start-Sleep -Seconds 2
  $url = "http://127.0.0.1:$Port/index.html"
  $shotArgs = @(
    "--headless",
    "--disable-gpu",
    "--window-size=1600,1000",
    "--screenshot=$outputPath",
    $url
  )
  & $browser @shotArgs | Out-Null
  if (-not (Test-Path $outputPath)) {
    throw "Screenshot capture failed: $outputPath was not created."
  }
  Write-Host "Screenshot saved: $outputPath" -ForegroundColor Green
}
finally {
  if ($server -and -not $server.HasExited) {
    Stop-Process -Id $server.Id -Force
  }
}
