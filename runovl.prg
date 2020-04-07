* Program..: runovl.prg
* Author...: Larry Hack
* Created..: 3/22/1990 at 21:30
* Copyright (c) 1990 by Hacksoft
* Called From: Runner
*.............................................................................
* Revision: 1.0 Last Revised: 3/22/1990 at 21:30
* Description: Original Creation.
*.............................................................................
* Revision: 3.7 Last Revised: 3/22/1990 at 21:31
* Description: Snapped system
*.............................................................................
* Revision: 4.0 BETA Last Revised: 09/19/90 at 21:07:27
* Description: Fixed bug that closed dbf after copying to new file in dbedit.
*.............................................................................
* Revision: 4.0 Last Revised: 06/27/90 at 22:37:50
* Description: Changes for Reed - update calculated fields when browsing,
* Calc_upd() Add recno() to dbedit and allow user to goto recno() from seek box
*.............................................................................
* Revision:  Last Revised: 10/11/90 at 01:13:32
* Description: Changed Seek_it from a procedure to a function to return xretv
*.............................................................................
* Revision:  Last Revised: 10/11/90 at 01:14:31
* Description: Fixed bug with filter in seek - crashed when seeking after
*              setting filter.
*.............................................................................
* Revision: 4.1 Last Revised: 10/18/90 at 13:58:19
* Description: Fixed bugs in creating & selecting new logs
*.............................................................................
* Revision: 4.1 Last Revised: 10/24/90 at 23:26:51
* Description: Added F6 - 'Display tagged only' in BROWSE
*.............................................................................
* Revision: 4.21 Last Revised: 11/02/90 at 14:18:55
* Description: Added directory to util.dbf for default directory when loading
*              new log.
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
* Revision: 4.4 Last Revised: 02/01/2020 at 12:47am
* Description: Had to replace text in parameter for BOX in PAGE_RUN
*              Corrupted?
*.............................................................................
***************************** ALL RIGHTS RESERVED ****************************
***********************************************************************
*!      Procedure: RUN1
*!
*!      Called by: RUNNER.PRG
*!
*!          Calls: USE_DB()       (function  in RUNOVL.PRG)
*!               : EXIT           (procedure in RUNOVL.PRG)
*!               : TORF()         (function  in RUNOVL.PRG)
*!               : DIST_F()       (function  in RUNOVL.PRG)
*!               : DIST_F2()      (function  in RUNOVL.PRG)
*!               : VAL_TIME()     (function  in RUNOVL.PRG)
*!*********************************************************************
PROCEDURE run1

IF .NOT. use_db()
   RETURN
ENDIF
BEGIN SEQUENCE
   SET KEY 27 TO EXIT
   SET CURSOR ON
   SETCOLOR(wbbrbg)
   SET Century ON
   CLEAR
   SET Century ON
   STORE DATE() TO mdate
   STORE 0 TO mdistance, mhour, mminutes
   STORE 0 TO mfirst,msecond,mthird,mfourth,mfifth,msixth,mseventh,meighth
   STORE 0 TO mninth,mtenth,meleven,mtwelve,mthirteen,mfourteen,mfifteen
   STORE 0 TO msixteen,mseventeen,meighteen,mnineteen,mtwenty,mtwenty1,mtwenty2
   STORE 0 TO mtwenty3,mtwenty4,mtwenty5,mtwenty6,mtwenty7,mtwenty8
   STORE 0 TO mtwenty9,mthirty, mdistancek, caltime
   STORE SPACE(64) TO mnote1, mnote2, mnote3, mnote4, mnote5
   STORE " " TO splits_yn, mrace

   @ 3,4 TO 21,75
   @ 0,2 TO 3,77 DOUBLE
   @ 1,30 SAY "R U N N E R' S  L O G"
   @ 2,32 SAY "DATE:"
   @ 4,9 SAY "RACE:    MILES:         KILOMETERS:         TIME:  :"
   @ 2,39 GET mdate PICTURE "@DK"
   @ 4,15 GET mrace PICTURE "!" VALID torf()
   @ 4,25 GET mdistance PICTURE '99999.9' VALID dist_f()
   @ 4,45 GET mdistancek PICTURE '99999.9' VALID dist_f2()
   @ 6,25 CLEAR TO 6,58
   @ 4,59 GET mhour PICTURE "9"
   @ 4,61 GET mminutes PICTURE "99.99" VALID val_time()
   READ
   @ 6,20 SAY "DO YOU WANT TO ENTER YOUR SPLITS? Y/N " GET splits_yn PICTURE '@!' VALID(splits_yn $ "YN")
   READ
   **** DO CALCULATIONS FOR MILES ****
   caltime = mhour*60 + INT(mminutes)+(((mminutes-INT(mminutes))/60)*100)                 && FOR CALORIES BURNED
   ttime = ((mhour * 3600)+INT(mminutes)*60)+(mminutes-INT(mminutes))*100
   maver = (ttime/mdistance)/60                  && TOTAL TIME DIVIDE BY DISTANCE IN SECONDS
   tottime = (maver - INT(maver))*.6             && CONVERT SECONDS TO TIME FORMAT
   maverage = INT(maver)+tottime                 && THE AVERAGE TIME IN CORRECT TIME FORMAT

   **** DO CALCULATIONS FOR KMS ****
   maver = (ttime/mdistancek)/60                 && TOTAL TIME DIVIDE BY DISTANCE IN SECONDS
   tottime = (maver - INT(maver))*.6             && CONVERT SECONDS TO TIME FORMAT
   maveragek = INT(maver)+tottime                && THE AVERAGE TIME IN CORRECT TIME FORMAT

   *******************
   IF splits_yn = "Y"
      @ 6,20 CLEAR TO 6,60
      STORE 0 TO countsplits
      DO WHILE countsplits < INT(mdistance) .AND. mdistance < 500
         countsplits = countsplits + 1
         IF countsplits = 1
            @ 6,6 SAY "1}"
            @ 6,9 GET mfirst PICTURE "99.99"
         ENDIF
         IF countsplits = 2
            @ 7,6 SAY "2}"
            @ 7,9 GET msecond PICTURE "99.99"
         ENDIF
         IF countsplits = 3
            @ 8,6 SAY "3}"
            @ 8,9 GET mthird PICTURE "99.99"
         ENDIF
         IF countsplits = 4
            @ 9,6 SAY "4}"
            @ 9,9 GET mfourth PICTURE "99.99"
         ENDIF
         IF countsplits = 5
            @ 10,6 SAY "5}"
            @ 10,9 GET mfifth PICTURE "99.99"
         ENDIF
         IF countsplits = 6
            @ 6,17 SAY "6}"
            @ 6,20 GET msixth PICTURE "99.99"
         ENDIF
         IF countsplits = 7
            @ 7,17 SAY "7}"
            @ 7,20 GET mseventh PICTURE "99.99"
         ENDIF
         IF countsplits = 8
            @  8,17 SAY "8}"
            @  8,20 GET meighth PICTURE "99.99"
         ENDIF
         IF countsplits = 9
            @  9,17 SAY "9}"
            @  9,20 GET mninth PICTURE "99.99"
         ENDIF
         IF countsplits = 10
            @ 10,16 SAY "10}"
            @ 10,20 GET mtenth PICTURE "99.99"
         ENDIF
         IF countsplits = 11
            @ 6,28 SAY "11}"
            @ 6,32 GET meleven PICTURE "99.99"
         ENDIF
         IF countsplits = 12
            @ 7,28 SAY "12}"
            @ 7,32 GET mtwelve PICTURE "99.99"
         ENDIF
         IF countsplits = 13
            @  8,28 SAY "13}"
            @  8,32 GET mthirteen PICTURE "99.99"
         ENDIF
         IF countsplits = 14
            @  9,28 SAY "14}"
            @  9,32 GET mfourteen PICTURE "99.99"
         ENDIF
         IF countsplits = 15
            @ 10,28 SAY "15}"
            @ 10,32 GET mfifteen PICTURE "99.99"
         ENDIF
         IF countsplits = 16
            @  6,40 SAY "16}"
            @  6,44 GET msixteen PICTURE "99.99"
         ENDIF
         IF countsplits = 17
            @  7,40 SAY "17}"
            @  7,44 GET mseventeen PICTURE "99.99"
         ENDIF
         IF countsplits = 18
            @  8,40 SAY "18}"
            @  8,44 GET meighteen PICTURE "99.99"
         ENDIF
         IF countsplits = 19
            @  9,40 SAY "19}"
            @  9,44 GET mnineteen PICTURE "99.99"
         ENDIF
         IF countsplits = 20
            @ 10,40 SAY "20}"
            @ 10,44 GET mtwenty PICTURE "99.99"
         ENDIF
         IF countsplits = 21
            @ 6,52 SAY "21}"
            @ 6,56 GET mtwenty1 PICTURE "99.99"
         ENDIF
         IF countsplits = 22
            @ 7,52 SAY "22}"
            @ 7,56 GET mtwenty2 PICTURE "99.99"
         ENDIF
         IF countsplits = 23
            @  8,52 SAY "23}"
            @  8,56 GET mtwenty3 PICTURE "99.99"
         ENDIF
         IF countsplits = 24
            @  9,52 SAY "24}"
            @  9,56 GET mtwenty4 PICTURE "99.99"
         ENDIF
         IF countsplits = 25
            @ 10,52 SAY "25}"
            @ 10,56 GET mtwenty5 PICTURE "99.99"
         ENDIF
         IF countsplits = 26
            @  6,64 SAY "26}"
            @  6,68 GET mtwenty6 PICTURE "99.99"
         ENDIF
         IF countsplits = 27
            @  7,64 SAY "27}"
            @  7,68 GET mtwenty7 PICTURE "99.99"
         ENDIF
         IF countsplits = 28
            @  8,64 SAY "28}"
            @  8,68 GET mtwenty8 PICTURE "99.99"
         ENDIF
         IF countsplits = 29
            @  9,64 SAY "29}"
            @  9,68 GET mtwenty9 PICTURE "99.99"
         ENDIF
         IF countsplits = 30
            @ 10,64 SAY "30}"
            @ 10,68 GET mthirty PICTURE "99.99"
         ENDIF
      ENDDO
      READ
   ENDIF
   STORE 0 TO m->weight
   @ 12,10 SAY "HOW MUCH DO YOU WEIGH? " GET m->weight PICTURE "999"
   READ
   @ 12,10 SAY SPACE(31)
   IF m->weight # 0
      IF maverage <= 6
         mcalorie = caltime*m->weight*.114
      ENDIF
      IF maverage <= 8.3 .AND. maverage > 6
         mcalorie = caltime*m->weight*.102
      ENDIF
      IF maverage < 11 .AND. maverage > 7
         mcalorie = caltime*m->weight*.090
      ENDIF
      IF maverage >= 11
         mcalorie = caltime*m->weight*.070
      ENDIF
   ELSE
      mcalorie = 0
   ENDIF
   @ 12, 8 SAY "AVERAGE PACE PER MILE:"+SPACE(10)+"CALORIES BURNED:"
   @ 13, 8 SAY "AVERAGE PACE PER KM:"
   Setcolor(brbg)
   @ 12, 31 SAY maverage PICTURE '99.99'
   @ 12, 57 SAY mcalorie PICTURE '99999'
   @ 13, 31 SAY maveragek PICTURE '99.99'
   Setcolor(wbbrbg)
   @ 15,37 SAY "NOTES"
   @ 16, 8 GET mnote1
   @ 17, 8 GET mnote2
   @ 18, 8 GET mnote3
   @ 19, 8 GET mnote4
   @ 20, 8 GET mnote5
   READ
   STORE " " TO SAVE
   @ 22,24 SAY "STORE RUN TO RUNNER'S LOG? Y/N " GET SAVE PICTURE '@!' VALID(SAVE $'YN')
   READ
   IF SAVE = "Y"
      APPEND BLANK
      REPLACE race       WITH UPPER(mrace)
      REPLACE DATE       WITH mdate
      REPLACE distance   WITH mdistance
      REPLACE distancek  WITH mdistancek
      REPLACE minutes    WITH mminutes
      REPLACE AVERAGE    WITH maverage
      REPLACE averagek   WITH maveragek
      REPLACE first      WITH mfirst
      REPLACE SECOND     WITH msecond
      REPLACE third      WITH mthird
      REPLACE fourth     WITH mfourth
      REPLACE fifth      WITH mfifth
      REPLACE sixth      WITH msixth
      REPLACE seventh    WITH mseventh
      REPLACE eighth     WITH meighth
      REPLACE ninth      WITH mninth
      REPLACE tenth      WITH mtenth
      REPLACE eleven     WITH meleven
      REPLACE twelve     WITH mtwelve
      REPLACE thirteen   WITH mthirteen
      REPLACE fourteen   WITH mfourteen
      REPLACE fifteen    WITH mfifteen
      REPLACE sixteen    WITH msixteen
      REPLACE seventeen  WITH mseventeen
      REPLACE eighteen   WITH meighteen
      REPLACE nineteen   WITH mnineteen
      REPLACE twenty     WITH mtwenty
      REPLACE twenty1    WITH mtwenty1
      REPLACE twenty2    WITH mtwenty2
      REPLACE twenty3    WITH mtwenty3
      REPLACE twenty4    WITH mtwenty4
      REPLACE twenty5    WITH mtwenty5
      REPLACE twenty6    WITH mtwenty6
      REPLACE twenty7    WITH mtwenty7
      REPLACE twenty8    WITH mtwenty8
      REPLACE twenty9    WITH mtwenty9
      REPLACE thirty     WITH mthirty
      REPLACE sectime    WITH ttime
      REPLACE hour       WITH mhour
      REPLACE weight     WITH m->weight
      REPLACE calorie    WITH mcalorie
      REPLACE note1      WITH mnote1
      REPLACE note2      WITH mnote2
      REPLACE note3      WITH mnote3
      REPLACE note4      WITH mnote4
      REPLACE note5      WITH mnote5
      USE
   ENDIF
   WAIT
END
SET KEY 27 TO
RETURN

*!*********************************************************************
*!      Procedure: RUN2
*!
*!      Called by: RUNNER.PRG
*!
*!          Calls: USE_DB()       (function  in RUNOVL.PRG)
*!               : EXIT           (procedure in RUNOVL.PRG)
*!               : PRINT          (procedure in HACKCAL.LIB)
*!
*!           Uses: &DB
*!
*!        Indexes: RUN.NTX
*!*********************************************************************
PROCEDURE run2

IF .NOT. use_db()
   RETURN
ENDIF
BEGIN SEQUENCE
   SET KEY 27 TO EXIT
   Setcolor(wbbrbg)
   SET CURSOR ON
   SET TALK OFF
   CLEAR
   STORE SPACE(8) TO mdate1, mdate2
   STORE 0 TO counter
   STORE 0 TO msectime
   STORE 0 TO msectime1
   STORE 0 TO msectime2
   STORE 0 TO mdistance
   STORE 0 TO mdistance1
   STORE 0 TO mdistance2
   STORE 0 TO mdistance3
   STORE 0 TO mhour1
   STORE 0 TO mhour2
   STORE 0 TO m2minutes
   STORE 0 TO m2minutes2
   STORE 0 TO m2time
   STORE 0 TO m2time2
   STORE 0 TO mmin1
   STORE 0 TO mmin2
   STORE 0 TO mpace1
   STORE 0 TO mpace2
   STORE 0 TO hmtime
   STORE 0 TO hmtime2
   STORE ' ' TO rpt_type
   *** OPERATORS ***
   STORE " " TO date1, date2, distance1, distance2, time1, time2, pace1, pace2

   @  1, 24  SAY "RUN SEARCH SPECIFICATION SCREEN"
   @  3, 32  SAY "Accepted Operators"
   @  4, 22  SAY "Less than:  <       Greater than:  >"
   @  5, 22  SAY "Equal:      =       Not Equal:     #"
   @  8,  4  SAY "Operator     Starting Date                  Operator       Ending Date"
   @ 10, 37  SAY "AND"
   @ 12,  4  SAY "Operator       Distance                     Operator        Distance"
   @ 14, 37  SAY "AND"
   @ 16,  4  SAY "Operator        Time                        Operator         Time"
   @ 18, 20  SAY ":"
   @ 18, 37  SAY "AND"
   @ 18, 65  SAY ":"
   @ 20,  4  SAY "Operator        Pace                        Operator         Pace"
   @ 22, 37  SAY "AND"
   @  0, 15  TO  2, 64    DOUBLE
   @  3, 17  TO  6, 62

   @ 10, 7 GET date1 VALID(date1 $"><=#' '")
   @ 10,19 GET mdate1 PICTURE "99/99/99"
   @ 10,51 GET date2 VALID(date2 $"><=#' '")
   @ 10,64 GET mdate2 PICTURE "99/99/99"
   @ 14, 7 GET distance1 VALID(distance1 $"><=#' '")
   @ 14,21 GET mdistance1 PICTURE "999.9"
   @ 14,51 GET distance2 VALID(distance2 $"><=#' '")
   @ 14,66 GET mdistance2 PICTURE "999.9"
   @ 18, 7 GET time1 VALID(time1 $"><=#' '")
   @ 18,19 GET mhour1 PICTURE "9"
   @ 18,21 GET mmin1 PICTURE "99.99"
   @ 18,51 GET time2 VALID(time2 $"><=#' '")
   @ 18,64 GET mhour2 PICTURE "9"
   @ 18,66 GET mmin2 PICTURE "99.99"
   @ 22, 7 GET pace1 VALID(pace1 $"><=#' '")
   @ 22,20 GET mpace1 PICTURE "99.99"
   @ 22,51 GET pace2 VALID(pace2 $"><=#' '")
   @ 22,65 GET mpace2 PICTURE "99.99"
   READ
   msectime1 = (mhour1*3600 + INT(mmin1)*60)+((mmin1 - INT(mmin1))*100)
   msectime2 = (mhour2*3600 + INT(mmin2)*60)+((mmin2 - INT(mmin2))*100)
   STORE SPACE(1) TO LIST, inorder
   Setcolor(wbbrbg)
   @ 0,0,24,79 BOX background
   Setcolor(wbgwbr)
   shdow_bx(7,10,11,69,'S')
   @  8,12 SAY "DO YOU WANT 1)RACES 2)WORKOUTS OR 3)BOTH ?" GET LIST VALID(LIST $'123')
   @ 10,12 SAY "DO YOU WANT THE RUNS IN ORDER FROM FASTEST TO SLOWEST?" GET inorder PICTURE '@!' VALID(inorder $'YN')
   READ
   SELECT 1
   USE (db)
   IF inorder = "Y"
      INDEX ON AVERAGE TO RUN
      SET INDEX TO RUN
   ENDIF
   GO TOP
   IF date1 = " "
      opdate1 = "1 = 1"
   ELSE
      opdate1 = "DATE &DATE1 CTOD(MDATE1)"
   ENDIF
   IF date2 = " "
      opdate2 = "1 = 1"
   ELSE
      opdate2 = "DATE &DATE2 CTOD(MDATE2)"
   ENDIF
   IF distance1 = " "
      opdist1 = "1 = 1"
   ELSE
      opdist1 = "DISTANCE &DISTANCE1 MDISTANCE1"
   ENDIF
   IF distance2 = " "
      opdist2 = "1 = 1"
   ELSE
      opdist2 = "DISTANCE &DISTANCE2 MDISTANCE2"
   ENDIF
   IF time1 = " "
      optime1 = "1 = 1"
   ELSE
      optime1 = "SECTIME &TIME1 MSECTIME1"
   ENDIF
   IF time2 = " "
      optime2 = "1 = 1"
   ELSE
      optime2 = "SECTIME &TIME2 MSECTIME2"
   ENDIF
   IF pace1 = " "
      oppace1 = "1 = 1"
   ELSE
      oppace1 = "AVERAGE &PACE1 MPACE1"
   ENDIF
   IF pace2 = " "
      oppace2 = "1 = 1"
   ELSE
      oppace2 = "AVERAGE &PACE2 MPACE2"
   ENDIF
   DO CASE
   CASE LIST = '1'
      raceyn = 'race="Y"'
   CASE LIST = '2'
      raceyn = 'race="N"'
   CASE LIST = '3'
      raceyn = '1=1'
   ENDCASE
   xfilter = raceyn+'.AND.'+opdate1+'.AND.'+opdate2+'.AND.'+opdist1+'.AND.'+opdist2+'.AND.'+optime1+'.AND.'+optime2+'.AND.'+oppace1+'.AND.'+oppace2
   which_rpt()                                      && DETAILED OR SHORT REPORT
END
SET KEY 27 TO
RETURN

*!*********************************************************************
*!      Procedure: RUN3
*!
*!      Called by: RUNNER.PRG
*!
*!          Calls: USE_DB()       (function  in RUNOVL.PRG)
*!               : EXIT           (procedure in RUNOVL.PRG)
*!               : PRINT          (procedure in HACKLIB.LIB)
*!*********************************************************************
PROCEDURE run3                                   && PRINT ALL RUNS

PRIVATE rpt_type
STORE ' ' TO rpt_type
IF .NOT. use_db()
   RETURN
ENDIF
BEGIN SEQUENCE
   SET CURSOR ON
   STORE 0 TO counter
   STORE 0 TO mdistance
   STORE 0 TO mdistance2
   STORE 0 TO mdistance3
   STORE 0 TO sectime
   STORE 0 TO msectime
   xfilter = '.T.'
   Setcolor(wbbrbg)
   @ 0,0,24,79 BOX REPL('±',9)
   which_rpt()                                    && DETAILED OR SHORT REPORT
END
USE
RETURN

*!**********************************************************************
*!      Procedure: RUN4
*!
*!      Called by: RUNNER.PRG
*!
*!          Calls: USE_DB()       (function  in RUNOVL.PRG)
*!               : EXIT           (procedure in RUNOVL.PRG)
*!               : PRINT          (procedure in HACKLIB.LIB)
*!
*!        Indexes: AVERAGE.NTX
*!*********************************************************************
PROCEDURE run4                                   && BEST TIMES

IF .NOT. use_db()
   RETURN
ENDIF
BEGIN SEQUENCE
   SET KEY 27 TO EXIT
   SET CURSOR ON
   STORE 0 TO best
   STORE 10 TO best2
   LIST=' '
   Setcolor(wbbrbg)
   @ 0,0,24,79 BOX background
   Setcolor(wbgwbr)
   shdow_bx(6,15,12,64,'S')
   @ 7,17 SAY "DO YOU WANT 1)RACES 2)WORKOUTS OR 3)BOTH ?" GET LIST VALID(LIST $'123')
   @  9,17 SAY "ENTER DISTANCE " GET best PICTURE "999.9"
   @ 11,17 SAY "DISPLAY THE" GET best2 PICTURE "999"
   @ ROW(),COL()+1 SAY "BEST TIMES"
   READ
   IF LIST = "1"
      race = "race = 'Y'"
   ENDIF
   IF LIST = "2"
      race = "race = 'N'"
   ENDIF
   IF LIST = "3"
      race = "1 = 1"
   ENDIF
   PRINT = PRINT()
   INDEX ON AVERAGE TO AVERAGE
   SET INDEX TO AVERAGE
   DO HEADING
   Setcolor(wbwbr)
   STORE 1 TO counter
   DO WHILE .NOT. EOF() .AND. counter <= best2
      raceyn = IF(race = "Y",'RACE','')
      IF distance = best .AND. sectime > 0 .AND. &race
         counter = counter + 1
         ? "  ", RECNO(), "   ", DATE, "   ", STR(distance,8,1), "      ", STR(hour),"  ", STR(minutes,5,2), "     ", STR(AVERAGE,5,2),"  ",raceyn
         REPLACE tag WITH .T.
      ENDIF
      SKIP
   ENDDO
   ?
   WAIT
   SET PRINT OFF
   SET DEVI TO SCREEN
END
USE
SET KEY 27 TO
RETURN
*!**********************************************************************
*!      Procedure: RUN5
*!
*!      Called by: RUNNER.PRG
*!
*!          Calls: USE_DB()       (function  in RUNOVL.PRG)
*!               : SHDOW_BX()     (function  in RUNOVL.PRG)
*!               : MAIN()         (function  in RUNOVL.PRG)
*!*********************************************************************
PROCEDURE run5

IF .NOT. use_db()
   RETURN
ENDIF
SET CURSOR ON
Setcolor(wbbrbg)
@ 0,0,24,79 BOX background
IF Lastrec() = 0
   @ 12,32 SAY "THE LOG IS EMPTY"
   @ 14,0 SAY ""
   WAIT
   RETURN
ENDIF

Setcolor(wbgwbr)
shdow_bx(19,2,23,76,'D')
@ 20,7 SAY 'F1 HELP  Ý <Enter> EDIT RUN  Ý <Esc> EXIT  Ý F3 SEEK  Ý F7 DELETE'
@ 21,7 SAY 'SPACE BAR - TAG/UNTAG Ý <Ctrl> T - TAG ALL Ý <Ctrl> U - UNTAG ALL'
@ 22,7 SAY 'F4 PRINT TAGGED Ý F5 COPY TAGGED TO FILE Ý F6 DISPLAY TAGGED ONLY'
main()
RETURN
*!*********************************************************************
*!       Function: MAIN()
*!
*!      Called by: RUN5           (procedure in RUNOVL.PRG)
*!
*!          Calls: SHDOW_BX()     (function  in RUNOVL.PRG)
*!
*!           Uses: UTIL.DBF
*!*********************************************************************
FUNCTION main

PRIVATE xrecno                                   && FOR CONTINUE IN SEEK
PRIVATE t,l,B,R,xseek_it, xretv
xrecno = 0
t = 8
l = 10
B = 20
R = 60
SELECT 3
USE util
GO TOP
IF .NOT. EMPTY(util->top)
   t = util->top
   l = util->left
   B = util->bottom
   R = util->right
ENDIF
USE

getout = .F.
SELECT 1                                         && DB DATABASE
GO TOP
DECLARE arry1[47], arry2[47]
arry1[1] =  'IF(TAG," û ","   ")'
arry1[2] = 'RECNO()'
arry1[3] =  'IF(race="Y","RACE","    ")'
arry1[4] =  'DATE'
arry1[5] =  'DISTANCE'
arry1[6] =  'STR(HOUR) + ":" + STR(MINUTES)'
arry1[7] = 'AVERAGE'
arry1[8] =  'DISTANCEK'
arry1[9] = 'AVERAGEK'
arry1[10] =  'CALORIE'
arry1[11] =  'WEIGHT'
arry1[12] = 'FIRST'
arry1[13] = 'SECOND'
arry1[14] = 'THIRD'
arry1[15] = 'FOURTH'
arry1[16] = 'FIFTH'
arry1[17] = 'SIXTH'
arry1[18] = 'SEVENTH'
arry1[19] = 'EIGHTH'
arry1[20] = 'NINTH'
arry1[21] = 'TENTH'
arry1[22] = 'ELEVEN'
arry1[23] = 'TWELVE'
arry1[24] = 'THIRTEEN'
arry1[25] = 'FOURTEEN'
arry1[26] = 'FIFTEEN'
arry1[27] = 'SIXTEEN'
arry1[28] = 'SEVENTEEN'
arry1[29] = 'EIGHTEEN'
arry1[30] = 'NINETEEN'
arry1[31] = 'TWENTY'
arry1[32] = 'TWENTY1'
arry1[33] = 'TWENTY2'
arry1[34] = 'TWENTY3'
arry1[35] = 'TWENTY4'
arry1[36] = 'TWENTY5'
arry1[37] = 'TWENTY6'
arry1[38] = 'TWENTY7'
arry1[39] = 'TWENTY8'
arry1[40] = 'TWENTY9'
arry1[41] = 'THIRTY'
arry1[42] = 'NOTE1'
arry1[43] = 'NOTE2'
arry1[44] = 'NOTE3'
arry1[45] = 'NOTE4'
arry1[46] = 'NOTE5'

arry2[1] =  'TAG'
arry2[2] =  'RECORD'
arry2[3] =  'RACE'
arry2[4] =  'DATE'
arry2[5] =  'MILES'
arry2[6] =  'TIME'
arry2[7] =  'AVERAGE'
arry2[8] =  'KM'
arry2[9] =  'AVERAGEK'
arry2[10] =  'CALORIES'
arry2[11] = 'WEIGHT'
arry2[12] = 'SPLIT 1'
arry2[13] = 'SPLIT 2'
arry2[14] = 'SPLIT 3'
arry2[15] = 'SPLIT 4'
arry2[16] = 'SPLIT 5'
arry2[17] = 'SPLIT 6'
arry2[18] = 'SPLIT 7'
arry2[19] = 'SPLIT 8'
arry2[20] = 'SPLIT 9'
arry2[21] = 'SPLIT 10'
arry2[22] = 'SPLIT 11'
arry2[23] = 'SPLIT 12'
arry2[24] = 'SPLIT 13'
arry2[25] = 'SPLIT 14'
arry2[26] = 'SPLIT 15'
arry2[27] = 'SPLIT 16'
arry2[28] = 'SPLIT 17'
arry2[29] = 'SPLIT 18'
arry2[30] = 'SPLIT 19'
arry2[31] = 'SPLIT 20'
arry2[32] = 'SPLIT 21'
arry2[33] = 'SPLIT 22'
arry2[34] = 'SPLIT 23'
arry2[35] = 'SPLIT 24'
arry2[36] = 'SPLIT 25'
arry2[37] = 'SPLIT 26'
arry2[38] = 'SPLIT 27'
arry2[39] = 'SPLIT 28'
arry2[40] = 'SPLIT 29'
arry2[41] = 'SPLIT 30'
arry2[42] = 'NOTE 1'
arry2[43] = 'NOTE 2'
arry2[44] = 'NOTE 3'
arry2[45] = 'NOTE 4'
arry2[46] = 'NOTE 5'

main_scr = Savescreen(0,0,24,79)
oldcolor = Setcolor(wbrwbg)
DO WHILE .NOT. getout
   Restscreen(0,0,24,79,main_scr)
   shdow_bx(t-1,l-1,B+1,R+1,'D')
   Dbedit(t,l,B,R,arry1,'DB_RUN',.T.,arry2,"ß",.T.,"Ü")
ENDDO
Restscreen(0,0,24,79,main_scr)
Setcolor(oldcolor)
RETURN(.T.)
*!*********************************************************************
*!       Function: DB_RUN()
*!
*!          Calls: PAGE_RUN       (procedure in RUNOVL.PRG)
*!               : SEEK_IT        (procedure in RUNOVL.PRG)
*!               : PRINT          (procedure in HACKLIB.LIB)
*!               : SHDOW_BX()     (function  in RUNOVL.PRG)
*!               : PLSWAIT        (procedure in RUNOVL.PRG)
*!
*!           Uses: UTIL.DBF
*!
*!        Indexes: &DB
*!*********************************************************************
FUNCTION db_run
PRIVATE dbmode, fld, xfield
PARAMETERS dbmode, fld
xfield = arry1[fld]
DO CASE

CASE dbmode = 0
   RETURN 1

CASE dbmode = 1 .OR. dbmode = 2
   ? CHR(7)
   RETURN 1

CASE dbmode = 3
   ? CHR(7)
   @ 24,10 SAY "No data to edit.  Press any key to RETURN to menu."
   INKEY(0)
   getout = .T.
   RETURN 0

CASE LASTKEY() = 13
   run_scr = Savescreen(0,0,24,79)
   run_clr = Setcolor()
   DO page_run
   Restscreen(0,0,24,79,run_scr)
   Setcolor(run_clr)
   RETURN 1

CASE LASTKEY() = 27
   getout = .T.
   RETURN 0

CASE LASTKEY() = 32                           && SPACE BAR
   IF tag
      REPLACE a->tag WITH .F.
   ELSE
      REPLACE a->tag WITH .T.
   ENDIF
   KEYBOARD CHR(24)
   RETURN 1

CASE LASTKEY() = 20                           && <Ctrl> T
   SET INDEX TO
   REPLACE ALL tag WITH .T.
   SET INDEX TO (db)
   GO TOP
   RETURN 0

CASE LASTKEY() = 21                           && <Ctrl> U
   SET INDEX TO
   REPLACE ALL tag WITH .F.
   SET INDEX TO (db)
   GO TOP
   RETURN 0

CASE LASTKEY() = -2                           && F3 SEEK
   xretv = seek_it()
   RETURN xretv

CASE LASTKEY() = -3                           && F4 PRINT TAGGED RUNS
   xfilter = 'a->tag'
   GO TOP
   SAVE SCREEN
   x_clr = Setcolor()
   which_rpt()                                    && DETAILED OR SHORT REPORT
   Setcolor(x_clr)
   RESTORE SCREEN
   GO TOP
   RETURN 1

CASE LASTKEY() = -4                           && F5 COPY TO LOG
   xlog = SPACE(23)
   x_clr = Setcolor(wbbrbg)
   x_scr = Savescreen(0,0,24,79)
   shdow_bx(10,15,12,65,'d')
   @ 11,17 SAY 'NAME OF LOG TO COPY TO' GET xlog
   SET CURSOR ON
   READ
   SET CURSOR OFF
   IF .NOT. FILE(TRIM(xlog)+'.dbf')
      @ 11,17 CLEAR TO 11,64
      @ 11,17 SAY 'LOG DOES NOT EXIST, CREATE IT'
      @ 11,48 PROMPT 'YES'
      @ 11,52 PROMPT 'NO'
      MENU TO xcopy
      IF xcopy = 1
         COPY TO (xlog) FOR tag
      ENDIF
   ELSE
      USE (xlog)
      APPEND FROM (db) FOR tag
      INDEX ON DATE TO (xlog)
   ENDIF
   use_db()
   Setcolor(x_clr)
   Restscreen(0,0,24,79)
   RETURN 0

CASE LASTKEY() = -5
   SET FILTER TO tag
   GO TOP
   RETURN 0

CASE LASTKEY() = -6                           && F7
   x_clr = Setcolor(wbbrbg)
   x_scr = Savescreen(0,0,24,79)
   shdow_bx(10,30,13,52,'d')
   @ 11,32 SAY 'DELETE THIS RECORD?'
   @ 12,32 PROMPT 'YES'
   @ 12,37 PROMPT 'NO'
   @ 12,41 PROMPT 'ALL TAGGED'
   MENU TO xdel_it
   DO CASE
   CASE xdel_it = 1
      DELETE
      DO plswait
      PACK
   CASE xdel_it = 3
      GO TOP
      DO WHILE .NOT. EOF()
         IF tag
            DELETE
         ENDIF
         SKIP
      ENDDO
      DO plswait
      PACK
   ENDCASE
   Setcolor(x_clr)
   Restscreen(0,0,24,79,x_scr)
   RETURN 0

CASE LASTKEY() = 85 .AND. t > 1               && U
   t = t -1
   B = B -1
   RETURN 0

CASE LASTKEY() = 76 .AND. l > 1               && L
   l = l -1
   R = R -1
   RETURN 0

CASE LASTKEY() = 68 .AND. B < 23              && D
   B = B +1
   t = t +1
   RETURN 0

CASE LASTKEY() = 82 .AND. R < 78              && R
   R = R +1
   l = l +1
   RETURN 0

CASE LASTKEY() = 56 .AND.  t > 1              && 8 UP
   t = t -1
   RETURN 0

CASE LASTKEY() = 52 .AND. l+2 < R             && 4 LEFT
   R = R -1
   RETURN 0

CASE LASTKEY() = 50 .AND. B-2 > t             && 2 BOTTOM
   t = t +1
   RETURN 0

CASE LASTKEY() = 54 .AND. R < 78              && 6 RIGHT
   R = R +1
   RETURN 0

CASE LASTKEY() = ASC('S')                     && SAVE
   @ 24,0 SAY 'SAVING'
   INKEY(1)
   SELECT 3
   USE util
   REPLACE TOP WITH t
   REPLACE LEFT WITH l
   REPLACE BOTTOM WITH B
   REPLACE RIGHT WITH R
   USE
   SELECT 1
   RETURN 0
OTHERWISE
   RETURN 1

ENDCASE

RETURN 0
*!*********************************************************************
*!      Procedure: SEEK_IT
*!
*!      Called by: DB_RUN()       (function  in RUNOVL.PRG)
*!
*!          Calls: SHDOW_BX()     (function  in RUNOVL.PRG)
*!*********************************************************************
FUNCTION seek_it

PRIVATE seek_scr, seek_clr, xretv
xretv = 1
seek_scr = Savescreen(0,0,24,79)
seek_clr = Setcolor(wbbrbg)
shdow_bx(7,31,11,48,'S')
SET FILTER TO
IF TYPE(xfield) = 'N'
   xseek_it = 0
ELSE
   xseek_it = SPACE(10)
ENDIF
@ 7,38 SAY 'SEEK'
@ 9,35 GET xseek_it PICTURE IF(TYPE(xfield)='C'.OR.TYPE(xfield)='D','@!',IF(xfield=='RECNO()','99999999','99999.99'))
SET CURS ON
READ
IF TYPE(xfield) # 'N'
   xseek_it = TRIM(xseek_it)
ENDIF
SET CURS OFF
DO CASE
CASE EMPTY(xseek_it)
   SET FILTER TO
   xretv = 2
CASE xfield == 'RECNO()'
   GOTO xseek_it
CASE xfield == 'DATE'
   SET ORDER TO 1
   SEEK CTOD(xseek_it)
CASE xfield == 'IF(race="Y","RACE","    ")'
   IF xseek_it = 'RACE'
      SET FILTER TO a->race = 'Y'
      GO TOP
      xretv = 2
   ENDIF
   IF xseek_it = 'WORKOUT'
      SET FILTER TO a->race = 'N'
      GO TOP
      xretv = 2
   ENDIF
CASE xfield == 'DISTANCE'
   SET FILTER TO a->distance = xseek_it
   GO TOP
   xretv = 2
CASE xfield == 'DISTANCEK'
   SET FILTER TO a->distancek = xseek_it
   GO TOP
   xretv = 2
OTHERWISE
   xrecno = RECNO()
   IF TYPE(xfield) = 'C'
      LOCATE FOR xseek_it $ UPPER(&xfield) .AND. RECNO() > xrecno
   ELSEIF TYPE(xfield) = 'N'
      LOCATE FOR &xfield = xseek_it .AND. RECNO() > xrecno
   ENDIF
ENDCASE
Setcolor(seek_clr)
Restscreen(0,0,24,79,seek_scr)

RETURN xretv
*!*********************************************************************
*!      Procedure: PAGE_RUN
*!
*!      Called by: DB_RUN()       (function  in RUNOVL.PRG)
*!
*!        Formats: RUN.PRG
*!*********************************************************************
PROCEDURE page_run

SET CURSOR ON
SET FORMAT TO RUN
Setcolor(wbbrbg)
CLEAR
@  3, 4,21,75 BOX "?ƒø?Ÿƒ¿? "
@  0, 2, 3,77 BOX "…Õª?ºÕ»? "
@ 1, 30 SAY "R U N N E R' S  L O G"
@ 4, 17 SAY "MILES:"+SPACE(10)+"KILOMETERS:"+SPACE(10)+"TIME:  :"
@ 6, 6 SAY "1}"+SPACE(9)+"6}"+SPACE(9)+"11}"+SPACE(9)+"16}"+SPACE(9)+"21}"+SPACE(9)+"26}"
@ 7, 6 SAY "2}"+SPACE(9)+"7}"+SPACE(9)+"12}"+SPACE(9)+"17}"+SPACE(9)+"22}"+SPACE(9)+"27}"
@ 8, 6 SAY "3}"+SPACE(9)+"8}"+SPACE(9)+"13}"+SPACE(9)+"18}"+SPACE(9)+"23}"+SPACE(9)+"28}"
@ 9, 6 SAY "4}"+SPACE(9)+"9}"+SPACE(9)+"14}"+SPACE(9)+"19}"+SPACE(9)+"24}"+SPACE(9)+"29}"
@ 10, 6 SAY "5}"+SPACE(8)+"10}"+SPACE(9)+"15}"+SPACE(9)+"20}"+SPACE(9)+"25}"+SPACE(9)+"30}"
@ 12, 8 SAY "AVERAGE PACE PER MILE:"+SPACE(10)+"CALORIES BURNED:"
@ 13, 8 SAY "AVERAGE PACE PER KM:"+SPACE(12)+"WEIGHT:"
@ 15, 37 SAY "NOTES"
@ 23, 11 SAY "<Esc> Exit  <PgUp> Previous Record  <PgDn> Next Record"

BEGIN SEQUENCE
   keypress = 0
   DO WHILE keypress # 27 .AND. keypress # 23
      READ
      keypress = LASTKEY()
      DO CASE
      CASE keypress = 18
         SKIP -1
         IF BOF()
            Tone(294)
         ENDIF
      CASE keypress = 3
         SKIP
         IF EOF()
            SKIP -1
            Tone(294)
         ENDIF
      ENDCASE                                    && CASE KEYPRESS
   ENDDO                                         && KEYPRESS
   SET FORMAT TO
   SET CURSOR OFF
END

RETURN
*!*********************************************************************
*!      Procedure: RUN6
*!
*!      Called by: RUNNER.PRG
*!
*!          Calls: SHDOW_BX()     (function  in RUNOVL.PRG)
*!               : HELP.PRG
*!
*!           Uses: HACKO.DBF
*!               : &LOG
*!               : &DB
*!
*!        Indexes: &DB
*!*********************************************************************
PROCEDURE run6

PRIVATE new_log, xlog, hacko, xfile, xscreen, dbf_count, B, menuchoice
PRIVATE no_dbf_clr, no_dbf_scr, xpath

CLEAR
STORE 1 TO new_log
SET CURSOR ON
Setcolor(wbbrbg)
@ 0,0,24,79 BOX background
Setcolor(wbgwbr)
shdow_bx(9,24,13,56,'S')
@ 10,33 PROMPT "CREATE NEW LOG"
@ 12,33 PROMPT "LOAD NEW LOG"
MENU TO new_log

DO CASE
CASE new_log = 1
   DO WHILE .T.
      Setcolor(wbbrbg)
      @ 0,0,24,79 BOX background
      Setcolor(wbgwbr)
      shdow_bx(10,23,12,59,'S')
      Setcolor(wbgwbr)
      STORE SPACE(8) TO xlog
      @ 11,26 SAY "ENTER NAME FOR NEW LOG" GET xlog
      READ
      IF EMPTY(xlog)
         RETURN
      ENDIF
      STORE TRIM(xlog) TO xlog
      IF FILE(xlog+'.DBF')
         Setcolor(wbrwbg)
         shdow_bx(15,30,17,52,'S')
         @ 16,32 SAY "LOG ALREADY EXISTS"
         Setcolor(wbgwbr)
         INKEY(3)
         LOOP
      ELSE
         EXIT
      ENDIF
   ENDDO
   SELECT 0
   CREATE hacko
   APPEND BLANK
   REPLACE field_name WITH 'DATE', field_type WITH 'D'
   APPEND BLANK
   REPLACE field_name WITH 'WEIGHT', field_type WITH 'N', field_len WITH 3
   APPEND BLANK
   REPLACE field_name WITH 'CALORIE', field_type WITH 'N', field_len WITH 5, field_dec WITH 0
   APPEND BLANK
   REPLACE field_name WITH 'race', field_type WITH 'C', field_len WITH 1
   APPEND BLANK
   REPLACE field_name WITH 'DISTANCE', field_type WITH 'N', field_len WITH 7, field_dec WITH 1
   APPEND BLANK
   REPLACE field_name WITH 'DISTANCEK', field_type WITH 'N', field_len WITH 7, field_dec WITH 1
   APPEND BLANK
   REPLACE field_name WITH 'HOUR', field_type WITH 'N', field_len WITH 1
   APPEND BLANK
   REPLACE field_name WITH 'MINUTES', field_type WITH 'N', field_len WITH 5, field_dec WITH 2
   APPEND BLANK
   REPLACE field_name WITH 'SECTIME', field_type WITH 'N', field_len WITH 5
   APPEND BLANK
   REPLACE field_name WITH 'FIRST', field_type WITH 'N', field_len WITH 5, field_dec WITH 2
   APPEND BLANK
   REPLACE field_name WITH 'SECOND', field_type WITH 'N', field_len WITH 5, field_dec WITH 2
   APPEND BLANK
   REPLACE field_name WITH 'THIRD', field_type WITH 'N', field_len WITH 5, field_dec WITH 2
   APPEND BLANK
   REPLACE field_name WITH 'FOURTH', field_type WITH 'N', field_len WITH 5, field_dec WITH 2
   APPEND BLANK
   REPLACE field_name WITH 'FIFTH', field_type WITH 'N', field_len WITH 5, field_dec WITH 2
   APPEND BLANK
   REPLACE field_name WITH 'SIXTH', field_type WITH 'N', field_len WITH 5, field_dec WITH 2
   APPEND BLANK
   REPLACE field_name WITH 'SEVENTH', field_type WITH 'N', field_len WITH 5, field_dec WITH 2
   APPEND BLANK
   REPLACE field_name WITH 'EIGHTH', field_type WITH 'N', field_len WITH 5, field_dec WITH 2
   APPEND BLANK
   REPLACE field_name WITH 'NINTH', field_type WITH 'N', field_len WITH 5, field_dec WITH 2
   APPEND BLANK
   REPLACE field_name WITH 'TENTH', field_type WITH 'N', field_len WITH 5, field_dec WITH 2
   APPEND BLANK
   REPLACE field_name WITH 'ELEVEN', field_type WITH 'N', field_len WITH 5, field_dec WITH 2
   APPEND BLANK
   REPLACE field_name WITH 'TWELVE', field_type WITH 'N', field_len WITH 5, field_dec WITH 2
   APPEND BLANK
   REPLACE field_name WITH 'THIRTEEN', field_type WITH 'N', field_len WITH 5, field_dec WITH 2
   APPEND BLANK
   REPLACE field_name WITH 'FOURTEEN', field_type WITH 'N', field_len WITH 5, field_dec WITH 2
   APPEND BLANK
   REPLACE field_name WITH 'FIFTEEN', field_type WITH 'N', field_len WITH 5, field_dec WITH 2
   APPEND BLANK
   REPLACE field_name WITH 'SIXTEEN', field_type WITH 'N', field_len WITH 5, field_dec WITH 2
   APPEND BLANK
   REPLACE field_name WITH 'SEVENTEEN', field_type WITH 'N', field_len WITH 5, field_dec WITH 2
   APPEND BLANK
   REPLACE field_name WITH 'EIGHTEEN', field_type WITH 'N', field_len WITH 5, field_dec WITH 2
   APPEND BLANK
   REPLACE field_name WITH 'NINETEEN', field_type WITH 'N', field_len WITH 5, field_dec WITH 2
   APPEND BLANK
   REPLACE field_name WITH 'TWENTY', field_type WITH 'N', field_len WITH 5, field_dec WITH 2
   APPEND BLANK
   REPLACE field_name WITH 'TWENTY1', field_type WITH 'N', field_len WITH 5, field_dec WITH 2
   APPEND BLANK
   REPLACE field_name WITH 'TWENTY2', field_type WITH 'N', field_len WITH 5, field_dec WITH 2
   APPEND BLANK
   REPLACE field_name WITH 'TWENTY3', field_type WITH 'N', field_len WITH 5, field_dec WITH 2
   APPEND BLANK
   REPLACE field_name WITH 'TWENTY4', field_type WITH 'N', field_len WITH 5, field_dec WITH 2
   APPEND BLANK
   REPLACE field_name WITH 'TWENTY5', field_type WITH 'N', field_len WITH 5, field_dec WITH 2
   APPEND BLANK
   REPLACE field_name WITH 'TWENTY6', field_type WITH 'N', field_len WITH 5, field_dec WITH 2
   APPEND BLANK
   REPLACE field_name WITH 'TWENTY7', field_type WITH 'N', field_len WITH 5, field_dec WITH 2
   APPEND BLANK
   REPLACE field_name WITH 'TWENTY8', field_type WITH 'N', field_len WITH 5, field_dec WITH 2
   APPEND BLANK
   REPLACE field_name WITH 'TWENTY9', field_type WITH 'N', field_len WITH 5, field_dec WITH 2
   APPEND BLANK
   REPLACE field_name WITH 'THIRTY', field_type WITH 'N', field_len WITH 5, field_dec WITH 2
   APPEND BLANK
   REPLACE field_name WITH 'AVERAGE', field_type WITH 'N', field_len WITH 5, field_dec WITH 2
   APPEND BLANK
   REPLACE field_name WITH 'AVERAGEK', field_type WITH 'N', field_len WITH 5, field_dec WITH 2
   APPEND BLANK
   REPLACE field_name WITH 'NOTE1', field_type WITH 'C', field_len WITH 64
   APPEND BLANK
   REPLACE field_name WITH 'NOTE2', field_type WITH 'C', field_len WITH 64
   APPEND BLANK
   REPLACE field_name WITH 'NOTE3', field_type WITH 'C', field_len WITH 64
   APPEND BLANK
   REPLACE field_name WITH 'NOTE4', field_type WITH 'C', field_len WITH 64
   APPEND BLANK
   REPLACE field_name WITH 'NOTE5', field_type WITH 'C', field_len WITH 64
   APPEND BLANK
   REPLACE field_name WITH 'TAG', field_type WITH 'L'
   CREATE &xlog FROM hacko
   USE
   DELETE FILE hacko.dbf
   SELECT 1
   db = xlog

CASE new_log = 2
   IF FILE('UTIL.DBF')
      USE util
      xpath = util->directory
   ENDIF
   Setcolor(wbbrbg)
   @ 0,0,24,79 BOX background
   @ 14, 19, 22, 60 BOX "ÚÄ¿³ÙÄÀ³ "
   @ 15, 38 SAY "HELP"
   @ 17, 22 SAY "PRESS ENTER TO USE CURRENT PATH OR"
   @ 18, 22 SAY "ENTER PATH THAT LOGS ARE IN, ie;"
   @ 20, 22 SAY "C:\RUNNER\DATA\"
   Setcolor(wbgwbr)
   shdow_bx(9,10,11,68,'S')
   DO WHILE .T.
      db = xpath
      @ 10,12 SAY "ENTER DIRECTORY TO USE " GET db PICTURE '@K'
      READ
      db = TRIM(db)
      IF LASTKEY() = 27
         RETURN
      ENDIF
      IF .NOT. EMPTY(db) .AND. SUBSTR(db,-1,1) # '\'
         db = db + '\'
      ENDIF
      xfile = db + '*.DBF'
      IF .NOT. FILE(xfile)
         xscreen = Savescreen(15,30,19,53)
         Setcolor(wbrwbg)
         shdow_bx(15,30,18,51,'S')
         @ 16,32 SAY "  PATH NOT FOUND  "
         @ 17,32 SAY " OR NO LOGS FOUND"
         Setcolor(wbgwbr)
         INKEY(3)
         Restscreen(15,30,19,53,xscreen)
         LOOP
      ELSE
         EXIT
      ENDIF
   ENDDO

   IF FILE('UTIL.DBF')
      REPLACE util->directory WITH db
      USE
   ENDIF

   dbf_count = Adir(xfile)
   DECLARE array_dir[dbf_count]
   Adir(xfile,array_dir)
   B = 3 + dbf_count
   IF B > 17
      B = 17
   ENDIF
   Setcolor(wbrwbg)
   shdow_bx(2,61,B,77,'S')
   DO WHILE .T.
      menuchoice = Achoice(3,62,17,76,array_dir,'','')
      IF menuchoice = 0
         IF FILE('RUN.DBF')
            db = 'RUN'
         ELSE
            db = 'WARNING! RUN.DBF NOT FOUND'
         ENDIF
         EXIT
      ELSE
         is_db = TRIM(db) + LEFT(array_dir[menuchoice],AT('.',array_dir[menuchoice])-1)
         USE (is_db)
         IF TYPE('DISTANCE') = 'U'
            no_dbf_clr = Setcolor(grbr)
            no_dbf_scr = Savescreen(10,26,13,55)
            shdow_bx(10,26,12,53,'D')
            @ 11,28 SAY "NOT A RUNNER'S LOG FILE"
            INKEY(3)
            Setcolor(no_dbf_clr)
            Restscreen(10,26,13,55,no_dbf_scr)
         ELSE
            db = is_db
            EXIT
         ENDIF
      ENDIF
   ENDDO
ENDCASE
use_db()

RETURN
** EOF RUNNER.PRG

***********************************************************************
PROCEDURE HEADING

Setcolor(grb)
CLEAR
? "      RECORD     DATE        DISTANCE         TIME          AVERAGE"
? "      NUMBER                              HOURS MINUTES "
?
RETURN
***********************************************************************
PROCEDURE list_runs

SET KEY 27 TO EXIT
BEGIN SEQUENCE
   STORE 0 TO counter, mdistance, msectime, mdistance3
   Setcolor(wbwbr)
   DO WHILE .NOT. EOF()
      IF &xfilter
         REPLACE tag WITH .T.
         IF race = "Y"
            raceyn = "RACE"
         ELSE
            raceyn = ""
         ENDIF
         ? "  ", RECNO(), "   ", DATE, "   ", STR(distance,8,1), "      ", STR(hour),"  ", STR(minutes,5,2), "     ", STR(AVERAGE,5,2),"  ",raceyn
         counter = counter + 1
         IF counter = 18
            counter = 0
            SET PRINT OFF
            SET DEVICE TO SCREEN
            ?
            WAIT
            @ 3,0 CLEAR
            IF PRINT .AND. Isprinter()
               SET PRINT ON
               SET DEVICE TO PRINT
            ENDIF
         ENDIF
         IF sectime # 0                             && DONT AVERAGE IF TIME = 0
            mdistance = mdistance + distance
            msectime = msectime + sectime
         ENDIF
         mdistance3 = mdistance3 + distance
      ENDIF
      SKIP
   ENDDO
   IF msectime # 0
      avgtime = INT((msectime/mdistance)/60)+(((msectime/mdistance)/60)-INT((msectime/mdistance)/60))*.6
   ENDIF
   Setcolor(RB)
   ?
   ? "         TOTAL DISTANCE:    " + STR(mdistance3,8,1) + "         AVERAGE PACE:" + IF(msectime#0,STR(avgtime,8,2),' N/A')
   ?
   xfilter = '.T.'
   Setcolor(wbwbr)
   SET PRINT OFF
   SET DEVICE TO SCREEN
   SET KEY 27 TO
   WAIT
END
SET KEY 27 TO
RETURN
*!*********************************************************************
*!       Function: TORF()
*!
*!      Called by: RUN1           (procedure in RUNOVL.PRG)
*!*********************************************************************
FUNCTION torf

IF .NOT. mrace $ "YN"
   oldcolor = Setcolor(bgb)
   @ 6,25 SAY "IF THIS IS A RACE TYPE Y"
   @ 7,25 SAY "IF THIS IS A WORKOUT TYPE N"
   Setcolor(oldcolor)
   RETURN .F.
ENDIF
@ 6,25 CLEAR TO 7,52

RETURN .T.

*!*********************************************************************
*!       Function: DIST_F()
*!
*!      Called by: RUN1           (procedure in RUNOVL.PRG)
*!*********************************************************************
FUNCTION dist_f

mdistancek = ROUND(mdistance * 1.6093,1)

RETURN .T.
*!*********************************************************************
*!       Function: DIST_F2()
*!
*!      Called by: RUN1           (procedure in RUNOVL.PRG)
*!*********************************************************************
FUNCTION dist_f2

IF mdistance = 0 .AND. mdistancek = 0
   oldcolor = Setcolor()
   Setcolor(bgb)
   @ 6,20 SAY "MILES OR KILOMETERS MUST CONTAIN A NUMBER"
   Setcolor(oldcolor)
   RETURN .F.
ENDIF
mdistance = ROUND(mdistancek * .6215,1)
old_clr = Setcolor(brbg)
@ 4,25 SAY mdistance PICTURE "99999.9"
Setcolor(old_clr)
@ 6,20 SAY SPACE(41)

RETURN .T.
*!*********************************************************************
*!       Function: CALC_UPD()
*!
*!      Called by: RUN           (procedure in RUNOVL.PRG)
*!*********************************************************************
FUNCTION calc_upd

IF Readvar() == 'DISTANCE'
   REPLACE distancek WITH ROUND(distance * 1.6093,1)
ENDIF
IF Readvar() == 'DISTANCEK'
   REPLACE distance WITH ROUND(distancek * .6215,1)
ENDIF

IF distance # 0
   **** DO CALCULATIONS FOR MILES ****
   caltime = hour*60 + INT(minutes)+(((minutes-INT(minutes))/60)*100)                 && FOR CALORIES BURNED
   ttime = ((hour * 3600)+INT(minutes)*60)+(minutes-INT(minutes))*100
   maver = (ttime/distance)/60                    && TOTAL TIME DIVIDE BY DISTANCE IN SECONDS
   tottime = (maver - INT(maver))*.6              && CONVERT SECONDS TO TIME FORMAT
   REPLACE AVERAGE WITH INT(maver)+tottime        && THE AVERAGE TIME IN CORRECT TIME FORMAT
   IF caltime # 0                                 && TO CALC MPH
      TIME = ttime/60
   ENDIF

   **** DO CALCULATIONS FOR KMS ****
   maver = (ttime/distancek)/60                   && TOTAL TIME DIVIDE BY DISTANCE IN SECONDS
   tottime = (maver - INT(maver))*.6              && CONVERT SECONDS TO TIME FORMAT
   REPLACE averagek WITH INT(maver)+tottime        && THE AVERAGE TIME IN CORRECT TIME FORMAT

   **** DO CALULATIONS FOR CALORIES ****
   IF weight # 0
      IF AVERAGE <= 6
         mcalorie = caltime*weight*.114
      ENDIF
      IF AVERAGE <= 8.3 .AND. AVERAGE > 6
         mcalorie = caltime*weight*.102
      ENDIF
      IF AVERAGE < 11 .AND. AVERAGE > 7
         mcalorie = caltime*weight*.090
      ENDIF
      IF AVERAGE >= 11
         mcalorie = caltime*weight*.070
      ENDIF
   ELSE
      mcalorie = 0
   ENDIF
   REPLACE calorie WITH mcalorie

   *** DISPLAY NEW VALUES ***
   old_clr = Setcolor(brbg)

   @  4,24 SAY distance  PICTURE '99999.9'
   @  4,45 SAY distancek PICTURE '99999.9'
   @ 12,31 SAY AVERAGE   PICTURE '99.99'
   @ 12,57 SAY calorie   PICTURE '99999'
   @ 13,31 SAY averagek  PICTURE '99.99'

   Setcolor(old_clr)
ENDIF

RETURN .T.
*!*********************************************************************
*!       Function: VAL_TIME()
*!
*!      Called by: RUN1           (procedure in RUNOVL.PRG)
*!*********************************************************************
FUNCTION val_time

IF ROUND(INT(mminutes),0) > 59 .OR. ROUND(mminutes - INT(mminutes),2) > .59
   oldcolor = Setcolor()
   Setcolor(bgb)
   @ 6,25 SAY "NOT A VALID TIME, PLEASE REENTER"
   Setcolor(oldcolor)
   RETURN .F.
ENDIF
@ 6,25 SAY SPACE(33)

RETURN .T.
*!*********************************************************************
*!       Function: USE_DB()
*!
*!          Calls: SHDOW_BX()     (function  in RUNOVL.PRG)
*!
*!           Uses: &DB
*!        Indexes: &DB
*!*********************************************************************
FUNCTION use_db

PRIV xret_val
xret_val = .F.
IF .NOT. FILE(db+'.DBF')
   CREATE IT
ENDIF
SELECT 1
USE (db)
IF FILE(db+'.NTX')
   SET INDEX TO (db)
ELSE
   INDEX ON DATE TO (db)
   SET INDEX TO (db)
ENDIF
xret_val = .T.

RETURN xret_val
**********************************************************
FUNCTION which_rpt

PRIVATE old_clr,rpt_type
old_clr=Setcolor(wbgwbr)
BEGIN SEQUENCE
   shdow_bx(10,18,12,62,'S')
   @ 11,20 SAY "DO YOU WANT            OR         REPORT?"
   @ ROW(),COL()-28 PROMPT 'DETAILED'
   @ ROW(),COL()+6 PROMPT 'SHORT'
   MENU TO rpt_type
   IF LASTKEY() # 27
      PRINT = PRINT()
   ELSE
      BREAK
   ENDIF
   DO CASE
   CASE rpt_type=1
      DO detail
   CASE rpt_type=2
      DO HEADING
      DO list_runs
   ENDCASE
   Setcolor(old_clr)
END
RETURN .T.
*: EOF: RUNOVL.PRG