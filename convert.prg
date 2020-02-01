* Program..: convert.prg
* Author...: Larry Hack
* Created..: 1/14/1990 at 16:59
* Copyright (c) 1990 by Data-Link Systems
* main =
* Called From:
*.............................................................................
* Revision: 1.0 Last Revised: 1/14/1990 at 16:59
* Description: Original Creation.
*...................................................................*
* Revision: 1.1 Modified on : 07-23-91 09:21:44pm
* Description:Changed deletion of old log file to renaming it LOGBAK.DBF
***************************** ALL RIGHTS RESERVED ****************************

CLEAR
TEXT
This program converts older versions of the Runner's Log data file to the
new data format.  Your old log file must be in this drive and directory.
You will be prompted to enter the name of the log.
Press any key to continue
ENDTEXT
inkey(0)
CLEAR
STORE SPACE(8) TO LOG
STORE 0 TO M->WEIGHT
@ 10,10 SAY "Enter the name of the log to convert (no extension)" GET LOG
@ 11,10 SAY "How much do you weigh" GET M->WEIGHT
READ
LOG = TRIM(LOG)+".DBF"
IF .NOT. FILE(LOG)
   @ 13,0 SAY CTR(LOG +" MUST BE IN THIS DRIVE AND DIRECTORY",80)
   @ 14,0 SAY CTR("PRESS ANY KEY TO EXIT",80)
   INKEY(0)
   QUIT
ENDIF

@ 12,0 SAY CTR("CONVERSION IN PROGRESS. ONE MOMENT PLEASE...",80)

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
CREATE HACKCONV FROM HACKO
USE
DELETE FILE HACKO.DBF
SELECT 1

USE HACKCONV
APPEND FROM &LOG
USE
RENAME &LOG TO LOGBAK.DBF
RENAME HACKCONV.DBF TO &LOG
USE &LOG
GO TOP
DO WHILE .NOT. EOF()
   IF EMPTY(WEIGHT)
      REPLACE WEIGHT WITH M->WEIGHT
   ENDIF
   IF sectime > 0
      caltime = hour*60 + minutes                && FOR CALORIES BURNED
      ttime = ((hour * 3600)+INT(minutes)*60)+(minutes-INT(minutes))*100
      maver = (ttime/distance)/60                && TOTAL TIME DIVIDE BY DISTANCE IN SECONDS
      tottime = (maver - INT(maver))*.6          && CONVERT SECONDS TO TIME FORMAT
      maverage = int(maver)+tottime              && THE AVERAGE TIME IN CORRECT TIME FORMAT

      **** DO CALCULATIONS FOR KMS ****
      maver = (ttime/distancek)/60               && TOTAL TIME DIVIDE BY DISTANCE IN SECONDS
      tottime = (maver - INT(maver))*.6          && CONVERT SECONDS TO TIME FORMAT
      maveragek = INT(maver)+tottime             && THE AVERAGE TIME IN CORRECT TIME FORMAT

      IF EMPTY(average)
         REPLACE average WITH maverage
      ENDIF
      IF EMPTY(averagek)
         REPLACE averagek WITH maveragek
      ENDIF

      IF EMPTY(CALORIE)
         CALTIME = HOUR*60 + MINUTES
         IF AVERAGE <= 6
            MCALORIE = CALTIME*M->WEIGHT*.114
         ENDIF
         IF AVERAGE <= 8.3 .AND. AVERAGE > 6
            MCALORIE = CALTIME*M->WEIGHT*.102
         ENDIF
         IF AVERAGE < 11 .AND. AVERAGE > 7
            MCALORIE = CALTIME*M->WEIGHT*.090
         ENDIF
         IF AVERAGE >= 11
            MCALORIE = CALTIME*M->WEIGHT*.070
         ENDIF
         IF AVERAGE = 0
            MCALORIE = 0
         ENDIF
         REPLACE CALORIE WITH MCALORIE
      ENDIF
   ENDIF
   SKIP
ENDDO
@ 13,0 SAY CTR("I'M FINISHED",80)