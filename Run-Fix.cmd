@echo off
setlocal
set "taskPowerShell=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
if exist "%SystemRoot%\Sysnative\WindowsPowerShell\v1.0\powershell.exe" set "taskPowerShell=%SystemRoot%\Sysnative\WindowsPowerShell\v1.0\powershell.exe"
"%taskPowerShell%" -NoProfile -ExecutionPolicy Bypass -File "%~dp0Fix-ChromeCountry.ps1" %*
set "taskResult=%ERRORLEVEL%"
echo.
if not "%taskResult%"=="0" echo Fix failed. Read the error above; original files are backed up before any write.
pause
exit /b %taskResult%
