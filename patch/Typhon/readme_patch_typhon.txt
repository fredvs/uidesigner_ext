This patch enable complete integration of fpGUI into Typhon.

If you have already a compiled designer_ext, load it and disable "Integration into IDE Typhon" and 
close designer_ext.

1)- Compile desinger_ext.pas
  - Close designer_ext

2)- Depending of your Typhon version, unzip sourcefilemanager_xxx in ~/designer_ext/patch/typhon/

2)- Copy-replace ~/designer_ext/patch/Typhon/sourcefilemanager.pas into ../codetyphon/typhon/ide and rebuild Typhon.
  - Close Typhon

3)- Load designer_ext and, in "Settings", enable "Integration into IDE Typhon".
  - Close designer_ext

Now, you may run Typhon with fpGUI-designer integeration...

Warning : If you want to re-compile designer_ext, first load designer_ext and disable "Integration into IDE Typhon" then close designer_ext.
Compile it (better not run it via Lazarus-run).
After, as stand-alone, re-enable "Integration into IDE Typhon". 

If designer_ext does not load, even as stand-alone, it is surely because a other instance of designer_ext is already running. If so, kill that instance via Ctrl-Alt-Del.

Fred van Stappen
fiens@hotmail.com  

