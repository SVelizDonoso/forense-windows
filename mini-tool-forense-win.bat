@echo off
cls
color 0A
echo **************************************************************************
echo                Toolkit Forense para Windows
echo.
echo **************************************************************************
echo.
echo Objetivos del Script
echo.
echo Extraer informacion volatil y no volatil en sistemas Windows
echo Analizar, revisar e instalar el software para proteccion de las comunicaciones
echo entre la maquina comprometida y el equipo forense.
echo.
echo.
mkdir evidencias
set PWD=”%cd%”
set EV=%PWD%\evidencias
set SW=%PWD%\software

NET SESSION >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
echo Permisos de ejecucion correctos.
echo.
) ELSE (
color 04
echo AVISO : Se necesitan privilegios de administrador
echo para ejecutar este programa. Saliendo…
echo.
pause
exit 1
)

set PWD=”%cd%”
if %PWD%==”C:\windows\system32″ (
color 04
echo AVISO: No ejecutes este script haciendo doble click sobre el script.
echo la forma correcta es Abrir una consola en modo administrador y accede a la ruta donde este ejecutable está localizado.
echo.
pause
exit 1
)

echo *****************************************************************
echo                  INFORMACION VOLATIL
echo.
echo Obteniendo Hora del sistema…
date /t > %EV%\FechaYHoraDeInicio.txt &time /t >> %EV%\FechaYHoraDeInicio.txt
echo.
echo OK!
echo.
echo Obteniendo Volcado de memoria…
%SW%\DumpIt.exe
move /y *.raw \%EV%
echo.
echo OK!
echo.
echo  obtener el listado de procesos en ejecucion…
tasklist > “%EV%\ProcesosEnEjecución-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.txt”
echo.
echo OK!
echo.
echo  Obtener Servicios en ejecucion…
sc query > “%EV%\ServiciosEnEjecución-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.txt”
echo.
echo OK!
echo.
echo  Obtener Usuarios que han iniciado sesion…
%SW%\netUsers.exe > “%EV%\UsuariosActualmenteLogueados-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.txt”
echo.
echo OK!
echo.
echo  Obtener listado de cuentas de usuario…
%SW%\netUsers.exe /History > “%EV%\HistoricoUsuariosLogueados-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.txt”
echo.
echo OK!
echo.
echo  Obtener Estado de la red…
ipconfig /all > “%EV%\EstadoDeLaRed-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.txt”
echo.
echo OK!
echo.
echo Obtener Conexiones NetBIOS establecidas
nbtstat -S > “%EV%\ConexionesNetBIOSEstablecidas-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.txt
net sessions > “%EV%\SesionesRemotasEstablecidas-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.txt”
echo OK!
echo.
echo Obtener Archivos transferidos recientemente mediante NetBIOS
net file > “%EV%\FicherosCopiadosMedianteNetBIOS%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.txt”
echo OK!
echo.
echo Obtener Conexiones activas o puertos abiertos
netstat -an |findstr /i “estado listening established” > “%EV%\PuertosAbiertos-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.txt”
echo OK!
echo.
echo Obtener Conexiones activas con aplicaciones
netstat -anob > “%EV%\AplicacionesConPuertosAbiertos-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.txt”
echo OK!
echo.
echo Obtener Contenido de la caché DNS
ipconfig /displaydns > “%EV%\DNSCache-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.txt”
echo OK!
echo.
echo Obtener ARP cache
arp -a > “%EV%\ArpCache-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.txt”
echo OK!
echo.
echo Obtener Registro de Windows
reg export HKEY_CLASSES_ROOT “%EV%\HKCR-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.reg”
reg export HKEY_CURRENT_USER “%EV%\HKCU-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.reg”
reg export HKEY_LOCAL_MACHINE “%EV%\HKLM-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.reg”
reg export HKEY_USERS “%EV%\HKU-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.reg”
reg export HKEY_CURRENT_CONFIG “%EV%\HKCC-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.reg”
echo OK!
echo.
echo Obtener Dispositivos USB
reg export “HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\USBSTOR” “%EV%\USBSTOR-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.reg”
reg export “HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\USB” “%EV%\USB-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.reg”
reg export “HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\DeviceClasses” “%EV%\DeviceClasses-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.reg”
reg export “HKEY_LOCAL_MACHINE\System\MountedDevices” “%EV%\MountedDevices-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.reg”
echo OK!
echo.
echo Obtener Listado de redes WIFI a las que se ha conectado un equipo
netsh wlan show profiles > “%EV%\PerfilesWifi-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.txt”
netsh wlan show all > “%EV%\ConfiguraciónPerfilesWifi-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.txt”
echo OK!
echo.
echo Obtener Configuración de Windows Security Center / Windows Action Center
reg export “HKEY_LOCAL_MACHINE\Software\Microsoft\Security Center” “%EV%\HKLM-SecurityCenter-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.reg”
reg export “HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ActionCenter” “%EV%\HKLM-ActionCenter-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.reg”
echo OK!
echo.
echo Obtener Configuración del firewall
reg export “HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy” “%EV%\HKLM-FirewallPolicy-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.reg”
echo OK!
echo.
echo Obtener Programas que se ejecutan al iniciar el sistema operativo
reg export “HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders” “%EV%\HKCU-ShellFolders-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.reg”
reg export “HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders” “%EV%\HKCU-UserShellFolders-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.reg”
reg export “HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run” “%EV%\HKCURun-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.reg”
reg export “HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\RunOnce” “%EV%\HKCU-RunOnce-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.reg”
reg export “HKEY_CURRENT_USER\Software\Microsoft\WindowsNT\CurrentVersion\Windows” “%EV%\HKCU-Windows-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.reg”
reg export “HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders” “%EV%\HKLM-ShellFolders-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.reg”
reg export “HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders” “%EV%\HKLM-UserShellFolders-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.reg”
reg export “HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer” “%EV%\HKLM-Explorer-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.reg”
reg export “HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run” “%EV%\HKLM-Run-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.reg”
reg export “HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\RunOnce” “%EV%\HKLM-RunOnce-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.reg”
reg export “HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\SessionManager” “%EV%\HKLM-SessionManager-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.reg”
echo OK!
echo.
echo Obtener Extensiones de Archivos y programas asociados para abrirlos
for %%t in (batfile cmdfile comfile exefile htafile https JSEfilepiffile regfile scrfile txtfile VBSfile WSFFile) do (
reg export “HKEY_CLASSES_ROOT\%%t\shell\open\command” “%EV%\HKCR-%%t-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.reg”
)
for %%t in (batfile comfile exefile piffile) do (
reg export “HKEY_LOCAL_MACHINE\software\Classes\%%t\shell\open\command” “%EV%\HKLM-%%t-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.reg”
)
echo OK!
echo.
echo Obtener Asociaciones de archivos con depuradores
reg export “HKEY_LOCAL_MACHINE\Software\Microsoft\WindowsNT\CurrentVersion\Image File Execution Options” “%EV%\HKLM-IFEO-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.reg”
echo OK!
echo.
echo Obtener Browser Helper Objects (BHO)
reg export “HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects” “%EV%\BHOs-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.reg”
echo OK!
echo.
echo Obtener MUICache
reg export “HKEY_CURRENT_USER\Software\Classes\LocalSettings\Software\Microsoft\Windows\Shell\MuiCache” “%EV%\MUICache-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.reg”
echo OK!
echo.
echo Obtener LastVisitedMRU / LastVisitedPidlMRU
reg export “HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRU” “%EV%\LastVisitedPidIMRU-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.reg”
echo OK!
echo.
echo Obtener OpenSaveMRU
reg export
“HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSavePidlMRU” “%EV%\OpenSavePidlMRU-%date:~6,4%%date:~3,2%%date:~0,2%-
%time:~0,2%%time:~3,2%.reg”
echo OK!
echo.
echo Obtener Archivos abiertos recientemente
reg export “HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs” “%EV%\RecentDocs-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.reg”
echo OK!
echo.
echo Obtener Software instalado
reg export “HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Uninstall” “%EV%\SoftwareInstalado-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.reg”
echo OK!
echo.
echo Obtener Información cacheada en los navegadores
copy %UserProfile%\AppData\Local\Google\Chrome\User Data\Default\WebData %EV%\WebData
copy %UserProfile%\AppData\Roaming\Mozilla\Firefox\Profiles\<random>.default\formhistory.sqlite %EV%\formhistory.sqlite
%SW%\IECacheView.exe /stab “%EV%\IECache-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.txt”
echo OK!
echo.
echo Obtener Arbol de directorios y Archivos
dir /t:w /a /s /o:d c:\ > “%EV%\ListadoFicherosPorFechaDeModificacion-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.txt”
dir /t:a /a /s /o:d c:\ > “%EV%\ListadoFicherosPorUltimoAcceso-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.txt”
dir /t:c /a /s /o:d c:\ > “%EV%\ListadoFicherosPorFechaDeCreacion-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.txt”
echo OK!
echo.
echo Obtener Historico del interprete de comandos
doskey /history > “%EV%\HistoricoCMD-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.txt”
echo OK!
echo.
echo Obtener Unidades mapeadas
net use > “%EV%\UnidadesMapeadas-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.txt”
echo OK!
echo.
echo Obtener Carpetas compartidas
net share > “%EV%\CarpetasCompartidas-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.txt”
echo.
echo Obtener USB
%SW%\USBDeview.exe /shtml %EV%\USBs-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%
echo OK!
echo.

echo *****************************************************************
echo                  INFORMACION NO VOLATIL
echo.

echo Obtener Información del sistema
systeminfo > “%EV%\InformaciónDelSistema-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.txt”
echo OK!
echo.
echo Tareas programadas
schtasks > “%EV%\TareasProgramadas-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.txt”
echo OK!
echo.
echo Obtener Variables de entorno
path > “%EV%\VariablesDeEntorno-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.txt”
echo OK!
echo.
echo Obtener Logs del sistema
wevtutil epl application “%EV%\Application-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.evtx”
wevtutil epl system “%EV%\System-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.evtx”
wevtutil epl security “%EV%\Security-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.evtx”
echo OK!
echo.
echo Obtener Archivo hosts
type c:\windows\system32\drivers\etc\hosts > “%EV%\FicheroHosts-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.txt”
echo OK!
echo.
echo Obtener Comprobar los ejecutables que no estén firmados
sigcheck -ct -h -vn -vt c:\Windows > “%EV%\FicherosFirmados-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.txt”
sigcheck -ct -h -vn -vt c:\Windows\System32 > “%EV%\FicherosFirmadosWindows-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.txt”
echo OK!
echo.
echo Obtener nivel de parcheado del servidor…
wmic /output:%EV%/installed.updates.%COMPUTERNAME%.csv qfe get /format:csv
echo OK!
echo.
echo Obtener Ip sistema y conf red
ipconfig /allcompartments /all > “%EV%\IP-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.txt”
echo OK!
echo.
echo Obtener Lista DLL
listdlls > “%EV%\DLL-%date:~6,4%%date:~3,2%%date:~0,2%-%time:~0,2%%time:~3,2%.txt”
echo OK!
Pause
echo.
echo.
pause