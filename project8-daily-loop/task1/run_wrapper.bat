@echo off
echo [%date% %time%] Wrapper started >> "D:\Gemini_Cli\Loop-Engineering\project8-daily-loop\task1\scheduler_debug.log"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "D:\Gemini_Cli\Loop-Engineering\project8-daily-loop\task1\daily_lint_loop.ps1" > "D:\Gemini_Cli\Loop-Engineering\project8-daily-loop\task1\scheduler_debug.log" 2>&1
