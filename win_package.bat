@echo off
REM This batch file packages the project into a Windows executable.
REM Requires Love2d to be installed at default location (C:\Program Files (x86)\LOVE).
REM Requires 7zip to be installed.
set love="C:\Program Files (x86)\LOVE"
set rh="C:\resource_hacker\ResourceHacker.exe"

REM Clean up previous build
rmdir /S /Q build
mkdir build

REM Create .love zip archive
7z a -tzip archive.love -r *.lua icon.png placeholders\ -x!CardLayout.lua -x!Cards.lua

REM Copy Love2D DLLs and append the archive with the love executable
copy /Y %love%\*.dll build
copy /b %love%\love.exe+archive.love build\RobCards.exe
del /F archive.love

REM Optionally changing the exe icon if ResourceHacker is installed
%rh% -open build\RobCards.exe -save build\RobCards.exe -action addoverwrite -res windowsIcon.ico -mask ICONGROUP,MAINICON,0

REM Copy placeholder layout and definition files
copy /y placeholders\empty_CardLayout.lua build\CardLayout.lua
copy /y placeholders\empty_Cards.lua build\Cards.lua

REM Drop a real helpful readme into the build
echo For help / tutorial, see: https://mythricia.github.io/RobCards/tutorial.html> build\Readme.txt

REM Zip it all up and clean up
cd /d build
7z a -tzip -sdel RobCards.zip *.*