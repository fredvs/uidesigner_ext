This patch enable complete integration of fpGUI into Lazarus.

If you have already a compiled uidesigner_ext, load it as stand-alone and disable "Integration into IDE Lazarus" then 
close uidesigner_ext.

1)- Compile uidesigner_ext.pas
  - Close uidesigner_ext

2)- Depending of your Lazarus version, unzip main.pp_laz_xxx in ~/uidesigner_ext/patch/Lazarus/

3)- Copy-replace ~/uidesigner_ext/patch/Lazarus/main.pp into ../Lazarus/ide and rebuild Lazarus.
  - Close Lazarus

4)- Load uidesigner_ext and, in "Settings", enable "Integration into IDE Lazarus".
  - Close uidesigner_ext

Now, you may run Lazarus with fpGUI-uidesigner integeration...

Warning : If you want to re-compile uidesigner_ext, first load uidesigner_ext and disable "Integration into IDE Lazarus" then close uidesigner_ext.
Compile it (better not run it via Lazarus-run).
After, as stand-alone, re-enable "Integration into IDE Lazarus".

If uidesigner_ext do not load, even as stand-alone, it is surely because a other instance of uidesigner_ext is already running. If so, kill that instance via Ctrl-Alt-Delete.

Fred van Stappen
fiens@hotmail.com  
