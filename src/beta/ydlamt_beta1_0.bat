
@echo off
:checkinstall
echo Welcome to the youtube to mp3 converter!
ping 127.0.0.1 -n 4 > nul
echo This version is beta 1.0!
ping 127.0.0.1 -n 4 > nul
echo "%~dp0"
set CURDRIVE=%cd:~0,2%
set CURDIR=%~dp0
set DOWNFLDR=%CURDIR%down
mkdir mp3
IF EXIST %CURDIR%ffmpeg\bin\* (
	IF EXIST %CURDIR%lame\* (
		IF EXIST %CURDIR%wget\bin\* (
		goto :checkvar
			)
		)
	)
echo You have not installed yet.
pause
goto end
:checkvar
IF "%wgetpath%"==""  (
	SET wgetpath=%CURDIR%wget\bin\
	goto ffmpegpathset
	)
IF NOT "%wgetpath%"==""  (
		echo wgetpath defined
		goto ffmpegpathset
)


:ffmpegpathset
IF "%ffpath%"==""  (
	set ffpath=%CURDIR%ffmpeg\bin\
	setx /M PATH "%PATH%;%CURDIR%ffmpeg\bin\"
	echo ffmpeg defined
	goto lamepathset
)
IF NOT "%ffpath%"==""  (
	echo ffmpeg already defined
	goto lamepathset
)

:lamepathset
IF "%lamepath%"==""  (
	set lamepath=%CURDIR%lame\
	echo lame set
	goto ytdl
)
IF NOT "%lamepath%"==""  (
	echo lame already defined
	goto ytdl
)

:ytdl
set /p ytvideo=Enter the ID of VIDEO or type help for help : 
IF "%ytvideo%"=="help"  (
	echo this is a program for downloading youtube videos or playlists
	echo and convert them to mp3 and add album art
	echo.
	echo -----------------------------------------------------------------------
	echo "`usage : Download Playlists : type playlist                         `"
	echo "`                    Syntax : --playlist-start n1 --playlist-end n2 `"
	echo "`                             (Download videos n1~n2 in playlist)   `"
	echo "`        EXIT SCRIPT : type exit instead of URL                     `"
    echo -----------------------------------------------------------------------
    goto ytdl 
)
IF "%ytvideo%"=="exit" goto end
IF "%ytvideo%"=="playlist" goto dplaylist
mkdir down
cd down
"%CURDIR%"youtube-dl -o %%(title)s.%%(ext)s %ytvideo% --restrict-filenames -x --audio-format mp3
"%CURDIR%"youtube-dl -o %%(title)s.mp3 %ytvideo% --restrict-filenames --get-filename > temp.txt
set /p filename=<temp.txt
::del temp.txt
::%CURDRIVE%
::cd %CURDIR%
cd ..
goto wget
pause

:dplaylist
echo Welcome to the Playlist menu!
set /p ytvideo=Enter the URL of the playlist or help for help :
IF "%ytvideo%"=="help"  (
	echo _____________________________________________________
	echo " syntax : URL --playlist-start n1 --plalist-end n2 "
	echo "                  (download video n1~n2)           "
	echo -----------------------------------------------------
)
mkdir down
cd down
"%CURDIR%"youtube-dl -o %%(title)s.%%(ext)s %ytvideo% --restrict-filenames -x --audio-format mp3
"%CURDIR%"youtube-dl -o %%(title)s.mp3 %ytvideo% --restrict-filenames --get-filename > temp.txt
set /p filename=<temp.txt
::del temp.txt
::%CURDRIVE%
::cd %CURDIR%
goto wget
pause

:wget
cd down
"%wgetpath%wget.exe" i4.ytimg.com/vi/%ytvideo%/maxresdefault.jpg
"%CURDIR%ImageMagick\convert.exe" maxresdefault.jpg -resize 720x720! maxresdefault.jpg
goto lame

:lame
"%lamepath%lame.exe" --ti "%CURDIR%down\maxresdefault.jpg" "%CURDIR%down\%filename%"  "C:\%filename%"
::echo remember to fix this bit!
goto end
:end