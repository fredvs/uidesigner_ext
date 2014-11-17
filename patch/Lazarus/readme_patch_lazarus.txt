This patch enable complete integration of fpGUI into Lazarus.

WARNING => The IDE integration is working, for now, only in Linux.

If you have already a compiled designer_ext, load it as stand-alone and disable "Integration into IDE Lazarus" then 
close designer_ext.

1)- Compile designer_ext.pas
  - Close designer_ext

2)- Depending of your Lazarus version, unzip main.pp_laz_xxx in ~/designer_ext/patch/Lazarus/

3)- Copy-replace ~/designer_ext/patch/Lazarus/main.pp into ../Lazarus/ide and rebuild Lazarus.
  - Close Lazarus

4)- Load designer_ext and, in "Settings", enable "Integration into IDE Lazarus".
  - Close designer_ext

Now, you may run Lazarus with fpGUI-designer integeration...

Warning : If you want to re-compile designer_ext, first load designer_ext and disable "Integration into IDE Lazarus" then close designer_ext.
Compile it (better not run it via Lazarus-run).
After, as stand-alone, re-enable "Integration into IDE Lazarus".

If designer_ext does not load, even as stand-alone, it is surely because a other instance of designer_ext is already running. If so, kill that instance via Ctrl-Alt-Delete.

Fred van Stappen
fiens@hotmail.com  
