*=========================={ RUNNER.PRG }===========================
* Copyright (c) 1991 Hacksoft Inc.
*.............................................................................
* Revision number: 3.5 Created on : 01/28/1990 at 22:07
* Description: Original Creation
*.............................................................................
* Revision: 3.6a Last Revised: 2/28/1990 at 7:15
* Description: First one linked with Alink, and picture added.
*.............................................................................
* Revision: 3.7 Last Revised: 5/17/1990 at 18:03
* Description: Moved generic functions to hackfunc, in hacklib.lib
*.............................................................................
* Revision: 3.7b Last Revised: 08/09/90 at 22:40:37
* Description: Changed USE_DB() to check for an invalid Runner's Log file.
*.............................................................................
* Revision: 4.0 beta Last Revised: 09/19/90 at 21:09:02
* Description: Changed inkey from 0 to 3 for opening screen.
*.............................................................................
* Revision:  Last Revised: 10/11/90 at 01:11:36
* Description: Moved menu to prompt to the left 1 and made them same length.
*.............................................................................
* Revision:  Last Revised: 10/11/90 at 01:17:19
* Description: Fixed bug - graphed half of reccount() only
*.............................................................................
* Revision:  Last Revised: 10/11/90 at 01:18:06
* Description: Added prompts for title and miles or kilometers, changed
*              box.dbf to util.dbf and added fields for title, font, & miles
*              or kilometers.
*.............................................................................
* Revision: 4.1 Last Revised: 10/18/90 at 13:58:19
* Description: Fixed bugs in creating & selecting new logs
*.............................................................................
* Revision:  Last Revised: 10/24/90 at 23:26:51
* Description: Added F6 - 'Display tagged only' in BROWSE
*.............................................................................
* Revision: 4.2 Last Revised: 10/28/90 at 18:29:26
* Description: Added cga support for graphics
*.............................................................................
* Revision: 4.21 Last Revised: 11/02/90 at 14:18:55
* Description: Added directory to util.dbf for default directory when loading
*              new log.
*.............................................................................
* Revision: 4.22 Last Revised: 11/16/90 at 00:01:25
* Description: Fixed problem with PRINT when you tried to exit and mouse
* cursor was on PRINT icon
*.............................................................................
* Revision: 4.3 Last Revised: 01/28/91 at 23:41:26
* Description: Added detailed report to '2 Display or Print Specific Runs'
*.............................................................................
* Revision: 4.3 Last Revised: 02/03/91 at 21:20:25
* Description: Added detailed report to rest of program
*.............................................................................
* Revision: 4.3 Last Revised: 02/10/91 at 15:29
* Description: Fixed bug with calorie - caltime was 14.30 if time was 14:30
*              Should be 14.50
*.............................................................................
* Revision: 4.3 Modified on : 04-20-91 06:08:05pm
* Description:Changed legend for graph from 'AVERAGE' to 'AVERAGE PACE'
*.............................................................................
* Revision: 4.4 Modified on : 08-22-91 11:15:56pm
* Description:Removed items that don't change on edit screen so it doesn't
*             redraw the screen when you <PgUp> or <PgDn>
*...................................................................*
* Revision: 4.41 Modified on : 04-29-92 00:06:18am
* Description:Build util.dbf if it doesn't exist
*...................................................................*
* Revision: 5.0 Modified on : 01/18/2020 6:26pm
* Description:Build with Clipper5.2 on x86 emulator on Mac!
*...................................................................*
* Revision: 5.01 Modified on : 04/08/2020 6:01pm
* Description:Added SHDOW_BX() to make up for lack of wndo
*...................................................................*
* Revision: 5.21 Modified on : 06/02/2020 11:30pm
* Description:Updated version to 5.21 for change to VAL_TIME in 
*             Runovl
*...................................................................*
* Revision: 5.22 Modified on : 06/27/2020 12:18pm
* Description:Set cursor off on intro screen
*...................................................................*

*========================[ ALL RIGHTS RESERVED ]====================*
**** RUN THE AD PROGRAM ****
EXTERNAL wndo, hackcal, dgedefs, runovl, run1, run2, run3, run4, run5, run6,;
   RUNGRAPH, fopen, fread, fclose, scroll, expbox

LOCAL aUtil:={}
PRIVATE db, xfilter, xpara, background, shadow

PARAMETERS xpara
IF PCOUNT() = 0
   xpara = 'Y'
ENDIF
xpara = UPPER(xpara)
xfilter = '.T.'
SET TALK OFF
SET STAT OFF
SET SCOREBOARD OFF
SET BELL OFF
SET ESCAPE ON
SET CONFIRM OFF

IF .NOT. FILE('UTIL.DBF')
   AADD(aUtil,{'NAME'     ,'C',10,0})
   AADD(aUtil,{'TOP'      ,'N', 2,0})
   AADD(aUtil,{'LEFT'     ,'N', 2,0})
   AADD(aUtil,{'BOTTOM'   ,'N', 2,0})
   AADD(aUtil,{'RIGHT'    ,'N', 2,0})
   AADD(aUtil,{'COLOR'    ,'C',10,0})
   AADD(aUtil,{'GSTRING'  ,'C',20,0})
   AADD(aUtil,{'GSTRFONT' ,'C',12,0})
   AADD(aUtil,{'MORK'     ,'C', 4,0})
   AADD(aUtil,{'DIRECTORY','C',30,0})
   DBCREATE('UTIL',aUtil)
   USE UTIL
   APPEND BLANK
   REPLACE TOP      WITH 1
   REPLACE LEFT     WITH 3
   REPLACE BOTTOM   WITH 16
   REPLACE RIGHT    WITH 75
   REPLACE GSTRING  WITH "Runner's Log Chart"
   REPLACE GSTRFONT WITH 'RMN2828'
   REPLACE MORK     WITH 'MILE'
   USE
ENDIF

IF ISCOLOR() .AND. xpara # 'M'
   wbbrbg = "W+/B,BR/BG"
   wbgwbr = "W+/BG,W+/BR"
   RB = "R+/B"
   grb = "GR+/B"
   wbrwbg = "W+/BR,W+/BG"
   bb = "B/B"
   wbwbr = "W+/B,W+/BR"
   bgb = "BG+/B"
   grbr = "GR+/BR"
   brbg = "BR/BG"
   wbrbrbg = "W+/BR,BR/BG"
ELSE
   wbbrbg = "W/N"
   wbgwbr = "W/N"
   RB = "W/N"
   grb = "W/N"
   wbrwbg = "W/N"
   bb = "W/N"
   wbwbr = "W/N"
   bgb = "W/N"
   grbr = "W/N"
   wbrbrbg = "W/N"
   brbg = "W/N"
ENDIF

/*xvid:=GETVIDEO(0)
IF xvid >= 6
   IF FILE('RUNEGA.PIC')
      DO dgedefs                                        && DGE
      setvideo(6)
      sethires(0)
      *PICREAD(0,0,0,'RUNEGA.PCX')
      diskfile(0,'RUNEGA.PIC')
      INKEY(3)
   ENDIF
ENDIF
IF xvid==4
   IF FILE('RUNCGA.PIC')
      DO dgedefs                                        && DGE
      xvid = 5
      setvideo(xvid)
      sethires(0)
      *PICREAD(0,0,0,'RUNCGA.PCX')
      diskfile(0,'RUNCGA.PIC')
      INKEY(3)
   ENDIF
ENDIF
SETTEXT()
*/

background=REPLICATE(CHR(176),9)
shadow=REPLICATE(CHR(219),9)

SETCOLOR(wbbrbg)
@ 0,0,24,79 BOX background
 SETCOLOR(wbrwbg)
//DO wndo
SHDOW_BX(5,12,14,67,'S')
SETCOLOR(wbrwbg)
SPREAD("RUNNER'S LOG VERSION 5.22 BY HACKSOFT",6)
//SPREAD("LICIENCED TO: "+LTRIM(BLISERNUM()),8)
SPREAD("COPYRIGHT (c) 1989, HACKSOFT ALL RIGHTS RESERVED",10)
SPREAD("FOR TECHNICAL ASSISTANCE OR UPDATES CALL",11)
SPREAD("(219)282-3369 OR (219)277-6993",12)

SETCOLOR(wbgwbr)
SHDOW_BX(18,23,20,53,'D')
SET CURSOR OFF
@ 19,26 SAY "PRESS ANY KEY TO CONTINUE"
db:='RUN'
USE_DB()
INKEY(0)
**** EOF AD.PRG ****
//BLIMEMPAK(10)                                 && BLINKER FUNCTION
SET KEY -1 TO HACKCAL                         && CALANDER
SET KEY 306 TO SHOWMEM                        && ALT-M
SET KEY 274 TO ENV_STATUS                     && ALT-E

DO WHILE .T.
//   BLIOVLCLR()
//   BLIMEMPAK(-1)
   SET CURSOR OFF
*  IF FILE('TITLE.SCR')
*     BLINDOPEN('DRAPE.SCR')
*  ENDIF
*   IF FILE('DRAPE.SCR')
*      PULL_DRAPE('DRAPE.SCR')
*   ENDIF
   SETCOLOR(wbrwbg)
   @ 0,0,24,79 BOX background
   DO SHOWMEM                                    && SHOW AVAILABLE MEMORY
   SETCOLOR(wbbrbg)
   SHDOW_BX(2,10,22,69,'D')
   SETCOLOR(wbgwbr)
   @ 2,10 TO 22,69 DOUBLE
   @ 4,11 TO 4,68 DOUBLE

   SETCOLOR(wbrwbg)
   @ 0,10 SAY "F1 HELP   F2 CALENDAR   LOG: " + db
   @ 3,29 SAY " R U N N E R'S  L O G "
   SET WRAP ON
   @  6,22 PROMPT " 1.  ADD RUNS TO THE RUNNER'S LOG   "
   @  8,22 PROMPT " 2.  DISPLAY OR PRINT SPECIFIC RUNS "
   @ 10,22 PROMPT " 3.  DISPLAY OR PRINT ALL RUNS      "
   @ 12,22 PROMPT " 4.  DISPLAY OR PRINT BEST TIMES    "
   @ 14,22 PROMPT " 5.  BROWSE THROUGH RUNS            "
   @ 16,22 PROMPT " 6.  CREATE OR LOAD NEW LOG         "
   @ 18,22 PROMPT " 7.  DISPLAY OR PRINT GRAPHICS      "
   @ 20,22 PROMPT " 8.  EXIT RUNNER'S LOG              "
   MENU TO choice
   DO CASE

   CASE choice = 1                          && ADD RUNS
      DO RUN1
   CASE choice = 2                          && PRINT SPECIFIC RUNS
      DO RUN2
   CASE choice = 3                          && PRINT ALL RUNS
      DO RUN3
   CASE choice = 4                          && BEST TIMES
      DO RUN4
   CASE choice = 5                          && BROWSE THROUGH RUNS
      DO RUN5
   CASE choice = 6                          && CREATE OR SELECT NEW LOG
      DO RUN6
   CASE choice = 7
      DO RUNGRAPH
   CASE choice = 8                          && EXIT
      SET CURSOR ON
      SETCOLOR(grb)
 //     BLINDCLOSE()
      RETURN
   ENDCASE
ENDDO

/*
    Program: SPREAD()
    System: GRUMPFISH LIBRARY
    Author: Greg Lief
    Copyright (c) 1988-93, Greg Lief
    CA-Clipper 5.x version
    Compile instructions: clipper spread /n /w
    Displays a character string from the center out
*/

#include "grump.ch"

function Spread(cMessage, nRow, nDelay, nMidPoint)
local nLength := len(cMessage)
local xx
local yy
local zz := int(nLength / 2)
default nDelay to 10
default nMidPoint to (maxcol() + 1) / 2
for xx := 1 to zz
   @ nRow, nMidPoint - xx ssay substr(cMessage, 1, xx) + ;
                               substr(cMessage, nLength + 1 - xx, xx)
   for yy := 1 to nDelay
   next
next
//ƒƒƒƒƒ if message was of odd length, redraw entire thing now
if nLength % 2 == 1
   @ nRow, nMidPoint - xx ssay cMessage
endif
return NIL

* end function Spread()
*--------------------------------------------------------------------*

* eof spread.prg

* EOF RUN.PRG