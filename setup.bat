@echo off
REM ========================================
REM Setup wizard entry
REM Usage: double-click setup.bat or run in cmd
REM uv if available, otherwise Python's built-in venv.
REM Chinese messages are printed by setup.py (encoding-safe)
REM ========================================
cd /d "%~dp0"

REM --- Prefer uv when it is on PATH ---
where uv >nul 2>nul
if %ERRORLEVEL% EQU 0 goto :have_uv

REM --- No uv: fall back to system Python ---
where python >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Neither uv nor Python found. Please install Python 3.10+ from:
    echo         https://www.python.org/downloads/
    echo         and check "Add python.exe to PATH" during install.
    pause
    exit /b 1
)
echo [*] uv not found, using Python built-in venv.
goto :have_python

:have_uv
REM --- Create virtual environment if missing ---
if not exist ".venv\Scripts\python.exe" (
    echo [1/3] Creating virtual environment with uv...
    uv venv
)

REM --- Install dependencies ---
echo [2/3] Installing dependencies with uv...
uv pip install -r requirements.txt -q
if %ERRORLEVEL% NEQ 0 goto :dep_fail
goto :wizard

:have_python
REM --- Create virtual environment if missing ---
if not exist ".venv\Scripts\python.exe" (
    echo [1/3] Creating virtual environment...
    python -m venv .venv
)

REM --- Install dependencies ---
echo [2/3] Installing dependencies...
".venv\Scripts\python.exe" -m pip install -r requirements.txt -q
if %ERRORLEVEL% NEQ 0 goto :dep_fail
goto :wizard

:dep_fail
echo [ERROR] Failed to install dependencies. Check your network connection.
pause
exit /b 1

:wizard
REM --- Run setup wizard ---
echo [3/3] Running setup wizard...
".venv\Scripts\python.exe" setup.py
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo Setup completed with warnings. Please read the output above.
)

pause
