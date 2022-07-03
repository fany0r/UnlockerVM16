@echo off
setlocal ENABLEEXTENSIONS
echo Get macOS VMware Tools 3.0.2
echo ===============================
echo (c) Dave Parsons 2011-18

rem net session >NUL 2>&1
rem if %errorlevel% neq 0 (
rem     echo Administrator privileges required! 
rem     exit
rem )

pushd %~dp0

set KeyName="HKLM\SOFTWARE\Wow6432Node\VMware, Inc.\VMware Workstation"
:: delims is a TAB followed by a space
for /F "tokens=2* delims=	 " %%A in ('REG QUERY %KeyName% /v InstallPath') do set InstallPath=%%B
echo [*] VMware is installed at: %InstallPath%

echo [*] Getting VMware Tools...
.\python\python.exe .\gettools.py
xcopy /F /Y .\updatetools\darwin*.* "%InstallPath%"

popd

echo [*] Finished!
