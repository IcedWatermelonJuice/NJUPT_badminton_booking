@echo off
REM ============================================================
REM  NJUPT badminton booking - daily pipeline
REM    1) refresh token (forced)
REM    2) keep current plan, or change courts via configure.py
REM    3) book.py  (waits until 12:00 by itself, then fires)
REM
REM  ASCII only on purpose: Chinese text in a .bat breaks under
REM  the GBK code page (same reason setup.bat/run.bat are ASCII).
REM ============================================================

setlocal
cd /d "%~dp0"

set "PY=%~dp0.venv\Scripts\python.exe"
if not exist "%PY%" set "PY=python"

echo.
echo [1/3] refreshing token ^(open WeChat mini program, go to the venue page^)
echo.
"%PY%" capture_token.py --refresh

echo.
echo [2/3] booking plan
choice /c 12 /n /m "[1] keep current plan   [2] change courts: "
if errorlevel 2 "%PY%" configure.py

echo.
echo [3/3] starting booking timer ^(waits for 12:00, keep this window open^)
echo.
"%PY%" book.py

echo.
pause
