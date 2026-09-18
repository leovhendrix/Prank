@echo off
title Lab Environment Configuration Tool
echo ===================================================
echo   Windows Remote Access Setup Script  
echo ===================================================
echo.

:: 1. Check for Administrator Privileges
net session >nul 2>&1
if %errorLevel% == 0 (
    echo [OK] Administrator privileges detected. Applying configurations...
) else (
    echo [ERROR] This script requires administrative privileges!
    echo Please right-click and select "Run as Administrator".
    pause
    exit
)
echo.

:: 2. Allow Remote Administrative Tokens Over Network
echo [1/3] Modifying Local Account Token Filter Policy...
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 1 /f
echo.

:: 3. Open Firewall Ports for File and Printer Sharing (Ports 135, 445)
echo [2/3] Enabling File and Printer Sharing Firewall Rules...
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes
echo.

:: 4. Enable Network Logins for Accounts Without Passwords
echo [3/3] Disabling Blank Password Network Restriction...
reg add HKLM\SYSTEM\CurrentControlSet\Control\Lsa /v LimitBlankPasswordUse /t REG_DWORD /d 0 /f
echo.

echo ===================================================
echo  Configuration Complete! 
echo  This machine is now configured for remote administration.
echo ===================================================
pause
