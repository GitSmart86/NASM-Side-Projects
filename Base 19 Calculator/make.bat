@echo off

REM call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvars64.bat"
call "D:\Program Files\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvars64.bat"

nasm -g -f win64 grok.asm || goto :eof

cl /Zi grok.obj msvcrt.lib legacy_stdio_definitions.lib || goto :eof

echo OK
