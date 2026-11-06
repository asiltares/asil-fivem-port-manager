@echo off
setlocal EnableExtensions DisableDelayedExpansion
title asil-fivem-port-manager
set "SCRIPT_PATH=%~f0"

set "APP_LANG=%~1"
if /I "%APP_LANG%"=="TR" goto LANG_TR
if /I "%APP_LANG%"=="EN" goto LANG_EN

cls
echo ====================================================
echo  Dil secin / Select language
echo ====================================================
echo  [1] Turkce
echo  [2] English
echo.
choice /C 12 /N /M "Secim / Choice [1/2]: "
if errorlevel 2 goto LANG_EN
goto LANG_TR

:LANG_TR
set "APP_LANG=TR"
set "YN=EH"
set "RQ=EH"
set "T_ADMIN=Yonetici izni gerekiyor, yeniden baslatiliyor..."
set "T_ADMIN_FAIL=[HATA] Yonetici izni alinamadi. Script'e sag tiklayip 'Yonetici olarak calistir' secin."
set "T_TITLE=FiveM / txAdmin Firewall Port Kontrolu"
set "T_RULE=Kural"
set "T_PROTO=Protokol"
set "T_PORT=Port"
set "T_FOUND=[BULUNDU] Bu isimde bir firewall kurali zaten var."
set "T_KEEP=[1] Koru / dokunma"
set "T_DEL=[2] Sil"
set "T_RECREATE=[3] Sil ve yeniden olustur"
set "T_SELECT=Secim [1/2/3]: "
set "T_KEPT=[ATLANDI] Kural korundu."
set "T_MISSING=[YOK] Bu isimde kural bulunamadi."
set "T_ASK_CREATE=Bu port icin kural olusturulsun mu? [E/H]: "
set "T_NOT_CREATED=[ATLANDI] Kural olusturulmadi."
set "T_ERR_DEL=[HATA] Kural silinemedi:"
set "T_OK_DEL=[OK] Kural silindi:"
set "T_ERR_ADD=[HATA] Kural olusturulamadi:"
set "T_OK_ADD=[OK] Kural olusturuldu:"
set "T_DONE=Islem tamamlandi."
set "T_TIP=txAdmin 40120 portunu mumkunse sadece kendi IP'ne ac."
set "T_AGAIN=[E] Tekrar kontrol et  [H] Cikis: "
goto CHECK_ADMIN

:LANG_EN
set "APP_LANG=EN"
set "YN=YN"
set "RQ=RQ"
set "T_ADMIN=Administrator rights required, restarting..."
set "T_ADMIN_FAIL=[ERROR] Could not get administrator rights. Right-click the script and choose 'Run as administrator'."
set "T_TITLE=FiveM / txAdmin Firewall Port Check"
set "T_RULE=Rule"
set "T_PROTO=Protocol"
set "T_PORT=Port"
set "T_FOUND=[FOUND] A firewall rule with this name already exists."
set "T_KEEP=[1] Keep / do not touch"
set "T_DEL=[2] Delete"
set "T_RECREATE=[3] Delete and recreate"
set "T_SELECT=Choice [1/2/3]: "
set "T_KEPT=[SKIPPED] Rule kept."
set "T_MISSING=[MISSING] No rule with this name was found."
set "T_ASK_CREATE=Create a rule for this port? [Y/N]: "
set "T_NOT_CREATED=[SKIPPED] Rule not created."
set "T_ERR_DEL=[ERROR] Could not delete rule:"
set "T_OK_DEL=[OK] Rule deleted:"
set "T_ERR_ADD=[ERROR] Could not create rule:"
set "T_OK_ADD=[OK] Rule created:"
set "T_DONE=Done."
set "T_TIP=If possible, open txAdmin port 40120 only to your own IP."
set "T_AGAIN=[R] Recheck  [Q] Quit: "
goto CHECK_ADMIN

:CHECK_ADMIN
net session >nul 2>&1
if not errorlevel 1 goto MAIN
echo %T_ADMIN%
powershell.exe -NoProfile -NonInteractive -Command "Start-Process -FilePath $env:SCRIPT_PATH -ArgumentList '%APP_LANG%' -Verb RunAs -ErrorAction Stop" >nul 2>&1
if errorlevel 1 (
    echo %T_ADMIN_FAIL%
    pause
    endlocal
    exit /b 1
)
endlocal
exit /b 0

:MAIN
cls
echo ====================================================
echo  %T_TITLE%
echo ====================================================
call :PROCESS "FiveM Server 30120 TCP" TCP 30120
call :PROCESS "FiveM Server 30120 UDP" UDP 30120
call :PROCESS "txAdmin 40120 TCP" TCP 40120
echo.
echo ====================================================
echo %T_DONE%
echo %T_TIP%
echo ====================================================
echo.
choice /C %RQ% /N /M "%T_AGAIN%"
if errorlevel 2 goto END
goto MAIN

:END
endlocal
exit /b 0

:PROCESS
set "RULE_NAME=%~1"
set "RULE_PROTOCOL=%~2"
set "RULE_PORT=%~3"
echo.
echo ----------------------------------------------------
echo %T_RULE%: %RULE_NAME%  ^|  %T_PROTO%: %RULE_PROTOCOL%  ^|  %T_PORT%: %RULE_PORT%
echo ----------------------------------------------------

powershell.exe -NoProfile -NonInteractive -Command "if (Get-NetFirewallRule -DisplayName '%RULE_NAME%' -ErrorAction SilentlyContinue) { exit 0 } else { exit 1 }" >nul 2>&1
if errorlevel 1 goto RULE_MISSING

echo %T_FOUND%
echo %T_KEEP%
echo %T_DEL%
echo %T_RECREATE%
choice /C 123 /N /M "%T_SELECT%"
if errorlevel 3 goto RECREATE_RULE
if errorlevel 2 goto DELETE_RULE
echo %T_KEPT%
exit /b 0

:DELETE_RULE
call :REMOVE_RULE
exit /b %errorlevel%

:RECREATE_RULE
call :REMOVE_RULE
if errorlevel 1 exit /b 1
call :ADD_RULE
exit /b %errorlevel%

:RULE_MISSING
echo %T_MISSING%
choice /C %YN% /N /M "%T_ASK_CREATE%"
if errorlevel 2 (
    echo %T_NOT_CREATED%
    exit /b 0
)
call :ADD_RULE
exit /b %errorlevel%

:REMOVE_RULE
powershell.exe -NoProfile -NonInteractive -Command "Remove-NetFirewallRule -DisplayName '%RULE_NAME%' -ErrorAction Stop" >nul 2>&1
if errorlevel 1 (
    echo %T_ERR_DEL% %RULE_NAME%
    exit /b 1
)
echo %T_OK_DEL% %RULE_NAME%
exit /b 0

:ADD_RULE
powershell.exe -NoProfile -NonInteractive -Command "New-NetFirewallRule -DisplayName '%RULE_NAME%' -Direction Inbound -Protocol '%RULE_PROTOCOL%' -LocalPort %RULE_PORT% -Action Allow -Profile Any -Enabled True -ErrorAction Stop | Out-Null" >nul 2>&1
if errorlevel 1 (
    echo %T_ERR_ADD% %RULE_NAME%
    exit /b 1
)
echo %T_OK_ADD% %RULE_NAME%
exit /b 0
