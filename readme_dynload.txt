- For dynamic loading of Xlib and Xft.

  Please, copy + paste all files in /src/dynX11 into /src.

  Also, depend of the fpGui branch you are using,
  copy + paste all files in /src/xxx_dynx11 into /src.

  Edit define.inc and uncomment {$DEFINE DYNLOAD}

- For static loading of Xlib and Xft.
  Delete all files in /src that are also in /src/dynX11. 
  Delete all files in /src that are also in /src//src/xxx_dynx11.
  Edit define.inc and comment {$.DEFINE DYNLOAD}

By default, designer_ext use fpGUI-maint 1.4 branch and dynamic loading of Xlib and Xft.