{ This is the dynamic loader header of xlib library.
  It includes xatom.pp and xutil.pp.
  Use x_load() to dynamically load libX11.so.6
  Fredvs ---> fiens@hotmail.com
}  
unit xlib;

interface
{$mode objfpc}{$H+}

uses
 dynlibs, ctypes, keysym, x ;
{$define MACROS}

{.$define initload} // uncomment if you want to load at init

 const
     libX11='libX11.so.6';
 
type
  PPcint = ^Pcint;
  PPcuchar = ^Pcuchar;

{$PACKRECORDS C}

const
   XlibSpecificationRelease = 6;
type

   PXPointer = ^TXPointer;
   TXPointer = ^char;
   PBool = ^TBool;
   { We cannot use TBool = LongBool, because Longbool(True)=-1, 
     and that is not handled well by X. So we leave TBool=cint; 
     and make overloaded calls with a boolean parameter. 
     For function results, longbool is OK, since everything <>0 
     is interpreted as true, so we introduce TBoolResult. }
   TBool = cint;
   TBoolResult = longbool;
   PStatus = ^TStatus;
   TStatus = cint;

const
   QueuedAlready = 0;
   QueuedAfterReading = 1;
   QueuedAfterFlush = 2;

type

   PPXExtData = ^PXExtData;
   PXExtData = ^TXExtData;
   TXExtData = record
        number : cint;
        next : PXExtData;
        free_private : function (extension:PXExtData):cint;cdecl;
        private_data : TXPointer;
     end;

   PXExtCodes = ^TXExtCodes;
   TXExtCodes = record
        extension : cint;
        major_opcode : cint;
        first_event : cint;
        first_error : cint;
     end;

   PXPixmapFormatValues = ^TXPixmapFormatValues;
   TXPixmapFormatValues = record
        depth : cint;
        bits_per_pixel : cint;
        scanline_pad : cint;
     end;

   PXGCValues = ^TXGCValues;
   TXGCValues = record
        _function : cint;
        plane_mask : culong;
        foreground : culong;
        background : culong;
        line_width : cint;
        line_style : cint;
        cap_style : cint;
        join_style : cint;
        fill_style : cint;
        fill_rule : cint;
        arc_mode : cint;
        tile : TPixmap;
        stipple : TPixmap;
        ts_x_origin : cint;
        ts_y_origin : cint;
        font : TFont;
        subwindow_mode : cint;
        graphics_exposures : TBool;
        clip_x_origin : cint;
        clip_y_origin : cint;
        clip_mask : TPixmap;
        dash_offset : cint;
        dashes : cchar;
     end;

   PXGC = ^TXGC;
   TXGC = record
     end;
   TGC = PXGC;
   PGC = ^TGC;

   PVisual = ^TVisual;
   TVisual = record
        ext_data : PXExtData;
        visualid : TVisualID;
        c_class : cint;
        red_mask, green_mask, blue_mask : culong;
        bits_per_rgb : cint;
        map_entries : cint;
     end;

   PDepth = ^TDepth;
   TDepth = record
        depth : cint;
        nvisuals : cint;
        visuals : PVisual;
     end;
   PXDisplay = ^TXDisplay;
   TXDisplay = record
     end;

   PScreen = ^TScreen;
   TScreen = record
        ext_data : PXExtData;
        display : PXDisplay;
        root : TWindow;
        width, height : cint;
        mwidth, mheight : cint;
        ndepths : cint;
        depths : PDepth;
        root_depth : cint;
        root_visual : PVisual;
        default_gc : TGC;
        cmap : TColormap;
        white_pixel : culong;
        black_pixel : culong;
        max_maps, min_maps : cint;
        backing_store : cint;
        save_unders : TBool;
        root_input_mask : clong;
     end;

   PScreenFormat = ^TScreenFormat;
   TScreenFormat = record
        ext_data : PXExtData;
        depth : cint;
        bits_per_pixel : cint;
        scanline_pad : cint;
     end;

   PXSetWindowAttributes = ^TXSetWindowAttributes;
   TXSetWindowAttributes = record
        background_pixmap : TPixmap;
        background_pixel : culong;
        border_pixmap : TPixmap;
        border_pixel : culong;
        bit_gravity : cint;
        win_gravity : cint;
        backing_store : cint;
        backing_planes : culong;
        backing_pixel : culong;
        save_under : TBool;
        event_mask : clong;
        do_not_propagate_mask : clong;
        override_redirect : TBool;
        colormap : TColormap;
        cursor : TCursor;
     end;

   PXWindowAttributes = ^TXWindowAttributes;
   TXWindowAttributes = record
        x, y : cint;
        width, height : cint;
        border_width : cint;
        depth : cint;
        visual : PVisual;
        root : TWindow;
        c_class : cint;
        bit_gravity : cint;
        win_gravity : cint;
        backing_store : cint;
        backing_planes : culong;
        backing_pixel : culong;
        save_under : TBool;
        colormap : TColormap;
        map_installed : TBool;
        map_state : cint;
        all_event_masks : clong;
        your_event_mask : clong;
        do_not_propagate_mask : clong;
        override_redirect : TBool;
        screen : PScreen;
     end;

   PXHostAddress = ^TXHostAddress;
   TXHostAddress = record
        family : cint;
        length : cint;
        address : Pchar;
     end;

   PXServerInterpretedAddress = ^TXServerInterpretedAddress;
   TXServerInterpretedAddress = record
        typelength : cint;
        valuelength : cint;
        _type : Pchar;
        value : Pchar;
     end;

   PXImage = ^TXImage;
   TXImage = record
        width, height : cint;
        xoffset : cint;
        format : cint;
        data : Pchar;
        byte_order : cint;
        bitmap_unit : cint;
        bitmap_bit_order : cint;
        bitmap_pad : cint;
        depth : cint;
        bytes_per_line : cint;
        bits_per_pixel : cint;
        red_mask : culong;
        green_mask : culong;
        blue_mask : culong;
        obdata : TXPointer;
        f : record
             create_image : function (para1:PXDisplay; para2:PVisual; para3:cuint; para4:cint; para5:cint;
                          para6:Pchar; para7:cuint; para8:cuint; para9:cint; para10:cint):PXImage;cdecl;
             destroy_image : function (para1:PXImage):cint;cdecl;
             get_pixel : function (para1:PXImage; para2:cint; para3:cint):culong;cdecl;
             put_pixel : function (para1:PXImage; para2:cint; para3:cint; para4:culong):cint;cdecl;
             sub_image : function (para1:PXImage; para2:cint; para3:cint; para4:cuint; para5:cuint):PXImage;cdecl;
             add_pixel : function (para1:PXImage; para2:clong):cint;cdecl;
          end;
     end;

   PXWindowChanges = ^TXWindowChanges;
   TXWindowChanges = record
        x, y : cint;
        width, height : cint;
        border_width : cint;
        sibling : TWindow;
        stack_mode : cint;
     end;

   PXColor = ^TXColor;
   TXColor = record
        pixel : culong;
        red, green, blue : cushort;
        flags : cchar;
        pad : cchar;
     end;

   PXSegment = ^TXSegment;
   TXSegment = record
        x1, y1, x2, y2 : cshort;
     end;

   PXPoint = ^TXPoint;
   TXPoint = record
        x, y : cshort;
     end;

   PXRectangle = ^TXRectangle;
   TXRectangle = record
        x, y : cshort;
        width, height : cushort;
     end;

   PXArc = ^TXArc;
   TXArc = record
        x, y : cshort;
        width, height : cushort;
        angle1, angle2 : cshort;
     end;

   PXKeyboardControl = ^TXKeyboardControl;
   TXKeyboardControl = record
        key_click_percent : cint;
        bell_percent : cint;
        bell_pitch : cint;
        bell_duration : cint;
        led : cint;
        led_mode : cint;
        key : cint;
        auto_repeat_mode : cint;
     end;

   PXKeyboardState = ^TXKeyboardState;
   TXKeyboardState = record
        key_click_percent : cint;
        bell_percent : cint;
        bell_pitch, bell_duration : cuint;
        led_mask : culong;
        global_auto_repeat : cint;
        auto_repeats : array[0..31] of cchar;
     end;

   PXTimeCoord = ^TXTimeCoord;
   TXTimeCoord = record
        time : TTime;
        x, y : cshort;
     end;

   PXModifierKeymap = ^TXModifierKeymap;
   TXModifierKeymap = record
        max_keypermod : cint;
        modifiermap : PKeyCode;
     end;

   PDisplay = ^TDisplay;
   TDisplay = TXDisplay;

   PXPrivate = ^TXPrivate;
   TXPrivate = record
     end;

   PXrmHashBucketRec = ^TXrmHashBucketRec;
   TXrmHashBucketRec = record
     end;


   PXPrivDisplay = ^TXPrivDisplay;
   TXPrivDisplay = record
        ext_data : PXExtData;
        private1 : PXPrivate;
        fd : cint;
        private2 : cint;
        proto_major_version : cint;
        proto_minor_version : cint;
        vendor : Pchar;
        private3 : TXID;
        private4 : TXID;
        private5 : TXID;
        private6 : cint;
        resource_alloc : function (para1:PXDisplay):TXID;cdecl;
        byte_order : cint;
        bitmap_unit : cint;
        bitmap_pad : cint;
        bitmap_bit_order : cint;
        nformats : cint;
        pixmap_format : PScreenFormat;
        private8 : cint;
        release : cint;
        private9, private10 : PXPrivate;
        qlen : cint;
        last_request_read : culong;
        request : culong;
        private11 : TXPointer;
        private12 : TXPointer;
        private13 : TXPointer;
        private14 : TXPointer;
        max_request_size : cunsigned;
        db : PXrmHashBucketRec;
        private15 : function (para1:PXDisplay):cint;cdecl;
        display_name : Pchar;
        default_screen : cint;
        nscreens : cint;
        screens : PScreen;
        motion_buffer : culong;
        private16 : culong;
        min_keycode : cint;
        max_keycode : cint;
        private17 : TXPointer;
        private18 : TXPointer;
        private19 : cint;
        xdefaults : Pchar;
     end;

   PXKeyEvent = ^TXKeyEvent;
   TXKeyEvent = record
        _type : cint;
        serial : culong;
        send_event : TBool;
        display : PDisplay;
        window : TWindow;
        root : TWindow;
        subwindow : TWindow;
        time : TTime;
        x, y : cint;
        x_root, y_root : cint;
        state : cuint;
        keycode : cuint;
        same_screen : TBool;
     end;

   PXKeyPressedEvent = ^TXKeyPressedEvent;
   TXKeyPressedEvent = TXKeyEvent;

   PXKeyReleasedEvent = ^TXKeyReleasedEvent;
   TXKeyReleasedEvent = TXKeyEvent;

   PXButtonEvent = ^TXButtonEvent;
   TXButtonEvent = record
        _type : cint;
        serial : culong;
        send_event : TBool;
        display : PDisplay;
        window : TWindow;
        root : TWindow;
        subwindow : TWindow;
        time : TTime;
        x, y : cint;
        x_root, y_root : cint;
        state : cuint;
        button : cuint;
        same_screen : TBool;
     end;

   PXButtonPressedEvent = ^TXButtonPressedEvent;
   TXButtonPressedEvent = TXButtonEvent;

   PXButtonReleasedEvent = ^TXButtonReleasedEvent;
   TXButtonReleasedEvent = TXButtonEvent;

   PXMotionEvent = ^TXMotionEvent;
   TXMotionEvent = record
        _type : cint;
        serial : culong;
        send_event : TBool;
        display : PDisplay;
        window : TWindow;
        root : TWindow;
        subwindow : TWindow;
        time : TTime;
        x, y : cint;
        x_root, y_root : cint;
        state : cuint;
        is_hint : cchar;
        same_screen : TBool;
     end;

   PXPointerMovedEvent = ^TXPointerMovedEvent;
   TXPointerMovedEvent = TXMotionEvent;

   PXCrossingEvent = ^TXCrossingEvent;
   TXCrossingEvent = record
        _type : cint;
        serial : culong;
        send_event : TBool;
        display : PDisplay;
        window : TWindow;
        root : TWindow;
        subwindow : TWindow;
        time : TTime;
        x, y : cint;
        x_root, y_root : cint;
        mode : cint;
        detail : cint;
        same_screen : TBool;
        focus : TBool;
        state : cuint;
     end;

   PXEnterWindowEvent = ^TXEnterWindowEvent;
   TXEnterWindowEvent = TXCrossingEvent;

   PXLeaveWindowEvent = ^TXLeaveWindowEvent;
   TXLeaveWindowEvent = TXCrossingEvent;

   PXFocusChangeEvent = ^TXFocusChangeEvent;
   TXFocusChangeEvent = record
        _type : cint;
        serial : culong;
        send_event : TBool;
        display : PDisplay;
        window : TWindow;
        mode : cint;
        detail : cint;
     end;

   PXFocusInEvent = ^TXFocusInEvent;
   TXFocusInEvent = TXFocusChangeEvent;

   PXFocusOutEvent = ^TXFocusOutEvent;
   TXFocusOutEvent = TXFocusChangeEvent;

   PXKeymapEvent = ^TXKeymapEvent;
   TXKeymapEvent = record
        _type : cint;
        serial : culong;
        send_event : TBool;
        display : PDisplay;
        window : TWindow;
        key_vector : array[0..31] of cchar;
     end;

   PXExposeEvent = ^TXExposeEvent;
   TXExposeEvent = record
        _type : cint;
        serial : culong;
        send_event : TBool;
        display : PDisplay;
        window : TWindow;
        x, y : cint;
        width, height : cint;
        count : cint;
     end;

   PXGraphicsExposeEvent = ^TXGraphicsExposeEvent;
   TXGraphicsExposeEvent = record
        _type : cint;
        serial : culong;
        send_event : TBool;
        display : PDisplay;
        drawable : TDrawable;
        x, y : cint;
        width, height : cint;
        count : cint;
        major_code : cint;
        minor_code : cint;
     end;

   PXNoExposeEvent = ^TXNoExposeEvent;
   TXNoExposeEvent = record
        _type : cint;
        serial : culong;
        send_event : TBool;
        display : PDisplay;
        drawable : TDrawable;
        major_code : cint;
        minor_code : cint;
     end;

   PXVisibilityEvent = ^TXVisibilityEvent;
   TXVisibilityEvent = record
        _type : cint;
        serial : culong;
        send_event : TBool;
        display : PDisplay;
        window : TWindow;
        state : cint;
     end;

   PXCreateWindowEvent = ^TXCreateWindowEvent;
   TXCreateWindowEvent = record
        _type : cint;
        serial : culong;
        send_event : TBool;
        display : PDisplay;
        parent : TWindow;
        window : TWindow;
        x, y : cint;
        width, height : cint;
        border_width : cint;
        override_redirect : TBool;
     end;

   PXDestroyWindowEvent = ^TXDestroyWindowEvent;
   TXDestroyWindowEvent = record
        _type : cint;
        serial : culong;
        send_event : TBool;
        display : PDisplay;
        event : TWindow;
        window : TWindow;
     end;

   PXUnmapEvent = ^TXUnmapEvent;
   TXUnmapEvent = record
        _type : cint;
        serial : culong;
        send_event : TBool;
        display : PDisplay;
        event : TWindow;
        window : TWindow;
        from_configure : TBool;
     end;

   PXMapEvent = ^TXMapEvent;
   TXMapEvent = record
        _type : cint;
        serial : culong;
        send_event : TBool;
        display : PDisplay;
        event : TWindow;
        window : TWindow;
        override_redirect : TBool;
     end;

   PXMapRequestEvent = ^TXMapRequestEvent;
   TXMapRequestEvent = record
        _type : cint;
        serial : culong;
        send_event : TBool;
        display : PDisplay;
        parent : TWindow;
        window : TWindow;
     end;

   PXReparentEvent = ^TXReparentEvent;
   TXReparentEvent = record
        _type : cint;
        serial : culong;
        send_event : TBool;
        display : PDisplay;
        event : TWindow;
        window : TWindow;
        parent : TWindow;
        x, y : cint;
        override_redirect : TBool;
     end;

   PXConfigureEvent = ^TXConfigureEvent;
   TXConfigureEvent = record
        _type : cint;
        serial : culong;
        send_event : TBool;
        display : PDisplay;
        event : TWindow;
        window : TWindow;
        x, y : cint;
        width, height : cint;
        border_width : cint;
        above : TWindow;
        override_redirect : TBool;
     end;

   PXGravityEvent = ^TXGravityEvent;
   TXGravityEvent = record
        _type : cint;
        serial : culong;
        send_event : TBool;
        display : PDisplay;
        event : TWindow;
        window : TWindow;
        x, y : cint;
     end;

   PXResizeRequestEvent = ^TXResizeRequestEvent;
   TXResizeRequestEvent = record
        _type : cint;
        serial : culong;
        send_event : TBool;
        display : PDisplay;
        window : TWindow;
        width, height : cint;
     end;

   PXConfigureRequestEvent = ^TXConfigureRequestEvent;
   TXConfigureRequestEvent = record
        _type : cint;
        serial : culong;
        send_event : TBool;
        display : PDisplay;
        parent : TWindow;
        window : TWindow;
        x, y : cint;
        width, height : cint;
        border_width : cint;
        above : TWindow;
        detail : cint;
        value_mask : culong;
     end;

   PXCirculateEvent = ^TXCirculateEvent;
   TXCirculateEvent = record
        _type : cint;
        serial : culong;
        send_event : TBool;
        display : PDisplay;
        event : TWindow;
        window : TWindow;
        place : cint;
     end;

   PXCirculateRequestEvent = ^TXCirculateRequestEvent;
   TXCirculateRequestEvent = record
        _type : cint;
        serial : culong;
        send_event : TBool;
        display : PDisplay;
        parent : TWindow;
        window : TWindow;
        place : cint;
     end;

   PXPropertyEvent = ^TXPropertyEvent;
   TXPropertyEvent = record
        _type : cint;
        serial : culong;
        send_event : TBool;
        display : PDisplay;
        window : TWindow;
        atom : TAtom;
        time : TTime;
        state : cint;
     end;

   PXSelectionClearEvent = ^TXSelectionClearEvent;
   TXSelectionClearEvent = record
        _type : cint;
        serial : culong;
        send_event : TBool;
        display : PDisplay;
        window : TWindow;
        selection : TAtom;
        time : TTime;
     end;

   PXSelectionRequestEvent = ^TXSelectionRequestEvent;
   TXSelectionRequestEvent = record
        _type : cint;
        serial : culong;
        send_event : TBool;
        display : PDisplay;
        owner : TWindow;
        requestor : TWindow;
        selection : TAtom;
        target : TAtom;
        _property : TAtom;
        time : TTime;
     end;

   PXSelectionEvent = ^TXSelectionEvent;
   TXSelectionEvent = record
        _type : cint;
        serial : culong;
        send_event : TBool;
        display : PDisplay;
        requestor : TWindow;
        selection : TAtom;
        target : TAtom;
        _property : TAtom;
        time : TTime;
     end;

   PXColormapEvent = ^TXColormapEvent;
   TXColormapEvent = record
        _type : cint;
        serial : culong;
        send_event : TBool;
        display : PDisplay;
        window : TWindow;
        colormap : TColormap;
        c_new : TBool;
        state : cint;
     end;

   PXClientMessageEvent = ^TXClientMessageEvent;
   TXClientMessageEvent = record
        _type : cint;
        serial : culong;
        send_event : TBool;
        display : PDisplay;
        window : TWindow;
        message_type : TAtom;
        format : cint;
        data : record
            case longint of
               0 : ( b : array[0..19] of cchar );
               1 : ( s : array[0..9] of cshort );
               2 : ( l : array[0..4] of clong );
            end;
     end;

   PXMappingEvent = ^TXMappingEvent;
   TXMappingEvent = record
        _type : cint;
        serial : culong;
        send_event : TBool;
        display : PDisplay;
        window : TWindow;
        request : cint;
        first_keycode : cint;
        count : cint;
     end;

   PXErrorEvent = ^TXErrorEvent;
   TXErrorEvent = record
        _type : cint;
        display : PDisplay;
        resourceid : TXID;
        serial : culong;
        error_code : cuchar;
        request_code : cuchar;
        minor_code : cuchar;
     end;

   PXAnyEvent = ^TXAnyEvent;
   TXAnyEvent = record
        _type : cint;
        serial : culong;
        send_event : TBool;
        display : PDisplay;
        window : TWindow;
     end;

   (***************************************************************
    *
    * GenericEvent.  This event is the standard event for all newer extensions.
    *)

   PXGenericEvent = ^TXGenericEvent;
   TXGenericEvent = record
        _type: cint;                 { of event. Always GenericEvent }
        serial: culong;              { # of last request processed }
        send_event: TBool;           { true if from SendEvent request }
        display: PDisplay;           { Display the event was read from }
        extension: cint;             { major opcode of extension that caused the event }
        evtype: cint;                { actual event type. }
     end;

   PXGenericEventCookie = ^TXGenericEventCookie;
   TXGenericEventCookie = record
        _type: cint;                 { of event. Always GenericEvent }
        serial: culong;              { # of last request processed }
        send_event: TBool;           { true if from SendEvent request }
        display: PDisplay;           { Display the event was read from }
        extension: cint;             { major opcode of extension that caused the event }
        evtype: cint;                { actual event type. }
        cookie: cuint;
        data: pointer;
     end;

   PXEvent = ^TXEvent;
   TXEvent = record
       case longint of
          0 : ( _type : cint );
          1 : ( xany : TXAnyEvent );
          2 : ( xkey : TXKeyEvent );
          3 : ( xbutton : TXButtonEvent );
          4 : ( xmotion : TXMotionEvent );
          5 : ( xcrossing : TXCrossingEvent );
          6 : ( xfocus : TXFocusChangeEvent );
          7 : ( xexpose : TXExposeEvent );
          8 : ( xgraphicsexpose : TXGraphicsExposeEvent );
          9 : ( xnoexpose : TXNoExposeEvent );
          10 : ( xvisibility : TXVisibilityEvent );
          11 : ( xcreatewindow : TXCreateWindowEvent );
          12 : ( xdestroywindow : TXDestroyWindowEvent );
          13 : ( xunmap : TXUnmapEvent );
          14 : ( xmap : TXMapEvent );
          15 : ( xmaprequest : TXMapRequestEvent );
          16 : ( xreparent : TXReparentEvent );
          17 : ( xconfigure : TXConfigureEvent );
          18 : ( xgravity : TXGravityEvent );
          19 : ( xresizerequest : TXResizeRequestEvent );
          20 : ( xconfigurerequest : TXConfigureRequestEvent );
          21 : ( xcirculate : TXCirculateEvent );
          22 : ( xcirculaterequest : TXCirculateRequestEvent );
          23 : ( xproperty : TXPropertyEvent );
          24 : ( xselectionclear : TXSelectionClearEvent );
          25 : ( xselectionrequest : TXSelectionRequestEvent );
          26 : ( xselection : TXSelectionEvent );
          27 : ( xcolormap : TXColormapEvent );
          28 : ( xclient : TXClientMessageEvent );
          29 : ( xmapping : TXMappingEvent );
          30 : ( xerror : TXErrorEvent );
          31 : ( xkeymap : TXKeymapEvent );
          32 : ( xgeneric : TXGenericEvent );
          33 : ( xcookie : TXGenericEventCookie );
          34 : ( pad : array[0..23] of clong );
       end;

type

   PXCharStruct = ^TXCharStruct;
   TXCharStruct = record
        lbearing : cshort;
        rbearing : cshort;
        width : cshort;
        ascent : cshort;
        descent : cshort;
        attributes : cushort;
     end;

   PXFontProp = ^TXFontProp;
   TXFontProp = record
        name : TAtom;
        card32 : culong;
     end;

   PPPXFontStruct = ^PPXFontStruct;
   PPXFontStruct = ^PXFontStruct;
   PXFontStruct = ^TXFontStruct;
   TXFontStruct = record
        ext_data : PXExtData;
        fid : TFont;
        direction : cunsigned;
        min_char_or_byte2 : cunsigned;
        max_char_or_byte2 : cunsigned;
        min_byte1 : cunsigned;
        max_byte1 : cunsigned;
        all_chars_exist : TBool;
        default_char : cunsigned;
        n_properties : cint;
        properties : PXFontProp;
        min_bounds : TXCharStruct;
        max_bounds : TXCharStruct;
        per_char : PXCharStruct;
        ascent : cint;
        descent : cint;
     end;

   PXTextItem = ^TXTextItem;
   TXTextItem = record
        chars : Pchar;
        nchars : cint;
        delta : cint;
        font : TFont;
     end;

   PXChar2b = ^TXChar2b;
   TXChar2b = record
        byte1 : cuchar;
        byte2 : cuchar;
     end;

   PXTextItem16 = ^TXTextItem16;
   TXTextItem16 = record
        chars : PXChar2b;
        nchars : cint;
        delta : cint;
        font : TFont;
     end;

   PXEDataObject = ^TXEDataObject;
   TXEDataObject = record
       case longint of
          0 : ( display : PDisplay );
          1 : ( gc : TGC );
          2 : ( visual : PVisual );
          3 : ( screen : PScreen );
          4 : ( pixmap_format : PScreenFormat );
          5 : ( font : PXFontStruct );
       end;

   PXFontSetExtents = ^TXFontSetExtents;
   TXFontSetExtents = record
        max_ink_extent : TXRectangle;
        max_logical_extent : TXRectangle;
     end;

   PXOM = ^TXOM;
   TXOM = record
     end;

   PXOC = ^TXOC;
   TXOC = record
     end;
   TXFontSet = PXOC;
   PXFontSet = ^TXFontSet;

   PXmbTextItem = ^TXmbTextItem;
   TXmbTextItem = record
        chars : Pchar;
        nchars : cint;
        delta : cint;
        font_set : TXFontSet;
     end;

   PXwcTextItem = ^TXwcTextItem;
   TXwcTextItem = record
        chars : PWideChar; {wchar_t*}
        nchars : cint;
        delta : cint;
        font_set : TXFontSet;
     end;

const
   XNRequiredCharSet = 'requiredCharSet';
   XNQueryOrientation = 'queryOrientation';
   XNBaseFontName = 'baseFontName';
   XNOMAutomatic = 'omAutomatic';
   XNMissingCharSet = 'missingCharSet';
   XNDefaultString = 'defaultString';
   XNOrientation = 'orientation';
   XNDirectionalDependentDrawing = 'directionalDependentDrawing';
   XNContextualDrawing = 'contextualDrawing';
   XNFontInfo = 'fontInfo';
type

   PXOMCharSetList = ^TXOMCharSetList;
   TXOMCharSetList = record
        charset_count : cint;
        charset_list : PPChar;
     end;

   PXOrientation = ^TXOrientation;
   TXOrientation = (XOMOrientation_LTR_TTB,XOMOrientation_RTL_TTB,
     XOMOrientation_TTB_LTR,XOMOrientation_TTB_RTL,
     XOMOrientation_Context);

   PXOMOrientation = ^TXOMOrientation;
   TXOMOrientation = record
        num_orientation : cint;
        orientation : PXOrientation;
     end;

   PXOMFontInfo = ^TXOMFontInfo;
   TXOMFontInfo = record
        num_font : cint;
        font_struct_list : ^PXFontStruct;
        font_name_list : PPChar;
     end;
     
   PXIM = ^TXIM;
   TXIM = record
     end;

   PXIC = ^TXIC;
   TXIC = record
     end;
  
   TXIMProc = procedure (para1:TXIM; para2:TXPointer; para3:TXPointer);cdecl;

   TXICProc = function (para1:TXIC; para2:TXPointer; para3:TXPointer):TBoolResult;cdecl;

   TXIDProc = procedure (para1:PDisplay; para2:TXPointer; para3:TXPointer);cdecl;

   PXIMStyle = ^TXIMStyle;
   TXIMStyle = culong;

   PXIMStyles = ^TXIMStyles;
   TXIMStyles = record
        count_styles : cushort;
        supported_styles : PXIMStyle;
     end;

const
   XIMPreeditArea = $0001;
   XIMPreeditCallbacks = $0002;
   XIMPreeditPosition = $0004;
   XIMPreeditNothing = $0008;
   XIMPreeditNone = $0010;
   XIMStatusArea = $0100;
   XIMStatusCallbacks = $0200;
   XIMStatusNothing = $0400;
   XIMStatusNone = $0800;
   XNVaNestedList = 'XNVaNestedList';
   XNQueryInputStyle = 'queryInputStyle';
   XNClientWindow = 'clientWindow';
   XNInputStyle = 'inputStyle';
   XNFocusWindow = 'focusWindow';
   XNResourceName = 'resourceName';
   XNResourceClass = 'resourceClass';
   XNGeometryCallback = 'geometryCallback';
   XNDestroyCallback = 'destroyCallback';
   XNFilterEvents = 'filterEvents';
   XNPreeditStartCallback = 'preeditStartCallback';
   XNPreeditDoneCallback = 'preeditDoneCallback';
   XNPreeditDrawCallback = 'preeditDrawCallback';
   XNPreeditCaretCallback = 'preeditCaretCallback';
   XNPreeditStateNotifyCallback = 'preeditStateNotifyCallback';
   XNPreeditAttributes = 'preeditAttributes';
   XNStatusStartCallback = 'statusStartCallback';
   XNStatusDoneCallback = 'statusDoneCallback';
   XNStatusDrawCallback = 'statusDrawCallback';
   XNStatusAttributes = 'statusAttributes';
   XNArea = 'area';
   XNAreaNeeded = 'areaNeeded';
   XNSpotLocation = 'spotLocation';
   XNColormap = 'colorMap';
   XNStdColormap = 'stdColorMap';
   XNForeground = 'foreground';
   XNBackground = 'background';
   XNBackgroundPixmap = 'backgroundPixmap';
   XNFontSet = 'fontSet';
   XNLineSpace = 'lineSpace';
   XNCursor = 'cursor';
   XNQueryIMValuesList = 'queryIMValuesList';
   XNQueryICValuesList = 'queryICValuesList';
   XNVisiblePosition = 'visiblePosition';
   XNR6PreeditCallback = 'r6PreeditCallback';
   XNStringConversionCallback = 'stringConversionCallback';
   XNStringConversion = 'stringConversion';
   XNResetState = 'resetState';
   XNHotKey = 'hotKey';
   XNHotKeyState = 'hotKeyState';
   XNPreeditState = 'preeditState';
   XNSeparatorofNestedList = 'separatorofNestedList';
   XBufferOverflow = -(1);
   XLookupNone = 1;
   XLookupChars = 2;
   XLookupKeySymVal = 3;
   XLookupBoth = 4;
type

   PXVaNestedList = ^TXVaNestedList;
   TXVaNestedList = pointer;

   PXIMCallback = ^TXIMCallback;
   TXIMCallback = record
        client_data : TXPointer;
        callback : TXIMProc;
     end;

   PXICCallback = ^TXICCallback;
   TXICCallback = record
        client_data : TXPointer;
        callback : TXICProc;
     end;

   PXIMFeedback = ^TXIMFeedback;
   TXIMFeedback = culong;

const
   XIMReverse = 1;
   XIMUnderline = 1 shl 1;
   XIMHighlight = 1 shl 2;
   XIMPrimary = 1 shl 5;
   XIMSecondary = 1 shl 6;
   XIMTertiary = 1 shl 7;
   XIMVisibleToForward = 1 shl 8;
   XIMVisibleToBackword = 1 shl 9;
   XIMVisibleToCenter = 1 shl 10;
type

   PXIMText = ^TXIMText;
   TXIMText = record
        length : cushort;
        feedback : PXIMFeedback;
        encoding_is_wchar : TBool;
        _string : record
            case longint of
               0 : ( multi_byte : Pchar );
               1 : ( wide_char : PWideChar ); {wchar_t*}
            end;
     end;

   PXIMPreeditState = ^TXIMPreeditState;
   TXIMPreeditState = culong;

const
   XIMPreeditUnKnown = 0;
   XIMPreeditEnable = 1;
   XIMPreeditDisable = 1 shl 1;
type

   PXIMPreeditStateNotifyCallbackStruct = ^TXIMPreeditStateNotifyCallbackStruct;
   TXIMPreeditStateNotifyCallbackStruct = record
        state : TXIMPreeditState;
     end;

   PXIMResetState = ^TXIMResetState;
   TXIMResetState = culong;

const
   XIMInitialState = 1;
   XIMPreserveState = 1 shl 1;
type

   PXIMStringConversionFeedback = ^TXIMStringConversionFeedback;
   TXIMStringConversionFeedback = culong;

const
   XIMStringConversionLeftEdge = $00000001;
   XIMStringConversionRightEdge = $00000002;
   XIMStringConversionTopEdge = $00000004;
   XIMStringConversionBottomEdge = $00000008;
   XIMStringConversionConcealed = $00000010;
   XIMStringConversionWrapped = $00000020;
type

   PXIMStringConversionText = ^TXIMStringConversionText;
   TXIMStringConversionText = record
        length : cushort;
        feedback : PXIMStringConversionFeedback;
        encoding_is_wchar : TBool;
        _string : record
            case longint of
               0 : ( mbs : Pchar );
               1 : ( wcs : PWideChar ); {wchar_t*}
            end;
     end;

   PXIMStringConversionPosition = ^TXIMStringConversionPosition;
   TXIMStringConversionPosition = cushort;

   PXIMStringConversionType = ^TXIMStringConversionType;
   TXIMStringConversionType = cushort;

const
   XIMStringConversionBuffer = $0001;
   XIMStringConversionLine = $0002;
   XIMStringConversionWord = $0003;
   XIMStringConversionChar = $0004;
type

   PXIMStringConversionOperation = ^TXIMStringConversionOperation;
   TXIMStringConversionOperation = cushort;

const
   XIMStringConversionSubstitution = $0001;
   XIMStringConversionRetrieval = $0002;
type

   PXIMCaretDirection = ^TXIMCaretDirection;
   TXIMCaretDirection = (XIMForwardChar,XIMBackwardChar,XIMForwardWord,
     XIMBackwardWord,XIMCaretUp,XIMCaretDown,
     XIMNextLine,XIMPreviousLine,XIMLineStart,
     XIMLineEnd,XIMAbsolutePosition,XIMDontChange
     );

   PXIMStringConversionCallbackStruct = ^TXIMStringConversionCallbackStruct;
   TXIMStringConversionCallbackStruct = record
        position : TXIMStringConversionPosition;
        direction : TXIMCaretDirection;
        operation : TXIMStringConversionOperation;
        factor : cushort;
        text : PXIMStringConversionText;
     end;

   PXIMPreeditDrawCallbackStruct = ^TXIMPreeditDrawCallbackStruct;
   TXIMPreeditDrawCallbackStruct = record
        caret : cint;
        chg_first : cint;
        chg_length : cint;
        text : PXIMText;
     end;

   PXIMCaretStyle = ^TXIMCaretStyle;
   TXIMCaretStyle = (XIMIsInvisible,XIMIsPrimary,XIMIsSecondary
     );

   PXIMPreeditCaretCallbackStruct = ^TXIMPreeditCaretCallbackStruct;
   TXIMPreeditCaretCallbackStruct = record
        position : cint;
        direction : TXIMCaretDirection;
        style : TXIMCaretStyle;
     end;

   PXIMStatusDataType = ^TXIMStatusDataType;
   TXIMStatusDataType = (XIMTextType,XIMBitmapType);

   PXIMStatusDrawCallbackStruct = ^TXIMStatusDrawCallbackStruct;
   TXIMStatusDrawCallbackStruct = record
        _type : TXIMStatusDataType;
        data : record
            case longint of
               0 : ( text : PXIMText );
               1 : ( bitmap : TPixmap );
            end;
     end;

   PXIMHotKeyTrigger = ^TXIMHotKeyTrigger;
   TXIMHotKeyTrigger = record
        keysym : TKeySym;
        modifier : cint;
        modifier_mask : cint;
     end;

   PXIMHotKeyTriggers = ^TXIMHotKeyTriggers;
   TXIMHotKeyTriggers = record
        num_hot_key : cint;
        key : PXIMHotKeyTrigger;
     end;

   PXIMHotKeyState = ^TXIMHotKeyState;
   TXIMHotKeyState = culong;

const
   XIMHotKeyStateON = $0001;
   XIMHotKeyStateOFF = $0002;
type

   PXIMValuesList = ^TXIMValuesList;
   TXIMValuesList = record
        count_values : cushort;
        supported_values : PPChar;
     end;

//{     
// from xutil.pp
const
   NoValue = $0000;
   XValue = $0001;
   YValue = $0002;
   WidthValue = $0004;
   HeightValue = $0008;
   AllValues = $000F;
   XNegative = $0010;
   YNegative = $0020;
type

   PXSizeHints = ^TXSizeHints;
   TXSizeHints = record
        flags : clong;
        x, y : cint;
        width, height : cint;
        min_width, min_height : cint;
        max_width, max_height : cint;
        width_inc, height_inc : cint;
        min_aspect, max_aspect : record
             x : cint;
             y : cint;
          end;
        base_width, base_height : cint;
        win_gravity : cint;
     end;

const
   USPosition = 1 shl 0;
   USSize = 1 shl 1;
   PPosition = 1 shl 2;
   PSize = 1 shl 3;
   PMinSize = 1 shl 4;
   PMaxSize = 1 shl 5;
   PResizeInc = 1 shl 6;
   PAspect = 1 shl 7;
   PBaseSize = 1 shl 8;
   PWinGravity = 1 shl 9;
   PAllHints = PPosition or PSize or PMinSize or PMaxSize or PResizeInc or PAspect;
type

   PXWMHints = ^TXWMHints;
   TXWMHints = record
        flags : clong;
        input : TBool;
        initial_state : cint;
        icon_pixmap : TPixmap;
        icon_window : TWindow;
        icon_x, icon_y : cint;
        icon_mask : TPixmap;
        window_group : TXID;
     end;

const
   InputHint = 1 shl 0;
   StateHint = 1 shl 1;
   IconPixmapHint = 1 shl 2;
   IconWindowHint = 1 shl 3;
   IconPositionHint = 1 shl 4;
   IconMaskHint = 1 shl 5;
   WindowGroupHint = 1 shl 6;
   AllHints = InputHint or StateHint or IconPixmapHint or IconWindowHint or IconPositionHint or IconMaskHint or WindowGroupHint;
   XUrgencyHint = 1 shl 8;
   WithdrawnState = 0;
   NormalState = 1;
   IconicState = 3;
   DontCareState = 0;
   ZoomState = 2;
   InactiveState = 4;
type

   PXTextProperty = ^TXTextProperty;
   TXTextProperty = record
        value : pcuchar;
        encoding : TAtom;
        format : cint;
        nitems : culong;
     end;

const
   XNoMemory = -1;
   XLocaleNotSupported = -2;
   XConverterNotFound = -3;
type

   PXICCEncodingStyle = ^TXICCEncodingStyle;
   TXICCEncodingStyle = (XStringStyle,XCompoundTextStyle,XTextStyle,
     XStdICCTextStyle,XUTF8StringStyle);

   PPXIconSize = ^PXIconSize;
   PXIconSize = ^TXIconSize;
   TXIconSize = record
        min_width, min_height : cint;
        max_width, max_height : cint;
        width_inc, height_inc : cint;
     end;

   PXClassHint = ^TXClassHint;
   TXClassHint = record
        res_name : Pchar;
        res_class : Pchar;
     end;

type

   PXComposeStatus = ^TXComposeStatus;
   TXComposeStatus = record
        compose_ptr : TXPointer;
        chars_matched : cint;
     end;

type

   PXRegion = ^TXRegion;
   TXRegion = record
     end;
   TRegion = PXRegion;
   PRegion = ^TRegion;

const
   RectangleOut = 0;
   RectangleIn = 1;
   RectanglePart = 2;
type

   PXVisualInfo = ^TXVisualInfo;
   TXVisualInfo = record
        visual : PVisual;
        visualid : TVisualID;
        screen : cint;
        depth : cint;
        _class : cint;
        red_mask : culong;
        green_mask : culong;
        blue_mask : culong;
        colormap_size : cint;
        bits_per_rgb : cint;
     end;

const
   VisualNoMask = $0;
   VisualIDMask = $1;
   VisualScreenMask = $2;
   VisualDepthMask = $4;
   VisualClassMask = $8;
   VisualRedMaskMask = $10;
   VisualGreenMaskMask = $20;
   VisualBlueMaskMask = $40;
   VisualColormapSizeMask = $80;
   VisualBitsPerRGBMask = $100;
   VisualAllMask = $1FF;
type

   PPXStandardColormap = ^PXStandardColormap;
   PXStandardColormap = ^TXStandardColormap;
   TXStandardColormap = record
        colormap : TColormap;
        red_max : culong;
        red_mult : culong;
        green_max : culong;
        green_mult : culong;
        blue_max : culong;
        blue_mult : culong;
        base_pixel : culong;
        visualid : TVisualID;
        killid : TXID;
     end;

const
   BitmapSuccess = 0;
   BitmapOpenFailed = 1;
   BitmapFileInvalid = 2;
   BitmapNoMemory = 3;
   XCSUCCESS = 0;
   XCNOMEM = 1;
   XCNOENT = 2;
   ReleaseByFreeingColormap : TXID = TXID(1);

type
   PXContext = ^TXContext;
   TXContext = cint;   
//}  
// from xatom.pp
const
        XA_PRIMARY             = TAtom ( 1);
        XA_SECONDARY           = TAtom ( 2);
        XA_ARC                 = TAtom ( 3);
        XA_ATOM                = TAtom ( 4);
        XA_BITMAP              = TAtom ( 5);
        XA_CARDINAL            = TAtom ( 6);
        XA_COLORMAP            = TAtom ( 7);
        XA_CURSOR              = TAtom ( 8);
        XA_CUT_BUFFER0         = TAtom ( 9);
        XA_CUT_BUFFER1         = TAtom (10);
        XA_CUT_BUFFER2         = TAtom (11);
        XA_CUT_BUFFER3         = TAtom (12);
        XA_CUT_BUFFER4         = TAtom (13);
        XA_CUT_BUFFER5         = TAtom (14);
        XA_CUT_BUFFER6         = TAtom (15);
        XA_CUT_BUFFER7         = TAtom (16);
        XA_DRAWABLE            = TAtom (17);
        XA_FONT                = TAtom (18);
        XA_INTEGER             = TAtom (19);
        XA_PIXMAP              = TAtom (20);
        XA_POINT               = TAtom (21);
        XA_RECTANGLE           = TAtom (22);
        XA_RESOURCE_MANAGER    = TAtom (23);
        XA_RGB_COLOR_MAP       = TAtom (24);
        XA_RGB_BEST_MAP        = TAtom (25);
        XA_RGB_BLUE_MAP        = TAtom (26);
        XA_RGB_DEFAULT_MAP     = TAtom (27);
        XA_RGB_GRAY_MAP        = TAtom (28);
        XA_RGB_GREEN_MAP       = TAtom (29);
        XA_RGB_RED_MAP         = TAtom (30);
        XA_STRING              = TAtom (31);
        XA_VISUALID            = TAtom (32);
        XA_WINDOW              = TAtom (33);
        XA_WM_COMMAND          = TAtom (34);
        XA_WM_HINTS            = TAtom (35);
        XA_WM_CLIENT_MACHINE   = TAtom (36);
        XA_WM_ICON_NAME        = TAtom (37);
        XA_WM_ICON_SIZE        = TAtom (38);
        XA_WM_NAME             = TAtom (39);
        XA_WM_NORMAL_HINTS     = TAtom (40);
        XA_WM_SIZE_HINTS       = TAtom (41);
        XA_WM_ZOOM_HINTS       = TAtom (42);
        XA_MIN_SPACE           = TAtom (43);
        XA_NORM_SPACE          = TAtom (44);
        XA_MAX_SPACE           = TAtom (45);
        XA_END_SPACE           = TAtom (46);
        XA_SUPERSCRIPT_X       = TAtom (47);
        XA_SUPERSCRIPT_Y       = TAtom (48);
        XA_SUBSCRIPT_X         = TAtom (49);
        XA_SUBSCRIPT_Y         = TAtom (50);
        XA_UNDERLINE_POSITION  = TAtom (51);
        XA_UNDERLINE_THICKNESS = TAtom (52);
        XA_STRIKEOUT_ASCENT    = TAtom (53);
        XA_STRIKEOUT_DESCENT   = TAtom (54);
        XA_ITALIC_ANGLE        = TAtom (55);
        XA_X_HEIGHT            = TAtom (56);
        XA_QUAD_WIDTH          = TAtom (57);
        XA_WEIGHT              = TAtom (58);
        XA_POINT_SIZE          = TAtom (59);
        XA_RESOLUTION          = TAtom (60);
        XA_COPYRIGHT           = TAtom (61);
        XA_NOTICE              = TAtom (62);
        XA_FONT_NAME           = TAtom (63);
        XA_FAMILY_NAME         = TAtom (64);
        XA_FULL_NAME           = TAtom (65);
        XA_CAP_HEIGHT          = TAtom (66);
        XA_WM_CLASS            = TAtom (67);
        XA_WM_TRANSIENT_FOR    = TAtom (68);

        XA_LAST_PREDEFINED     = TAtom (68);
      
{$ifndef os2}
  var
     _Xdebug : cint;cvar;external;
{$endif}
type
  funcdisp    = function(display:PDisplay):cint;cdecl;
  funcifevent = function(display:PDisplay; event:PXEvent; p : TXPointer):TBoolResult;cdecl;
  chararr32   = array[0..31] of char;
  pchararr32  = chararr32;

const
  AllPlanes : culong = culong(not 0);

type
   TXErrorHandler = function (para1:PDisplay; para2:PXErrorEvent):cint;cdecl;

type
   TXIOErrorHandler = function (para1:PDisplay):cint;cdecl;

type
   TXConnectionWatchProc = procedure (para1:PDisplay; para2:TXPointer; para3:cint; para4:TBool; para5:PXPointer);cdecl;   
  
   ////// Dynamic load : Vars that will hold our dynamically loaded functions...
   
var XActivateScreenSaver: function(para1:PDisplay):cint;cdecl;
var XAddConnectionWatch: function(para1:PDisplay; para2:TXConnectionWatchProc; para3:TXPointer):TStatus;cdecl;
var XAddExtension: function(para1:PDisplay):PXExtCodes;cdecl;
var XAddHost: function(para1:PDisplay; para2:PXHostAddress):cint;cdecl;
var XAddHosts: function(para1:PDisplay; para2:PXHostAddress; para3:cint):cint;cdecl;
var XAddToExtensionList: function(para1:PPXExtData; para2:PXExtData):cint;cdecl;
var XAddToSaveSet: function(para1:PDisplay; para2:TWindow):cint;cdecl;
var XAllocClassHint: function():PXClassHint;cdecl;
var XAllocColor: function(para1:PDisplay; para2:TColormap; para3:PXColor):TStatus;cdecl;
var XAllocColorCells: function(para1:PDisplay; para2:TColormap; para3:TBool; para4:Pculong; para5:cuint; para6:Pculong; para7:cuint):TStatus;cdecl;
var XAllocColorPlanes: function(para1:PDisplay; para2:TColormap; para3:TBool; para4:Pculong; para5:cint; para6:cint; para7:cint; para8:cint; para9:Pculong; para10:Pculong; para11:Pculong):TStatus;cdecl;
var XAllocIconSize: function():PXIconSize;cdecl;
var XAllocNamedColor: function(para1:PDisplay; para2:TColormap; para3:Pchar; para4:PXColor; para5:PXColor):TStatus;cdecl;
var XAllocSizeHints: function():PXSizeHints;cdecl;
var XAllocStandardColormap: function():PXStandardColormap;cdecl;
var XAllocWMHints: function():PXWMHints;cdecl;
var XAllowEvents: function(para1:PDisplay; para2:cint; para3:TTime):cint;cdecl;
var XAllPlanes: function() :culong;cdecl;
var XAutoRepeatOff: function(para1:PDisplay):cint;cdecl;
var XAutoRepeatOn: function(para1:PDisplay):cint;cdecl;
var XBaseFontNameListOfFontSet: function(para1:TXFontSet):Pchar;cdecl;
var XBell: function(para1:PDisplay; para2:cint):cint;cdecl;
var XBitmapBitOrder: function(para1:PDisplay):cint;cdecl;
var XBitmapPad: function(para1:PDisplay):cint;cdecl;
var XBitmapUnit: function(para1:PDisplay):cint;cdecl;
var XBlackPixel: function(ADisplay:PDisplay; AScreenNumber:cint):culong;cdecl;
var XBlackPixelOfScreen: function(para1:PScreen):culong;cdecl;
var XCellsOfScreen: function(para1:PScreen):cint;cdecl;
var XChangeActivePointerGrab: function(para1:PDisplay; para2:cuint; para3:TCursor; para4:TTime):cint;cdecl;
var XChangeGC: function(para1:PDisplay; para2:TGC; para3:culong; para4:PXGCValues):cint;cdecl;
var XChangeKeyboardControl: function(para1:PDisplay; para2:culong; para3:PXKeyboardControl):cint;cdecl;
var XChangeKeyboardMapping: function(para1:PDisplay; para2:cint; para3:cint; para4:PKeySym; para5:cint):cint;cdecl;
var XChangePointerControl: function(para1:PDisplay; para2:TBool; para3:TBool; para4:cint; para5:cint; para6:cint):cint;cdecl;
var XChangeProperty: function(para1:PDisplay; para2:TWindow; para3:TAtom; para4:TAtom; para5:cint; para6:cint; para7:Pcuchar; para8:cint):cint;cdecl;
var XChangeSaveSet: function(para1:PDisplay; para2:TWindow; para3:cint):cint;cdecl;
var XChangeWindowAttributes: function(para1:PDisplay; para2:TWindow; para3:culong; para4:PXSetWindowAttributes):cint;cdecl;
var XCheckIfEvent: function(para1:PDisplay; para2:PXEvent; para3:funcifevent; para4:TXPointer):TBoolResult;cdecl;
var XCheckMaskEvent: function(para1:PDisplay; para2:clong; para3:PXEvent):TBoolResult;cdecl;
var XCheckTypedEvent: function(para1:PDisplay; para2:cint; para3:PXEvent):TBoolResult;cdecl;
var XCheckTypedWindowEvent: function(para1:PDisplay; para2:TWindow; para3:cint; para4:PXEvent):TBoolResult;cdecl;
var XCheckWindowEvent: function(para1:PDisplay; para2:TWindow; para3:clong; para4:PXEvent):TBoolResult;cdecl;
var XCirculateSubwindows: function(para1:PDisplay; para2:TWindow; para3:cint):cint;cdecl;
var XCirculateSubwindowsDown: function(para1:PDisplay; para2:TWindow):cint;cdecl;
var XCirculateSubwindowsUp: function(para1:PDisplay; para2:TWindow):cint;cdecl;
var XClearArea: function(para1:PDisplay; para2:TWindow; para3:cint; para4:cint; para5:cuint; para6:cuint; para7:TBool):cint;cdecl;
var XClearWindow: function(para1:PDisplay; para2:TWindow):cint;cdecl;
var XClipBox: function(para1:TRegion; para2:PXRectangle):cint;cdecl;
var XCloseDisplay: function(para1:PDisplay):cint;cdecl;
var XCloseIM: function(para1:PXIM):TStatus;cdecl;
var XCloseOM: function(para1:TXOM):TStatus;cdecl;
var XConfigureWindow: function(para1:PDisplay; para2:TWindow; para3:cuint; para4:PXWindowChanges):cint;cdecl;
var XConnectionNumber: function(para1:PDisplay):cint;cdecl;
var XContextDependentDrawing: function(para1:TXFontSet):TBoolResult;cdecl;
var XContextualDrawing: function(para1:TXFontSet):TBoolResult;cdecl;
var XConvertCase: procedure(para1:TKeySym; para2:PKeySym; para3:PKeySym);cdecl;
var XConvertSelection: function(para1:PDisplay; para2:TAtom; para3:TAtom; para4:TAtom; para5:TWindow; para6:TTime):cint;cdecl;
var XCopyArea: function(para1:PDisplay; para2:TDrawable; para3:TDrawable; para4:TGC; para5:cint; para6:cint; para7:cuint; para8:cuint; para9:cint; para10:cint):cint;cdecl;
var XCopyColormapAndFree: function(para1:PDisplay; para2:TColormap):TColormap;cdecl;
var XCopyGC: function(para1:PDisplay; para2:TGC; para3:culong; para4:TGC):cint;cdecl;
var XCopyPlane: function(para1:PDisplay; para2:TDrawable; para3:TDrawable; para4:TGC; para5:cint; para6:cint; para7:cuint; para8:cuint; para9:cint; para10:cint;      para11:culong):cint;cdecl;
var XCreateBitmapFromData: function(ADiplay:PDisplay; ADrawable:TDrawable; AData:Pchar; AWidth:cuint; AHeight:cuint):TPixmap;cdecl;
var XCreateColormap: function(para1:PDisplay; para2:TWindow; para3:PVisual; para4:cint):TColormap;cdecl;
var XCreateFontCursor: function(ADisplay:PDisplay; AShape:cuint):TCursor;cdecl;
var XCreateFontSet: function(para1:PDisplay; para2:Pchar; para3:PPPchar; para4:Pcint; para5:PPchar):TXFontSet;cdecl;
var XCreateGC: function(para1:PDisplay; para2:TDrawable; para3:culong; para4:PXGCValues):TGC;cdecl;
var XCreateGlyphCursor: function(ADisplay:PDisplay; ASourceFont:TFont; AMaskFont:TFont; ASourceChar:cuint; AMaskChar:cuint; AForegroundColor:PXColor; ABackgroundColor:PXColor):TCursor;cdecl;
var XCreateIC: function(para1:PXIM; dotdotdot:array of const):PXIC;cdecl;
var XCreateImage: function(para1:PDisplay; para2:PVisual; para3:cuint; para4:cint; para5:cint; para6:Pchar; para7:cuint; para8:cuint; para9:cint; para10:cint):PXImage;cdecl;
var XCreateOC: function(para1:TXOM; dotdotdot:array of const):TXOC;cdecl;
var XCreatePixmap: function(ADisplay:PDisplay; ADrawable:TDrawable; AWidth:cuint; AHeight:cuint; ADepth:cuint):TPixmap;cdecl;
var XCreatePixmapCursor: function(ADisplay:PDisplay; ASource:TPixmap; AMask:TPixmap; AForegroundColor:PXColor; ABackgroundColor:PXColor; AX:cuint; AY:cuint):TCursor;cdecl;
var XCreatePixmapFromBitmapData: function(para1:PDisplay; para2:TDrawable; para3:Pchar; para4:cuint; para5:cuint; para6:culong; para7:culong; para8:cuint):TPixmap;cdecl;
var XCreateRegion: function():TRegion;cdecl;
var XCreateSimpleWindow: function(ADisplay:PDisplay; AParent:TWindow; AX:cint; AY:cint; AWidth:cuint; AHeight:cuint; ABorderWidth:cuint; ABorder:culong; ABackground:culong):TWindow;cdecl;
var XCreateWindow: function(ADisplay:PDisplay; AParent:TWindow; AX:cint; AY:cint; AWidth:cuint; AHeight:cuint; ABorderWidth:cuint; ADepth:cint; AClass:cuint; AVisual:PVisual; AValueMask:culong; AAttributes:PXSetWindowAttributes):TWindow;cdecl;
var XDefaultColormap: function(para1:PDisplay; para2:cint):TColormap;cdecl;
var XDefaultColormapOfScreen: function(para1:PScreen):TColormap;cdecl;
var XDefaultDepth: function(para1:PDisplay; para2:cint):cint;cdecl;
var XDefaultDepthOfScreen: function(para1:PScreen):cint;cdecl;
var XDefaultGC: function(para1:PDisplay; para2:cint):TGC;cdecl;
var XDefaultGCOfScreen: function(para1:PScreen):TGC;cdecl;
var XDefaultRootWindow: function(ADisplay:PDisplay):TWindow;cdecl;
var XDefaultScreen: function(para1:PDisplay):cint;cdecl;
var XDefaultScreenOfDisplay: function(para1:PDisplay):PScreen;cdecl;
var XDefaultString: function():Pchar;cdecl;
var XDefaultVisual: function(para1:PDisplay; para2:cint):PVisual;cdecl;
var XDefaultVisualOfScreen: function(para1:PScreen):PVisual;cdecl;
var XDefineCursor: function(ADisplay:PDisplay; AWindow:TWindow; ACursor:TCursor):cint;cdecl;
var XDeleteContext: function(para1:PDisplay; para2:TXID; para3:TXContext):cint;cdecl;
var XDeleteModifiermapEntry: function(para1:PXModifierKeymap; para2:TKeyCode; para3:cint):PXModifierKeymap;cdecl;
var XDeleteProperty: function(para1:PDisplay; para2:TWindow; para3:TAtom):cint;cdecl;
var XDestroyIC: procedure(para1:PXIC);cdecl;
var XDestroyOC: procedure(para1:TXOC);cdecl;
var XDestroyRegion: function(para1:TRegion):cint;cdecl;
var XDestroySubwindows: function(ADisplay:PDisplay; AWindow:TWindow):cint;cdecl;
var XDestroyWindow: function(ADisplay:PDisplay; AWindow:TWindow):cint;cdecl;
var XDirectionalDependentDrawing: function(para1:TXFontSet):TBoolResult;cdecl;
var XDisableAccessControl: function(para1:PDisplay):cint;cdecl;
var XDisplayCells: function(para1:PDisplay; para2:cint):cint;cdecl;
var XDisplayHeight: function(para1:PDisplay; para2:cint):cint;cdecl;
var XDisplayHeightMM: function(para1:PDisplay; para2:cint):cint;cdecl;
var XDisplayKeycodes: function(para1:PDisplay; para2:Pcint; para3:Pcint):cint;cdecl;
var XDisplayMotionBufferSize: function(para1:PDisplay):culong;cdecl;
var XDisplayName: function(para1:Pchar):Pchar;cdecl;
var XDisplayOfIM: function(para1:TXIM):PDisplay;cdecl;
var XDisplayOfOM: function(para1:TXOM):PDisplay;cdecl;
var XDisplayOfScreen: function(para1:PScreen):PDisplay;cdecl;
var XDisplayPlanes: function(para1:PDisplay; para2:cint):cint;cdecl;
var XDisplayString: function(para1:PDisplay):Pchar;cdecl;
var XDisplayWidth: function(para1:PDisplay; para2:cint):cint;cdecl;
var XDisplayWidthMM: function(para1:PDisplay; para2:cint):cint;cdecl;
var XDoesBackingStore: function(para1:PScreen):cint;cdecl;
var XDoesSaveUnders: function(para1:PScreen):TBoolResult;cdecl;
var XDrawArc: function(para1:PDisplay; para2:TDrawable; para3:TGC; para4:cint; para5:cint; para6:cuint; para7:cuint; para8:cint; para9:cint):cint;cdecl;
var XDrawArcs: function(para1:PDisplay; para2:TDrawable; para3:TGC; para4:PXArc; para5:cint):cint;cdecl;
var XDrawImageString: function(para1:PDisplay; para2:TDrawable; para3:TGC; para4:cint; para5:cint; para6:Pchar; para7:cint):cint;cdecl;
var XDrawImageString16: function(para1:PDisplay; para2:TDrawable; para3:TGC; para4:cint; para5:cint; para6:PXChar2b; para7:cint):cint;cdecl;
var XDrawLine: function(para1:PDisplay; para2:TDrawable; para3:TGC; para4:cint; para5:cint; para6:cint; para7:cint):cint;cdecl;
var XDrawLines: function(para1:PDisplay; para2:TDrawable; para3:TGC; para4:PXPoint; para5:cint; para6:cint):cint;cdecl;
var XDrawPoint: function(para1:PDisplay; para2:TDrawable; para3:TGC; para4:cint; para5:cint):cint;cdecl;
var XDrawPoints: function(para1:PDisplay; para2:TDrawable; para3:TGC; para4:PXPoint; para5:cint; para6:cint):cint;cdecl;
var XDrawRectangle: function(para1:PDisplay; para2:TDrawable; para3:TGC; para4:cint; para5:cint; para6:cuint; para7:cuint):cint;cdecl;
var XDrawRectangles: function(para1:PDisplay; para2:TDrawable; para3:TGC; para4:PXRectangle; para5:cint):cint;cdecl;
var XDrawSegments: function(para1:PDisplay; para2:TDrawable; para3:TGC; para4:PXSegment; para5:cint):cint;cdecl;
var XDrawString: function(para1:PDisplay; para2:TDrawable; para3:TGC; para4:cint; para5:cint; para6:Pchar; para7:cint):cint;cdecl;
var XDrawString16: function(para1:PDisplay; para2:TDrawable; para3:TGC; para4:cint; para5:cint; para6:PXChar2b; para7:cint):cint;cdecl;
var XDrawText: function(para1:PDisplay; para2:TDrawable; para3:TGC; para4:cint; para5:cint; para6:PXTextItem; para7:cint):cint;cdecl;
var XDrawText16: function(para1:PDisplay; para2:TDrawable; para3:TGC; para4:cint; para5:cint; para6:PXTextItem16; para7:cint):cint;cdecl;
var XEHeadOfExtensionList: function(para1:TXEDataObject):PPXExtData;cdecl;
var XEmptyRegion: function(para1:TRegion):cint;cdecl;
var XEnableAccessControl: function(para1:PDisplay):cint;cdecl;
var XEqualRegion: function(para1:TRegion; para2:TRegion):cint;cdecl;
var XEventMaskOfScreen: function(para1:PScreen):clong;cdecl;
var XEventsQueued: function(para1:PDisplay; para2:cint):cint;cdecl;
var XExtendedMaxRequestSize: function(para1:PDisplay):clong;cdecl;
var XExtentsOfFontSet: function(para1:TXFontSet):PXFontSetExtents;cdecl;
var XFetchBuffer: function(para1:PDisplay; para2:Pcint; para3:cint):Pchar;cdecl;
var XFetchBytes: function(para1:PDisplay; para2:Pcint):Pchar;cdecl;
var XFetchName: function(para1:PDisplay; para2:TWindow; para3:PPchar):TStatus;cdecl;
var XFillArc: function(para1:PDisplay; para2:TDrawable; para3:TGC; para4:cint; para5:cint; para6:cuint; para7:cuint; para8:cint; para9:cint):cint;cdecl;
var XFillArcs: function(para1:PDisplay; para2:TDrawable; para3:TGC; para4:PXArc; para5:cint):cint;cdecl;
var XFillPolygon: function(para1:PDisplay; para2:TDrawable; para3:TGC; para4:PXPoint; para5:cint; para6:cint; para7:cint):cint;cdecl;
var XFillRectangle: function(para1:PDisplay; para2:TDrawable; para3:TGC; para4:cint; para5:cint; para6:cuint; para7:cuint):cint;cdecl;
var XFillRectangles: function(para1:PDisplay; para2:TDrawable; para3:TGC; para4:PXRectangle; para5:cint):cint;cdecl;
var XFilterEvent: function(para1:PXEvent; para2:TWindow):TBoolResult;cdecl;
var XFindContext: function(para1:PDisplay; para2:TXID; para3:TXContext; para4:PXPointer):cint;cdecl;
var XFindOnExtensionList: function(para1:PPXExtData; para2:cint):PXExtData;cdecl;
var XFlush: function(para1:PDisplay):cint;cdecl;
var XFlushGC: procedure(para1:PDisplay; para2:TGC);cdecl;
var XFontsOfFontSet: function(para1:TXFontSet; para2:PPPXFontStruct; para3:PPPchar):cint;cdecl;
var XForceScreenSaver: function(para1:PDisplay; para2:cint):cint;cdecl;
var XFree: function(para1:pointer):cint;cdecl;
var XFreeColormap: function(para1:PDisplay; para2:TColormap):cint;cdecl;
var XFreeColors: function(para1:PDisplay; para2:TColormap; para3:Pculong; para4:cint; para5:culong):cint;cdecl;
var XFreeCursor: function(ADisplay:PDisplay; ACursor:TCursor):cint;cdecl;
var XFreeEventData: procedure( dpy: PDisplay; cookie: PXGenericEventCookie);cdecl;
var XFreeExtensionLis: function(para1:PPchar):cint;cdecl;
var XFreeFont: function(para1:PDisplay; para2:PXFontStruct):cint;cdecl;
var XFreeFontInfo: function(para1:PPchar; para2:PXFontStruct; para3:cint):cint;cdecl;
var XFreeFontNames: function(para1:PPchar):cint;cdecl;
var XFreeFontPath: function(para1:PPchar):cint;cdecl;
var XFreeFontSet: procedure(para1:PDisplay; para2:TXFontSet);cdecl;
var XFreeGC: function(para1:PDisplay; para2:TGC):cint;cdecl;
var XFreeModifiermap: function(para1:PXModifierKeymap):cint;cdecl;
var XFreePixmap: function(para1:PDisplay; para2:TPixmap):cint;cdecl;
var XFreeStringList: procedure(para1:PPchar);cdecl;
var XGContextFromGC: function(para1:TGC):TGContext;cdecl;
var XGeometry: function(para1:PDisplay; para2:cint; para3:Pchar; para4:Pchar; para5:cuint; para6:cuint; para7:cuint; para8:cint; para9:cint; para10:Pcint; para11:Pcint; para12:Pcint; para13:Pcint):cint;cdecl;
var XGetAtomName: function(para1:PDisplay; para2:TAtom):Pchar;cdecl;
var XGetAtomNames: function(para1:PDisplay; para2:PAtom; para3:cint; para4:PPchar):TStatus;cdecl;
var XGetClassHint: function(para1:PDisplay; para2:TWindow; para3:PXClassHint):TStatus;cdecl;
var XGetCommand: function(para1:PDisplay; para2:TWindow; para3:PPPchar; para4:Pcint):TStatus;cdecl;
var XGetDefault: function(para1:PDisplay; para2:Pchar; para3:Pchar):Pchar;cdecl;
var XGetErrorDatabaseText: function(para1:PDisplay; para2:Pchar; para3:Pchar; para4:Pchar; para5:Pchar; para6:cint):cint;cdecl;
var XGetErrorText: function(para1:PDisplay; para2:cint; para3:Pchar; para4:cint):cint;cdecl;
var XGetEventData: function( dpy: PDisplay; cookie: PXGenericEventCookie): TBoolResult;cdecl;
var XGetFontPath: function(para1:PDisplay; para2:Pcint):PPChar;cdecl;
var XGetFontProperty: function(para1:PXFontStruct; para2:TAtom; para3:Pculong):TBoolResult;cdecl;
var XGetGCValues: function(para1:PDisplay; para2:TGC; para3:culong; para4:PXGCValues):TStatus;cdecl;
var XGetGeometry: function(para1:PDisplay; para2:TDrawable; para3:PWindow; para4:Pcint; para5:Pcint; para6:Pcuint; para7:Pcuint; para8:Pcuint; para9:Pcuint):TStatus;cdecl;
var XGetIconName: function(para1:PDisplay; para2:TWindow; para3:PPchar):TStatus;cdecl;
var XGetIconSizes: function(para1:PDisplay; para2:TWindow; para3:PPXIconSize; para4:Pcint):TStatus;cdecl;
var XGetICValues: function(para1:TXIC; dotdotdot:array of const):Pchar;cdecl;

var XGetImage: function (para1:PDisplay; para2:TDrawable; para3:cint; para4:cint; para5:cuint;
           para6:cuint; para7:culong; para8:cint):PXImage;cdecl;

var XGetIMValues: function(para1:TXIM; dotdotdot:array of const):Pchar;cdecl;
var XGetInputFocus: function(para1:PDisplay; para2:PWindow; para3:Pcint):cint;cdecl;
var XGetKeyboardControl: function(para1:PDisplay; para2:PXKeyboardState):cint;cdecl;
var XGetKeyboardMapping: function(para1:PDisplay; para2:TKeyCode; para3:cint; para4:Pcint):PKeySym;cdecl;
var XGetModifierMapping: function(para1:PDisplay):PXModifierKeymap;cdecl;
var XGetMotionEvents: function(para1:PDisplay; para2:TWindow; para3:TTime; para4:TTime; para5:Pcint):PXTimeCoord;cdecl;
var XGetNormalHints: function(para1:PDisplay; para2:TWindow; para3:PXSizeHints):TStatus;cdecl;
var XGetOCValues: function(para1:TXOC; dotdotdot:array of const):Pchar;cdecl;
var XGetOMValues: function(para1:TXOM; dotdotdot:array of const):Pchar;cdecl;
var XGetPointerControl: function(para1:PDisplay; para2:Pcint; para3:Pcint; para4:Pcint):cint;cdecl;
var XGetPointerMapping: function(para1:PDisplay; para2:Pcuchar; para3:cint):cint;cdecl;
var XGetRGBColormaps: function(para1:PDisplay; para2:TWindow; para3:PPXStandardColormap; para4:Pcint; para5:TAtom):TStatus;cdecl;
var XGetScreenSaver: function(para1:PDisplay; para2:Pcint; para3:Pcint; para4:Pcint; para5:Pcint):cint;cdecl;
var XGetSelectionOwner: function(para1:PDisplay; para2:TAtom):TWindow;cdecl;
var XGetSizeHints: function(para1:PDisplay; para2:TWindow; para3:PXSizeHints; para4:TAtom):TStatus;cdecl;
var XGetStandardColormap: function(para1:PDisplay; para2:TWindow; para3:PXStandardColormap; para4:TAtom):TStatus;cdecl;
var XGetSubImage: function(para1:PDisplay; para2:TDrawable; para3:cint; para4:cint; para5:cuint; para6:cuint; para7:culong; para8:cint; para9:PXImage; para10:cint;   para11:cint):PXImage;cdecl;
var XGetTextProperty: function(para1:PDisplay; para2:TWindow; para3:PXTextProperty; para4:TAtom):TStatus;cdecl;
var XGetTransientForHint: function(para1:PDisplay; para2:TWindow; para3:PWindow):TStatus;cdecl;
var XGetVisualInfo: function(para1:PDisplay; para2:clong; para3:PXVisualInfo; para4:Pcint):PXVisualInfo;cdecl;
var XGetWindowAttributes: function(para1:PDisplay; para2:TWindow; para3:PXWindowAttributes):TStatus;cdecl;
var XGetWindowProperty: function(para1:PDisplay; para2:TWindow; para3:TAtom; para4:clong; para5:clong; para6:TBool; para7:TAtom; para8:PAtom; para9:Pcint; para10:Pculong; para11:Pculong; para12:PPcuchar):cint;cdecl;
var XGetWMClientMachine: function(para1:PDisplay; para2:TWindow; para3:PXTextProperty):TStatus;cdecl;
var XGetWMColormapWindows: function(para1:PDisplay; para2:TWindow; para3:PPWindow; para4:Pcint):TStatus;cdecl;
var XGetWMHints: function(para1:PDisplay; para2:TWindow):PXWMHints;cdecl;
var XGetWMIconName: function(para1:PDisplay; para2:TWindow; para3:PXTextProperty):TStatus;cdecl;
var XGetWMName: function(para1:PDisplay; para2:TWindow; para3:PXTextProperty):TStatus;cdecl;
var XGetWMNormalHints: function(para1:PDisplay; para2:TWindow; para3:PXSizeHints; para4:Pclong):TStatus;cdecl;
var XGetWMProtocols: function(para1:PDisplay; para2:TWindow; para3:PPAtom; para4:Pcint):TStatus;cdecl;
var XGetWMSizeHints: function(para1:PDisplay; para2:TWindow; para3:PXSizeHints; para4:Pclong; para5:TAtom):TStatus;cdecl;
var XGetZoomHints: function(para1:PDisplay; para2:TWindow; para3:PXSizeHints):TStatus;cdecl;
var XGrabButton: function(para1:PDisplay; para2:cuint; para3:cuint; para4:TWindow; para5:TBool; para6:cuint; para7:cint; para8:cint; para9:TWindow; para10:TCursor):cint;cdecl;
var XGrabKey: function(para1:PDisplay; para2:cint; para3:cuint; para4:TWindow; para5:TBool; para6:cint; para7:cint):cint;cdecl;
var XGrabKeyboard: function(para1:PDisplay; para2:TWindow; para3:TBool; para4:cint; para5:cint; para6:TTime):cint;cdecl;
var XGrabPointer: function(para1:PDisplay; para2:TWindow; para3:TBool; para4:cuint; para5:cint; para6:cint; para7:TWindow; para8:TCursor; para9:TTime):cint;cdecl;
var XGrabServer: function(para1:PDisplay):cint;cdecl;
var XHeightMMOfScreen: function(para1:PScreen):cint;cdecl;
var XHeightOfScreen: function(para1:PScreen):cint;cdecl;
var XIconifyWindow: function(para1:PDisplay; para2:TWindow; para3:cint):TStatus;cdecl;
var XIfEvent: function(para1:PDisplay; para2:PXEvent; para3:funcifevent; para4:TXPointer):cint;cdecl;
var XImageByteOrder: function(para1:PDisplay):cint;cdecl;
var XIMOfIC: function(para1:TXIC):TXIM;cdecl;
var XInitExtension: function(para1:PDisplay; para2:Pchar):PXExtCodes;cdecl;
var XInitImage: function(para1:PXImage):TStatus;cdecl;
var XInitThreads: function(): TStatus;cdecl;
var XInsertModifiermapEntry: function(para1:PXModifierKeymap; para2:TKeyCode; para3:cint):PXModifierKeymap;cdecl;
var XInstallColormap: function(para1:PDisplay; para2:TColormap):cint;cdecl;
var XInternalConnectionNumbers: function(para1:PDisplay; para2:PPcint; para3:Pcint):TStatus;cdecl;
var XInternAtom: function(para1:PDisplay; para2:Pchar; para3:TBool):TAtom;cdecl;
var XInternAtoms: function(para1:PDisplay; para2:PPchar; para3:cint; para4:TBool; para5:PAtom):TStatus;cdecl;
var XIntersectRegion: function(para1:TRegion; para2:TRegion; para3:TRegion):cint;cdecl;
var XKeycodeToKeysym: function(para1:PDisplay; para2:TKeyCode; para3:cint):TKeySym;cdecl;
var XKeysymToKeycode: function(para1:PDisplay; para2:TKeySym):TKeyCode;cdecl;
var XKeysymToString: function(para1:TKeySym):Pchar;cdecl;
var XKillClient: function(para1:PDisplay; para2:TXID):cint;cdecl;
var XLastKnownRequestProcessed: function(para1:PDisplay):culong;cdecl;
var XListDepths: function(para1:PDisplay; para2:cint; para3:Pcint):Pcint;cdecl;
var XListExtensions: function(para1:PDisplay; para2:Pcint):PPChar;cdecl;
var XListFonts: function(para1:PDisplay; para2:Pchar; para3:cint; para4:Pcint):PPChar;cdecl;
var XListFontsWithInfo: function(para1:PDisplay; para2:Pchar; para3:cint; para4:Pcint; para5:PPXFontStruct):PPChar;cdecl;
var XListHosts: function(para1:PDisplay; para2:Pcint; para3:PBool):PXHostAddress;cdecl;
var XListInstalledColormaps: function(para1:PDisplay; para2:TWindow; para3:Pcint):PColormap;cdecl;
var XListPixmapFormats: function(para1:PDisplay; para2:Pcint):PXPixmapFormatValues;cdecl;
var XListProperties: function(para1:PDisplay; para2:TWindow; para3:Pcint):PAtom;cdecl;
var XLoadFont: function(para1:PDisplay; para2:Pchar):TFont;cdecl;
var XLoadQueryFont: function(para1:PDisplay; para2:Pchar):PXFontStruct;cdecl;
var XLocaleOfFontSet: function(para1:TXFontSet):Pchar;cdecl;
var XLocaleOfIM: function(para1:TXIM):Pchar;cdecl;
var XLocaleOfOM: function(para1:TXOM):Pchar;cdecl;
var XLockDisplay: procedure(para1:PDisplay);cdecl;
var XLookupColor: function(para1:PDisplay; para2:TColormap; para3:Pchar; para4:PXColor; para5:PXColor):TStatus;cdecl;
var XLookupKeysym: function(para1:PXKeyEvent; para2:cint):TKeySym;cdecl;
var XLookupString: function(para1:PXKeyEvent; para2:Pchar; para3:cint; para4:PKeySym; para5:PXComposeStatus):cint;cdecl;
var XLowerWindow: function(ADisplay:PDisplay; AWindow:TWindow):cint;cdecl;
var XMapRaised: function(ADisplay:PDisplay; AWindow:TWindow):cint;cdecl;
var XMapSubwindows: function(ADisplay:PDisplay; AWindow:TWindow):cint;cdecl;
var XMapWindow: function(ADisplay:PDisplay; AWindow:TWindow):cint;cdecl;
var XMaskEvent: function(para1:PDisplay; para2:clong; para3:PXEvent):cint;cdecl;
var XMatchVisualInfo: function(para1:PDisplay; para2:cint; para3:cint; para4:cint; para5:PXVisualInfo):TStatus;cdecl;
var XMaxCmapsOfScreen: function(para1:PScreen):cint;cdecl;
var XMaxRequestSize: function(para1:PDisplay):clong;cdecl;
var XmbDrawImageString: procedure(para1:PDisplay; para2:TDrawable; para3:TXFontSet; para4:TGC; para5:cint; para6:cint; para7:Pchar; para8:cint);cdecl;
var XmbDrawString: procedure(para1:PDisplay; para2:TDrawable; para3:TXFontSet; para4:TGC; para5:cint; para6:cint; para7:Pchar; para8:cint);cdecl;
var XmbDrawText: procedure(para1:PDisplay; para2:TDrawable; para3:TGC; para4:cint; para5:cint; para6:PXmbTextItem; para7:cint);cdecl;
var XmbLookupString: function(p1: PXIC; ev: PXKeyPressedEvent; str: PChar; len: longword; ks: PKeySym; stat: PStatus):cint;cdecl;
var XmbResetIC: function(para1:TXIC):Pchar;cdecl;
var XmbSetWMProperties: procedure(para1:PDisplay; para2:TWindow; para3:Pchar; para4:Pchar; para5:PPchar; para6:cint; para7:PXSizeHints; para8:PXWMHints; para9:PXClassHint);cdecl;
var XmbTextEscapement: function(para1:TXFontSet; para2:Pchar; para3:cint):cint;cdecl;
var XmbTextExtents: function(para1:TXFontSet; para2:Pchar; para3:cint; para4:PXRectangle; para5:PXRectangle):cint;cdecl;
var XmbTextListToTextProperty: function(para1:PDisplay; para2:PPchar; para3:cint; para4:TXICCEncodingStyle; para5:PXTextProperty):cint;cdecl;
var XmbTextPerCharExtents: function(para1:TXFontSet; para2:Pchar; para3:cint; para4:PXRectangle; para5:PXRectangle; para6:cint; para7:Pcint; para8:PXRectangle; para9:PXRectangle):TStatus;cdecl;
var XmbTextPropertyToTextList: function(para1:PDisplay; para2:PXTextProperty; para3:PPPchar; para4:Pcint):cint;cdecl;
var XMinCmapsOfScreen: function(para1:PScreen):cint;cdecl;
var XMoveResizeWindow: function(ADisplay:PDisplay; AWindow:TWindow; AX:cint; AY:cint; AWidth:cuint; AHeight:cuint):cint;cdecl;
var XMoveWindow: function(ADisplay:PDisplay; AWindow:TWindow; AX:cint; AY:cint):cint;cdecl;
var XNewModifiermap: function(para1:cint):PXModifierKeymap;cdecl;
var XNextEvent: function(ADisplay:PDisplay; AEvent:PXEvent):cint;cdecl;
var XNextRequest: function(para1:PDisplay):culong;cdecl;
var XNoOp: function(para1:PDisplay):cint;cdecl;
var XOffsetRegion: function(para1:TRegion; para2:cint; para3:cint):cint;cdecl;
var XOMOfOC: function(para1:TXOC):TXOM;cdecl;
var XOpenDisplay: function(para1:Pchar):PDisplay;cdecl;
var XOpenIM: function(para1:PDisplay; para2:PXrmHashBucketRec; para3:Pchar; para4:Pchar):PXIM;cdecl;
var XOpenOM: function(para1:PDisplay; para2:PXrmHashBucketRec; para3:Pchar; para4:Pchar):TXOM;cdecl;
var XParseColor: function(para1:PDisplay; para2:TColormap; para3:Pchar; para4:PXColor):TStatus;cdecl;
var XParseGeometry: function(para1:Pchar; para2:Pcint; para3:Pcint; para4:Pcuint; para5:Pcuint):cint;cdecl;
var XPeekEvent: function(ADisplay:PDisplay; AEvent:PXEvent):cint;cdecl;
var XPeekIfEvent: function(para1:PDisplay; para2:PXEvent; para3:funcifevent; para4:TXPointer):cint;cdecl;
var XPending: function(para1:PDisplay):cint;cdecl;
var XPlanesOfScreen: function(para1:PScreen):cint;cdecl;
var XPointInRegion: function(para1:TRegion; para2:cint; para3:cint):TBoolResult;cdecl;
var XPolygonRegion: function(para1:PXPoint; para2:cint; para3:cint):TRegion;cdecl;
var XProcessInternalConnection: procedure(para1:PDisplay; para2:cint);cdecl;
var XProtocolRevision: function(para1:PDisplay):cint;cdecl;
var XProtocolVersion: function(para1:PDisplay):cint;cdecl;
var XPutBackEvent: function(para1:PDisplay; para2:PXEvent):cint;cdecl;
var XPutImage: function(para1:PDisplay; para2:TDrawable; para3:TGC; para4:PXImage; para5:cint; para6:cint; para7:cint; para8:cint; para9:cuint; para10:cuint):cint;cdecl;
var XQLength: function(para1:PDisplay):cint;cdecl;
var XQueryBestCursor: function(para1:PDisplay; para2:TDrawable; para3:cuint; para4:cuint; para5:Pcuint; para6:Pcuint):TStatus;cdecl;
var XQueryBestSize: function(para1:PDisplay; para2:cint; para3:TDrawable; para4:cuint; para5:cuint; para6:Pcuint; para7:Pcuint):TStatus;cdecl;
var XQueryBestStipple: function(para1:PDisplay; para2:TDrawable; para3:cuint; para4:cuint; para5:Pcuint;  para6:Pcuint):TStatus;cdecl;
var XQueryBestTile: function(para1:PDisplay; para2:TDrawable; para3:cuint; para4:cuint; para5:Pcuint; para6:Pcuint):TStatus;cdecl;
var XQueryColor: function(para1:PDisplay; para2:TColormap; para3:PXColor):cint;cdecl;
var XQueryColors: function(para1:PDisplay; para2:TColormap; para3:PXColor; para4:cint):cint;cdecl;
var XQueryExtension: function(para1:PDisplay; para2:Pchar; para3:Pcint; para4:Pcint; para5:Pcint):TBoolResult;cdecl;
var XQueryFont: function(para1:PDisplay; para2:TXID):PXFontStruct;cdecl;
var XQueryKeymap: function(para1:PDisplay; para2:pchararr32):cint;cdecl;
var XQueryPointer: function(para1:PDisplay; para2:TWindow; para3:PWindow; para4:PWindow; para5:Pcint; para6:Pcint; para7:Pcint; para8:Pcint; para9:Pcuint):TBoolResult;cdecl;
var XQueryTextExtents: function(para1:PDisplay; para2:TXID; para3:Pchar; para4:cint; para5:Pcint; para6:Pcint; para7:Pcint; para8:PXCharStruct):cint;cdecl;
var XQueryTextExtents16: function(para1:PDisplay; para2:TXID; para3:PXChar2b; para4:cint; para5:Pcint; para6:Pcint; para7:Pcint; para8:PXCharStruct):cint;cdecl;
var XQueryTree: function(para1:PDisplay; para2:TWindow; para3:PWindow; para4:PWindow; para5:PPWindow; para6:Pcuint):TStatus;cdecl;
var XRaiseWindow: function(para1:PDisplay; para2:TWindow):cint;cdecl;
var XReadBitmapFile: function(para1:PDisplay; para2:TDrawable; para3:Pchar; para4:Pcuint; para5:Pcuint; para6:PPixmap; para7:Pcint; para8:Pcint):cint;cdecl;
var XReadBitmapFileData: function(para1:Pchar; para2:Pcuint; para3:Pcuint; para4:PPcuchar; para5:Pcint;  para6:Pcint):cint;cdecl;
var XRebindKeysym: function(para1:PDisplay; para2:TKeySym; para3:PKeySym; para4:cint; para5:Pcuchar; para6:cint):cint;cdecl;
var XRecolorCursor: function(para1:PDisplay; para2:TCursor; para3:PXColor; para4:PXColor):cint;cdecl;
var XReconfigureWMWindow: function(para1:PDisplay; para2:TWindow; para3:cint; para4:cuint; para5:PXWindowChanges):TStatus;cdecl;
var XRectInRegion: function(para1:TRegion; para2:cint; para3:cint; para4:cuint; para5:cuint):cint;cdecl;
var XRefreshKeyboardMapping: function(para1:PXMappingEvent):cint;cdecl;
var XRegisterIMInstantiateCallback: function(para1:PDisplay; para2:PXrmHashBucketRec; para3:Pchar; para4:Pchar; para5:TXIDProc; para6:TXPointer):TBoolResult;cdecl;
var XRemoveConnectionWatch: procedure(para1:PDisplay; para2:TXConnectionWatchProc; para3:TXPointer);cdecl;
var XRemoveFromSaveSet: function(para1:PDisplay; para2:TWindow):cint;cdecl;
var XRemoveHost: function(para1:PDisplay; para2:PXHostAddress):cint;cdecl;
var XRemoveHosts: function(para1:PDisplay; para2:PXHostAddress; para3:cint):cint;cdecl;
var XReparentWindow: function(para1:PDisplay; para2:TWindow; para3:TWindow; para4:cint; para5:cint):cint;cdecl;
var XResetScreenSaver: function(para1:PDisplay):cint;cdecl;
var XResizeWindow: function(para1:PDisplay; para2:TWindow; para3:cuint; para4:cuint):cint;cdecl;
var XResourceManagerString: function(para1:PDisplay):Pchar;cdecl;
var XRestackWindows: function(para1:PDisplay; para2:PWindow; para3:cint):cint;cdecl;
var XrmInitialize: procedure();cdecl;
var XRootWindow: function(ADisplay:PDisplay; AScreenNumber:cint):TWindow;cdecl;
var XRootWindowOfScreen: function(para1:PScreen):TWindow;cdecl;
var XRotateBuffers: function(para1:PDisplay; para2:cint):cint;cdecl;
var XRotateWindowProperties: function(para1:PDisplay; para2:TWindow; para3:PAtom; para4:cint; para5:cint):cint;cdecl;
var XSaveContext: function(para1:PDisplay; para2:TXID; para3:TXContext; para4:Pchar):cint;cdecl;
var XScreenCount: function(para1:PDisplay):cint;cdecl;
var XScreenNumberOfScreen: function(para1:PScreen):cint;cdecl;
var XScreenOfDisplay: function(para1:PDisplay; para2:cint):PScreen;cdecl;
var XScreenResourceString: function(para1:PScreen):Pchar;cdecl;
var XSelectInput: function(ADisplay:PDisplay; AWindow:TWindow; AEventMask:clong):cint;cdecl;
var XSendEvent: function(para1:PDisplay; para2:TWindow; para3:TBool; para4:clong; para5:PXEvent):TStatus;cdecl;
var XServerVendor: function(para1:PDisplay):Pchar;cdecl;
var XSetAccessControl: function(para1:PDisplay; para2:cint):cint;cdecl;
var XSetAfterFunction: function(para1:PDisplay; para2:funcdisp):funcdisp;cdecl;
var XSetArcMode: function(para1:PDisplay; para2:TGC; para3:cint):cint;cdecl;
var XSetAuthorization: procedure(para1:Pchar; para2:cint; para3:Pchar; para4:cint);cdecl;
var XSetBackground: function(para1:PDisplay; para2:TGC; para3:culong):cint;cdecl;
var XSetClassHint: function(para1:PDisplay; para2:TWindow; para3:PXClassHint):cint;cdecl;
var XSetClipMask: function(para1:PDisplay; para2:TGC; para3:TPixmap):cint;cdecl;
var XSetClipOrigin: function(para1:PDisplay; para2:TGC; para3:cint; para4:cint):cint;cdecl;
var XSetClipRectangles: function(para1:PDisplay; para2:TGC; para3:cint; para4:cint; para5:PXRectangle;  para6:cint; para7:cint):cint;cdecl;
var XSetCloseDownMode: function(para1:PDisplay; para2:cint):cint;cdecl;
var XSetCommand: function(para1:PDisplay; para2:TWindow; para3:PPchar; para4:cint):cint;cdecl;
var XSetDashes: function(para1:PDisplay; para2:TGC; para3:cint; para4:Pchar; para5:cint):cint;cdecl;
var XSetErrorHandler: function(para1:TXErrorHandler):TXErrorHandler;cdecl;
var XSetFillRule: function(para1:PDisplay; para2:TGC; para3:cint):cint;cdecl;
var XSetFillStyle: function(para1:PDisplay; para2:TGC; para3:cint):cint;cdecl;
var XSetFont: function(para1:PDisplay; para2:TGC; para3:TFont):cint;cdecl;
var XSetFontPath: function(para1:PDisplay; para2:PPchar; para3:cint):cint;cdecl;
var XSetForeground: function(para1:PDisplay; para2:TGC; para3:culong):cint;cdecl;
var XSetFunction: function(para1:PDisplay; para2:TGC; para3:cint):cint;cdecl;
var XSetGraphicsExposures: function(para1:PDisplay; para2:TGC; para3:TBool):cint;cdecl;
var XSetICFocus: procedure(para1:PXIC);cdecl;
var XSetIconName: function(para1:PDisplay; para2:TWindow; para3:Pchar):cint;cdecl;
var XSetIconSizes: function(para1:PDisplay; para2:TWindow; para3:PXIconSize; para4:cint):cint;cdecl;
var XSetICValues: function(para1:TXIC; dotdotdot:array of const):Pchar;cdecl;
var XSetIMValues: function(para1:TXIM; dotdotdot:array of const):Pchar;cdecl;
var XSetInputFocus: function(para1:PDisplay; para2:TWindow; para3:cint; para4:TTime):cint;cdecl;
var XSetIOErrorHandler: function(para1:TXIOErrorHandler):TXIOErrorHandler;cdecl;
var XSetLineAttributes: function(para1:PDisplay; para2:TGC; para3:cuint; para4:cint; para5:cint; para6:cint):cint;cdecl;
var XSetLocaleModifiers: function(para1:Pchar):Pchar;cdecl;
var XSetModifierMapping: function(para1:PDisplay; para2:PXModifierKeymap):cint;cdecl;
var XSetNormalHints: function(para1:PDisplay; para2:TWindow; para3:PXSizeHints):cint;cdecl;
var XSetOCValues: function(para1:TXOC; dotdotdot:array of const):Pchar;cdecl;
var XSetOMValues: function(para1:TXOM; dotdotdot:array of const):Pchar;cdecl;
var XSetPlaneMask: function(para1:PDisplay; para2:TGC; para3:culong):cint;cdecl;
var XSetPointerMapping: function(para1:PDisplay; para2:Pcuchar; para3:cint):cint;cdecl;
var XSetRegion: function(para1:PDisplay; para2:TGC; para3:TRegion):cint;cdecl;
var XSetRGBColormaps: procedure(para1:PDisplay; para2:TWindow; para3:PXStandardColormap; para4:cint; para5:TAtom);cdecl;
var XSetScreenSaver: function(para1:PDisplay; para2:cint; para3:cint; para4:cint; para5:cint):cint;cdecl;
var XSetSelectionOwner: function(para1:PDisplay; para2:TAtom; para3:TWindow; para4:TTime):cint;cdecl;
var XSetSizeHints: function(para1:PDisplay; para2:TWindow; para3:PXSizeHints; para4:TAtom):cint;cdecl;
var XSetStandardColormap: procedure(para1:PDisplay; para2:TWindow; para3:PXStandardColormap; para4:TAtom);cdecl;
var XSetStandardProperties: function(para1:PDisplay; para2:TWindow; para3:Pchar; para4:Pchar; para5:TPixmap; para6:PPchar; para7:cint; para8:PXSizeHints):cint;cdecl;
var XSetState: function(para1:PDisplay; para2:TGC; para3:culong; para4:culong; para5:cint; para6:culong):cint;cdecl;
var XSetStipple: function(para1:PDisplay; para2:TGC; para3:TPixmap):cint;cdecl;
var XSetSubwindowMode: function(para1:PDisplay; para2:TGC; para3:cint):cint;cdecl;
var XSetTextProperty: procedure(para1:PDisplay; para2:TWindow; para3:PXTextProperty; para4:TAtom);cdecl;
var XSetTile: function(para1:PDisplay; para2:TGC; para3:TPixmap):cint;cdecl;
var XSetTransientForHint: function(ADisplay:PDisplay; AWindow:TWindow; APropWindow:TWindow):cint;cdecl;
var XSetTSOrigin: function(para1:PDisplay; para2:TGC; para3:cint; para4:cint):cint;cdecl;
var XSetWindowBackground: function(para1:PDisplay; para2:TWindow; para3:culong):cint;cdecl;
var XSetWindowBackgroundPixmap: function(para1:PDisplay; para2:TWindow; para3:TPixmap):cint;cdecl;
var XSetWindowBorder: function(para1:PDisplay; para2:TWindow; para3:culong):cint;cdecl;
var XSetWindowBorderPixmap: function(para1:PDisplay; para2:TWindow; para3:TPixmap):cint;cdecl;
var XSetWindowBorderWidth: function(para1:PDisplay; para2:TWindow; para3:cuint):cint;cdecl;
var XSetWindowColormap: function(para1:PDisplay; para2:TWindow; para3:TColormap):cint;cdecl;
var XSetWMClientMachine: procedure(para1:PDisplay; para2:TWindow; para3:PXTextProperty);cdecl;
var XSetWMColormapWindows: function(para1:PDisplay; para2:TWindow; para3:PWindow; para4:cint):TStatus;cdecl;
var XSetWMHints: function(para1:PDisplay; para2:TWindow; para3:PXWMHints):cint;cdecl;
var XSetWMIconName: procedure(para1:PDisplay; para2:TWindow; para3:PXTextProperty);cdecl;
var XSetWMName: procedure(para1:PDisplay; para2:TWindow; para3:PXTextProperty);cdecl;
var XSetWMNormalHints: procedure(ADisplay:PDisplay; AWindow:TWindow; AHints:PXSizeHints);cdecl;
var XSetWMProperties: procedure(ADisplay:PDisplay; AWindow:TWindow; AWindowName:PXTextProperty; AIconName:PXTextProperty; AArgv:PPchar; AArgc:cint; ANormalHints:PXSizeHints; AWMHints:PXWMHints; AClassHints:PXClassHint);cdecl;
var XSetWMProtocols: function(para1:PDisplay; para2:TWindow; para3:PAtom; para4:cint):TStatus;cdecl;
var XSetWMSizeHints: procedure(para1:PDisplay; para2:TWindow; para3:PXSizeHints; para4:TAtom);cdecl;
var XSetZoomHints: function(para1:PDisplay; para2:TWindow; para3:PXSizeHints):cint;cdecl;
var XShrinkRegion: function(para1:TRegion; para2:cint; para3:cint):cint;cdecl;
var XStoreBuffer: function(para1:PDisplay; para2:Pchar; para3:cint; para4:cint):cint;cdecl;
var XStoreBytes: function(para1:PDisplay; para2:Pchar; para3:cint):cint;cdecl;
var XStoreColor: function(para1:PDisplay; para2:TColormap; para3:PXColor):cint;cdecl;
var XStoreColors: function(para1:PDisplay; para2:TColormap; para3:PXColor; para4:cint):cint;cdecl;
var XStoreName: function(para1:PDisplay; para2:TWindow; para3:Pchar):cint;cdecl;
var XStoreNamedColor: function(para1:PDisplay; para2:TColormap; para3:Pchar; para4:culong; para5:cint):cint;cdecl;
var XStringListToTextProperty: function(para1:PPchar; para2:cint; para3:PXTextProperty):TStatus;cdecl;
var XStringToKeysym: function(para1:Pchar):TKeySym;cdecl;
var XSubtractRegion: function(para1:TRegion; para2:TRegion; para3:TRegion):cint;cdecl;
var XSupportsLocale: function :TBool;cdecl;
var XSync: function(para1:PDisplay; para2:TBool):cint;cdecl;
var XSynchronize: function(para1:PDisplay; para2:TBool):funcdisp;cdecl;
var XTextExtents: function(para1:PXFontStruct; para2:Pchar; para3:cint; para4:Pcint; para5:Pcint; para6:Pcint; para7:PXCharStruct):cint;cdecl;
var XTextExtents16: function(para1:PXFontStruct; para2:PXChar2b; para3:cint; para4:Pcint; para5:Pcint; para6:Pcint; para7:PXCharStruct):cint;cdecl;
var XTextPropertyToStringList: function(para1:PXTextProperty; para2:PPPchar; para3:Pcint):TStatus;cdecl;
var XTextWidth: function(para1:PXFontStruct; para2:Pchar; para3:cint):cint;cdecl;
var XTextWidth16: function(para1:PXFontStruct; para2:PXChar2b; para3:cint):cint;cdecl;
var XTranslateCoordinates: function(ADisplay:PDisplay; ASrcWindow:TWindow; ADestWindow:TWindow; ASrcX:cint; ASrcY:cint; ADestXReturn:Pcint; ADestYReturn:Pcint; AChildReturn:PWindow):TBool;cdecl;
var XUndefineCursor: function(para1:PDisplay; para2:TWindow):cint;cdecl;
var XUngrabButton: function(para1:PDisplay; para2:cuint; para3:cuint; para4:TWindow):cint;cdecl;
var XUngrabKey: function(para1:PDisplay; para2:cint; para3:cuint; para4:TWindow):cint;cdecl;
var XUngrabKeyboard: function(para1:PDisplay; para2:TTime):cint;cdecl;
var XUngrabPointer: function(para1:PDisplay; para2:TTime):cint;cdecl;
var XUngrabServer: function(para1:PDisplay):cint;cdecl;
var XUninstallColormap: function(para1:PDisplay; para2:TColormap):cint;cdecl;
var XUnionRectWithRegion: function(para1:PXRectangle; para2:TRegion; para3:TRegion):cint;cdecl;
var XUnionRegion: function(para1:TRegion; para2:TRegion; para3:TRegion):cint;cdecl;
var XUnloadFont: function(para1:PDisplay; para2:TFont):cint;cdecl;
var XUnlockDisplay: procedure(para1:PDisplay);cdecl;
var XUnmapSubwindows: function(ADisplay:PDisplay; AWindow:TWindow):cint;cdecl;
var XUnmapWindow: function(ADisplay:PDisplay; AWindow:TWindow):cint;cdecl;
var XUnregisterIMInstantiateCallback: function(para1:PDisplay; para2:PXrmHashBucketRec; para3:Pchar; para4:Pchar; para5:TXIDProc; para6:TXPointer):TBoolResult;cdecl;
var XUnsetICFocus: procedure(para1:PXIC);cdecl;
var Xutf8DrawImageString: procedure(para1:PDisplay; para2:TDrawable; para3:TXFontSet; para4:TGC; para5:cint; para6:cint; para7:Pchar; para8:cint);cdecl;
var Xutf8DrawString: procedure(para1:PDisplay; para2:TDrawable; para3:TXFontSet; para4:TGC; para5:cint; para6:cint; para7:Pchar; para8:cint);cdecl;
var Xutf8DrawText: procedure(para1:PDisplay; para2:TDrawable; para3:TGC; para4:cint; para5:cint; para6:PXmbTextItem; para7:cint);cdecl;
var Xutf8LookupString: function(para1:PXIC; para2:PXKeyPressedEvent; para3:Pchar; para4:cint; para5:PKeySym; para6:PStatus):cint;cdecl;
var Xutf8ResetIC: function(para1:PXIC):Pchar;cdecl;
var Xutf8SetWMProperties: procedure(para1:PDisplay; para2:TWindow; para3:Pchar; para4:Pchar; para5:PPchar; para6:cint; para7:PXSizeHints; para8:PXWMHints; para9:PXClassHint);cdecl;
var Xutf8TextEscapement: function(para1:TXFontSet; para2:Pchar; para3:cint):cint;cdecl;
var Xutf8TextExtents: function(para1:TXFontSet; para2:Pchar; para3:cint; para4:PXRectangle; para5:PXRectangle):cint;cdecl;
var Xutf8TextListToTextProperty: function(para1:PDisplay; para2:PPchar; para3:cint; para4:TXICCEncodingStyle; para5:PXTextProperty):cint;cdecl;
var Xutf8TextPerCharExtents: function(para1:TXFontSet; para2:Pchar; para3:cint; para4:PXRectangle; para5:PXRectangle; para6:cint; para7:Pcint; para8:PXRectangle; para9:PXRectangle):TStatus;cdecl;
var Xutf8TextPropertyToTextList: function(para1:PDisplay; para2:PXTextProperty; para3:PPPchar; para4:Pcint):cint;cdecl;
var XVaCreateNestedList: function(unused:cint; dotdotdot:array of const):TXVaNestedList;cdecl;
var XVendorRelease: function(para1:PDisplay):cint;cdecl;
var XVisualIDFromVisual: function(para1:PVisual):TVisualID;cdecl;
var XWarpPointer: function(para1:PDisplay; para2:TWindow; para3:TWindow; para4:cint; para5:cint; para6:cuint; para7:cuint; para8:cint; para9:cint):cint;cdecl;
var XwcDrawImageString: procedure(para1:PDisplay; para2:TDrawable; para3:TXFontSet; para4:TGC; para5:cint; para6:cint; para7:PWideChar; para8:cint);cdecl;
var XwcDrawString: procedure(para1:PDisplay; para2:TDrawable; para3:TXFontSet; para4:TGC; para5:cint; para6:cint; para7:PWideChar; para8:cint);cdecl;
var XwcDrawText: procedure(para1:PDisplay; para2:TDrawable; para3:TGC; para4:cint; para5:cint; para6:PXwcTextItem; para7:cint);cdecl;
var XwcFreeStringList: procedure(para1:PPWideChar);cdecl;
var XwcLookupString: function(p1: PXIC; ev: PXKeyPressedEvent; str: PChar; len: longword; ks: PKeySym; stat: PStatus):cint;cdecl;
var XwcResetIC: function(para1:TXIC):PWideChar;cdecl;
var XwcTextEscapement: function(para1:TXFontSet; para2:PWideChar; para3:cint):cint;cdecl;
var XwcTextExtents: function(para1:TXFontSet; para2:PWideChar; para3:cint; para4:PXRectangle; para5:PXRectangle):cint;cdecl;
var XwcTextListToTextProperty: function(para1:PDisplay; para2:PPWideChar; para3:cint; para4:TXICCEncodingStyle; para5:PXTextProperty):cint;cdecl;
var XwcTextPerCharExtents: function(para1:TXFontSet; para2:PWideChar; para3:cint; para4:PXRectangle; para5:PXRectangle; para6:cint; para7:Pcint; para8:PXRectangle; para9:PXRectangle):TStatus;cdecl;
var XwcTextPropertyToTextList: function(para1:PDisplay; para2:PXTextProperty; para3:PPPWideChar; para4:Pcint):cint;cdecl;
var XWhitePixel: function(ADisplay:PDisplay; AScreenNumber:cint):culong;cdecl;
var XWhitePixelOfScreen: function(para1:PScreen):culong;cdecl;
var XWidthMMOfScreen: function(para1:PScreen):cint;cdecl;
var XWidthOfScreen: function(para1:PScreen):cint;cdecl;
var XWindowEvent: function(para1:PDisplay; para2:TWindow; para3:clong; para4:PXEvent):cint;cdecl;
var XWithdrawWindow: function(para1:PDisplay; para2:TWindow; para3:cint):TStatus;cdecl;
var XWMGeometry: function(para1:PDisplay; para2:cint; para3:Pchar; para4:Pchar; para5:cuint; para6:PXSizeHints; para7:Pcint; para8:Pcint; para9:Pcint; para10:Pcint;  para11:Pcint):cint;cdecl;
var XWriteBitmapFile: function(para1:PDisplay; para2:Pchar; para3:TPixmap; para4:cuint; para5:cuint; para6:cint; para7:cint):cint;cdecl;
var XXorRegion: function(para1:TRegion; para2:TRegion; para3:TRegion):cint;cdecl;

{$ifdef MACROS}
function ConnectionNumber(dpy : PDisplay) : cint;
function RootWindow(dpy : PDisplay; scr : cint) : TWindow;
function DefaultScreen(dpy : PDisplay) : cint;
function DefaultRootWindow(dpy : PDisplay) : TWindow;
function DefaultVisual(dpy : PDisplay; scr : cint) : PVisual;
function DefaultGC(dpy : PDisplay; scr : cint) : TGC;
function BlackPixel(dpy : PDisplay; scr : cint) : culong;
function WhitePixel(dpy : PDisplay; scr : cint) : culong;
function QLength(dpy : PDisplay) : cint;
function DisplayWidth(dpy : PDisplay; scr : cint) : cint;
function DisplayHeight(dpy : PDisplay; scr : cint) : cint;
function DisplayWidthMM(dpy : PDisplay; scr : cint) : cint;
function DisplayHeightMM(dpy : PDisplay; scr : cint) : cint;
function DisplayPlanes(dpy : PDisplay; scr : cint) : cint;
function DisplayCells(dpy : PDisplay; scr : cint) : cint;
function ScreenCount(dpy : PDisplay) : cint;
function ServerVendor(dpy : PDisplay) : Pchar;
function ProtocolVersion(dpy : PDisplay) : cint;
function ProtocolRevision(dpy : PDisplay) : cint;
function VendorRelease(dpy : PDisplay) : cint;
function DisplayString(dpy : PDisplay) : Pchar;
function DefaultDepth(dpy : PDisplay; scr : cint) : cint;
function DefaultColormap(dpy : PDisplay; scr : cint) : TColormap;
function BitmapUnit(dpy : PDisplay) : cint;
function BitmapBitOrder(dpy : PDisplay) : cint;
function BitmapPad(dpy : PDisplay) : cint;
function ImageByteOrder(dpy : PDisplay) : cint;
function NextRequest(dpy : PDisplay) : culong;
function LastKnownRequestProcessed(dpy : PDisplay) : culong;
function ScreenOfDisplay(dpy : PDisplay; scr : cint) : PScreen;
function DefaultScreenOfDisplay(dpy : PDisplay) : PScreen;
function DisplayOfScreen(s : PScreen) : PDisplay;
function RootWindowOfScreen(s : PScreen) : TWindow;
function BlackPixelOfScreen(s : PScreen) : culong;
function WhitePixelOfScreen(s : PScreen) : culong;
function DefaultColormapOfScreen(s : PScreen) : TColormap;
function DefaultDepthOfScreen(s : PScreen) : cint;
function DefaultGCOfScreen(s : PScreen) : TGC;
function DefaultVisualOfScreen(s : PScreen) : PVisual;
function WidthOfScreen(s : PScreen) : cint;
function HeightOfScreen(s : PScreen) : cint;
function WidthMMOfScreen(s : PScreen) : cint;
function HeightMMOfScreen(s : PScreen) : cint;
function PlanesOfScreen(s : PScreen) : cint;
function CellsOfScreen(s : PScreen) : cint;
function MinCmapsOfScreen(s : PScreen) : cint;
function MaxCmapsOfScreen(s : PScreen) : cint;
function DoesSaveUnders(s : PScreen) : TBool;
function DoesBackingStore(s : PScreen) : cint;
function EventMaskOfScreen(s : PScreen) : clong;
function XAllocID(dpy : PDisplay) : TXID;

// from xutil.pp
function XDestroyImage(ximage : PXImage) : cint;
function XGetPixel(ximage : PXImage; x, y : cint) : culong;
function XPutPixel(ximage : PXImage; x, y : cint; pixel : culong) : cint;
function XSubImage(ximage : PXImage; x, y : cint; width, height : cuint) : PXImage;
function XAddPixel(ximage : PXImage; value : clong) : cint;
function IsKeypadKey(keysym : TKeySym) : Boolean;
function IsPrivateKeypadKey(keysym : TKeySym) : Boolean;
function IsCursorKey(keysym : TKeySym) : Boolean;
function IsPFKey(keysym : TKeySym) : Boolean;
function IsFunctionKey(keysym : TKeySym) : Boolean;
function IsMiscFunctionKey(keysym : TKeySym) : Boolean;
function IsModifierKey(keysym : TKeySym) : Boolean;


{$endif MACROS}

var x_Handle:TLibHandle=dynlibs.NilHandle; // this will hold our handle for the lib; it functions nicely as a mutli-lib prevention unit as well...

    var ReferenceCounter : cardinal = 0;  // Reference counter
         
    function x_IsLoaded() : boolean; inline; 

    Function x_Load(const libfilename:string = libX11) :boolean; // load the lib

    Procedure x_Unload(); // unload and frees the lib from memory : do not forget to call it before close application.

   // Procedure dummy() ; cdecl; external libX11;

implementation

function x_IsLoaded(): boolean;
begin
 Result := (x_Handle <> dynlibs.NilHandle);
end;

Function x_Load (const libfilename:string = libX11) :boolean;
begin
  Result := False;
  if x_Handle<>0 then 
begin
 Inc(ReferenceCounter);
 result:=true {is it already there ?}
end  else 
begin {go & load the library}
    if Length(libfilename) = 0 then exit;
    x_Handle:=DynLibs.SafeLoadLibrary(libfilename); // obtain the handle we want
  	if x_Handle <> DynLibs.NilHandle then
begin {now we tie the functions to the VARs from above}

{
// from fpg_netlayer_x11.pas
Pointer(XDefaultRootWindow):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDefaultRootWindow'));
Pointer(XInternAtom):=DynLibs.GetProcedureAddress(x_Handle,PChar('XInternAtom'));
Pointer(XFree):=DynLibs.GetProcedureAddress(x_Handle,PChar('XFree'));
Pointer(XGetWindowProperty):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetWindowProperty'));
Pointer(XChangeProperty):=DynLibs.GetProcedureAddress(x_Handle,PChar('XChangeProperty'));
Pointer(XGetWMProtocols):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetWMProtocols'));
Pointer(XSendEvent):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSendEvent'));
Pointer(XSetWMProtocols):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetWMProtocols'));
}
 Pointer(XActivateScreenSaver):=DynLibs.GetProcedureAddress(x_Handle,PChar('XActivateScreenSaver'));
 Pointer(XAddConnectionWatch):=DynLibs.GetProcedureAddress(x_Handle,PChar('XAddConnectionWatch'));
 Pointer(XAddExtension):=DynLibs.GetProcedureAddress(x_Handle,PChar('XAddExtension'));
 Pointer(XAddHost):=DynLibs.GetProcedureAddress(x_Handle,PChar('XAddHost'));
 Pointer(XAddHosts):=DynLibs.GetProcedureAddress(x_Handle,PChar('XAddHosts'));
 Pointer(XAddToExtensionList):=DynLibs.GetProcedureAddress(x_Handle,PChar('XAddToExtensionList'));
 Pointer(XAddToSaveSet):=DynLibs.GetProcedureAddress(x_Handle,PChar('XAddToSaveSet'));
 Pointer(XAllocClassHint):=DynLibs.GetProcedureAddress(x_Handle,PChar('XAllocClassHint'));
 Pointer(XAllocColor):=DynLibs.GetProcedureAddress(x_Handle,PChar('XAllocColor'));
 Pointer(XAllocColorCells):=DynLibs.GetProcedureAddress(x_Handle,PChar('XAllocColorCells'));
 Pointer(XAllocColorPlanes):=DynLibs.GetProcedureAddress(x_Handle,PChar('XAllocColorPlanes'));
 Pointer(XAllocIconSize):=DynLibs.GetProcedureAddress(x_Handle,PChar('XAllocIconSize'));
 Pointer(XAllocNamedColor):=DynLibs.GetProcedureAddress(x_Handle,PChar('XAllocNamedColor'));
 Pointer(XAllocSizeHints):=DynLibs.GetProcedureAddress(x_Handle,PChar('XAllocSizeHints'));
 Pointer(XAllocStandardColormap):=DynLibs.GetProcedureAddress(x_Handle,PChar('XAllocStandardColormap'));
 Pointer(XAllocWMHints):=DynLibs.GetProcedureAddress(x_Handle,PChar('XAllocWMHints'));
 Pointer(XAllowEvents):=DynLibs.GetProcedureAddress(x_Handle,PChar('XAllowEvents'));
 Pointer(XAllPlanes):=DynLibs.GetProcedureAddress(x_Handle,PChar('XAllPlanes'));
 Pointer(XAutoRepeatOff):=DynLibs.GetProcedureAddress(x_Handle,PChar('XAutoRepeatOff'));
 Pointer(XAutoRepeatOn):=DynLibs.GetProcedureAddress(x_Handle,PChar('XAutoRepeatOn'));
 Pointer(XBaseFontNameListOfFontSet):=DynLibs.GetProcedureAddress(x_Handle,PChar('XBaseFontNameListOfFontSet'));
 Pointer(XBell):=DynLibs.GetProcedureAddress(x_Handle,PChar('XBell'));
 Pointer(XBitmapBitOrder):=DynLibs.GetProcedureAddress(x_Handle,PChar('XBitmapBitOrder'));
 Pointer(XBitmapPad):=DynLibs.GetProcedureAddress(x_Handle,PChar('XBitmapPad'));
 Pointer(XBitmapUnit):=DynLibs.GetProcedureAddress(x_Handle,PChar('XBitmapUnit'));
 Pointer(XBlackPixel):=DynLibs.GetProcedureAddress(x_Handle,PChar('XBlackPixel'));
 Pointer(XBlackPixelOfScreen):=DynLibs.GetProcedureAddress(x_Handle,PChar('XBlackPixelOfScreen'));
 Pointer(XCellsOfScreen):=DynLibs.GetProcedureAddress(x_Handle,PChar('XCellsOfScreen'));
 Pointer(XChangeActivePointerGrab):=DynLibs.GetProcedureAddress(x_Handle,PChar('XChangeActivePointerGrab'));
 Pointer(XChangeGC):=DynLibs.GetProcedureAddress(x_Handle,PChar('XChangeGC'));
 Pointer(XChangeKeyboardControl):=DynLibs.GetProcedureAddress(x_Handle,PChar('XChangeKeyboardControl'));
 Pointer(XChangeKeyboardMapping):=DynLibs.GetProcedureAddress(x_Handle,PChar('XChangeKeyboardMapping'));
 Pointer(XChangePointerControl):=DynLibs.GetProcedureAddress(x_Handle,PChar('XChangePointerControl'));
 Pointer(XChangeProperty):=DynLibs.GetProcedureAddress(x_Handle,PChar('XChangeProperty'));
 Pointer(XChangeSaveSet):=DynLibs.GetProcedureAddress(x_Handle,PChar('XChangeSaveSet'));
 Pointer(XChangeWindowAttributes):=DynLibs.GetProcedureAddress(x_Handle,PChar('XChangeWindowAttributes'));
 Pointer(XCheckIfEvent):=DynLibs.GetProcedureAddress(x_Handle,PChar('XCheckIfEvent'));
 Pointer(XCheckTypedEvent):=DynLibs.GetProcedureAddress(x_Handle,PChar('XCheckTypedEvent'));
 Pointer(XCheckTypedWindowEvent):=DynLibs.GetProcedureAddress(x_Handle,PChar('XCheckTypedWindowEvent'));
 Pointer(XCheckWindowEvent):=DynLibs.GetProcedureAddress(x_Handle,PChar('XCheckWindowEvent'));
 Pointer(XCirculateSubwindows):=DynLibs.GetProcedureAddress(x_Handle,PChar('XCirculateSubwindows'));
 Pointer(XCirculateSubwindowsDown):=DynLibs.GetProcedureAddress(x_Handle,PChar('XCirculateSubwindowsDown'));
 Pointer(XCirculateSubwindowsUp):=DynLibs.GetProcedureAddress(x_Handle,PChar('XCirculateSubwindowsUp'));
 Pointer(XClearArea):=DynLibs.GetProcedureAddress(x_Handle,PChar('XClearArea'));
 Pointer(XClearWindow):=DynLibs.GetProcedureAddress(x_Handle,PChar('XClearWindow'));
 Pointer(XClipBox):=DynLibs.GetProcedureAddress(x_Handle,PChar('XClipBox'));
 Pointer(XCloseDisplay):=DynLibs.GetProcedureAddress(x_Handle,PChar('XCloseDisplay'));
 Pointer(XCloseIM):=DynLibs.GetProcedureAddress(x_Handle,PChar('XCloseIM'));
 Pointer(XCloseOM):=DynLibs.GetProcedureAddress(x_Handle,PChar('XCloseOM'));
 Pointer(XConfigureWindow):=DynLibs.GetProcedureAddress(x_Handle,PChar('XConfigureWindow'));
 Pointer(XConnectionNumber):=DynLibs.GetProcedureAddress(x_Handle,PChar('XConnectionNumber'));
 Pointer(XContextDependentDrawing):=DynLibs.GetProcedureAddress(x_Handle,PChar('XContextDependentDrawing'));
 Pointer(XContextualDrawing):=DynLibs.GetProcedureAddress(x_Handle,PChar('XContextualDrawing'));
 Pointer(XConvertCase):=DynLibs.GetProcedureAddress(x_Handle,PChar('XConvertCase'));
 Pointer(XConvertSelection):=DynLibs.GetProcedureAddress(x_Handle,PChar('XConvertSelection'));
 Pointer(XCopyArea):=DynLibs.GetProcedureAddress(x_Handle,PChar('XCopyArea'));
 Pointer(XCopyColormapAndFree):=DynLibs.GetProcedureAddress(x_Handle,PChar('XCopyColormapAndFree'));
 Pointer(XCopyGC):=DynLibs.GetProcedureAddress(x_Handle,PChar('XCopyGC'));
 Pointer(XCopyPlane):=DynLibs.GetProcedureAddress(x_Handle,PChar('XCopyPlane'));
 Pointer(XCreateBitmapFromData):=DynLibs.GetProcedureAddress(x_Handle,PChar('XCreateBitmapFromData'));
 Pointer(XCreateColormap):=DynLibs.GetProcedureAddress(x_Handle,PChar('XCreateColormap'));
 Pointer(XCreateFontCursor):=DynLibs.GetProcedureAddress(x_Handle,PChar('XCreateFontCursor'));
 Pointer(XCreateFontSet):=DynLibs.GetProcedureAddress(x_Handle,PChar('XCreateFontSet'));
 Pointer(XCreateGC):=DynLibs.GetProcedureAddress(x_Handle,PChar('XCreateGC'));
 Pointer(XCreateGlyphCursor):=DynLibs.GetProcedureAddress(x_Handle,PChar('XCreateGlyphCursor'));
 Pointer(XCreateIC):=DynLibs.GetProcedureAddress(x_Handle,PChar('XCreateIC'));
 Pointer(XCreateImage):=DynLibs.GetProcedureAddress(x_Handle,PChar('XCreateImage'));
 Pointer(XCreateOC):=DynLibs.GetProcedureAddress(x_Handle,PChar('XCreateOC'));
 Pointer(XCreatePixmap):=DynLibs.GetProcedureAddress(x_Handle,PChar('XCreatePixmap'));
 Pointer(XCreatePixmapCursor):=DynLibs.GetProcedureAddress(x_Handle,PChar('XCreatePixmapCursor'));
 Pointer(XCreatePixmapFromBitmapData):=DynLibs.GetProcedureAddress(x_Handle,PChar('XCreatePixmapFromBitmapData'));
 Pointer(XCreateRegion):=DynLibs.GetProcedureAddress(x_Handle,PChar('XCreateRegion'));
 Pointer(XCreateSimpleWindow):=DynLibs.GetProcedureAddress(x_Handle,PChar('XCreateSimpleWindow'));
 Pointer(XCreateWindow):=DynLibs.GetProcedureAddress(x_Handle,PChar('XCreateWindow'));
 Pointer(XDefaultColormap):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDefaultColormap'));
 Pointer(XDefaultColormapOfScreen):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDefaultColormapOfScreen'));
 Pointer(XDefaultDepth):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDefaultDepth'));
 Pointer(XDefaultDepthOfScreen):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDefaultDepthOfScreen'));
 Pointer(XDefaultGC):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDefaultGC'));
 Pointer(XDefaultGCOfScreen):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDefaultGCOfScreen'));
 Pointer(XDefaultRootWindow):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDefaultRootWindow'));
 Pointer(XDefaultScreen):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDefaultScreen'));
 Pointer(XDefaultScreenOfDisplay):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDefaultScreenOfDisplay'));
 Pointer(XDefaultString):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDefaultString'));
 Pointer(XDefaultString):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDefaultString'));
 Pointer(XDefaultVisual):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDefaultVisual'));
 Pointer(XDefaultVisualOfScreen):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDefaultVisualOfScreen'));
 Pointer(XDefineCursor):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDefineCursor'));
 Pointer(XDeleteContext):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDeleteContext'));
 Pointer(XDeleteModifiermapEntry):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDeleteModifiermapEntry'));
 Pointer(XDeleteProperty):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDeleteProperty'));
 Pointer(XDestroyIC):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDestroyIC'));
 Pointer(XDestroyOC):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDestroyOC'));
 Pointer(XDestroyRegion):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDestroyRegion'));
 Pointer(XDestroySubwindows):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDestroySubwindows'));
 Pointer(XDestroyWindow):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDestroyWindow'));
 Pointer(XDirectionalDependentDrawing):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDirectionalDependentDrawing'));
 Pointer(XDisableAccessControl):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDisableAccessControl'));
 Pointer(XDisplayCells):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDisplayCells'));
 Pointer(XDisplayHeight):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDisplayHeight'));
 Pointer(XDisplayHeightMM):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDisplayHeightMM'));
 Pointer(XDisplayKeycodes):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDisplayKeycodes'));
 Pointer(XDisplayMotionBufferSize):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDisplayMotionBufferSize'));
 Pointer(XDisplayName):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDisplayName'));
 Pointer(XDisplayOfIM):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDisplayOfIM'));
 Pointer(XDisplayOfOM):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDisplayOfOM'));
 Pointer(XDisplayOfScreen):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDisplayOfScreen'));
 Pointer(XDisplayPlanes):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDisplayPlanes'));
 Pointer(XDisplayString):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDisplayString'));
 Pointer(XDisplayWidthMM):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDisplayWidthMM'));
 Pointer(XDoesBackingStore):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDoesBackingStore'));
 Pointer(XDoesSaveUnders):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDoesSaveUnders'));
 Pointer(XDrawArc):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDrawArc'));
 Pointer(XDrawArcs):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDrawArcs'));
 Pointer(XDrawImageString):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDrawImageString'));
 Pointer(XDrawImageString16):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDrawImageString16'));
 Pointer(XDrawLine):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDrawLine'));
 Pointer(XDrawLines):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDrawLines'));
 Pointer(XDrawPoint):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDrawPoint'));
 Pointer(XDrawPoints):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDrawPoints'));
 Pointer(XDrawRectangle):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDrawRectangle'));
 Pointer(XDrawRectangles):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDrawRectangles'));
 Pointer(XDrawSegments):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDrawSegments'));
 Pointer(XDrawString):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDrawString'));
 Pointer(XDrawString16):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDrawString16'));
 Pointer(XDrawText):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDrawText'));
 Pointer(XDrawText16):=DynLibs.GetProcedureAddress(x_Handle,PChar('XDrawText16'));
 Pointer(XEHeadOfExtensionList):=DynLibs.GetProcedureAddress(x_Handle,PChar('XEHeadOfExtensionList'));
 Pointer(XEmptyRegion):=DynLibs.GetProcedureAddress(x_Handle,PChar('XEmptyRegion'));
 Pointer(XEnableAccessControl):=DynLibs.GetProcedureAddress(x_Handle,PChar('XEnableAccessControl'));
 Pointer(XEqualRegion):=DynLibs.GetProcedureAddress(x_Handle,PChar('XEqualRegion'));
 Pointer(XEventMaskOfScreen):=DynLibs.GetProcedureAddress(x_Handle,PChar('XEventMaskOfScreen'));
 Pointer(XEventsQueued):=DynLibs.GetProcedureAddress(x_Handle,PChar('XEventsQueued'));
 Pointer(XExtendedMaxRequestSize):=DynLibs.GetProcedureAddress(x_Handle,PChar('XExtendedMaxRequestSize'));
 Pointer(XExtentsOfFontSet):=DynLibs.GetProcedureAddress(x_Handle,PChar('XExtentsOfFontSet'));
 Pointer(XFetchBytes):=DynLibs.GetProcedureAddress(x_Handle,PChar('XFetchBytes'));
 Pointer(XFetchName):=DynLibs.GetProcedureAddress(x_Handle,PChar('XFetchName'));
 Pointer(XFillArc):=DynLibs.GetProcedureAddress(x_Handle,PChar('XFillArc'));
 Pointer(XFillArcs):=DynLibs.GetProcedureAddress(x_Handle,PChar('XFillArcs'));
 Pointer(XFillPolygon):=DynLibs.GetProcedureAddress(x_Handle,PChar('XFillPolygon'));
 Pointer(XFillRectangle):=DynLibs.GetProcedureAddress(x_Handle,PChar('XFillRectangle'));
 Pointer(XFillRectangles):=DynLibs.GetProcedureAddress(x_Handle,PChar('XFillRectangles'));
 Pointer(XFilterEvent):=DynLibs.GetProcedureAddress(x_Handle,PChar('XFilterEvent'));
 Pointer(XFindContext):=DynLibs.GetProcedureAddress(x_Handle,PChar('XFindContext'));
 Pointer(XFindOnExtensionList):=DynLibs.GetProcedureAddress(x_Handle,PChar('XFindOnExtensionList'));
 Pointer(XFlush):=DynLibs.GetProcedureAddress(x_Handle,PChar('XFlush'));
 Pointer(XFlushGC):=DynLibs.GetProcedureAddress(x_Handle,PChar('XFlushGC'));
 Pointer(XFontsOfFontSet):=DynLibs.GetProcedureAddress(x_Handle,PChar('XFontsOfFontSet'));
 Pointer(XForceScreenSaver):=DynLibs.GetProcedureAddress(x_Handle,PChar('XForceScreenSaver'));
 Pointer(XFree):=DynLibs.GetProcedureAddress(x_Handle,PChar('XFree'));
 Pointer(XFreeColormap):=DynLibs.GetProcedureAddress(x_Handle,PChar('XFreeColormap'));
 Pointer(XFreeColors):=DynLibs.GetProcedureAddress(x_Handle,PChar('XFreeColors'));
 Pointer(XFreeCursor):=DynLibs.GetProcedureAddress(x_Handle,PChar('XFreeCursor'));
 Pointer(XFreeEventData):=DynLibs.GetProcedureAddress(x_Handle,PChar('XFreeEventData'));
 Pointer(XFreeExtensionLis):=DynLibs.GetProcedureAddress(x_Handle,PChar('XFreeExtensionLis'));
 Pointer(XFreeFont):=DynLibs.GetProcedureAddress(x_Handle,PChar('XFreeFont'));
 Pointer(XFreeFontInfo):=DynLibs.GetProcedureAddress(x_Handle,PChar('XFreeFontInfo'));
 Pointer(XFreeFontNames):=DynLibs.GetProcedureAddress(x_Handle,PChar('XFreeFontNames'));
 Pointer(XFreeFontPath):=DynLibs.GetProcedureAddress(x_Handle,PChar('XFreeFontPath'));
 Pointer(XFreeFontSet):=DynLibs.GetProcedureAddress(x_Handle,PChar('XFreeFontSet'));
 Pointer(XFreeGC):=DynLibs.GetProcedureAddress(x_Handle,PChar('XFreeGC'));
 Pointer(XFreeModifiermap):=DynLibs.GetProcedureAddress(x_Handle,PChar('XFreeModifiermap'));
 Pointer(XFreePixmap):=DynLibs.GetProcedureAddress(x_Handle,PChar('XFreePixmap'));
 Pointer(XFreeStringList):=DynLibs.GetProcedureAddress(x_Handle,PChar('XFreeStringList'));
 Pointer(XGContextFromGC):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGContextFromGC'));
 Pointer(XGeometry):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGeometry'));
 Pointer(XGetAtomName):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetAtomName'));
 Pointer(XGetAtomNames):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetAtomNames'));
 Pointer(XGetClassHint):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetClassHint'));
 Pointer(XGetCommand):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetCommand'));
 Pointer(XGetDefault):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetDefault'));
 Pointer(XGetErrorDatabaseText):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetErrorDatabaseText'));
 Pointer(XGetErrorText):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetErrorText'));
 Pointer(XGetEventData):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetEventData'));
 Pointer(XGetFontPath):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetFontPath'));
 Pointer(XGetFontProperty):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetFontProperty'));
 Pointer(XGetGCValues):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetGCValues'));
 Pointer(XGetGeometry):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetGeometry'));
 Pointer(XGetIconName):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetIconName'));
 Pointer(XGetIconSizes):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetIconSizes'));
 Pointer(XGetICValues):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetICValues'));
 Pointer(XGetImage):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetImage'));
 Pointer(XGetIMValues):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetIMValues'));
 Pointer(XGetInputFocus):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetInputFocus'));
 Pointer(XGetKeyboardControl):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetKeyboardControl'));
 Pointer(XGetModifierMapping):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetModifierMapping'));
 Pointer(XGetMotionEvents):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetMotionEvents'));
 Pointer(XGetNormalHints):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetNormalHints'));
 Pointer(XGetOCValues):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetOCValues'));
 Pointer(XGetOMValues):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetOMValues'));
 Pointer(XGetPointerControl):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetPointerControl'));
 Pointer(XGetPointerMapping):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetPointerMapping'));
 Pointer(XGetRGBColormaps):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetRGBColormaps'));
 Pointer(XGetScreenSaver):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetScreenSaver'));
 Pointer(XGetSelectionOwner):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetSelectionOwner'));
 Pointer(XGetSizeHints):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetSizeHints'));
 Pointer(XGetStandardColormap):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetStandardColormap'));
 Pointer(XGetSubImage):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetSubImage'));
 Pointer(XGetTextProperty):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetTextProperty'));
 Pointer(XGetTransientForHint):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetTransientForHint'));
 Pointer(XGetVisualInfo):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetVisualInfo'));
 Pointer(XGetWindowAttributes):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetWindowAttributes'));
 Pointer(XGetWindowProperty):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetWindowProperty'));
 Pointer(XGetWMClientMachine):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetWMClientMachine'));
 Pointer(XGetWMColormapWindows):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetWMColormapWindows'));
 Pointer(XGetWMHints):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetWMHints'));
 Pointer(XGetWMIconName):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetWMIconName'));
 Pointer(XGetWMName):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetWMName'));
 Pointer(XGetWMNormalHints):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetWMNormalHints'));
 Pointer(XGetWMProtocols):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetWMProtocols'));
 Pointer(XGetWMSizeHints):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetWMSizeHints'));
 Pointer(XGetZoomHints):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGetZoomHints'));
 Pointer(XGrabButton):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGrabButton'));
 Pointer(XGrabKey):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGrabKey'));
 Pointer(XGrabKeyboard):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGrabKeyboard'));
 Pointer(XGrabPointer):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGrabPointer'));
 Pointer(XGrabServer):=DynLibs.GetProcedureAddress(x_Handle,PChar('XGrabServer'));
 Pointer(XHeightMMOfScreen):=DynLibs.GetProcedureAddress(x_Handle,PChar('XHeightMMOfScreen'));
 Pointer(XIconifyWindow):=DynLibs.GetProcedureAddress(x_Handle,PChar('XIconifyWindow'));
 Pointer(XIfEvent):=DynLibs.GetProcedureAddress(x_Handle,PChar('XIfEvent'));
 Pointer(XImageByteOrder):=DynLibs.GetProcedureAddress(x_Handle,PChar('XImageByteOrder'));
 Pointer(XIMOfIC):=DynLibs.GetProcedureAddress(x_Handle,PChar('XIMOfIC'));
 Pointer(XInitExtension):=DynLibs.GetProcedureAddress(x_Handle,PChar('XInitExtension'));
 Pointer(XInitImage):=DynLibs.GetProcedureAddress(x_Handle,PChar('XInitImage'));
 Pointer(XInitThreads):=DynLibs.GetProcedureAddress(x_Handle,PChar('XInitThreads'));
 Pointer(XInsertModifiermapEntry):=DynLibs.GetProcedureAddress(x_Handle,PChar('XInsertModifiermapEntry'));
 Pointer(XInstallColormap):=DynLibs.GetProcedureAddress(x_Handle,PChar('XInstallColormap'));
 Pointer(XInternalConnectionNumbers):=DynLibs.GetProcedureAddress(x_Handle,PChar('XInternalConnectionNumbers'));
 Pointer(XInternAtom):=DynLibs.GetProcedureAddress(x_Handle,PChar('XInternAtom'));
 Pointer(XIntersectRegion):=DynLibs.GetProcedureAddress(x_Handle,PChar('XIntersectRegion'));
 Pointer(XKeycodeToKeysym):=DynLibs.GetProcedureAddress(x_Handle,PChar('XKeycodeToKeysym'));
 Pointer(XKeysymToKeycode):=DynLibs.GetProcedureAddress(x_Handle,PChar('XKeysymToKeycode'));
 Pointer(XKeysymToString):=DynLibs.GetProcedureAddress(x_Handle,PChar('XKeysymToString'));
 Pointer(XKillClient):=DynLibs.GetProcedureAddress(x_Handle,PChar('XKillClient'));
 Pointer(XLastKnownRequestProcessed):=DynLibs.GetProcedureAddress(x_Handle,PChar('XLastKnownRequestProcessed'));
 Pointer(XListDepths):=DynLibs.GetProcedureAddress(x_Handle,PChar('XListDepths'));
 Pointer(XListExtensions):=DynLibs.GetProcedureAddress(x_Handle,PChar('XListExtensions'));
 Pointer(XListFonts):=DynLibs.GetProcedureAddress(x_Handle,PChar('XListFonts'));
 Pointer(XListFontsWithInfo):=DynLibs.GetProcedureAddress(x_Handle,PChar('XListFontsWithInfo'));
 Pointer(XListHosts):=DynLibs.GetProcedureAddress(x_Handle,PChar('XListHosts'));
 Pointer(XListInstalledColormaps):=DynLibs.GetProcedureAddress(x_Handle,PChar('XListInstalledColormaps'));
 Pointer(XListPixmapFormats):=DynLibs.GetProcedureAddress(x_Handle,PChar('XListPixmapFormats'));
 Pointer(XListProperties):=DynLibs.GetProcedureAddress(x_Handle,PChar('XListProperties'));
 Pointer(XLoadFont):=DynLibs.GetProcedureAddress(x_Handle,PChar('XLoadFont'));
 Pointer(XLoadQueryFont):=DynLibs.GetProcedureAddress(x_Handle,PChar('XLoadQueryFont'));
 Pointer(XLocaleOfFontSet):=DynLibs.GetProcedureAddress(x_Handle,PChar('XLocaleOfFontSet'));
 Pointer(XLocaleOfIM):=DynLibs.GetProcedureAddress(x_Handle,PChar('XLocaleOfIM'));
 Pointer(XLocaleOfOM):=DynLibs.GetProcedureAddress(x_Handle,PChar('XLocaleOfOM'));
 Pointer(XLockDisplay):=DynLibs.GetProcedureAddress(x_Handle,PChar('XLockDisplay'));
 Pointer(XLookupColor):=DynLibs.GetProcedureAddress(x_Handle,PChar('XLookupColor'));
 Pointer(XLookupString):=DynLibs.GetProcedureAddress(x_Handle,PChar('XLookupString'));
 Pointer(XLowerWindow):=DynLibs.GetProcedureAddress(x_Handle,PChar('XLowerWindow'));
 Pointer(XMapRaised):=DynLibs.GetProcedureAddress(x_Handle,PChar('XMapRaised'));
 Pointer(XMapSubwindows):=DynLibs.GetProcedureAddress(x_Handle,PChar('XMapSubwindows'));
 Pointer(XMapWindow):=DynLibs.GetProcedureAddress(x_Handle,PChar('XMapWindow'));
 Pointer(XMaskEvent):=DynLibs.GetProcedureAddress(x_Handle,PChar('XMaskEvent'));
 Pointer(XMatchVisualInfo):=DynLibs.GetProcedureAddress(x_Handle,PChar('XMatchVisualInfo'));
 Pointer(XMaxCmapsOfScreen):=DynLibs.GetProcedureAddress(x_Handle,PChar('XMaxCmapsOfScreen'));
 Pointer(XMaxRequestSize):=DynLibs.GetProcedureAddress(x_Handle,PChar('XMaxRequestSize'));
 Pointer(XmbDrawImageString):=DynLibs.GetProcedureAddress(x_Handle,PChar('XmbDrawImageString'));
 Pointer(XmbDrawString):=DynLibs.GetProcedureAddress(x_Handle,PChar('XmbDrawString'));
 Pointer(XmbDrawText):=DynLibs.GetProcedureAddress(x_Handle,PChar('XmbDrawText'));
 Pointer(XmbLookupString):=DynLibs.GetProcedureAddress(x_Handle,PChar('XmbLookupString'));
 Pointer(XmbResetIC):=DynLibs.GetProcedureAddress(x_Handle,PChar('XmbResetIC'));
 Pointer(XmbSetWMProperties):=DynLibs.GetProcedureAddress(x_Handle,PChar('XmbSetWMProperties'));
 Pointer(XmbTextEscapement):=DynLibs.GetProcedureAddress(x_Handle,PChar('XmbTextEscapement'));
 Pointer(XmbTextExtents):=DynLibs.GetProcedureAddress(x_Handle,PChar('XmbTextExtents'));
 Pointer(XmbTextListToTextProperty):=DynLibs.GetProcedureAddress(x_Handle,PChar('XmbTextListToTextProperty'));
 Pointer(XmbTextPerCharExtents):=DynLibs.GetProcedureAddress(x_Handle,PChar('XmbTextPerCharExtents'));
 Pointer(XmbTextPropertyToTextList):=DynLibs.GetProcedureAddress(x_Handle,PChar('XmbTextPropertyToTextList'));
 Pointer(XMinCmapsOfScreen):=DynLibs.GetProcedureAddress(x_Handle,PChar('XMinCmapsOfScreen'));
 Pointer(XMoveResizeWindow):=DynLibs.GetProcedureAddress(x_Handle,PChar('XMoveResizeWindow'));
 Pointer(XMoveWindow):=DynLibs.GetProcedureAddress(x_Handle,PChar('XMoveWindow'));
 Pointer(XNewModifiermap):=DynLibs.GetProcedureAddress(x_Handle,PChar('XNewModifiermap'));
 Pointer(XNextEvent):=DynLibs.GetProcedureAddress(x_Handle,PChar('XNextEvent'));
 Pointer(XNextRequest):=DynLibs.GetProcedureAddress(x_Handle,PChar('XNextRequest'));
 Pointer(XNoOp):=DynLibs.GetProcedureAddress(x_Handle,PChar('XNoOp'));
 Pointer(XOffsetRegion):=DynLibs.GetProcedureAddress(x_Handle,PChar('XOffsetRegion'));
 Pointer(XOMOfOC):=DynLibs.GetProcedureAddress(x_Handle,PChar('XOMOfOC'));
 Pointer(XOpenDisplay):=DynLibs.GetProcedureAddress(x_Handle,PChar('XOpenDisplay'));
 Pointer(XOpenDisplay):=DynLibs.GetProcedureAddress(x_Handle,PChar('XOpenDisplay'));
 Pointer(XOpenIM):=DynLibs.GetProcedureAddress(x_Handle,PChar('XOpenIM'));
 Pointer(XOpenOM):=DynLibs.GetProcedureAddress(x_Handle,PChar('XOpenOM'));
 Pointer(XParseColor):=DynLibs.GetProcedureAddress(x_Handle,PChar('XParseColor'));
 Pointer(XParseGeometry):=DynLibs.GetProcedureAddress(x_Handle,PChar('XParseGeometry'));
 Pointer(XPeekEvent):=DynLibs.GetProcedureAddress(x_Handle,PChar('XPeekEvent'));
 Pointer(XPeekIfEvent):=DynLibs.GetProcedureAddress(x_Handle,PChar('XPeekIfEvent'));
 Pointer(XPending):=DynLibs.GetProcedureAddress(x_Handle,PChar('XPending'));
 Pointer(XPlanesOfScreen):=DynLibs.GetProcedureAddress(x_Handle,PChar('XPlanesOfScreen'));
 Pointer(XPointInRegion):=DynLibs.GetProcedureAddress(x_Handle,PChar('XPointInRegion'));
 Pointer(XPolygonRegion):=DynLibs.GetProcedureAddress(x_Handle,PChar('XPolygonRegion'));
 Pointer(XProcessInternalConnection):=DynLibs.GetProcedureAddress(x_Handle,PChar('XProcessInternalConnection'));
 Pointer(XProtocolRevision):=DynLibs.GetProcedureAddress(x_Handle,PChar('XProtocolRevision'));
 Pointer(XProtocolVersion):=DynLibs.GetProcedureAddress(x_Handle,PChar('XProtocolVersion'));
 Pointer(XPutBackEvent):=DynLibs.GetProcedureAddress(x_Handle,PChar('XPutBackEvent'));
 Pointer(XPutImage):=DynLibs.GetProcedureAddress(x_Handle,PChar('XPutImage'));
 Pointer(XQLength):=DynLibs.GetProcedureAddress(x_Handle,PChar('XQLength'));
 Pointer(XQueryBestCursor):=DynLibs.GetProcedureAddress(x_Handle,PChar('XQueryBestCursor'));
 Pointer(XQueryBestSize):=DynLibs.GetProcedureAddress(x_Handle,PChar('XQueryBestSize'));
 Pointer(XQueryBestStipple):=DynLibs.GetProcedureAddress(x_Handle,PChar('XQueryBestStipple'));
 Pointer(XQueryBestTile):=DynLibs.GetProcedureAddress(x_Handle,PChar('XQueryBestTile'));
 Pointer(XQueryColor):=DynLibs.GetProcedureAddress(x_Handle,PChar('XQueryColor'));
 Pointer(XQueryColors):=DynLibs.GetProcedureAddress(x_Handle,PChar('XQueryColors'));
 Pointer(XQueryExtension):=DynLibs.GetProcedureAddress(x_Handle,PChar('XQueryExtension'));
 Pointer(XQueryFont):=DynLibs.GetProcedureAddress(x_Handle,PChar('XQueryFont'));
 Pointer(XQueryKeymap):=DynLibs.GetProcedureAddress(x_Handle,PChar('XQueryKeymap'));
 Pointer(XQueryPointer):=DynLibs.GetProcedureAddress(x_Handle,PChar('XQueryPointer'));
 Pointer(XQueryTextExtents):=DynLibs.GetProcedureAddress(x_Handle,PChar('XQueryTextExtents'));
 Pointer(XQueryTextExtents16):=DynLibs.GetProcedureAddress(x_Handle,PChar('XQueryTextExtents16'));
 Pointer(XQueryTree):=DynLibs.GetProcedureAddress(x_Handle,PChar('XQueryTree'));
 Pointer(XRaiseWindow):=DynLibs.GetProcedureAddress(x_Handle,PChar('XRaiseWindow'));
 Pointer(XReadBitmapFile):=DynLibs.GetProcedureAddress(x_Handle,PChar('XReadBitmapFile'));
 Pointer(XReadBitmapFileData):=DynLibs.GetProcedureAddress(x_Handle,PChar('XReadBitmapFileData'));
 Pointer(XRebindKeysym):=DynLibs.GetProcedureAddress(x_Handle,PChar('XRebindKeysym'));
 Pointer(XReconfigureWMWindow):=DynLibs.GetProcedureAddress(x_Handle,PChar('XReconfigureWMWindow'));
 Pointer(XRectInRegion):=DynLibs.GetProcedureAddress(x_Handle,PChar('XRectInRegion'));
 Pointer(XRefreshKeyboardMapping):=DynLibs.GetProcedureAddress(x_Handle,PChar('XRefreshKeyboardMapping'));
 Pointer(XRegisterIMInstantiateCallback):=DynLibs.GetProcedureAddress(x_Handle,PChar('XRegisterIMInstantiateCallback'));
 Pointer(XRemoveConnectionWatch):=DynLibs.GetProcedureAddress(x_Handle,PChar('XRemoveConnectionWatch'));
 Pointer(XRemoveFromSaveSet):=DynLibs.GetProcedureAddress(x_Handle,PChar('XRemoveFromSaveSet'));
 Pointer(XRemoveHost):=DynLibs.GetProcedureAddress(x_Handle,PChar('XRemoveHost'));
 Pointer(XRemoveHosts):=DynLibs.GetProcedureAddress(x_Handle,PChar('XRemoveHosts'));
 Pointer(XReparentWindow):=DynLibs.GetProcedureAddress(x_Handle,PChar('XReparentWindow'));
 Pointer(XResetScreenSaver):=DynLibs.GetProcedureAddress(x_Handle,PChar('XResetScreenSaver'));
 Pointer(XResizeWindow):=DynLibs.GetProcedureAddress(x_Handle,PChar('XResizeWindow'));
 Pointer(XResourceManagerString):=DynLibs.GetProcedureAddress(x_Handle,PChar('XResourceManagerString'));
 Pointer(XRestackWindows):=DynLibs.GetProcedureAddress(x_Handle,PChar('XRestackWindows'));
 Pointer(XrmInitialize):=DynLibs.GetProcedureAddress(x_Handle,PChar('XrmInitialize'));
 Pointer(XRootWindow):=DynLibs.GetProcedureAddress(x_Handle,PChar('XRootWindow'));
 Pointer(XRootWindowOfScreen):=DynLibs.GetProcedureAddress(x_Handle,PChar('XRootWindowOfScreen'));
 Pointer(XRotateBuffers):=DynLibs.GetProcedureAddress(x_Handle,PChar('XRotateBuffers'));
 Pointer(XRotateWindowProperties):=DynLibs.GetProcedureAddress(x_Handle,PChar('XRotateWindowProperties'));
 Pointer(XSaveContext):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSaveContext'));
 Pointer(XScreenCount):=DynLibs.GetProcedureAddress(x_Handle,PChar('XScreenCount'));
 Pointer(XScreenNumberOfScreen):=DynLibs.GetProcedureAddress(x_Handle,PChar('XScreenNumberOfScreen'));
 Pointer(XScreenOfDisplay):=DynLibs.GetProcedureAddress(x_Handle,PChar('XScreenOfDisplay'));
 Pointer(XScreenResourceString):=DynLibs.GetProcedureAddress(x_Handle,PChar('XScreenResourceString'));
 Pointer(XSelectInput):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSelectInput'));
 Pointer(XSendEvent):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSendEvent'));
 Pointer(XServerVendor):=DynLibs.GetProcedureAddress(x_Handle,PChar('XServerVendor'));
 Pointer(XSetAccessControl):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetAccessControl'));
 Pointer(XSetAfterFunction):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetAfterFunction'));
 Pointer(XSetArcMode):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetArcMode'));
 Pointer(XSetAuthorization):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetAuthorization'));
 Pointer(XSetBackground):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetBackground'));
 Pointer(XSetClassHint):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetClassHint'));
 Pointer(XSetClipMask):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetClipMask'));
 Pointer(XSetClipOrigin):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetClipOrigin'));
 Pointer(XSetClipRectangles):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetClipRectangles'));
 Pointer(XSetCloseDownMode):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetCloseDownMode'));
 Pointer(XSetCommand):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetCommand'));
 Pointer(XSetDashes):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetDashes'));
 Pointer(XSetErrorHandler):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetErrorHandler'));
 Pointer(XSetFillRule):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetFillRule'));
 Pointer(XSetFillStyle):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetFillStyle'));
 Pointer(XSetFont):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetFont'));
 Pointer(XSetFontPath):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetFontPath'));
 Pointer(XSetForeground):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetForeground'));
 Pointer(XSetFunction):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetFunction'));
 Pointer(XSetGraphicsExposures):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetGraphicsExposures'));
 Pointer(XSetICFocus):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetICFocus'));
 Pointer(XSetIconName):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetIconName'));
 Pointer(XSetIconSizes):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetIconSizes'));
 Pointer(XSetICValues):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetICValues'));
 Pointer(XSetIMValues):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetIMValues'));
 Pointer(XSetInputFocus):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetInputFocus'));
 Pointer(XSetIOErrorHandler):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetIOErrorHandler'));
 Pointer(XSetLineAttributes):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetLineAttributes'));
 Pointer(XSetLocaleModifiers):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetLocaleModifiers'));
 Pointer(XSetModifierMapping):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetModifierMapping'));
 Pointer(XSetNormalHints):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetNormalHints'));
 Pointer(XSetOCValues):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetOCValues'));
 Pointer(XSetOMValues):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetOMValues'));
 Pointer(XSetPlaneMask):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetPlaneMask'));
 Pointer(XSetPointerMapping):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetPointerMapping'));
 Pointer(XSetRegion):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetRegion'));
 Pointer(XSetRGBColormaps):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetRGBColormaps'));
 Pointer(XSetScreenSaver):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetScreenSaver'));
 Pointer(XSetSelectionOwner):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetSelectionOwner'));
 Pointer(XSetSizeHints):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetSizeHints'));
 Pointer(XSetStandardColormap):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetStandardColormap'));
 Pointer(XSetStandardProperties):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetStandardProperties'));
 Pointer(XSetState):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetState'));
 Pointer(XSetStipple):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetStipple'));
 Pointer(XSetSubwindowMode):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetSubwindowMode'));
 Pointer(XSetTextProperty):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetTextProperty'));
 Pointer(XSetTile):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetTile'));
 Pointer(XSetTransientForHint):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetTransientForHint'));
 Pointer(XSetTSOrigin):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetTSOrigin'));
 Pointer(XSetWindowBackground):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetWindowBackground'));
 Pointer(XSetWindowBackgroundPixmap):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetWindowBackgroundPixmap'));
 Pointer(XSetWindowBorder):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetWindowBorder'));
 Pointer(XSetWindowBorderPixmap):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetWindowBorderPixmap'));
 Pointer(XSetWindowBorderWidth):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetWindowBorderWidth'));
 Pointer(XSetWindowColormap):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetWindowColormap'));
 Pointer(XSetWMClientMachine):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetWMClientMachine'));
 Pointer(XSetWMColormapWindows):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetWMColormapWindows'));
 Pointer(XSetWMHints):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetWMHints'));
 Pointer(XSetWMIconName):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetWMIconName'));
 Pointer(XSetWMName):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetWMName'));
 Pointer(XSetWMNormalHints):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetWMNormalHints'));
 Pointer(XSetWMProperties):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetWMProperties'));
 Pointer(XSetWMProtocols):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetWMProtocols'));
 Pointer(XSetWMSizeHints):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetWMSizeHints'));
 Pointer(XSetZoomHints):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSetZoomHints'));
 Pointer(XShrinkRegion):=DynLibs.GetProcedureAddress(x_Handle,PChar('XShrinkRegion'));
 Pointer(XStoreBuffer):=DynLibs.GetProcedureAddress(x_Handle,PChar('XStoreBuffer'));
 Pointer(XStoreBytes):=DynLibs.GetProcedureAddress(x_Handle,PChar('XStoreBytes'));
 Pointer(XStoreColor):=DynLibs.GetProcedureAddress(x_Handle,PChar('XStoreColor'));
 Pointer(XStoreColors):=DynLibs.GetProcedureAddress(x_Handle,PChar('XStoreColors'));
 Pointer(XStoreName):=DynLibs.GetProcedureAddress(x_Handle,PChar('XStoreName'));
 Pointer(XStoreNamedColor):=DynLibs.GetProcedureAddress(x_Handle,PChar('XStoreNamedColor'));
 Pointer(XStringListToTextProperty):=DynLibs.GetProcedureAddress(x_Handle,PChar('XStringListToTextProperty'));
 Pointer(XSubtractRegion):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSubtractRegion'));
 Pointer(XSupportsLocale):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSupportsLocale'));
 Pointer(XSync):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSync'));
 Pointer(XSynchronize):=DynLibs.GetProcedureAddress(x_Handle,PChar('XSynchronize'));
 Pointer(XTextExtents):=DynLibs.GetProcedureAddress(x_Handle,PChar('XTextExtents'));
 Pointer(XTextExtents16):=DynLibs.GetProcedureAddress(x_Handle,PChar('XTextExtents16'));
 Pointer(XTextPropertyToStringList):=DynLibs.GetProcedureAddress(x_Handle,PChar('XTextPropertyToStringList'));
 Pointer(XTextWidth):=DynLibs.GetProcedureAddress(x_Handle,PChar('XTextWidth'));
 Pointer(XTextWidth16):=DynLibs.GetProcedureAddress(x_Handle,PChar('XTextWidth16'));
 Pointer(XTranslateCoordinates):=DynLibs.GetProcedureAddress(x_Handle,PChar('XTranslateCoordinates'));
 Pointer(XUndefineCursor):=DynLibs.GetProcedureAddress(x_Handle,PChar('XUndefineCursor'));
 Pointer(XUngrabButton):=DynLibs.GetProcedureAddress(x_Handle,PChar('XUngrabButton'));
 Pointer(XUngrabKey):=DynLibs.GetProcedureAddress(x_Handle,PChar('XUngrabKey'));
 Pointer(XUngrabKeyboard):=DynLibs.GetProcedureAddress(x_Handle,PChar('XUngrabKeyboard'));
 Pointer(XUngrabPointer):=DynLibs.GetProcedureAddress(x_Handle,PChar('XUngrabPointer'));
 Pointer(XUngrabServer):=DynLibs.GetProcedureAddress(x_Handle,PChar('XUngrabServer'));
 Pointer(XUninstallColormap):=DynLibs.GetProcedureAddress(x_Handle,PChar('XUninstallColormap'));
 Pointer(XUnionRectWithRegion):=DynLibs.GetProcedureAddress(x_Handle,PChar('XUnionRectWithRegion'));
 Pointer(XUnionRegion):=DynLibs.GetProcedureAddress(x_Handle,PChar('XUnionRegion'));
 Pointer(XUnloadFont):=DynLibs.GetProcedureAddress(x_Handle,PChar('XUnloadFont'));
 Pointer(XUnlockDisplay):=DynLibs.GetProcedureAddress(x_Handle,PChar('XUnlockDisplay'));
 Pointer(XUnmapSubwindows):=DynLibs.GetProcedureAddress(x_Handle,PChar('XUnmapSubwindows'));
 Pointer(XUnmapWindow):=DynLibs.GetProcedureAddress(x_Handle,PChar('XUnmapWindow'));
 Pointer(XUnregisterIMInstantiateCallback):=DynLibs.GetProcedureAddress(x_Handle,PChar('XUnregisterIMInstantiateCallback'));
 Pointer(XUnsetICFocus):=DynLibs.GetProcedureAddress(x_Handle,PChar('XUnsetICFocus'));
 Pointer(Xutf8DrawImageString):=DynLibs.GetProcedureAddress(x_Handle,PChar('Xutf8DrawImageString'));
 Pointer(Xutf8DrawString):=DynLibs.GetProcedureAddress(x_Handle,PChar('Xutf8DrawString'));
 Pointer(Xutf8DrawText):=DynLibs.GetProcedureAddress(x_Handle,PChar('Xutf8DrawText'));
 Pointer(Xutf8LookupString):=DynLibs.GetProcedureAddress(x_Handle,PChar('Xutf8LookupString'));
 Pointer(Xutf8ResetIC):=DynLibs.GetProcedureAddress(x_Handle,PChar('Xutf8ResetIC'));
 Pointer(Xutf8SetWMProperties):=DynLibs.GetProcedureAddress(x_Handle,PChar('Xutf8SetWMProperties'));
 Pointer(Xutf8TextEscapement):=DynLibs.GetProcedureAddress(x_Handle,PChar('Xutf8TextEscapement'));
 Pointer(Xutf8TextExtents):=DynLibs.GetProcedureAddress(x_Handle,PChar('Xutf8TextExtents'));
 Pointer(Xutf8TextListToTextProperty):=DynLibs.GetProcedureAddress(x_Handle,PChar('Xutf8TextListToTextProperty'));
 Pointer(Xutf8TextPerCharExtents):=DynLibs.GetProcedureAddress(x_Handle,PChar('Xutf8TextPerCharExtents'));
 Pointer(Xutf8TextPropertyToTextList):=DynLibs.GetProcedureAddress(x_Handle,PChar('Xutf8TextPropertyToTextList'));
 Pointer(XVaCreateNestedList):=DynLibs.GetProcedureAddress(x_Handle,PChar('XVaCreateNestedList'));
 Pointer(XVendorRelease):=DynLibs.GetProcedureAddress(x_Handle,PChar('XVendorRelease'));
 Pointer(XVisualIDFromVisual):=DynLibs.GetProcedureAddress(x_Handle,PChar('XVisualIDFromVisual'));
 Pointer(XWarpPointer):=DynLibs.GetProcedureAddress(x_Handle,PChar('XWarpPointer'));
 Pointer(XwcDrawImageString):=DynLibs.GetProcedureAddress(x_Handle,PChar('XwcDrawImageString'));
 Pointer(XwcDrawString):=DynLibs.GetProcedureAddress(x_Handle,PChar('XwcDrawString'));
 Pointer(XwcDrawText):=DynLibs.GetProcedureAddress(x_Handle,PChar('XwcDrawText'));
 Pointer(XwcFreeStringList):=DynLibs.GetProcedureAddress(x_Handle,PChar('XwcFreeStringList'));
 Pointer(XwcLookupString):=DynLibs.GetProcedureAddress(x_Handle,PChar('XwcLookupString'));
 Pointer(XwcResetIC):=DynLibs.GetProcedureAddress(x_Handle,PChar('XwcResetIC'));
 Pointer(XwcTextEscapement):=DynLibs.GetProcedureAddress(x_Handle,PChar('XwcTextEscapement'));
 Pointer(XwcTextExtents):=DynLibs.GetProcedureAddress(x_Handle,PChar('XwcTextExtents'));
 Pointer(XwcTextListToTextProperty):=DynLibs.GetProcedureAddress(x_Handle,PChar('XwcTextListToTextProperty'));
 Pointer(XwcTextPerCharExtents):=DynLibs.GetProcedureAddress(x_Handle,PChar('XwcTextPerCharExtents'));
 Pointer(XwcTextPropertyToTextList):=DynLibs.GetProcedureAddress(x_Handle,PChar('XwcTextPropertyToTextList'));
 Pointer(XWhitePixel):=DynLibs.GetProcedureAddress(x_Handle,PChar('XWhitePixel'));
 Pointer(XWidthMMOfScreen):=DynLibs.GetProcedureAddress(x_Handle,PChar('XWidthMMOfScreen'));
 Pointer(XWidthOfScreen):=DynLibs.GetProcedureAddress(x_Handle,PChar('XWidthOfScreen'));
 Pointer(XWindowEvent):=DynLibs.GetProcedureAddress(x_Handle,PChar('XWindowEvent'));
 Pointer(XWithdrawWindow):=DynLibs.GetProcedureAddress(x_Handle,PChar('XWithdrawWindow'));
 Pointer(XWMGeometry):=DynLibs.GetProcedureAddress(x_Handle,PChar('XWMGeometry'));
 Pointer(XWriteBitmapFile):=DynLibs.GetProcedureAddress(x_Handle,PChar('XWriteBitmapFile'));
 Pointer(XXorRegion):=DynLibs.GetProcedureAddress(x_Handle,PChar('XXorRegion'));

end;
   Result := x_IsLoaded();
   ReferenceCounter:=1;   
end;

end;

Procedure x_Unload();
begin
// < Reference counting
  if ReferenceCounter > 0 then
    dec(ReferenceCounter);
  if ReferenceCounter > 0 then
    exit;
  // >
  if x_IsLoaded() then
  begin
    DynLibs.UnloadLibrary(x_Handle);
    x_Handle:=DynLibs.NilHandle;
  end;
end;

{$ifdef MACROS}
function ConnectionNumber(dpy : PDisplay) : cint;
begin
   ConnectionNumber:=(PXPrivDisplay(dpy))^.fd;
end;

function RootWindow(dpy : PDisplay; scr : cint) : TWindow;
begin
   RootWindow:=(ScreenOfDisplay(dpy,scr))^.root;
end;

function DefaultScreen(dpy : PDisplay) : cint;
begin
   DefaultScreen:=(PXPrivDisplay(dpy))^.default_screen;
end;

function DefaultRootWindow(dpy : PDisplay) : TWindow;
begin
   DefaultRootWindow:=(ScreenOfDisplay(dpy,DefaultScreen(dpy)))^.root;
end;

function DefaultVisual(dpy : PDisplay; scr : cint) : PVisual;
begin
   DefaultVisual:=(ScreenOfDisplay(dpy,scr))^.root_visual;
end;

function DefaultGC(dpy : PDisplay; scr : cint) : TGC;
begin
   DefaultGC:=(ScreenOfDisplay(dpy,scr))^.default_gc;
end;

function BlackPixel(dpy : PDisplay; scr : cint) : culong;
begin
   BlackPixel:=(ScreenOfDisplay(dpy,scr))^.black_pixel;
end;

function WhitePixel(dpy : PDisplay; scr : cint) : culong;
begin
   WhitePixel:=(ScreenOfDisplay(dpy,scr))^.white_pixel;
end;

function QLength(dpy : PDisplay) : cint;
begin
   QLength:=(PXPrivDisplay(dpy))^.qlen;
end;

function DisplayWidth(dpy : PDisplay; scr : cint) : cint;
begin
   DisplayWidth:=(ScreenOfDisplay(dpy,scr))^.width;
end;

function DisplayHeight(dpy : PDisplay; scr : cint) : cint;
begin
   DisplayHeight:=(ScreenOfDisplay(dpy,scr))^.height;
end;

function DisplayWidthMM(dpy : PDisplay; scr : cint) : cint;
begin
   DisplayWidthMM:=(ScreenOfDisplay(dpy,scr))^.mwidth;
end;

function DisplayHeightMM(dpy : PDisplay; scr : cint) : cint;
begin
   DisplayHeightMM:=(ScreenOfDisplay(dpy,scr))^.mheight;
end;

function DisplayPlanes(dpy : PDisplay; scr : cint) : cint;
begin
   DisplayPlanes:=(ScreenOfDisplay(dpy,scr))^.root_depth;
end;

function DisplayCells(dpy : PDisplay; scr : cint) : cint;
begin
   DisplayCells:=(DefaultVisual(dpy,scr))^.map_entries;
end;

function ScreenCount(dpy : PDisplay) : cint;
begin
   ScreenCount:=(PXPrivDisplay(dpy))^.nscreens;
end;

function ServerVendor(dpy : PDisplay) : Pchar;
begin
   ServerVendor:=(PXPrivDisplay(dpy))^.vendor;
end;

function ProtocolVersion(dpy : PDisplay) : cint;
begin
   ProtocolVersion:=(PXPrivDisplay(dpy))^.proto_major_version;
end;

function ProtocolRevision(dpy : PDisplay) : cint;
begin
   ProtocolRevision:=(PXPrivDisplay(dpy))^.proto_minor_version;
end;

function VendorRelease(dpy : PDisplay) : cint;
begin
   VendorRelease:=(PXPrivDisplay(dpy))^.release;
end;

function DisplayString(dpy : PDisplay) : Pchar;
begin
   DisplayString:=(PXPrivDisplay(dpy))^.display_name;
end;

function DefaultDepth(dpy : PDisplay; scr : cint) : cint;
begin
   DefaultDepth:=(ScreenOfDisplay(dpy,scr))^.root_depth;
end;

function DefaultColormap(dpy : PDisplay; scr : cint) : TColormap;
begin
   DefaultColormap:=(ScreenOfDisplay(dpy,scr))^.cmap;
end;

function BitmapUnit(dpy : PDisplay) : cint;
begin
   BitmapUnit:=(PXPrivDisplay(dpy))^.bitmap_unit;
end;

function BitmapBitOrder(dpy : PDisplay) : cint;
begin
   BitmapBitOrder:=(PXPrivDisplay(dpy))^.bitmap_bit_order;
end;

function BitmapPad(dpy : PDisplay) : cint;
begin
   BitmapPad:=(PXPrivDisplay(dpy))^.bitmap_pad;
end;

function ImageByteOrder(dpy : PDisplay) : cint;
begin
   ImageByteOrder:=(PXPrivDisplay(dpy))^.byte_order;
end;

function NextRequest(dpy : PDisplay) : culong;
begin
   NextRequest:=((PXPrivDisplay(dpy))^.request) + 1;
end;

function LastKnownRequestProcessed(dpy : PDisplay) : culong;
begin
   LastKnownRequestProcessed:=(PXPrivDisplay(dpy))^.last_request_read;
end;

function ScreenOfDisplay(dpy : PDisplay; scr : cint) : PScreen;
begin
   ScreenOfDisplay:=@(((PXPrivDisplay(dpy))^.screens)[scr]);
end;

function DefaultScreenOfDisplay(dpy : PDisplay) : PScreen;
begin
   DefaultScreenOfDisplay:=ScreenOfDisplay(dpy,DefaultScreen(dpy));
end;

function DisplayOfScreen(s : PScreen) : PDisplay;
begin
   DisplayOfScreen:=s^.display;
end;

function RootWindowOfScreen(s : PScreen) : TWindow;
begin
   RootWindowOfScreen:=s^.root;
end;

function BlackPixelOfScreen(s : PScreen) : culong;
begin
   BlackPixelOfScreen:=s^.black_pixel;
end;

function WhitePixelOfScreen(s : PScreen) : culong;
begin
   WhitePixelOfScreen:=s^.white_pixel;
end;

function DefaultColormapOfScreen(s : PScreen) : TColormap;
begin
   DefaultColormapOfScreen:=s^.cmap;
end;

function DefaultDepthOfScreen(s : PScreen) : cint;
begin
   DefaultDepthOfScreen:=s^.root_depth;
end;

function DefaultGCOfScreen(s : PScreen) : TGC;
begin
   DefaultGCOfScreen:=s^.default_gc;
end;

function DefaultVisualOfScreen(s : PScreen) : PVisual;
begin
   DefaultVisualOfScreen:=s^.root_visual;
end;

function WidthOfScreen(s : PScreen) : cint;
begin
   WidthOfScreen:=s^.width;
end;

function HeightOfScreen(s : PScreen) : cint;
begin
   HeightOfScreen:=s^.height;
end;

function WidthMMOfScreen(s : PScreen) : cint;
begin
   WidthMMOfScreen:=s^.mwidth;
end;

function HeightMMOfScreen(s : PScreen) : cint;
begin
   HeightMMOfScreen:=s^.mheight;
end;

function PlanesOfScreen(s : PScreen) : cint;
begin
   PlanesOfScreen:=s^.root_depth;
end;

function CellsOfScreen(s : PScreen) : cint;
begin
   CellsOfScreen:=(DefaultVisualOfScreen(s))^.map_entries;
end;

function MinCmapsOfScreen(s : PScreen) : cint;
begin
   MinCmapsOfScreen:=s^.min_maps;
end;

function MaxCmapsOfScreen(s : PScreen) : cint;
begin
   MaxCmapsOfScreen:=s^.max_maps;
end;

function DoesSaveUnders(s : PScreen) : TBool;
begin
   DoesSaveUnders:=s^.save_unders;
end;

function DoesBackingStore(s : PScreen) : cint;
begin
   DoesBackingStore:=s^.backing_store;
end;

function EventMaskOfScreen(s : PScreen) : clong;
begin
   EventMaskOfScreen:=s^.root_input_mask;
end;

function XAllocID(dpy : PDisplay) : TXID;
begin
   XAllocID:=(PXPrivDisplay(dpy))^.resource_alloc(dpy);
end;

// from xutil.pp


function XDestroyImage(ximage : PXImage) : cint;

begin
  XDestroyImage := ximage^.f.destroy_image(ximage);
end;

function XGetPixel(ximage : PXImage; x, y : cint) : culong;
begin
   XGetPixel:=ximage^.f.get_pixel(ximage, x, y);
end;

function XPutPixel(ximage : PXImage; x, y : cint; pixel : culong) : cint;
begin
   XPutPixel:=ximage^.f.put_pixel(ximage, x, y, pixel);
end;

function XSubImage(ximage : PXImage; x, y : cint; width, height : cuint) : PXImage;
begin
   XSubImage:=ximage^.f.sub_image(ximage, x, y, width, height);
end;

function XAddPixel(ximage : PXImage; value : clong) : cint;
begin
   XAddPixel:=ximage^.f.add_pixel(ximage, value);
end;

function IsKeypadKey(keysym : TKeySym) : Boolean;
begin
   IsKeypadKey:=(keysym >= XK_KP_Space) and (keysym <= XK_KP_Equal);
end;

function IsPrivateKeypadKey(keysym : TKeySym) : Boolean;
begin
   IsPrivateKeypadKey:=(keysym >= $11000000) and (keysym <= $1100FFFF);
end;

function IsCursorKey(keysym : TKeySym) : Boolean;
begin
   IsCursorKey:=(keysym >= XK_Home) and (keysym < XK_Select);
end;

function IsPFKey(keysym : TKeySym) : Boolean;
begin
   IsPFKey:=(keysym >= XK_KP_F1) and (keysym <= XK_KP_F4);
end;

function IsFunctionKey(keysym : TKeySym) : Boolean;
begin
   IsFunctionKey:=(keysym >= XK_F1) and (keysym <= XK_F35);
end;

function IsMiscFunctionKey(keysym : TKeySym) : Boolean;
begin
   IsMiscFunctionKey:=(keysym >= XK_Select) and (keysym <= XK_Break);
end;

function IsModifierKey(keysym : TKeySym) : Boolean;
begin
  IsModifierKey := ((keysym >= XK_Shift_L) And (keysym <= XK_Hyper_R)) Or
                   (keysym = XK_Mode_switch) Or (keysym = XK_Num_Lock);
end;

{$endif MACROS}

{$ifdef initload}
initialization

x_Load(libX11);

finalization

x_unLoad();

{$endif initload}

end.
