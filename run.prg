*============================{ RUN.PRG }=====================================
* Copyright (c) 1991 Hacksoft Inc.
*............................................................................*
* Revision: 0000 Modified on : 01-28-90 10:38:00pm
* Description: Orignal creation
*............................................................................*
* Revision: 3.5 Last Revised: 1/28/1990 at 22:38
* Description:
*............................................................................*
* Revision: 4.3 Last Revised: 3/22/1990 at 21:28
* Description: Snapped system
*............................................................................*
* Revision: 4.4 Modified on : 08-22-91 11:15:56pm
* Description:Removed items that don't change so it doesn't redraw the screen
*             when you <PgUp> or <PgDn>
*............................................................................*
* Revision: 5.2 Modified on : 04-30-2020 10:15am
* Description:Changed miles and km from 1 to 2 decimal places

***************************** ALL RIGHTS RESERVED ****************************
@ 2, 5 SAY "Record #:"+SPACE(18)+"DATE:"
@ 2, 15 SAY RECNO() PICTURE "999999"
@ 4, 9 SAY IF(race='Y','RACE','    ')
@  2,38 GET DATE
@  4,24 GET distance  PICTURE '9999.99'  VALID CALC_UPD()
@  4,45 GET distancek PICTURE '9999.99'  VALID CALC_UPD()
@  4,60 GET hour      PICTURE '9'        VALID CALC_UPD()
@  4,62 GET minutes   PICTURE '99.99'    VALID CALC_UPD()
@  6, 9 GET first     PICTURE '99.99'
@  7, 9 GET SECOND    PICTURE '99.99'
@  8, 9 GET third     PICTURE '99.99'
@  9, 9 GET fourth    PICTURE '99.99'
@ 10, 9 GET fifth     PICTURE '99.99'
@  6,20 GET sixth     PICTURE '99.99'
@  7,20 GET seventh   PICTURE '99.99'
@  8,20 GET eighth    PICTURE '99.99'
@  9,20 GET ninth     PICTURE '99.99'
@ 10,20 GET tenth     PICTURE '99.99'
@  6,32 GET eleven    PICTURE '99.99'
@  7,32 GET twelve    PICTURE '99.99'
@  8,32 GET thirteen  PICTURE '99.99'
@  9,32 GET fourteen  PICTURE '99.99'
@ 10,32 GET fifteen   PICTURE '99.99'
@  6,44 GET sixteen   PICTURE '99.99'
@  7,44 GET seventeen PICTURE '99.99'
@  8,44 GET eighteen  PICTURE '99.99'
@  9,44 GET nineteen  PICTURE '99.99'
@ 10,44 GET twenty    PICTURE '99.99'
@  6,56 GET twenty1   PICTURE '99.99'
@  7,56 GET twenty2   PICTURE '99.99'
@  8,56 GET twenty3   PICTURE '99.99'
@  9,56 GET twenty4   PICTURE '99.99'
@ 10,56 GET twenty5   PICTURE '99.99'
@  6,68 GET twenty6   PICTURE '99.99'
@  7,68 GET twenty7   PICTURE '99.99'
@  8,68 GET twenty8   PICTURE '99.99'
@  9,68 GET twenty9   PICTURE '99.99'
@ 10,68 GET thirty    PICTURE '99.99'
@ 12,31 GET AVERAGE   PICTURE '99.99'  VALID CALC_UPD()
@ 12,57 GET calorie   PICTURE '99999'  VALID CALC_UPD()
@ 13,31 GET averagek  PICTURE '99.99'  VALID CALC_UPD()
@ 13,59 GET weight    PICTURE '999'    VALID CALC_UPD()
@ 16, 8 GET note1
@ 17, 8 GET note2
@ 18, 8 GET note3
@ 19, 8 GET note4
@ 20, 8 GET note5

*: EOF: RUN.PRG