@echo off
setlocal enabledelayedexpansion
cls

REM check for elevated privileges
net session >nul 2>&1
if not %errorLevel% == 0 (
    echo Error: You must run this as administrator.
    pause
    exit /b
)

set fwRule="Grand Theft Auto V by reverie"
set InputFile=%~dp0\whitelist.txt

REM Remove firewall rule if set previously
:deleteFW
cls
netsh advfirewall firewall show rule name=%fwRule% >nul
if not ERRORLEVEL 1 (
    netsh advfirewall firewall delete rule name=%fwRule%
    echo.Firewall rule deleted. The public can now join your session.
)

:menuNone
echo.
echo =========================================
echo GTA V: Online private session by reverie
echo =========================================
echo.
echo 1) Start solo public session
echo 2) Start whitelist session
echo 5) How to use this?
echo 7) About this program
echo 0) Exit
set m=noChoice
set /p m=Enter option: 
if %m%==noChoice (
    cls
    echo.Error: You need to select an option
    goto menuNone
)
if %m%==1 goto startSolo
if %m%==2 goto startWhitelist
if %m%==5 goto howto
if %m%==7 goto readme
if %m%==0 goto quitScript

:menuSolo
echo.
echo =========================================
echo GTA V: Online private session by reverie
echo =========================================
echo.
echo 1) Stop solo public session
set m=noChoice
set /p m=Enter option: 
if %m%==noChoice (
    cls
    echo.Error: You need to select an option
    goto menuSolo
)
if %m%==1 goto deleteFW

:menuWhitelist
echo.
echo =========================================
echo GTA V: Online private session by reverie
echo =========================================
echo.
echo 2) Stop whitelist session
set m=noChoice
set /p m=Enter option: 
if %m%==noChoice (
    cls
    echo.Error: You need to select an option
    goto menuWhitelist
)
if %m%==2 goto deleteFW

:howto
cls
echo.-----------------------------
echo.How to play alone
echo.-----------------------------
echo.1. Go to GTA V: Online
echo.2. After entering a public session, select "1) Start solo public session".
echo.3. Wait for a few moments. Players should start leaving your session.
echo.4. ???
echo.5. Profit!
echo.
echo.-----------------------------
echo.How to play with friends
echo.-----------------------------
echo.1. Ensure your friends' IP are put in a text file called "whitelist.txt" in the same
echo.directory where this program is run. They can find their IP address through any third-
echo.party services such as www.canihazip.com or even simply googling "what is my ip"
echo.2. Follow steps in "Play alone"
echo.3. Select "1) Stop solo public session" and then "2) Start whitelist session"
echo.4. Invite your friends into your session via Steam overlay or Rockstar Social Club.
echo.5. ???
echo.6. Profit!
echo.
echo.-----------------------------
echo.How to remove firewall rules
echo.-----------------------------
echo.1. Select "Stop whitelist session" or "Stop solo public session"
echo.
echo.Closed the program without selecting that first? The next time you run this they will
echo.be deleted automatically.
echo.
goto menuNone

:readme
cls
echo.-----------------------------
echo.About this program
echo.-----------------------------
echo.This tool uses *Windows Firewall* to set up port blocking and whitelisting so
echo.you can have a fun experience playing GTA V: Online alone or with friends.
echo.
echo.This tool is not compatible if you are using a third-party firewall such as
echo.ZoneAlarm or Comodo.
echo.
echo.This tool is useful if you want to play features such as CEO missions and Biker
echo.businesses that can otherwise only be played if you are in a Public session but
echo.wish to keep out griefers and/or modders who spoil your game.
echo.
echo.This is a convenient tool written so that the user does not need any account
echo.registration with a third-party website and keeps out the tedious configuration
echo.of Windows Firewall rules.
echo.
echo.This tool does not touch any files related to the game. Instead it manipulates
echo.your computer's connection to the network so you cannot connect to other players'
echo.sessions. When you cannot connect to any network, the game places you into a
echo.public session by yourself. This is also true if you have a terrible internet
echo.connection. Unless Rockstar changes their terms of service, there is no reason
echo.for your account to be flagged and banned.
goto menuNone

:startSolo
cls
REM Create firewall rule for solo session
netsh advfirewall firewall add rule name=%fwRule% protocol=UDP dir=out action=block localport=6672
REM netsh advfirewall firewall add rule name=%fwRule% protocol=UDP dir=in action=block localport=6672
echo.Firewall rule set. You are now in solo public session.
goto menuSolo

:startWhitelist
cls
REM Check for file
if not exist %InputFile% (
    echo.
    echo.
    echo Error: You need to create whitelist.txt file in the same directory where this program is run
    goto menuNone
)

REM Refresh whitelist file
set TmpTmpFile=%Temp%\%~n0-tmp.tmp
set TmpFile=%Temp%\%~n0.tmp
(for /f "tokens=1-4 delims=. " %%a in ('type "%InputFile%"') do (
    set Oct1=00%%a
    set Oct2=00%%b
    set Oct3=00%%c
    set Oct4=00%%d
    echo !Oct1:~-3!!Oct2:~-3!!Oct3:~-3!!Oct4:~-3!	%%a.%%b.%%c.%%d
))>"%TmpTmpFile%"
(for /f "tokens=2" %%a in ('type "%TmpTmpFile%" ^| sort.exe') do (
    echo %%a
))>"%TmpFile%"
del "%TmpTmpFile%"

REM Show IP(s) in whitelist file
echo.======================== IP(s) in whitelist ============================
set /a ColWidth = 3
set /a ColCount = 0
set Line=
for /f "tokens=1" %%a in ('type "%TmpFile%"') do (
    set /a ColCount += 1
    set Line=!Line!		%%a

    if !ColCount! geq !ColWidth! (
        set /a ColCount = 0
        echo.!Line:~1!
        set Line=
    )
)
if defined Line echo.%Line:~1%
echo.========================================================================

REM Prepare range of IP to block
set "fullRange="
set "startRange=1.1.1.1"
set "endRange=224.0.0.0"
set "prevset=0.0.0.-1"
set "nextset=0.0.0.1"
for /f "tokens=1" %%a in ('type "%TmpFile%"') do (

    for /f "tokens=1-4 delims=. " %%w in ("%%a") do (
        if %%z==0 (
            echo.Error: %%w.%%x.%%y.%%z is an invalid IP
            goto menuNone
        )
        for /f "tokens=1-4 delims=. " %%i in ("!prevset!") do (
            set /a octPrevA=%%w+%%i, octPrevB=%%x+%%j, octPrevC=%%y+%%k, octPrevD=%%z+%%l
            REM modify prevset if last octet is actually 1
            if %%z==1 (
                set /a octPrevC=!octPrevC!-1, octPrevD=!octPrevD!+255
            )
            REM modify prevset if third and last octet are actually 0 and 1 e.g. 192.168.0.1
            if %%y==0 (
                set /a octPrevB=!octPrevB!-1, octPrevC=!octPrevC!+256
            )
            REM modify prevset if all except first octet is 0 and last octet is 1 e.g. 192.0.0.1
            if %%x==0 (
                set /a octPrevA=!octPrevA!-1, octPrevB=!octPrevB!+256
            )
            set prevIP=!octPrevA!.!octPrevB!.!octPrevC!.!octPrevD!
        )
        for /f "tokens=1-4 delims=. " %%i in ("!nextset!") do (
            set /a octNextA=%%w+%%i, octNextB=%%x+%%j, octNextC=%%y+%%k, octNextD=%%z+%%l
            REM modify nextset if last octet is actually 255 e.g. 192.168.1.255
            if %%z==255 (
                set /a octNextC=!octNextC!+1, octNextD=!octNextD!-254
            )
            REM modify nextset if third and last octet are actually 255 e.g. 192.168.255.255
            if %%y==255 (
                if %%z==255 (
                    set /a octNextB=!octNextB!+1, octNextC=!octNextC!-254
                )
            )
            REM modify nextset if all are 255 e.g. 192.255.255.255
            if %%x==255 (
                if %%y==255 (
                    if %%z==255 (
                        set /a octNextA=!octNextA!+1, octNextB=!octNextB!-254
                    )
                )
            )
            set nextIP=!octNextA!.!octNextB!.!octNextC!.!octNextD!
        )
    )

    if [!fullRange!] == [] (
        set "fullRange=%startRange%-!prevIP!,!nextIP!-%endRange%"
    ) else (
        call set fullRange=%%fullRange:%endRange%=!prevIP!%%,!nextIP!-%endRange%
    )
)
del "%TmpFile%"
REM Create firewall rule for whitelist session based on range to block
netsh advfirewall firewall add rule name=%fwRule% protocol=UDP dir=out action=block localport=6672 remoteip=!fullRange!
REM netsh advfirewall firewall add rule name=%fwRule% protocol=UDP dir=in action=block localport=6672 remoteip=!fullRange!
echo.Firewall rule set. Only players from the whitelist can join your session.
goto menuWhitelist

:quitScript
cls
echo.Thank you for using %fwRule%
pause
exit /b