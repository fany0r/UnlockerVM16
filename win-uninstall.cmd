@echo off
setlocal ENABLEEXTENSIONS
echo.
echo Unlocker 3.0.2 for VMware Workstation
echo =====================================
echo (c) Dave Parsons 2011-18

rem net session >NUL 2>&1
rem if %errorlevel% neq 0 (
rem     echo Administrator privileges required! 
rem     exit
rem )

echo.
set KeyName="HKLM\SOFTWARE\Wow6432Node\VMware, Inc.\VMware Player"
:: delims is a TAB followed by a space
for /F "tokens=2* delims=	 " %%A in ('REG QUERY %KeyName% /v InstallPath') do set InstallPath=%%B
echo [*] VMware is installed at: %InstallPath%
for /F "tokens=2* delims=	 " %%A in ('REG QUERY %KeyName% /v ProductVersion') do set ProductVersion=%%B
echo [*] VMware product version: %ProductVersion%

pushd %~dp0

echo.
echo [*] Stopping VMware services...
net stop "VMwareHostd" > NUL 2>&1
net stop "VMAuthdService" > NUL 2>&1
net stop "VMnetDHCP" > NUL 2>&1
net stop "VMUSBArbService" > NUL 2>&1
net stop "VMware NAT Service" > NUL 2>&1
taskkill /F /IM vmware-tray.exe > NUL 2>&1

echo.
echo [*] Restoring files...
xcopy /F /Y .\backup\x64\*.* "%InstallPath%x64\"
xcopy /F /Y .\backup\*.* "%InstallPath%"
del /f "%InstallPath%"darwin*.*

echo.
echo [*] Removing backup files...
rd /s /q .\backup > NUL 2>&1

echo.
echo [*] Starting VMware services...
net start "VMware NAT Service" > NUL 2>&1
net start "VMnetDHCP" > NUL 2>&1
net start "VMAuthdService" > NUL 2>&1
net start "VMUSBArbService" > NUL 2>&1
net start "VMwareHostd" > NUL 2>&1

popd
echo.
echo [+] Finished!
pause

