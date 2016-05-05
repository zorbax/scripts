@echo off
title Memoria Flash 
color 0A
@echo ----------------------------------------------
@echo ---- REPARACION DE FICHEROS MEMORIA FLASH ----
@echo ----------------------------------------------
@echo Changing folder attributes
Attrib /d /s -r -h -s *.* 
@echo ----------------------------------------------
@echo Removing Sym Links
if exist *.lnk del *.lnk 
@echo ----------------------------------------------
@echo Deleting Autorun
if exist autorun.inf del autorun.inf 
@echo ----------------------------------------------
@echo OK...
@echo ----------------------------------------------
@echo ----------------------------------------------
@echo u_u  
@echo ----------------------------------------------
@echo ----------------------------------------------
@echo
pause