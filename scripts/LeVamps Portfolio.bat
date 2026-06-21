@echo off
chcp 65001 >nul
setlocal EnableExtensions

set "HTML=%~dp0entrega.html"
if not exist "%HTML%" (
  echo No se encontro entrega.html junto al launcher.
  pause
  exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$html = (Resolve-Path -LiteralPath '%HTML%').Path;" ^
  "$url = 'file:///' + ($html -replace '\\','/');" ^
  "$chrome = @(" ^
  "  Join-Path $env:ProgramFiles 'Google\Chrome\Application\chrome.exe'," ^
  "  Join-Path $env:LOCALAPPDATA 'Google\Chrome\Application\chrome.exe'" ^
  ") | Where-Object { Test-Path $_ } | Select-Object -First 1;" ^
  "if ($chrome) { Start-Process -FilePath $chrome -ArgumentList @('--app=' + $url, '--window-size=1280,720', '--new-window'); exit 0 }" ^
  "$edge = @(" ^
  "  Join-Path ${env:ProgramFiles(x86)} 'Microsoft\Edge\Application\msedge.exe'," ^
  "  Join-Path $env:ProgramFiles 'Microsoft\Edge\Application\msedge.exe'" ^
  ") | Where-Object { Test-Path $_ } | Select-Object -First 1;" ^
  "if ($edge) { Start-Process -FilePath $edge -ArgumentList @('--app=' + $url, '--window-size=1280,720', '--new-window'); exit 0 }" ^
  "Start-Process -FilePath $html"

exit /b %ERRORLEVEL%
