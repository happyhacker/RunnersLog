*...................................................................*
* Revision: 1.0 Modified on : 09/02/90 21:51:58
* Description: Original Creation
*...................................................................*
* Revision: 4.0 BETA Last Revised: 09/19/90 at 21:20:09
* Description: Removed nvfgrp and hard coded to 2.
*...................................................................*
* Revision:  Last Revised: 10/11/90 at 01:17:19
* Description: Fixed bug - graphed half of reccount() only
*...................................................................*
* Revision:  Last Revised: 10/11/90 at 01:18:06
* Description: Added prompts for title and miles or kilometers, changed
*              box.dbf to util.dbf and added fields for title, font, & miles
*              or kilometers.
*...................................................................*
* Revision: 4.2 Last Revised: 10/28/90 at 18:29:26
* Description: Added cga support for graphics
*...................................................................*
* Revision: 4.22 Last Revised: 11/16/90 at 00:01:25
* Description: Fixed problem with PRINT when you tried to exit and mouse
* cursor was on PRINT icon
*...................................................................*
* Revision: 4.3 Modified on : 04-20-91 06:08:05pm
* Description:Changed legend 'AVERAGE' to 'AVERAGE PACE'
*...................................................................*
* Revision: 4.4 Modified on : 08-23-91 00:26:59am
* Description:Changed ?? tone() + tone() to two lines/ worked in 87
*             crashes in 5.01
*========================[ ALL RIGHTS RESERVED ]====================*
IF .NOT. use_db()
   RETURN
ENDIF

PRIVATE driverid, hackgraph, mork
IF .NOT. INIT_OK()
   RETURN
ENDIF

DO WHILE .T.
   SETCOLOR(wbbrbg)
   @ 0,0,24,79 BOX background
   SETCOLOR(wbgwbr)
   SHDOW_BX(10,22,12,58,'S')
   @ 11,24 PROMPT 'LINE'
   @ 11,30 PROMPT 'BAR/LINE'
   @ 11,40 PROMPT 'CONFIGURE'
   @ 11,51 SAY 'GRAPH'
   MENU TO hackgraph

   DO CASE
      CASE hackgraph = 0
         RETURN
      CASE hackgraph = 1 .OR. hackgraph = 2
         EXIT
      CASE hackgraph = 3
         IF FILE('UTIL.DBF')
            SELECT 3
            USE UTIL
            SETCOLOR(wbgwbr)
            SHDOW_BX(3,24,7,56,'D')
            @ 4, 27 SAY "TITLE:"
            @ 6, 27 SAY "USE  : MILES  KILOMETERS"
            @ 4, 34 GET GSTRING
            SET CURSOR ON
            READ
            SET CURSOR OFF
            @ 6,34 PROMPT 'MILES'
            @ 6,41 PROMPT 'KILOMETERS'
            MENU TO M->mork
            IF M->mork = 2
               REPLACE util->mork WITH 'KILO'
            ELSE
               REPLACE util->mork WITH 'MILE'
            ENDIF
         ELSE
            SHDOW_BX(3,24,7,56,'D')
            @ 4,29 SAY 'Util.dbf not available'
            INKEY(2)
         ENDIF
   ENDCASE
ENDDO
IF FILE('UTIL.DBF')
   SELECT 3
   USE UTIL
   M->gstring = TRIM(UTIL->gstring)
   M->gstrfont = TRIM(UTIL->gstrfont)
   M->mork = UTIL->mork
   USE
   SELECT 1
ELSE
   M->gstring = "RUNNER'S LOG CHART"
   M->gstrfont = "RMN2828.STX"
   M->mork = 'MILE'
ENDIF

SET CONS OFF
DO RUNNER_S
SET CONS ON

SET FILTER TO
GO TOP
MCUROFF()
RETURN

*********************************************************************************
FUNCTION init_ok

driverid = GETVIDEO(0)

IF .NOT. (driverid >=3 .AND. driverid <=7)
   @ 24,0 say ' Graphic driver ' + STR(driverid) + ' not loaded. Aborting'
   INKEY(0)
   RETURN .F.
ENDIF

RETURN .T.
*********************************************************************************
PROCEDURE RUNNER_S

SET FILTER TO TAG = .T.
np_maxx = reccount()*2
if np_maxx > 767*2
   np_maxx = 767*2
ENDIF

* MAKE AN ARRAY TO SEQUENTIAL BUFFERING VALUES OF
* DATABASE AND GROUP DEFINITIONS
* ---------------------------------------------
DECLARE AGROUP[2]
DECLARE ANYVAL[np_maxx]
DECLARE ALEGCOL[2]

PRIVATE I,J,X, nanylen, II
PRIVATE xrecno, CP_LBX, LFIXYAXE

I = 0
II = 0
xrecno = 'STR(RECNO())'
CP_LBX = ''

IF M->mork = 'MILE'
   AGROUP[1] = 'DISTANCE'
   AGROUP[2] = 'AVERAGE'
ELSE
   AGROUP[1] = 'DISTANCEK'
   AGROUP[2] = 'AVERAGEK'
ENDIF

? 'GRAPHIC RECALCULATION IN PROGRESS, PLEASE WAIT ...'
GO TOP
DO WHILE .NOT. EOF()
   * IS MAXIMUM OF X-POINTS ESTABLISHED ?
   IF I + 1 < np_maxx
      cp_lbx = cp_lbx + SUBSTR(&xrecno + SPACE(20), 1, 20)
      FOR j = 1 TO 2
         x = AGROUP[J]
         i = i + 1
         ANYVAL[i] = &x
      NEXT
      SKIP
   ELSE
      EXIT
   ENDIF
ENDDO

nanylen = i
IF nanylen = 0
   @ 24, 0 SAY 'THERE IS NO DATA MATCHING THE QUERY-LIST !'
   INKEY(2)
   USE
   RETURN
ENDIF
PRIVATE NYMAXVAL, NYMINVAL
NYMAXVAL = 0.000000001
NYMINVAL = 9999999999
I = 1
DO WHILE I <= nanylen
   * SCAN FOR THE MAXIMUM VALUE OF DATES IN THE ARRAY
   * MAXIMUM LOOKUP
   * ---------------------------------------------
   X = 0
   FOR J = 1 TO 2
      IF ANYVAL[I+J-1] > NYMAXVAL
         NYMAXVAL = ANYVAL[I+J-1]
      ENDIF
   NEXT
   * SCAN FOR THE MINIMUM VALUE OF DATES IN THE ARRAY
   X = 0
   FOR J = 1 TO 2
      IF ANYVAL[I+J-1] < NYMINVAL
         NYMINVAL = ANYVAL[I+J-1]
      ENDIF
   NEXT
   I = I + 2
ENDDO
* HIGH RESOLUTION SWITCHING
* ---------------------------------------------
SETVIDEO(driverid)
SETHIRES(0)
CLRSCREEN()
SETPAL(0, 0, 0)

* DRAW TITLE AND HEADER OF CHART ON SCREEN
* ---------------------------------------------
LOADCSET(0,'DGE1108.STX')

UP_BUTTON(100,934)
SAYSTRING(118,947,0+32,0,0,'PRINT')
DRAWLINE(116,947,127,947,3,0,0)
DRAWLINE(116,946,127,946,3,0,0)

UP_BUTTON(300,934)
SAYSTRING(324,947,0+32,0,0,'EXIT')
DRAWLINE(341,947,353,947,3,0,0)
DRAWLINE(341,946,353,946,3,0,0)


* =========08-23-91 00:21:15am
*IF driverid = 4
*   M->gstrfont = 'dge1108.stx'                   && IF CGA, USE SMALLER FONT
*ENDIF
* =========08-23-91 00:21:15am

LOADCSET(0,M->gstrfont)                          &&load defined char-set
SAYSTRING(675, 815, 0, 0+8, 5, M->gstring)       &&give out string on defined position

* SCALE THE VALUES TO THE VIRTUAL SCREEN
* ---------------------------------------------
PRIVATE NYAMPLID, NYFACTOR, NYPOSOFX, NPIXVAL
IF NYMINVAL < 0
   LFIXYAXE = .T.
   IF NYMAXVAL > ABS(NYMINVAL)
      NYAMPLID = NYMAXVAL * 2
      NYPOSOFX = NYMAXVAL
   ELSE
      NYAMPLID = ABS(NYMINVAL) * 2
      NYPOSOFX = ABS(NYMINVAL)
   ENDIF
ELSE
   LFIXYAXE = .F.
   NYAMPLID = NYMAXVAL
   NYPOSOFX = 0
ENDIF
NXPIX = 1122
NYPIX = 580
NYFACTOR = NYPIX / NYAMPLID

NYPOSOFX = NYFACTOR * NYPOSOFX
PRIVATE NXINCREM
NXINCREM = INT(NXPIX / INT(nanylen /2))
NXPIX = NXINCREM * INT(nanylen /2)

PRIVATE NCOLCONT, NCHNGGRP, NSHDCONT
NSHDCONT =1
NCOLCONT = 0
NCHNGGRP = 1

DATARESET()                                      &&reset dGE-array

* LABELS OF CHART TAKEN OF FIELDNAMES
* ---------------------------------------------
PRIVATE NCSHI, NCSWI, CL_LBX
LOADCSET(0, 'DGE0906.STX')
NCSWI = INT(GETFONTINF(0))
IF NCSWI = 0
   NCSWI = 1
ENDIF
NCSHI = INT(GETFONTINF(1))
IF NCSHI = 0
   NCSHI = 1
ENDIF

PRIVATE NYHISAV, NYHIGH
IF NYMAXVAL > ABS(NYMINVAL)
   NYHIGH = NYMAXVAL * NYFACTOR
ELSE
   NYHIGH = ABS(NYMINVAL) * NYFACTOR
ENDIF
NYHISAV = NYHIGH
IF NYMINVAL < 0
   NP_AXART = 1
   NFACHORI = 2
ELSE
   NP_AXART = 0
   NFACHORI = 1
ENDIF
PRIVATE NXAXPART, NYAXPART
NXAXPART = 0
CL_LBY = ''
CL_LBX = ''
NYDIGS = 1
NXDIGS = 1
NYLBOUT = NCSWI * (NYDIGS + 3)
NXLBOUT = NCSHI * 5
PRIVATE NHEIGSCR
NHEIGSCR = NYPIX
* LABELLING OF Y-AXES
* ---------------------------------------------
PRIVATE NMAX, NMIN, LPORTR, LSCRHALF, NSCRHIGH
NMAX = NYMAXVAL
NMIN = NYMINVAL
LPORTR = .T.
IF LFIXYAXE
   LSCRHALF = .T.
ELSE
   LSCRHALF = .F.
ENDIF
NSCRHIGH = NHEIGSCR
SET DECIMALS TO 10
IF NMIN < 0
   LNEG = .T.
   NSCRHIGH = NSCRHIGH/2
ELSE
   LNEG = .F.
   IF LSCRHALF = .T.
      NSCRHIGH = NSCRHIGH/2
   ENDIF
ENDIF
NMAX = MAX(ABS(NMAX),ABS(NMIN))

IF NMAX <> 0
   PRIVATE NSCRUNI
   NSCRUNI = NSCRHIGH/NMAX
   PRIVATE NMULT, NDECI, NPARM
   NMULT = 0
   NPARM = NMAX
   nDeci = notnul(nParm,'L')

   IF AT('.',LTRIM(RTRIM(STR(NMAX)))) < NDECI
      NMULT = AT('.',LTRIM(RTRIM(STR(NMAX))))
      NPARM = NMAX
      nDeci = notnul(nParm,'L') - nMult
   ENDIF

   NMULT = NMULT + 1
   NMAX = NMAX * 10 ^ NMULT
   NYHIGH = NMAX

   IF NSCRHIGH < 100
      NYAXPART = 1
   ELSE
      IF LPORTR = .T.
         DO CASE
            CASE NCSHI <= 10
               NYAXPART = INT(((NYHIGH/(10 ^ NMULT)) * NSCRUNI)/(3 * NCSHI))
            CASE NCSHI > 10 .AND. NCSHI <= 15
               NYAXPART = INT(((NYHIGH/(10 ^ NMULT)) * NSCRUNI)/(2.5 * NCSHI))
            CASE NCSHI > 15 .AND. NCSHI <= 20
               NYAXPART = INT(((NYHIGH/(10 ^ NMULT)) * NSCRUNI)/(2 * NCSHI))
            CASE NCSHI > 20
               NYAXPART = INT(((NYHIGH/(10 ^ NMULT)) * NSCRUNI)/(1.5 * NCSHI))
         ENDCASE
      ELSE
         NYAXPART = INT(((NYHIGH/(10 ^ NMULT)) * NSCRUNI)/(5 * NCSWI))
      ENDIF
      NYP = NYAXPART
      PRIVATE C1, C2, T, LEX
      C1 = 0
      T = LEN(LTRIM(RTRIM(STR(INT(NYHIGH)))))

      DO WHILE .T.
         NYAXPART = NYP
         LEX = .F.
         C2 = 0

         DO WHILE C2 < 10
            IF    ROUND(NYHIGH/NYAXPART,6) =        10 ^ (T-2) ;
               .OR. ROUND(NYHIGH/NYAXPART,6) = 2.00 * 10 ^ (T-2) ;
               .OR. ROUND(NYHIGH/NYAXPART,6) = 2.50 * 10 ^ (T-2) ;
               .OR. ROUND(NYHIGH/NYAXPART,6) = 5.00 * 10 ^ (T-2) ;
               .OR. ROUND(NYHIGH/NYAXPART,6) = 10.0 * 10 ^ (T - 2)
               LEX = .T.
               EXIT
            ENDIF
            NYAXPART = NYAXPART - 1
            IF NYAXPART = 0
               NYAXPART = 1
               EXIT
            ENDIF
            C2 = C2+1
         ENDDO

         DO CASE
            CASE C1 < 5 .AND. LEX = .F.
               IF C1 = 0
                  NYHIGH = NYHIGH + (0.5 * 10 ^ (T - 2))
                  NYHIGH = ROUND(NYHIGH,(-1) * (T - 2))
               ENDIF

               IF C1 > 0 .AND. C1 < 4
                  IF VAL(SUBSTR(LTRIM(RTRIM(STR(NYHIGH))),2,2)) >= 75
                     NYHIGH = NYHIGH + (0.5 * 10 ^ (T - 1))
                     NYHIGH = ROUND(NYHIGH,(-1) * (T - 1))
                     T = LEN(LTRIM(RTRIM(STR(INT(NYHIGH)))))
                  ENDIF
                  IF VAL(SUBSTR(LTRIM(RTRIM(STR(NYHIGH))),2,2)) < 75;
                     .AND. VAL(SUBSTR(LTRIM(RTRIM(STR(NYHIGH))),2,2)) >= 50
                     NYHIGH = VAL(SUBSTR(LTRIM(RTRIM(STR(NYHIGH))),1,1)) * (10 ^(T - 1))
                     NYHIGH = NYHIGH + (0.75 * (10 ^ (T - 1)))
                  ENDIF
                  IF VAL(SUBSTR(LTRIM(RTRIM(STR(NYHIGH))),2,2)) < 50;
                     .AND. VAL(SUBSTR(LTRIM(RTRIM(STR(NYHIGH))),2,2)) >= 25
                     NYHIGH = VAL(SUBSTR(LTRIM(RTRIM(STR(NYHIGH))),1,1)) * (10 ^(T - 1))
                     NYHIGH = NYHIGH + (0.5 * (10 ^ (T - 1)))
                  ENDIF
                  IF VAL(SUBSTR(LTRIM(RTRIM(STR(NYHIGH))),2,2)) < 25;
                     .AND. VAL(SUBSTR(LTRIM(RTRIM(STR(NYHIGH))),2,2)) >= 0
                     NYHIGH = VAL(SUBSTR(LTRIM(RTRIM(STR(NYHIGH))),1,1)) * (10 ^(T - 1))
                     NYHIGH = NYHIGH + (0.25 * (10 ^ (T - 1)))
                  ENDIF
               ENDIF

               IF C1 = 4
                  NYHIGH = NYHIGH + (0.5 * 10 ^ (T - 1))
                  NYHIGH = ROUND(NYHIGH,(-1) * (T - 1))
                  T = LEN(LTRIM(RTRIM(STR(INT(NYHIGH)))))
               ENDIF
               C1 = C1 + 1
               LOOP

            CASE C1 = 5 .AND. LEX = .F.
               NYAXPART = 1
               EXIT

            CASE C1 = 5 .AND. LEX = .T.
               EXIT

            CASE C1 < 5 .AND. LEX = .T.
               EXIT

         ENDCASE
      ENDDO
   ENDIF
   NYAXPART = INT(NYAXPART)
   PRIVATE LL_LBY
   LL_LBY = .T.
   IF NYAXPART = 1
      NYAXPART = 10
      LL_LBY = .F.
   ENDIF
   IF NMULT > 0
      NYHIGH = NYHIGH/(10 ^ NMULT)
      NMAX = NMAX/(10 ^ NMULT)
   ENDIF
   PRIVATE NYLEN
   NYLEN = NYHIGH/NYAXPART

   IF LPORTR = .F.
      DO WHILE NYLEN < 1.0
         SET DECIMALS TO 1
         NYLEN = NYLEN * 10
      ENDDO
      DO WHILE NYLEN > 50
         SET DECIMALS TO 0
         NYLEN = NYLEN/10
      ENDDO
   ELSE
      IF NYLEN >= 10
         SET DECIMALS TO 0
      ELSE
         NDECI = NPARM
         ndeci = notnul(nParm,'L')
         IF AT('.',LTRIM(RTRIM(STR(NYLEN)))) > NDECI
            SET DECIMALS TO 0
         ELSE
            NDECI = NPARM
            nDeci = notnul(nParm,'L') - at('.',ltrim(rtrim(str(nYlen))))
            SET DECIMALS TO NDECI
         ENDIF
      ENDIF
   ENDIF

   NYLEN = NYLEN/1
   NYDIGS = LEN(LTRIM(RTRIM(STR(NYLEN * NYAXPART))))
   IF LNEG = .T.
      NYDIGS = NYDIGS + 1
   ENDIF

   IF LL_LBY = .T.
      PRIVATE N, I
      CL_LBY = REPLICATE(' ',INT((NYDIGS)/2)) + '0' + REPLICATE(' ',INT((NYDIGS - 1)/2))
      CL_LBY = SUBSTR(CL_LBY,1,NYDIGS)
      N = NYLEN
      I = 0

      DO WHILE I < NYAXPART
         IF LEN(LTRIM(RTRIM(STR(INT(N))))) < NYDIGS
            IF LNEG = .T.
               CL_LBY = REPLICATE( ' ', NYDIGS - LEN( LTRIM( RTRIM( STR( N )))) - 1) + '-' + LTRIM( RTRIM( STR( N ))) + CL_LBY + REPLICATE(' ',NYDIGS - LEN( LTRIM( RTRIM( STR( N))))) + LTRIM( RTRIM( STR( N ) ) )
            ELSE
               CL_LBY = CL_LBY + REPLICATE(' ',NYDIGS - LEN(LTRIM(RTRIM(STR(N))))) + LTRIM(RTRIM(STR(N)))
            ENDIF
         ELSE
            IF LNEG = .T.
               CL_LBY = LTRIM(RTRIM(STR(N))) + '-' + CL_LBY + ' ' + LTRIM(RTRIM(STR(N)))
            ELSE
               CL_LBY = CL_LBY + LTRIM(RTRIM(STR(N)))
            ENDIF
         ENDIF
         N = N + NYLEN
         I = I + 1
      ENDDO
   ELSE
      CL_LBY = ''
   ENDIF
   NYHIGH = NYHIGH * NSCRUNI
ENDIF
SET DECIMALS TO 10

* DRAW THE X-Y-AXES WITH THE SELECTED GRID
* ---------------------------------------------
XYAXES(115, 135 + NYPOSOFX, NXPIX, NYHIGH, NXAXPART, NYAXPART, NP_AXART + 68, 15)

* CALCULATE LENGTH AND POSITION OF LABELS
* ---------------------------------------------
NXDIGS = INT(NXINCREM / NCSWI)
NXDIGS = NXDIGS * 2
IF NXDIGS * INT(LEN(CP_LBX) / 20) > 255
   NXDIGS = INT( 255 / LEN(CP_LBX) / 20)
ENDIF
IF NXDIGS > 20
   NXDIGS = 20
ENDIF
CL_LBX = ''
I = 1
DO WHILE I <= LEN(CP_LBX)
   CL_LBX = CL_LBX + SUBSTR( CP_LBX, I, NXDIGS )
   I = I + 20
ENDDO
PRIVATE NYSTOUTY, NYSTOUTX,NLABBEG, NYOUT
NLABBEG = 0
NYSTOUTX = IIF(LFIXYAXE, (1.5 * NCSHI) + (NYHIGH - NYHISAV), 1.5 * NCSHI )
NYSTOUTY = IIF(LFIXYAXE, (0.5 * NCSHI) + (NYHIGH - NYHISAV), 0.5 * NCSHI )
NYOUT = 0
NYLBOUT = NCSWI * (NYDIGS + 2)
NYOUT =  NYLBOUT
NLABBEG = IIF( NYLBOUT < 115, 115 - NYLBOUT, NXPIX + 115+ 2*NCSWI )
IF NYPIX >= 300
   LABELY(NLABBEG, 135 - NYSTOUTY , NYHIGH / NYAXPART, NYDIGS, 0, 2, 0, CL_LBY)
ENDIF
* DRAW THE CHART ON-SCREEN
* ---------------------------------------------

* * DRAW LINES
* ---------------------------------------------

FOR i = 1 TO 2
   DATARESET()
   j = i
   DO WHILE j <= nanylen
      NPIXVAL = NYFACTOR * ANYVAL[j]
      IF HACKGRAPH = 1
         DATASTORE(NPIXVAL, 0, 0,0)
      ELSE
         IF I = 1
            DATASTORE(NPIXVAL, 1, 0,11)
         ELSE
            DATASTORE(NPIXVAL, 2, 0,13)
         ENDIF
      ENDIF
      ALEGCOL[i] = 0
      J = J + 2
   ENDDO
   IF I = 1
      xcolor = 11
   ELSE
      xcolor = 13
   ENDIF
   IF HACKGRAPH = 1
      XYGRAPH(115,135 + NYPOSOFX, NXINCREM, 0, xcolor)
   ELSE
      IF I = 1
         BARGRAPH(115,135 + NYPOSOFX,NXINCREM,0+16,1)
      ELSE
         XYGRAPH(115,135 + NYPOSOFX, NXINCREM, 0, xcolor)
      ENDIF
   ENDIF
   IF I <= 2
      ALEGCOL[I] = STR(ALEGCOL[I]) + ',' + '0' + ',' + STR(11 + I)
   ENDIF
NEXT

* BUILDING UP THE LEGEND'S TEXTS AND COLORS
* ---------------------------------------------
PRIVATE  KK , NPOS1 , NPOS2 , NICON, NLEGSHAD, NLEGCOL, NLEGWID, NLEGHIG
LOADCSET(0,'DGE1108.STX')
NLEGWID = GETFONTINF(0)
NLEGHIG = GETFONTINF(1)
KK = 1
DO  WHILE KK <= 2
   II = 1
   DO WHILE II <= 2
      NPOS1 = AT(',' , ALEGCOL[KK])
      NLEGSHAD = VAL(RTRIM(LTRIM(SUBSTR(ALEGCOL[KK], NPOS1 + 1, LEN(ALEGCOL[KK])))))
      NXINC = IIF(II = 1 , 0 , (II-1)  * 4 * NLEGWID)
      NPOS2 = AT(',', SUBSTR(ALEGCOL[KK], NPOS1 ))
      NICON = VAL(SUBSTR(ALEGCOL[KK] , 1, NPOS1 - 1))
      NLNTYP = VAL(SUBSTR(ALEGCOL[KK] , NPOS1 + 1 , NPOS2 - 1))
      IF II = 1
         NLEGCOL = 11
      ELSE
         NLEGCOL = 13
      ENDIF
      DRAWLINE(165,65,205,65,0,0,11)
      DRAWLINE(390,65,430,65,0,1,13)
      IF HACKGRAPH = 2
         BOXFILL(165,48,40,40,1,11)
      ENDIF
      SAYSTRING(125,1,0,0,14,'DISTANCE   AVERAGE PACE')
      IF KK = 2
         KK = KK + 1
         EXIT
      ENDIF
      KK = KK + 1
      II = II + 1
   ENDDO
ENDDO
* WAITING FOR KEYPRESS [P] TO PRINT IF OUTPUT IMAGE IS SELECTED
* ---------------------------------------------
MRESET()
MSETWIN(25,902,500,1000)                         && SET MOUSE WINDOW OVER BUTTONS
MCURON()                                         && TURN MOUSE ON
MFIXPOS(125,942)                                 && SET MOUSE OVER PRINT BUTTON
MSETHOT(1,100,936,115,64)
MSETHOT(2,300,936,115,64)
DO WHILE .T.
   DO WHILE MSTATUS() = 0
      NKEY = INKEY(.1)
      IF NKEY = ASC('P') .OR. nkey = ASC('p') .OR. nkey = ASC('X') .OR.;
         nkey = ASC('x') .OR. nkey = 281 .OR. nkey = 27
         EXIT
      ENDIF
   ENDDO
   mstatus = MSTATUS()
   mregion = MGETHOT()
   IF mregion = 1 .AND. nkey # 27 .AND. nkey # ASC('X') .AND. nkey # ASC('x')
      NKEY = ASC('P')
   ENDIF
   IF mregion = 2
      NKEY = 27
   ENDIF

   DO CASE

      CASE NKEY = ASC('P') .OR. NKEY = ASC('p')
         LOADCSET(0,'DGE1108.STX')
         DN_BUTTON(100,934)
         SAYSTRING(122,944,0+32,0,0,'PRINT')
         DRAWLINE(120,945,131,945,3,0,0)
         DRAWLINE(120,944,131,944,3,0,0)
         PICWRITE(0, 0, 1350, 900, 0,'RUN.PCX')
         TONE(550,4)
         TONE(750,2)
         UP_BUTTON(100,934)
         SAYSTRING(118,947,0+32,0,0,'PRINT')
         DRAWLINE(116,947,127,947,3,0,0)
         DRAWLINE(116,946,127,946,3,0,0)

      CASE nkey = 281
         loadmprn( 1 ,'MPRN.DAT EPSON FX')   && load selected printer data from MPRN.DAT
         printscrn()   && print on a matrix printer

      CASE nkey = 27 .OR. nkey = ASC('X') .OR. nkey = ASC('x')
         EXIT

   ENDCASE
   KEYBOARD CHR(0)
ENDDO

* SWITCHING TO TEXT MODE
* ---------------------------------------------
CLRSCREEN()
SETTEXT()
USE
RETURN

***********************************************
FUNCTION NOTNUL

PARAMETER N, CFL
PRIVATE NPOS
if upper(cFl) = 'F'
   NPOS = 1
   DO WHILE NPOS <= LEN(LTRIM(RTRIM(STR(N))))
      IF VAL(SUBSTR(LTRIM(RTRIM(STR(N))),NPOS,1)) <> 0
         EXIT
      ENDIF
      NPOS = NPOS + 1
   ENDDO
ENDIF
if upper(cFl) = 'L'
   NPOS = LEN(LTRIM(RTRIM(STR(N))))
   DO WHILE NPOS >= 1
      IF VAL(SUBSTR(LTRIM(RTRIM(STR(N))),NPOS,1)) <> 0
         EXIT
      ENDIF
      NPOS = NPOS - 1
   ENDDO
ENDIF
RETURN NPOS

*****************************************************************************
FUNCTION UP_BUTTON
PRIVATE x,y
PARA x,y

BOXFILL(x,y,115,55,0,7)

DRAWLINE(x+3,y+53,x+113,y+53,3,0,0)
DRAWLINE(  0,  0,x+113,y+2,3+16,0,0)
DRAWLINE(  0,  0,x+3,y+2,3+16,0,0)
DRAWLINE(  0,  0,x+3,y+53,3+16,0,0)

DRAWLINE(x+8,y+7,x+111,y+7,0,0,8)                && BOTTOM GREY
DRAWLINE(x+7,y+5,x+111,y+5,0,0,8)

DRAWLINE(x+109,y+6,x+109,y+51,0,0,8)             && RIGHT GREY
DRAWLINE(x+111,y+6,x+111,y+52,0,0,8)
*------------------------------*
DRAWLINE(x+8,y+50,x+109,y+50,0,0,15)             && TOP WHITE
DRAWLINE(x+8,y+48,x+107,y+48,0,0,15)

DRAWLINE(x+5,y+6,x+5,y+51,0,0,15)                && LEFT WHITE
DRAWLINE(x+7,y+8,x+7,y+51,0,0,15)

RETURN .T.

*****************************************************************************
FUNCTION DN_BUTTON
PRIVATE x,y
PARA x,y

BOXFILL(x,y,115,55,0,7)

DRAWLINE(x+3,y+53,x+113,y+53,3,0,0)
DRAWLINE(  0,  0,x+113,y+2,3+16,0,0)
DRAWLINE(  0,  0,x+3,y+2,3+16,0,0)
DRAWLINE(  0,  0,x+3,y+53,3+16,0,0)

DRAWLINE(x+8,y+7,x+111,y+7,0,0,7)                && BOTTOM GREY
DRAWLINE(x+7,y+5,x+111,y+5,0,0,7)

DRAWLINE(x+109,y+6,x+109,y+51,0,0,7)             && RIGHT GREY
DRAWLINE(x+111,y+6,x+111,y+52,0,0,7)
*------------------------------*
DRAWLINE(x+8,y+50,x+109,y+50,0,0,8)              && TOP DARK GREY
DRAWLINE(x+8,y+48,x+107,y+48,0,0,8)

DRAWLINE(x+5,y+6,x+5,y+51,0,0,8)                 && LEFT DARK GREY
DRAWLINE(x+6,y+8,x+6,y+51,0,0,8)

RETURN .T.