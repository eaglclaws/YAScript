
:checkinstall
echo "%~dp0"
set CURDRIVE=%cd:~0,2%
set CURDIR=%~dp0
IF EXIST "C:\down\ffmepg\bin\ffmpeg.exe" (
	::IF EXIST C:\down\lame\lame.exe (
	::	IF EXIST C:\down\wget\bin\wget.exe (
			goto :checkvar
	::		)
	::	)
	)
echo You have not installed yet.
pause
goto end
:checkvar
IF "%wgetpath%"==""  (
	SET wgetpath=%CURDIR%wget\
	goto ffmpegpathset
)
IF NOT "%wgetpath%"==""  (
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
	echo -----------------------------------------------------------------------
	echo "`usage : Download Playlists : Enter URL of playlist                 `"
	echo "`                    Syntax : --playlist-start n1 --playlist-end n2 `"
	echo "`                             (Download videos n1~n2 in playlist)   `"
	echo "`        EXIT SCRIPT : type exit instead of URL                     `"
    echo -----------------------------------------------------------------------
    goto ytdl 
)
IF "%ytvideo%"=="exit" goto end
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

:end