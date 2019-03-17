@echo off
REM This batch file packages the project into a Windows executable.
REM Requires Love2d to be installed at default location (C:\Program Files (x86)\LOVE).
REM Requires 7zip to be installed.
set love="C:\Program Files (x86)\LOVE"

REM 7zip it all up first:
7z a -tzip archive.love -r *.lua icon.png placeholders\ -x!CardLayout.lua -x!Cards.lua
mkdir build
copy /Y %love%\*.dll build
copy /b %love%\love.exe+archive.love build\RobCards.exe
copy /y placeholders\empty_CardLayout.lua build\CardLayout.lua
copy /y placeholders\empty_Cards.lua build\Cards.lua
del /F archive.love