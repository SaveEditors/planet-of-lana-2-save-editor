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

function Test-PortAvailable {
  param([int]$CandidatePort)
  $listener = $null
  try {
    $listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Parse("127.0.0.1"), $CandidatePort)
    $listener.Start()
    return $true
  }
  catch {
    return $false
  }
  finally {
    if ($listener) { $listener.Stop() }
  }
}

function Get-FreePort {
  $listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Parse("127.0.0.1"), 0)
  $listener.Start()
  try {
    return $listener.LocalEndpoint.Port
  }
  finally {
    $listener.Stop()
  }
}

function Resolve-ServerPort {
  param([int]$PreferredPort)

  if ($PreferredPort -gt 0 -and (Test-PortAvailable -CandidatePort $PreferredPort)) {
    return $PreferredPort
  }

  $fallback = Get-FreePort
  if ($PreferredPort -gt 0) {
    Write-Warning "Port $PreferredPort is not available. Using free port $fallback instead."
  }
  return $fallback
}

function Wait-ServerReady {
  param(
    [string]$Url,
    [System.Diagnostics.Process]$Process,
    [int]$TimeoutSeconds = 20
  )

  $deadline = [DateTime]::UtcNow.AddSeconds($TimeoutSeconds)
  while ([DateTime]::UtcNow -lt $deadline) {
    if ($Process.HasExited) {
      throw "Local server exited before it became ready."
    }

    try {
      $response = Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec 3
      if ($response.StatusCode -ge 200 -and $response.StatusCode -lt 400 -and $response.Content -match "<title>Planet of Lana 2 - Save Editor</title>") {
        return
      }
    }
    catch {
      # Retry until timeout.
    }
    Start-Sleep -Milliseconds 500
  }

  throw "Timed out waiting for local server at $Url"
}

$root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$python = Get-PythonLauncher
$browser = Get-BrowserPath
$resolvedPort = Resolve-ServerPort -PreferredPort $Port
$outputPath = Join-Path $root $Output
$outputDir = Split-Path $outputPath -Parent
if (-not (Test-Path $outputDir)) { New-Item -Path $outputDir -ItemType Directory | Out-Null }

$serverArgs = if ($python -eq "py") {
  @("-3", "-m", "http.server", "$resolvedPort", "--bind", "127.0.0.1")
} else {
  @("-m", "http.server", "$resolvedPort", "--bind", "127.0.0.1")
}

$server = Start-Process -FilePath $python -ArgumentList $serverArgs -WorkingDirectory $root -PassThru -WindowStyle Hidden
try {
  $url = "http://127.0.0.1:$resolvedPort/index.html"
  Wait-ServerReady -Url $url -Process $server -TimeoutSeconds 20
  $shotArgs = @(
    "--headless",
    "--disable-gpu",
    "--virtual-time-budget=4000",
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
