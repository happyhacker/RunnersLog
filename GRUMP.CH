/*
   File: GRUMP.CH
   System: GRUMPFISH LIBRARY
   Author: Greg Lief
   Copyright (c) 1988-92, Greg Lief
   Standard header file for Grumpfish Library Version 3.x
   WARNING: You must #include this file if you want to use any of the
            following functions:  LoadArray(), Center(), PopBox(),
            DropBox(), WaitOff(), StrPad(), TIMEWORD(), Datest(), ByeByeBox()
*/

//ÄÄÄÄÄ simple defines
#ifndef YES    // to preclude redef warnings due to 5.2 COMMON.CH
   #define YES           .T.
#endif
#ifndef NO     // to preclude redef warnings due to 5.2 COMMON.CH
   #define NO            .F.
#endif
#define SPACEBAR      32
#define CRLF          chr(13)+chr(10)
#define NETERR_MSG    "Network error, could not add/edit at this time"

//ÄÄÄÄÄ sneaky way to return an array and a logical value from the
//ÄÄÄÄÄ same function
#xtranslate loadarray(<array>, <file>) => ;
           (len(<array> := gloadarray(<file>)) > 0)

/* Nantucket's boxes don't clear the area, so I wrote my own */
#xtranslate SINGLEBOX(<top>, <left>, <bottom>, <right> [,<color>] ) => ;
           DispBox(<top>, <left>, <bottom>, <right>, "ÚÄ¿³ÙÄÀ³ " [, <color>] )
#xtranslate DOUBLEBOX(<top>, <left>, <bottom>, <right> [,<color>] ) => ;
           DispBox(<top>, <left>, <bottom>, <right>, 'ÉÍ»º¼ÍÈº ' [, <color>] )

/* ­the ubiquitous Center() function! */
#xtranslate CENTER(<row>, <msg>, <width> [, <color>] ) => ;
            DevPos( <row>, int(( <width> - len( <msg> )) / 2)) ; ;
            DevOut( <msg> [,<color>] )

#xtranslate CENTER(<row>, <msg> [, , <color> ] ) => ;
            DevPos( <row>, int((maxcol() + 1 - len( <msg> )) / 2)) ; ;
            DevOut( <msg> [, <color>] )

/*
   a modified CENTER(), which uses setpos() and dispout() to ensure
   that output always goes to the screen and never the printer
*/
#xtranslate SCRNCENTER(<row>, <msg> [, <color> ] ) => ;
            SetPos( <row>, int(( maxcol()+1 - len(<msg>)) / 2)) ; ;
            DispOut( <msg> [, <color>] )

/*
   a modified @..SAY which uses setpos() and dispout() to ensure
   that output always goes to the screen and never the printer
*/
#xcommand @ <row>, <col> SSAY <xpr> [COLOR <color>] [PICTURE <pic>] => ;
                        SetPos( <row>, <col> )                     ;   ;
                        DispOut( transform( <xpr>, <pic> ) [, <color>] )

#xcommand @ <row>, <col> SSAY <xpr> [COLOR <color>] =>    ;
                        SetPos( <row>, <col> )         ;  ;
                        DispOut( <xpr> [, <color>] )

/* shorthand to lop off the rightmost element of an array */
#xtranslate Truncate( <a> ) => asize( <a>, len(<a>) - 1)

/*
   Function to delete an array element and resize the array in one fell swoop
   Made possible because ADEL() returns a reference to the array in question
*/
#xtranslate AKill( <a>, <e> ) => asize( adel( <a>, <e> ), len( <a> ) - 1 )

//ÄÄÄÄÄ directives to return filename only
#xtranslate StripPath( <f> ) => ;
           if("\" $ <f>, substr(<f>, rat("\", <f>) + 1), <f>)

/* constants for CLRSCR() -- fancy screen clearing function */
#define WINDOWDOWN  1
#define WINDOWUP    2
#define DOORRIGHT   3
#define DOORLEFT    4
#define CURTAINOPEN 5
#define CURTAINSHUT 6
#define CAMERALENS  7
#define DIAGONAL    8
#define HALVES      9


/* constants for COLORSET() (Grumpfish color management - see COLORSET.PRG) */
#define C_GETS                       1
#define C_MESSAGE                    2
#define C_MESSAGEBLINK               3
#define C_WAITMESSAGE                4
#define C_WAITMESSAGEBLINK           5
#define C_YESNO                      6
#define C_ERRORBOX                   7
#define C_ERRORMESSAGE               8
#define C_MEMEDIT_BOX                9
#define C_MEMEDIT_WINDOW            10
#define C_STOPWATCH_BOX             11
#define C_STOPWATCH_WINDOW          12
#define C_CALCULATOR_BOX            13
#define C_CALCULATOR_WINDOW         14
#define C_NOTEPAD_BOX               15
#define C_NOTEPAD_WINDOW            16
#define C_PHONEBOOK_WINDOW1         17
#define C_PHONEBOOK_WINDOW2         18
#define C_CALENDAR                  19
#define C_APPOINTMENT               20
#define C_APICK_BOXOUTLINE          21
#define C_APICK_STATUSBAR           22
#define C_APICK_INDICATOR           23
#define C_APICK_UNSELECTED          24
#define C_APICK_CURRENT             25
#define C_APICK_TAGGED              26
#define C_APICK_TAGGEDCURRENT       27
#define C_APICK_UNAVAILABLE         28
#define C_APICK_UNAVAILABLECURRENT  29
#define C_MENU_UNSELECTED           30
#define C_MENU_SELECTED             31
#define C_GRUMPBROW_BOX             32
#define C_GRUMPBROW_SAY             33
#define C_GRUMPBROW_GET             34


/* no more BoxType() function with this handy array of box outlines */
#define BOXFRAMES {'ÉÍ»º¼ÍÈº ¹ÌÌ¹', 'ÚÄ¿³ÙÄÀ³ ´ÃÃ´', 'ÕÍ¸³¾ÍÔ³ ¹ÌÆµ', ;
                   'ÖÄ·º½ÄÓº ´ÃÇ¶', 'ÛßÛÛÛÜÛÛ ÛÛÛÛ', SPACE(12) }


/* PopBox() & DropBox() have been consolidated into one function: PopNDrop() */
#xtranslate popbox( <parms,...> )  => PopNDrop(1, <parms>)
#xtranslate dropbox( <parms,...> ) => PopNDrop(2, <parms>)

/* Music Maestro Please!! -- even if you scoff at the prospect of using
   audio feedback in your programs, it still behooves you to look at the
   coding techniques presented here.  The first call to one of the musical
   themes (e.g., Charge) is preprocessed into a multi-dimensional array
   (contained note frequency and duration) which is passed to the function
   Tunes().  Tunes() is then translated again by the preprocessor into an
   AEVAL() statement which invokes the TONE() function to play one note for
   each element in the array.  This principle is quite enlightening...
   (NOTE: public domain themes only due to the great GrumpFun snafu)  */

#xcommand Charge => tunes({ {523,2}, {698,2}, {880,2}, {1046,4}, ;
                            {880,2}, {1046,8} } )
#xcommand NannyBoo => tunes( { {196,4}, {196,4}, {164,4}, {220,4}, ;
                               {196,8}, {164,8} } )
#xcommand TheFifth => tunes( { {392,2}, {392,2}, {392,2}, {311,8} } )
#xcommand tunes(<a>) => aeval(<a>, { | a | tone(a\[1], a\[2]) } )

/* while we're on the subject of music, here are some manifest constants */
#define MUSIC_ERROR           440
#define MUSIC_WAITON          {800, 1600}
#define MUSIC_ALERT           880
#define MUSIC_RASPBERRY       50      // insulting but necessary
#define MUSIC_TTY             25      // use in TTY() and TTY2()

//ÄÄÄÄÄ if you need the frequency equivalents, put #define GRUMP_MUSIC
//ÄÄÄÄÄ somewhere in your program
#ifdef GRUMP_MUSIC

/* frequency equivalents for six octaves - write your own tunes */
#define T_C1                  130.8
#define T_CSHARP1             138.6
#define T_D1                  146.8
#define T_DSHARP1             155.6
#define T_E1                  164.8
#define T_F1                  174.6
#define T_FSHARP1             185.0
#define T_G1                  196.0
#define T_GSHARP1             207.7
#define T_A1                  220.0
#define T_ASHARP1             233.1
#define T_B1                  246.9
#define T_C2                  261.7
#define T_CSHARP2             277.2
#define T_D2                  293.7
#define T_DSHARP2             311.1
#define T_E2                  329.6
#define T_F2                  349.2
#define T_FSHARP2             370.0
#define T_G2                  392.0
#define T_GSHARP2             415.3
#define T_A2                  440.0
#define T_ASHARP2             466.2
#define T_B2                  493.9
#define T_C3                  523.4
#define T_CSHARP3             554.4
#define T_D3                  587.4
#define T_DSHARP3             622.2
#define T_E3                  659.2
#define T_F3                  698.4
#define T_FSHARP3             740.0
#define T_G3                  784.0
#define T_GSHARP3             830.6
#define T_A3                  880.0
#define T_ASHARP3             932.4
#define T_B3                  987.8
#define T_C4                 1046.8
#define T_CSHARP4            1108.8
#define T_D4                 1174.8
#define T_DSHARP4            1244.4
#define T_E4                 1318.4
#define T_F4                 1396.8
#define T_FSHARP4            1480.0
#define T_G4                 1568.0
#define T_GSHARP4            1660.6
#define T_A4                 1760.0
#define T_ASHARP4            1864.8
#define T_B4                 1975.6
#define T_C5                 2093.6
#define T_CSHARP5            2217.6
#define T_D5                 2349.6
#define T_DSHARP5            2488.8
#define T_E5                 2636.8
#define T_F5                 2793.6
#define T_FSHARP5            2960.0
#define T_G5                 3136.0
#define T_GSHARP5            3321.2
#define T_A5                 3520.0
#define T_ASHARP5            3729.6
#define T_B5                 3951.2
#define T_C6                 4187.2
#define T_CSHARP6            4435.2
#define T_D6                 4699.2
#define T_DSHARP6            4977.6
#define T_E6                 5273.6
#define T_F6                 5587.2
#define T_FSHARP6            5920.0
#define T_G6                 6272.0
#define T_GSHARP6            6642.4
#define T_A6                 7040.0
#define T_ASHARP6            7459.2
#define T_B6                 7902.4

#endif // GRUMP_MUSIC


/*
   WAITOFF() no longer exists as a function per se... the preprocessor
   translates it to call WAITON() with a logical parameter, which tells
   WAITON() that it must restore the affected portion of the screen...
*/
#xtranslate waitoff( [<sound:ON,NOISE,SOUND>] ) => WaitOn(.F., <.sound.>)


/* my STRPAD() function is no longer necessary in light of Clipper's PADR() */
#xtranslate strpad(<msg>, <length>) => PADR(<msg>, <length>)


/* add or remove file extensions */
#xtranslate AddExtension(<file>, <ext>) => ;
       <file> := upper(<file>) + ;
       if(! "." + upper(<ext>) $ upper(<file>), "." + upper(<ext>), '')
#xtranslate StripExt( <fname> ) => ;
      if('.' $ <fname>, substr( <fname>, 1, at('.', <fname>) - 1), <fname> )


//ÄÄÄÄÄ default all parameters to a specific value if not passed to function
#xcommand DEFAULT <param> TO <value> [, <param2> TO <value2> ] => ;
          IF <param> == NIL ; <param> := <value> ; END ;
          [; IF <param2> == NIL ; <param2> := <value2> ; END ]

//ÄÄÄÄÄ several small functions that are better suited for this treatment
#xtranslate timeword() => if(seconds() \< 43200, 'morning', ;
                          if(seconds() \< 64800, 'afternoon', 'evening'))
#xtranslate Datest(<date>) => if(empty(<date>), space(8), dtoc(<date>))
#xtranslate ByeByeBox(<buff>) => ;
            restscreen(<buff>\[1], <buff>\[2], <buff>\[3], <buff>\[4], ;
                       <buff>\[5])

//ÄÄÄÄÄ Constants for calendaring concerns (POPDATE, CALENDAR, GETDATE)
//ÄÄÄÄÄ those three programs will have #defined GRUMP_CALENDAR.
//ÄÄÄÄÄ There should be no other need for these in your program.

#ifdef GRUMP_CALENDAR

#define FIRSTDAY_ROW      datecoords[1]
#define FIRSTDAY_COL      datecoords[2]
#define LASTDAY_ROW       datecoords[3]
#define LASTDAY_COL       datecoords[4]
#define LASTDAY_NUMBER    datecoords[5]
#define CURRENTDAY_ROW    datecoords[6]
#define CURRENTDAY_COL    datecoords[7]
#define SYSTEMDATE_ROW    datecoords[8]
#define SYSTEMDATE_COL    datecoords[9]
#define CURRENTAPPTS      datecoords[10]

#endif // GRUMP_CALENDAR

/* compile a character string to a code block -- often preferable to do
   this instead of macro expansion for LOCATE conditions et cetera     */
#xtranslate MakeBlock(<string>) =>  &("{ | | " + <string> + "}")

/* handy functions to parse a screen variable for text/color attributes */
#xtranslate TextAt(<row>, <col>)  => ;
                  left(savescreen( <row>, <col>, <row>, <col> ), 1)
#xtranslate ColorAt(<row>, <col>) => ;
                  Color_N2S(right(savescreen( <row>, <col>, <row>, <col> ), 1))


//ÄÄÄÄÄ manifest constants for GInkeyTime() function
#define GINKEYTIME    1
#define GINKEYEVENT   2
#define GINKEYEXIT    3

//ÄÄÄÄÄ directive to make GInkeyTime() function call simpler
#xcommand INKEY [TIMEOUT <timeout>] [EVENT <event>] [EXIT <exit>] => ;
          [GInkeyTime(GINKEYTIME,  <timeout>) ;]          ;
          [GInkeyTime(GINKEYEVENT, <{event}>) ;]           ;
          [GInkeyTime(GINKEYEXIT,  <{exit}>) ]

//ÄÄÄÄÄ since I must use a nasty internal, I might as well protect myself...
#xtranslate StuffKey( <key> ) => __Keyboard( <key> )

/*
   Status Bar directives
*/
#xtranslate INITIALIZE STATUS BAR  ;
                  [MESSAGE <msg>]  ;
                  [ROW <row>]      ;
                  [FILE <file>]    ;
                  [RECORDS <recs>] ;
                              =>   ;
            GFStatInit( <msg>, <row>, <file>, <recs> )

//ÄÄÄÄÄ these are meant to be used with COPY TO and APPEND FROM
#xtranslate STATUSBAR  => WHILE GFStatBar()
#xtranslate STATUS BAR => WHILE GFStatBar()


/*
   Mouse-related directives begin here
*/

#ifdef MOUSE

//ÄÄÄÄÄ manifest constants for GFMCursor()
#define MCURS_BLOCK     0
#define MCURS_ARROW     1
#define MCURS_IBEAM     2
#define MCURS_HOURGLASS 3
#define MCURS_CROSS     4

//ÄÄÄÄÄ manifest constants for mouse events returned by Inkey()
#ifndef K_LEFT_DOWN   // to avoid conflicts with CLIP4DOS.CH
   #define  K_LEFT_DOWN       433
   #define  K_LEFT_DBLCLICK   434
   #define  K_LEFT_UP         435
   #define  K_RIGHT_DOWN      449
   #define  K_RIGHT_DBLCLICK  450
   #define  K_RIGHT_UP        451
#endif

#xtranslate MouseInit()                => __gfmInit()
#xtranslate MouseExit()                => __gfmExit()
#xtranslate HideMouseCursor()          => __gfmHide()
#xtranslate ShowMouseCursor()          => __gfmShow()
#xtranslate SetMousePos( <x>, <y> )    => __gfmSetP( <x>, <y> )
#xtranslate GetMousePos()              => __gfmGetP()
#xtranslate SetMouseDoubleClick( <m> ) => __gfmDblCl( <m> )
#xtranslate SetMouseCursor([<l>])      => __gfmCurs( [<l>] )
#xtranslate SetMouseLimits( <xMin>, <yMin>, <xMax>, <yMax> ) => ;
                __gfmLimit( <xMin>, <yMin>, <xMax>, <yMax> )

#ifdef CLIPPER52
   request GFMOUSE
#else
   external GFMOUSE
#endif

#endif

* eof: GRUMP.CH
