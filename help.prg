* Program..: help.prg 
* Author...: Larry Hack 
* Created..: 3/22/1990 at 21:26
* Copyright (c) 1990 by Data-Link Systems 
* main = 
* Called From:
*.............................................................................
* Revision: 4.3 Last Revised: 3/22/1990 at 21:26
* Description: Original Creation.
*.............................................................................
***************************** ALL RIGHTS RESERVED ****************************
*:*********************************************************************
*:      Called by: RUNNER.PRG                    
*:               : HELP.PRG                      
*:               : RUN6           (procedure in RUNOVL.PRG)
*:
*:          Calls: SHDOW_BX()     (function  in RUNOVL.PRG)
*:               : EXIT           (procedure in RUNOVL.PRG)
*:               : HELP.PRG
*:               : HACKCAL.PRG
*:
*:           Uses: HELP.DBF       
*:*********************************************************************

PARAMETERS p, l, v
PRIV t,l,B,R
t = 5
l = 21
B = 20
R = 61
HELP_SCR = SAVESCREEN(t,l,b+1,r+2)
IF FILE('HELP.DBF')
   SELECT 2
   USE HELP
ELSE
   shdow_bx(10,26,12,53,grbr,'D')
   help_err = Setcolor(grbr)
   @ 11,28 SAY 'HELP.DBF FILE NOT FOUND'
   Setcolor(help_err)
   INKEY(3)
   RESTSCREEN(t,l,b+1,r+2,HELP_SCR)
   RETURN
ENDIF

SET KEY 27 TO      && EXIT
SET KEY 28 TO      && HELP
SET KEY -1 TO      && F2 CALANDER

curr_color = Setcolor()
DO WHILE .T.
   Setcolor(wbrwbg)
   shdow_bx(t,l,B,R,wbrwbg,'D')
   Setcolor(grbr)
   @  t,l+((R-l)/2)-2 SAY "HELP"
   Setcolor(wbrwbg)
   @ t+ 2,l+2 PROMPT "     INTRODUCTION                    "
   @ t+ 3,l+2 PROMPT "     EDITING                         "
   @ t+ 4,l+2 PROMPT "     THE MAIN MENU                   "
   @ t+ 5,l+2 PROMPT "  1  ADD RUNS TO THE RUNNER'S LOG    "
   @ t+ 6,l+2 PROMPT "  2  DISPLAY OR PRINT SPECIFIC RUNS  "
   @ t+ 7,l+2 PROMPT "  3  DISPLAY OR PRINT ALL RUNS       "
   @ t+ 8,l+2 PROMPT "  4  DISPLAY OR PRINT BEST TIMES     "
   @ t+ 9,l+2 PROMPT "  5  PAGE THROUGH RUNS               "
   @ t+10,l+2 PROMPT "  6  CREATE OR LOAD NEW LOG          "
   @ t+11,l+2 PROMPT "  7  DISPLAY OR PRINT GRAPHICS       "
   @ t+12,l+2 PROMPT "  8  EXIT RUNNER'S LOG               "
   @ t+13,l+2 PROMPT "     QUIT HELP                       "
   MENU TO HELP
   
   IF HELP = 12 .OR. HELP = 0
      EXIT
   ELSE
      GOTO HELP
      SET CURSOR ON
      IF xpara == 'DEV'
         REPLACE MEMO WITH MEMOEDIT(memo, t+1,l+2,B-1,R-2,.T.)
       ELSE
         MEMOEDIT(memo, t+1,l+2,B-1,R-2,.F.)
       ENDIF
      SET CURSOR OFF
   ENDIF
ENDDO

SET CURSOR ON
IF p = "RUN1" .OR. p = "RUN2" .OR. p = "RUN3" .OR. p = "RUN4" .OR.;
   p = "RUN5" .OR. p = "RUN6"
   SET KEY 27 TO EXIT
ENDIF
SET KEY 28 TO HELP
SET KEY -1 TO hackcal
Setcolor(curr_color)
RESTSCREEN(t,l,b+1,r+2,HELP_SCR)
IF p = 'RUNNER' .OR. P = 'DBEDIT'
   SET CURS OFF
ENDIF
USE
SELECT 1

RETURN
* eof() help.prg
