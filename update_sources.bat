@echo off

echo.
echo ----------------------------------------------------------------------------------
echo Usage :
echo   1/ update des sources Gemeo sans build
echo     ^> update_sources.bat
echo   2/ update des sources Gemeo + build maven
echo     ^> update_sources.bat maven
echo   3/ update des sources Gemeo + build maven + update gim
echo     ^> update_sources.bat maven gim
echo   4/ update des sources Gemeo + update Digital Offer  (sans build maven de Gemeo)
echo     ^> update_sources.bat maven digital_offer
echo ----------------------------------------------------------------------------------

echo. 
echo Update des projets Gemeo ... 

set HOME_PROJETS=%HOME%/projets
set GEMEO_HOME=%HOME_PROJETS%/gemeo
set MAVEN_OPTS=-Xmx512m -XX:MaxPermSize=128m

echo. 
echo -- GEMEO -- 
cd %GEMEO_HOME%
call svn up Application
call svn up Batchs\trunk
REM svn up Batchs\GemeoInterfacesTMA
REM svn up Batchs\GemeoInterfaces
REM svn up Batchs\ExtractionsXML
call svn up QueryRunner\trunk
call svn up GemeoWAT\trunk
call svn up Application-7.2.X
call svn up Application-7.4.X


if "%1" == "maven" ( goto :maven )
if "%2" == "maven" ( goto :maven )
if "%3" == "maven" ( goto :maven )
if "%4" == "maven" ( goto :maven )
:fin-maven

if "%1" == "cleanup" ( goto :cleanup )
if "%2" == "cleanup" ( goto :cleanup )
if "%3" == "cleanup" ( goto :cleanup )
if "%4" == "cleanup" ( goto :cleanup )
:fin-cleanup

if "%1" == "digital_offer" ( goto :digital_offer )
if "%2" == "digital_offer" ( goto :digital_offer )
if "%3" == "digital_offer" ( goto :digital_offer )
if "%4" == "digital_offer" ( goto :digital_offer )
:fin-digital_offer

if "%1" == "gim" ( goto :gim )
if "%2" == "gim" ( goto :gim )
if "%3" == "gim" ( goto :gim )
if "%4" == "gim" ( goto :gim )
:fin-gim


goto :fin



:maven
echo. 
echo  MAVEN 1 : Build de l'Application Web ............
echo. 
cd %GEMEO_HOME%/Application
echo   Le repetoire courant est : %cd%
call mvn clean install  -Declipselink.home=C:/tools/eclipselink-2.3.3 -Dversion.suffix=-local
REM call mvn clean install  -Declipselink.home=C:/tools/eclipselink-2.3.3 -Dversion.suffix=-local -DskipTests
echo. 
echo  MAVEN 1 : Fin build.
echo. 
echo. 
echo. 
echo  MAVEN 2 : Build des Batchs ............
echo. 
cd %GEMEO_HOME%\Batchs\trunk
echo   Le repetoire courant est : %cd%
call mvn clean install -Declipselink.home=C:/tools/eclipselink-2.3.3 -Dversion.suffix=-local
REM call mvn clean install -Declipselink.home=C:/tools/eclipselink-2.3.3 -Dversion.suffix=-local -DskipTests
echo. 
echo  MAVEN 2 : Fin build.
echo. 
goto :fin-maven


:cleanup
echo. 
echo SVN CLEANUP : Debut ............
echo. 
cd %GEMEO_HOME%
echo cleanup Application
call svn cleanup %GEMEO_HOME%\Application

echo cleanup Batchs\trunk
call svn cleanup %GEMEO_HOME%\Batchs\trunk

REM echo cleanup Batchs\GemeoInterfacesTMA
REM svn cleanup %GEMEO_HOME%\Batchs\GemeoInterfacesTMA

REM echo cleanup Batchs\GemeoInterfaces
REM svn cleanup %GEMEO_HOME%\Batchs\GemeoInterfaces

REM echo cleanup Batchs\ExtractionsXML
REM svn cleanup %GEMEO_HOME%\Batchs\ExtractionsXML

echo cleanup QueryRunner\trunk
call svn cleanup %GEMEO_HOME%\QueryRunner\trunk

echo cleanup GemeoWAT\trunk
call svn cleanup %GEMEO_HOME%\GemeoWAT\trunk

echo cleanup Application-7.2.X
call svn cleanup %GEMEO_HOME%\Application-7.2.X

echo cleanup Application-7.4.X
call svn cleanup %GEMEO_HOME%\Application-7.4.X
echo. 
echo  SVN CLEANUP : Fin.
echo. 
goto :fin-cleanup


:digital_offer
echo. 
echo -- DIGITAL OFFER -- 
cd %HOME_PROJETS%
call svn up digital_offer\DIGITAL-OFFER
call svn up digital_offer\database
goto :fin-digital_offer


:gim
echo. 
echo -- SUIVI DES IMPRESSIONS -- 
cd %HOME_PROJETS%\suivi-impression 
call git -c core.quotepath=false fetch origin --progress --prune 
call git -c core.quotepath=false merge --no-stat -v origin/master
goto :fin-gim


:fin
echo.
echo FIN DE MISE A JOUR DES SOURCES
