@echo off
SETLOCAL ENABLEDELAYEDEXPANSION
SET old=_Square_0.png
set new=.png
for /f "tokens=*" %%f in ('dir /b *.png') do (
  SET newname=%%f
  SET newname=!newname:%old%=%new%!
  move "%%f" "!newname!"
)