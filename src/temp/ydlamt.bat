:checkinstall
echo "%~dp0"
set CURDRIVE=%cd:~0,2%
set CURDIR=%~dp0
pause
goto checkvar
:checkvar
IF "%wgetpath%"==""  (
	SET wgetpath=%CURDIR%wget\
	Echo THIS
	Echo Test
	Echo worked
	goto ffmpegpathset
)
IF NOT "%wgetpath%"==""  (
	ECHO MyVar IS defined
	ECHO YAY!
	goto ffmpegpathset
)


:ffmpegpathset
IF "%ffpath%"==""  (
	set ffpath=%CURDIR%ffmpeg\bin\
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
set /p ytvideo=Enter the URL of VIDEO or PLAYLIST or type help for help : 
IF "%ytvideo%"=="help"  (
	echo this is a program for downloading youtube videos or playlists
	echo and convert them to mp3 and add album art
	echo.
	echo ---------------------------------------------------------------------
	echo "`usage : Download Playlists : Enter URL of playlist                 "
	echo "`                    Syntax : --playlist-start n1 --playlist-end n2 "
	echo "`                             (Download video n1~n2 in playlist)    " 
    echo ---------------------------------------------------------------------
    goto ytdl 
)
C:
mkdir down
cd C:\down\
goto subroutine
:subroutine
youtube-dl -o %%(title)s.%%(ext)s %ytvideo% -x --audio-format mp3
%CURDRIVE%
cd %CURDIR%
goto wget
pause