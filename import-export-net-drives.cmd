REM this is cmd version of the powershell script i tried to develop
REM then just pasted in some else's solution
REM I think this way might be easier for me

REM start with some net use with a "find" filter
REM net use | find /i "OK"
REM for whatever reason on my PC there are two network drives defined that 
REM do not have drive letters associated with them
REM although this is unlikely to be the case on any other computers
REM I'm still going to check for the possibility

REM for exporting we'll take this output and send it to a text file
REM pretty quick and easy
net use | find /i ":" > exported-map-drives.txt 
REM now the hard part: importing those drives back in
REM I'm going to use a for-loop to iterate through
REM using my own repo as a reference course because why not
REM https://github.com/tildesarecool/advib/blob/master/advib.cmd

REM this is probably necessary
setlocal EnableDelayedExpansion

set tracker=0

for /f "usebackq tokens=3 delims= " %%i in (`letterlist.txt`) do (set /a _letters(%tracker%+=1) )




REM set DRIVELET=
REM set DRIVEPATH=

REM would be a better idea to do an if exist but we're just doing a rough draft right now
REM for /f "usebackq tokens=2 delims= " %%i in (`type exported-map-drives.txt`) do (set DRIVELET=%%i &&  call :NETPATHS)
REM for /f "usebackq tokens=2 delims= " %%i in (`type exported-map-drives.txt`) do ((set DRIVELET=%%i) &&  (for /f "usebackq tokens=3 delims= " %%j in (`type exported-map-drives.txt`) do (set DRIVEPATH=%DRIVEPATH% && echo value of DRIVELET is %DRIVELET% and DRIVEPATH is %%j)) )
REM for /f "usebackq tokens=2 delims= " %%i in (`type exported-map-drives.txt`) do (echo %%i >> driveletterlist.txt)
REM type driveletterlist.txt
pause 
REM for /f "usebackq tokens=3 delims= " %%j in (`type exported-map-drives.txt`) do (echo %%j >> netpaths.txt)
type netpaths.txt
pause 



REM :DRIVLETSUB
REM echo value is %DRIVELET%
REM for /f "usebackq tokens=3 delims= " %%j in (`type exported-map-drives.txt`) do (set DRIVEPATH=%%j)

REM echo value of DRIVELET is %DRIVELET% and DRIVEPATH is %DRIVEPATH%


REM :NETPATHS
REM echo %DRIVELET%
REM for /f "usebackq tokens=3 delims= " %%j in (`type exported-map-drives.txt`) do (set DRIVEPATH=%%j && call echo value of DRIVELET is %DRIVELET% and DRIVEPATH is %DRIVEPATH%)


REM :MAPDRIVES
REM echo value of DRIVELET is %DRIVELET% and DRIVEPATH is %DRIVEPATH%
REM net use %DRIVELET% %DRIVEPATH% /persistent:yes