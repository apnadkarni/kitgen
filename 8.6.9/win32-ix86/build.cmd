set TWAPIVER=4.3.5

IF ".%1" == ".full" goto build_full
IF ".%1" == ".minimal" goto build_minimal
IF ".%1" == ".notwapi" goto build_notwapi
IF ".%1" == "." goto build_full

ECHO Unknown option "%1". Must be "minimal", "full" (default), or "plain"

:build_notwapi
:: twapi-less tclkits
PAUSE Building twapi-less version
nmake lite VERSION=86 UPX=0 KITOPTS="-e -m -z" PARTS="vqtcl vfs"
ECHO file rename tclkit-gui.exe tclkit-gui-[string map {. _ amd64 x64 intel x86} "[info patchlevel]-$tcl_platform(machine)"].exe | tclkit-cli.exe
REM We use this roundabout way to do the rename/link because tclkit-cli cannot link to itself due to interference from tclvfs
FSUTIL hardlink create tclkit-cli-temp.exe tclkit-cli.exe
REM Do not use rename below instead of link. It will fail, again thanks to tclvfs
ECHO file rename tclkit-cli.exe tclkit-cli-[string map {. _ amd64 x64 intel x86} "[info patchlevel]-$tcl_platform(machine)"].exe | tclkit-cli-temp.exe
DEL tclkit-cli-temp.exe
exit /b 0

:build_full
PAUSE Building full version
SET kittype=max
nmake lite VERSION=86 UPX=0 KITOPTS="-e -m -z" PARTS="vqtcl vfs" TWAPILIBDIR=d:\src\twapi\twapi\releases\dist-%TWAPIVER%\twapi-lib 
goto done

:build_minimal
PAUSE Building minimal version
SET kittype=min
nmake lite VERSION=86 UPX=0 KITOPTS="-E" PARTS="vqtcl vfs" TWAPILIBDIR=D:\src\twapi\twapi\releases\dist-%TWAPIVER%\twapi-lib 

:done
ECHO package require twapi ; file rename tclkit-gui.exe tclkit-gui-[string map {. _ amd64 x64 intel x86} "[info patchlevel]-twapi-[twapi::get_version -patchlevel]-$tcl_platform(machine)"]-%kittype%.exe | tclkit-cli.exe
REM We use this roundabout way to do the rename/link because tclkit-cli cannot link to itself due to interference from tclvfs
FSUTIL hardlink create tclkit-cli-temp.exe tclkit-cli.exe
REM Do not use rename below instead of link. It will fail, again thanks to tclvfs
ECHO package require twapi ; file rename tclkit-cli.exe tclkit-cli-[string map {. _ amd64 x64 intel x86} "[info patchlevel]-twapi-[twapi::get_version -patchlevel]-$tcl_platform(machine)"]-%kittype%.exe | tclkit-cli-temp.exe
DEL tclkit-cli-temp.exe

