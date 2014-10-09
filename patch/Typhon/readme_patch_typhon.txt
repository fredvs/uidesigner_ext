This patch enable complete integration of fpGUI into Typhon.

If you have already a compiled uidesigner_ext, load it and disable "Integration into IDE Typhon" and 
close uidesigner_ext.

1)- Compile uidesinger_ext.pas
  - Close uidesigner_ext

2)- Depending of your Typhon version, unzip sourcefilemanager_xxx in ~/uidesigner_ext/patch/typhon/

2)- Copy-replace ~/uidesigner_ext/patch/Typhon/sourcefilemanager.pas into ../codetyphon/typhon/ide and rebuild Typhon.
  - Close Typhon

3)- Load uidesigner_ext and, in "Settings", enable "Integration into IDE Typhon".
  - Close uidesigner_ext

Now, you may run Typhon with fpGUI-uidesigner integeration...

Warning : If you want to re-compile uidesigner_ext, first load uidesigner_ext and disable "Integration into IDE Typhon" then close uidesigner_ext.
Compile it (better not run it via Lazarus-run).
After, as stand-alone, re-enable "Integration into IDE Typhon". 

If uidesigner_ext does not load, even as stand-alone, it is surely because a other instance of uidesigner_ext is already running. If so, kill that instance via Ctrl-Alt-Del.

Fred van Stappen
fiens@hotmail.com  

