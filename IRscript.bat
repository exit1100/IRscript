::===========================================================::
@echo off
Rem start
echo.
echo.
echo ::::::::::: :::::::::   ::::::::   ::::::::  :::::::::  ::::::::::: ::::::::: ::::::::::: 
echo     :+:     :+:    :+: :+:    :+: :+:    :+: :+:    :+:     :+:     :+:    :+:    :+:     
echo     +:+     +:+    +:+ +:+        +:+        +:+    +:+     +:+     +:+    +:+    +:+     
echo     +#+     +#++:++#:  +#++:++#++ +#+        +#++:++#:      +#+     +#++:++#+     +#+     
echo     +#+     +#+    +#+        +#+ +#+        +#+    +#+     +#+     +#+           +#+     
echo     #+#     #+#    #+# #+#    #+# #+#    #+# #+#    #+#     #+#     #+#           #+#     
echo ########### ###    ###  ########   ########  ###    ### ########### ###           ###   
echo.
echo                                                         ---------------------------------
echo                                                          %date% %time% - YEJUN
echo.    

:: administrator privileges check
bcdedit >>nul 
if %errorlevel% == 1 (
echo Run with administrator privileges!
echo.
pause 
exit 
) 
set /p flag=Do you want to dump memory? (yes/no) : 

:: ExaminerName
Set ExaminerName="yejun"

REM yyyymmdd set
:: Korea Windows
SET yyyymmdd=%DATE:~0,4%%DATE:~5,2%%DATE:~8,2%
:: English Windows
:: SET yyyymmdd=%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%

:: path set
Set BASEPATH=.\Artifact
Set Tools=%BASEPATH%\..\Tools
Set Dead=%BASEPATH%\Dead
Set Live=%BASEPATH%\Live
Set etc=%BASEPATH%\etc

:: OS bit
reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT

:: Create Folder
if not exist %BASEPATH% (
    mkdir %BASEPATH%
)
if not exist %Dead% (
    mkdir %Dead%
)
if not exist %Live% (
    mkdir %Live%
)
if not exist %etc% (
    mkdir %etc%
)

:: system time
date /T > %BASEPATH%\%yyyymmdd%_systemTime_%ExaminerName%.txt
time /T >> %BASEPATH%\%yyyymmdd%_systemTime_%ExaminerName%.txt

::===========================================================::
::===========================================================::
Rem volatile data

:: Process
if not exist %Live%\Process (
    mkdir %Live%\Process
)
%Tools%\SysinternalsSuite\PsInfo -d -s -h /accepteula > %Live%\Process\%yyyymmdd%_processInfo_%ExaminerName%.txt
%Tools%\SysinternalsSuite\pslist /accepteula > %Live%\Process\%yyyymmdd%_processList_%ExaminerName%.txt
%Tools%\SysinternalsSuite\psloglist /accepteula > %Live%\Process\%yyyymmdd%_processLogList_%ExaminerName%.txt

:: Network_Session
if not exist %Live%\Network_Session (
    mkdir %Live%\Network_Session
)
ipconfig /all > %Live%\Network_Session\%yyyymmdd%_networkInterface_%ExaminerName%.txt
getmac > %Live%\Network_Session\%yyyymmdd%_networkMAC_%ExaminerName%.txt
netstat -anob > %Live%\Network_Session\%yyyymmdd%_networkPort_%ExaminerName%.txt 
%Tools%\SysinternalsSuite\tcpvcon -c -a -n /accepteula > %Live%\Network_Session\%yyyymmdd%_networkPortCSV_%ExaminerName%.txt

:: logonsessions
if not exist %Live%\Logon_Session (
    mkdir %Live%\Logon_Session
)
%Tools%\SysinternalsSuite\logonsessions.exe -p /accepteula > %Live%\Logon_Session\%yyyymmdd%_logonSessions_%ExaminerName%.txt
%Tools%\SysinternalsSuite\psloggedon /accepteula > %Live%\Logon_Session\%yyyymmdd%_logonHistory_%ExaminerName%.txt 

:: Service list
if not exist %Live%\Service_list (
    mkdir %Live%\Service_list
)
%Tools%\SysinternalsSuite\psservice /accepteula > %Live%\Service_list\%yyyymmdd%_serviceList_%ExaminerName%.txt

:: ARP info
if not exist %Live%\ARP_info (
    mkdir %Live%\ARP_info
)
arp -a > %Live%\ARP_info\%yyyymmdd%_arpInfo_%ExaminerName%.txt

:: Shared_Folder_File
if not exist %Live%\Shared_Folder_File (
    mkdir %Live%\Shared_Folder_File
)
net share > %Live%\Shared_Folder_File\%yyyymmdd%_localSharedFolder_%ExaminerName%.txt
net use > %Live%\Shared_Folder_File\%yyyymmdd%_remoteSharedFolder_%ExaminerName%.txt
:: %Tools%\SysinternalsSuite\ShareEnum /accepteula > %Live%\Shared_Folder_File\%yyyymmdd%_sharedFolderFile_%ExaminerName%.txt

:: NetBIOS
if not exist %Live%\NetBIOS (
    mkdir %Live%\NetBIOS
)
nbtstat -c > %Live%\NetBIOS\%yyyymmdd%_netBIOS_%ExaminerName%.txt

:: Routing info
if not exist %Live%\Routing_info (
    mkdir %Live%\Routing_info
)
netstat -r > %Live%\Routing_info\%yyyymmdd%_routingInfo_%ExaminerName%.txt
ipconfig /displaydns > %Live%\Routing_info\%yyyymmdd%_DNScache_%ExaminerName%.txt

:: DLL list
if not exist %Live%\DLL_list (
    mkdir %Live%\DLL_list
)
%Tools%\SysinternalsSuite\Listdlls /accepteula > %Live%\DLL_list\%yyyymmdd%_dllList_%ExaminerName%.txt

:: Handle list
if not exist %Live%\Handle_list (
    mkdir %Live%\Handle_list
)
%Tools%\SysinternalsSuite\handle /accepteula > %Live%\Handle_list\%yyyymmdd%_handleList_%ExaminerName%.txt

:: GPO info
if not exist %Live%\GPO_info (
    mkdir %Live%\GPO_info
)
Gpresult /h %Live%\GPO_info\%yyyymmdd%_gpoInfo_%ExaminerName%.html /f 

::===========================================================::
::===========================================================::
Rem non-volatile data

:: MFT
if not exist %Dead%\MFT (
    mkdir %Dead%\MFT
)
%Tools%\forecopy_handy -f  c:\$mft %Dead%\MFT
echo %yyyymmdd% %time% %ExaminerName% > %Dead%\MFT\%yyyymmdd%_MFT_%ExaminerName%.txt

:: registry
%Tools%\forecopy_handy -g %Dead%
echo %yyyymmdd% %time% %ExaminerName% > %Dead%\registry\%yyyymmdd%_registry_%ExaminerName%.txt

:: LogFile
if not exist %Dead%\LogFile (
    mkdir %Dead%\LogFile
)
%Tools%\forecopy_handy -f c:\$logfile %Dead%\LogFile
echo %yyyymmdd% %time% %ExaminerName% > %Dead%\LogFile\%yyyymmdd%_LogFile_%ExaminerName%.txt

:: prefetch 
%Tools%\forecopy_handy -p %Dead%
echo %yyyymmdd% %time% %ExaminerName% > %Dead%\prefetch\%yyyymmdd%_prefetch_%ExaminerName%.txt

:: event log
%Tools%\forecopy_handy -e %Dead%
echo %yyyymmdd% %time% %ExaminerName% > %Dead%\eventlogs\%yyyymmdd%_eventlogs_%ExaminerName%.txt

:: Shortcuts/Jump lists
%Tools%\forecopy_handy -r %AppData%\microsoft\windows\recent %Dead%
echo %yyyymmdd% %time% %ExaminerName% > %Dead%\recent\%yyyymmdd%_recent_%ExaminerName%.txt

:: recycle bin
if not exist %Dead%\recycle_bin (
    mkdir %Dead%\recycle_bin
) 
echo %yyyymmdd% %time% %ExaminerName% > %Dead%\recycle_bin\%yyyymmdd%_recycleBin_%ExaminerName%.txt
%Tools%\RBCmd.exe -d C:\$Recycle.Bin --csv %Dead%\recycle_bin 
%Tools%\RBCmd.exe -d D:\$Recycle.Bin --csv %Dead%\recycle_bin
:: 할당 된 파티션에 따라 추출해야함!

:: Amacache
if not exist %Dead%\Amacache (
    mkdir %Dead%\Amacache
)
echo %yyyymmdd% %time% %ExaminerName% > %Dead%\Amacache\%yyyymmdd%_Amacache_%ExaminerName%.txt
%Tools%\AmcacheParser.exe -f C:\Windows\appcompat\Programs\Amcache.hve --csv %Dead%\Amacache\
%Tools%\AppCompatCacheParser.exe --csv %Dead%\Amacache --csvf AppCompatCache.csv

:: Task Scheduler
if not exist %Dead%\Task_Scheduler (
    mkdir %Dead%\Task_Scheduler
)
echo %yyyymmdd% %time% %ExaminerName% > %Dead%\Task_Scheduler\%yyyymmdd%_Task_Scheduler_%ExaminerName%.txt
copy /Y %SystemDrive%\Windows\Tasks\* %Dead%\Task_Scheduler\
copy /Y %SystemDrive%\Windows\System32\Tasks\* %Dead%\Task_Scheduler\

:: WER
if not exist %Dead%\WER (
    mkdir %Dead%\WER
)
echo %yyyymmdd% %time% %ExaminerName% > %Dead%\WER\%yyyymmdd%_WER_%ExaminerName%.txt
:: copy /Y %SystemDrive%\ProgramData\Microsoft\WER\ReportArchive %Dead%\WER\
:: copy /Y %UserProfile%\AppData\Local\Microsoft\Windows\WER %Dead%\WER\
copy /Y %SystemRoot%\system32\winevt\Logs\Microsoft-Windows-WER-Diag%%4Operational.evtx %Dead%\WER\

:: Memory
if %flag%==yes (
    if not exist %Dead%\memory ( mkdir %Dead%\memory )
    if %OS%==64BIT ( %Tools%\winpmem_mini_x64_rc2.exe "%Dead%\memory\%yyyymmdd%_MemoryDump_%ExaminerName%.raw" )
    if %OS%==32BIT ( %Tools%\winpmem_mini_x86.exe "%Dead%\memory\%yyyymmdd%_MemoryDump_%ExaminerName%.raw" )
)

::===========================================================::
::===========================================================::
Rem etc data

:: web browser history
if not exist %etc%\web_browser_history (
    mkdir %etc%\web_browser_history
)
%Tools%\browsinghistoryview\BrowsingHistoryView.exe /LoadIE 1 /LoadFirefox 1 /LoadChrome 1 LoadSafari 1 /HistorySource 1 /VisitTimeFilterType 1 /scomma %etc%\web_browser_history\%yyyymmdd%_localWebBrowserHistory_%ExaminerName%.csv
%Tools%\browsinghistoryview\BrowsingHistoryView.exe /LoadIE 1 /LoadFirefox 1 /LoadChrome 1 LoadSafari 1 /HistorySource 7 /VisitTimeFilterType 1 /scomma %etc%\web_browser_history\%yyyymmdd%_remoteWebBrowserHistory_%ExaminerName%.csv

:: env
if not exist %etc%\env (
    mkdir %etc%\env
)
set > %etc%\env\%yyyymmdd%_envList_%ExaminerName%.txt

:: command hisotry
if not exist %etc%\history (
    mkdir %etc%\history
)
doskey/history > %etc%\history\%yyyymmdd%_cmdHistory_%ExaminerName%.txt

::===========================================================::
cls
echo.
echo.
echo.
echo.
echo ::::::::   ::::::::  ::::    ::::  :::::::::  :::        :::::::::: ::::::::::: :::::::::: 
echo :+:    :+: :+:    :+: +:+:+: :+:+:+ :+:    :+: :+:        :+:            :+:     :+:        
echo +:+        +:+    +:+ +:+ +:+:+ +:+ +:+    +:+ +:+        +:+            +:+     +:+        
echo +#+        +#+    +:+ +#+  +:+  +#+ +#++:++#+  +#+        +#++:++#       +#+     +#++:++#   
echo +#+        +#+    +#+ +#+       +#+ +#+        +#+        +#+            +#+     +#+        
echo #+#    #+# #+#    #+# #+#       #+# #+#        #+#        #+#            #+#     #+#        
echo  ########   ########  ###       ### ###        ########## ##########     ###     ########## 
echo.
echo                                                            --------------------------------
echo                                                              Complete : Collect Artifact 
echo.
echo.
echo.

