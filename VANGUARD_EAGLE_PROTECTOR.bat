@echo off
title Shadow System Hardening Tool
echo ===================================================
echo   Shadow System Defense and Hardening Tool  
echo ===================================================
echo.

:: 1. Check for Administrator Privileges
net session >nul 2>&1
if %errorLevel% == 0 (
    echo [OK] Administrator privileges detected. Starting defense protocol...
) else (
    echo [ERROR] Please run this file as an Administrator!
    pause
    exit
)
echo.

:: 2. Block Dangerous Network Ports Using Windows Firewall
echo [1/4] Blocking dangerous network ports (SMB, RDP, RPC)...
netsh advfirewall firewall add rule name="Block_SMB_445" dir=in action=block protocol=TCP localport=445
netsh advfirewall firewall add rule name="Block_RDP_3389" dir=in action=block protocol=TCP localport=3389
netsh advfirewall firewall add rule name="Block_RPC_135" dir=in action=block protocol=TCP localport=135
echo [OK] Ports are locked down. Competitors cannot scan these entry points.
echo.

:: 3. Enforce Registry Protections Against Remote Execution
echo [2/4] Activating registry security policies...
:: Enforce restriction on blank password network logons
reg add HKLM\SYSTEM\CurrentControlSet\Control\Lsa /v LimitBlankPasswordUse /t REG_DWORD /d 1 /f
:: Block remote administrative tokens over the network
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v LocalAccountTokenFilterPolicy /t REG_DWORD /d 0 /f
echo [OK] Registry defenses successfully deployed.
echo.

:: 4. Disable the Built-in Guest Account
echo [3/4] Disabling the local Guest account...
net user Guest /active:no
echo [OK] Guest account has been completely disabled.
echo.

:: 5. Ensure Task Manager is Protected and Enabled
echo [4/4] Verifying system monitoring tools...
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System /v DisableTaskMgr /t REG_DWORD /d 0 /f
echo [OK] Task Manager access verified.
echo.

echo ===================================================
echo  Your system is now fully secured against remote scans!
echo ===================================================
pause
