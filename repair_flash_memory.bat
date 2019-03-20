@echo off
title Flash Memory Cleaner
color 0A
@echo ---------------------------------
@echo ----   Flash Memory Repair   ----
@echo ---------------------------------
Attrib /d /s -r -h -s *.* 
if exist *.lnk del *.lnk 
if exist autorun.inf del autorun.inf 
@echo ¡CLEAN!
@echo
pause
