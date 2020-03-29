*.............................................................................
*
*   Program Name: DETAIL.PRG        Copyright: Hacksoft
*   Date Created: 01/28/91           Language: Clipper
*   Time Created: 22:32:54             Author: Larry Hack
*.............................................................................
* Revision: 1.0 Last Revised: 2/10/1991 at 13:10
* Description: Removed hard-coded database - uses dbf in area 1
*.............................................................................
* Revision: 1.0 Last Revised: 2/10/1991 at 13:10
* Description: gc_dest is set depending on print()
*.............................................................................
* Revision: 1.0 Last Revised: 2/10/1991 at 13:10
* Description: Set filter to xfilter
*.............................................................................
* Revision: 1.0 Last Revised: 2/10/1991 at 13:10
* Description: Replace tag with .t. if selected
*.............................................................................
* Program generated by R&R Relational Report Writer Code Generator, Version 1.1
* Serial Number:    152357

* Program Name:     DETAIL.PRG
* Program Time:     28-Jan-91  10:32 PM
* Program Language: Clipper

* Report Library:   C:\DEV\RR\RUNLOG.RP1
* Report Name:      Runner's Log Detailed Report
* Report Time:      28-Jan-91  10:29 PM

* Listed functions are referenced but not defined in this program

* User-defined functions:
*	(none)

* Report-independent functions:
*	ceiling()
*	edit_cc()
*	edit_df()
*	edit_fp()
*	rr_outf()
*	rr_outfs()
*	rr_outl()
*	rr_style()
*	rr_wait()

BEGIN SEQUENCE
PRIVATE gn_lno, gn_slno, gn_pno, gn_lpno, gn_rno, gn_outcol, gn_break, gn_body
PRIVATE gl_eof, gl_fields, gl_cmpress, gl_blank, gl_wait, gl_body
PRIVATE gc_true, gc_false, gc_idate, gc_csign, gc_cpos, gc_tsep, gc_point
PRIVATE gc_dest, gc_printer, gc_orient, gn_indent, gn_pitch, gn_lpi, gn_pglen
PRIVATE gn_startpg, gn_endpg, gc_psff, gc_style
PRIVATE gc_str, gc_tag, gc_srt, gx_loscope, gx_hiscope
PRIVATE gn_head, gc_memx, gc_string, gc_color, gc_psreset
PRIVATE gn_key1
PRIVATE gc_key1
PRIVATE old_clr
old_clr=SETCOLOR(wbbrbg)
CLEAR
IF print
   gc_dest = 'P'
ELSE
   gc_dest = 'D'
ENDIF
gn_lno = 1
gn_slno = 1
gn_pno = 1
gn_lpno = 1
gn_rno = 0
gl_eof = .F.
gl_fields = .F.
gc_true = 'T'
gc_false = 'F'
gc_idate = 'A'
gc_csign = '$'
gc_cpos = 'L'
gc_tsep =  ','
gc_point = '.'
gn_break = 0
gc_color = ''
gn_outcol = 0
gn_head = 0
gc_printer = 'A'
gc_style = 'bui00'
gn_startpg = 1
gn_endpg = 9999
gl_cmpress = .T.
gl_blank = .T.
gl_wait = .F.
gl_body = .T.
gc_orient = 'P'
gn_indent = 0
gn_pitch = 12
gn_lpi = 6
gn_pglen = 66
gc_psff = ''
gc_psreset = ''
gn_key1 = 0
gc_key1 = ''
gx_loscope = ''
gx_hiscope = ''

PRIVATE F[27]
* assigment of F array indexes:
* 1: DATE
* 2: WEIGHT
* 3: CALORIE
* 4: DISTANCE
* 5: HOUR
* 6: MINUTES
* 7: SECTIME
* 8: AVERAGE
* 9: NOTE1
* 10: NOTE2
* 11: NOTE3
* 12: NOTE4
* 13: NOTE5
* 14: xHOUR() = IIF(HOUR>0,':',' ')
* 16: TOT_DIST() = Grand Sum of DISTANCE
* 17: TOT_SEX() = Grand Sum of SECTIME
* 18: VAL_DIST() = IIF(SECTIME>0,DISTANCE,0)
* 20: DIST2() = Grand Sum of VAL_DIST
* 21: AVER() = IIF(SECTIME=0,0,INT((TOT_SEX/DIST2)/60)+((((TOT_SEX/DIST2)/60)-
	*INT((TOT_SEX/DIST2)/60))*.6))
* 23: cals() = Grand Sum of CALORIE
* 24: high() = Grand Highest of WEIGHT
* 26: low() = Grand Lowest of WEIGHT

DO set1_RL1
DO clrc_RL1
DO gfr_RL1
IF m->gl_eof
	SET CONSOLE ON
	? 'No records found' + chr(7)
	SET PRINT OFF
	WAIT
	DO esc_RL1
ENDIF
DO clrg_RL1
IF m->gc_printer $ '12345678' .AND. m->gc_dest # 'D'
	IF FILE('rr_pr'+gc_printer+'.mem')
		RESTORE FROM rr_pr&gc_printer ADDITIVE
	ELSE
		gc_printer = 'A'
	ENDIF
ENDIF
DO set2_RL1
DO fld_RL1
DO topm_RL1
DO head_RL1

* main program
DO WHILE .T.
	IF INKEY() = 27 .OR. LASTKEY() = 27
		DO esc_RL1
	ENDIF
	DO body_RL1
	DO gnr_RL1
	gl_fields = .F.
	DO CASE
		CASE m->gl_eof
			gl_fields = .T.
			EXIT
		OTHERWISE
			gn_break = 9
	ENDCASE
ENDDO

* termination
DO summ_RL1
DO ff_RL1
IF m->gc_dest = 'D'
	WAIT
ENDIF
DO rset_RL1
END
SET FILTER TO
RETURN

* --------------
* * procedures *
* --------------

**************************
PROCEDURE set1_RL1
* set environment, phase 1
**************************
gc_color = SETCOLOR()
SET CONSOLE ON
SET PRINT OFF
SET CENTURY OFF
SET DELETED OFF
SET EXACT OFF
SET MARGIN TO 0
SET SAFETY OFF

DO CASE
	CASE m->gc_idate = 'A'
		SET DATE AMERICAN
	CASE m->gc_idate = 'B'
		SET DATE BRITISH
	CASE m->gc_idate = 'C'
		SET DATE GERMAN
	CASE m->gc_idate = 'D'
		SET DATE ANSI
ENDCASE
RETURN

**************************
PROCEDURE set2_RL1
* set environment, phase 2
**************************
DO CASE
	CASE m->gc_dest = 'P'
		SET CONSOLE OFF
		SET PRINT ON
		IF m->gc_printer = 'A'
			SET PRINTER TO PRN
		ELSE
			SET PRINTER TO &gc_psoutp
		ENDIF
	CASE m->gc_dest = 'D'
		SET CONSOLE ON
		SET PRINT OFF
		SET STATUS OFF
	CASE m->gc_dest = 'F'
		SET CONSOLE OFF
		SET PRINTER TO NUL
		SET PRINT ON
ENDCASE
IF m->gc_dest <> 'D' .AND. m->gc_printer <> 'A'
	?? m->gc_pssetup
	?? IIF(m->gc_orient = 'P', m->gc_psport, m->gc_psland)
	?? IIF(m->gn_pitch = 10, m->gc_ps10cpi, IIF(m->gn_pitch =	12, ;
		m->gc_ps12cpi, m->gc_pscompr))
	?? IIF(m->gn_lpi = 6, m->gc_ps6lpi, m->gc_ps8lpi)
	?? IIF(''#m->gc_psflen, m->gc_psflen+CHR(m->gn_pglen % 256), '')
ENDIF
RETURN

*******************
PROCEDURE rset_RL1
* reset environment
*******************
IF LEN(m->gc_psreset) <> 0
	?? m->gc_psreset
ENDIF
SETCOLOR(m->gc_color)
SET CONSOLE ON
SET PRINT OFF
SET DEVICE TO SCREEN
RETURN

****************
PROCEDURE esc_RL1
* escape key
****************
DO rset_RL1
BREAK

************************
PROCEDURE clrc_RL1
* clear composite record
************************
F[14] = ''
F[15] = ''
F[16] = 0
F[17] = 0
F[18] = 0
F[19] = 0
F[20] = 0
F[21] = 0
F[22] = 0
F[23] = 0
F[24] = 0
F[26] = 0
RETURN

*****************
PROCEDURE ff_RL1
* print form feed
*****************
IF m->gn_lno = 1
	RETURN
ENDIF
IF m->gn_pno >= m->gn_startpg
	DO CASE
		CASE m->gc_dest = 'D'
			?? REPLICATE(CHR(196),80)
			DO rr_wait
		CASE m->gc_printer = 'A' .OR. LEN(m->gc_psff) = 0
			DO WHILE m->gn_lno < 67
				DO rr_outl WITH .F.
			ENDDO
		CASE m->gn_lno < 67
			?? m->gc_psff
	ENDCASE
ENDIF
gn_pno = m->gn_pno + 1
gn_lpno = m->gn_lpno + 1
gn_lno = 1
IF m->gn_pno > m->gn_endpg
	IF m->gc_dest = 'D'
		WAIT
	ENDIF
	DO esc_RL1
ENDIF
RETURN

******************
PROCEDURE topm_RL1
* print top margin
******************
IF m->gc_dest = 'P' .AND. m->gl_wait
	SET CONSOLE ON
	SET PRINT OFF
	@ 24,0
	@ 24,0 SAY 'Wait between pages, press any key to continue...'
	WAIT
	SET CONSOLE OFF
	SET PRINT ON
ENDIF
DO WHILE m->gn_lno < 4
	DO rr_outl WITH .F.
ENDDO
RETURN

***********************
PROCEDURE newp_RL1
* check for top of page
***********************
IF m->gn_lno = 1
	DO topm_RL1
	DO head_RL1
ENDIF
RETURN

***********************
PROCEDURE endp_RL1
* check for end of page
***********************
IF m->gn_lno > 61
	DO ff_RL1
	DO fld_RL1
	DO newp_RL1
ENDIF
RETURN

*******************
PROCEDURE head_RL1
* print page header
*******************
DO rr_outf WITH SPACE(22)
DO rr_outfs WITH "Runner's Log by Hacksoft Inc.", 'BUi01'
DO rr_outl WITH .F.
DO rr_outl WITH .F.
DO rr_outf WITH SPACE(6)
DO rr_outfs WITH 'Date', 'Bui00'
DO rr_outf WITH SPACE(20 - m->gn_outcol)
DO rr_outfs WITH 'Distance', 'Bui00'
DO rr_outf WITH SPACE(32 - m->gn_outcol)
DO rr_outfs WITH 'Time', 'Bui00'
DO rr_outf WITH SPACE(39 - m->gn_outcol)
DO rr_outfs WITH 'Average', 'Bui00'
DO rr_outf WITH SPACE(48 - m->gn_outcol)
DO rr_outfs WITH 'Weight', 'Bui00'
DO rr_outf WITH SPACE(56 - m->gn_outcol)
DO rr_outfs WITH 'Calories', 'Bui00'
DO rr_outf WITH SPACE(66 - m->gn_outcol)
DO rr_outfs WITH 'Accumulated', 'Bui00'
DO rr_outl WITH .F.
DO rr_outf WITH SPACE(40)
DO rr_outfs WITH 'Pace', 'Bui00'
DO rr_outf WITH SPACE(57 - m->gn_outcol)
DO rr_outfs WITH 'Burned', 'Bui00'
DO rr_outf WITH SPACE(67 - m->gn_outcol)
DO rr_outfs WITH 'Distance', 'Bui00'
DO rr_outl WITH .F.
RETURN

*****************
PROCEDURE summ_RL1
* print summary
*****************
IF m->gn_lno > 58
	DO ff_RL1
	DO newp_RL1
ENDIF
DO rr_outl WITH .F.
DO rr_outfs WITH 'Totals', 'Bui00'
DO rr_outf WITH SPACE(11 - m->gn_outcol)
DO rr_outfs WITH 'Weight:', 'Bui00'
DO rr_outf WITH SPACE(19 - m->gn_outcol)
DO rr_outfs WITH 'Highest', 'Bui00'
DO rr_outf WITH SPACE(27 - m->gn_outcol)
DO rr_outfs WITH 'Lowest', 'Bui00'
DO rr_outf WITH SPACE(39 - m->gn_outcol)
DO rr_outfs WITH 'Average', 'Bui00'
DO rr_outf WITH SPACE(56 - m->gn_outcol)
DO rr_outfs WITH 'Calories', 'Bui00'
DO rr_outf WITH SPACE(66 - m->gn_outcol)
DO rr_outfs WITH 'Accumulated', 'Bui00'
DO rr_outl WITH .F.
DO rr_outf WITH SPACE(57)
DO rr_outfs WITH 'Burned', 'Bui00'
DO rr_outf WITH SPACE(67 - m->gn_outcol)
DO rr_outfs WITH 'Distance', 'Bui00'
DO rr_outl WITH .F.
DO rr_outf WITH SPACE(21)
DO rr_outfs WITH edit_fp(F[24],3,0,' 0F'), 'Bui00'
DO rr_outf WITH SPACE(28 - m->gn_outcol)
DO rr_outfs WITH edit_fp(F[26],3,0,' 0F'), 'Bui00'
DO rr_outf WITH SPACE(40 - m->gn_outcol)
DO rr_outfs WITH edit_fp(F[21],2,2,' 0F'), 'Bui00'
DO rr_outf WITH SPACE(48 - m->gn_outcol)
DO rr_outfs WITH edit_cc(F[23],11,0,' ,'), 'Bui00'
DO rr_outf WITH SPACE(67 - m->gn_outcol)
DO rr_outfs WITH edit_fp(F[16],6,1,' 0F'), 'Bui00'
DO rr_outl WITH .F.
RETURN

**************************
PROCEDURE fld_RL1
* move data to field array
**************************
IF m->gl_fields
	RETURN
ENDIF
F[1] = DATE
F[2] = WEIGHT
F[3] = CALORIE
F[4] = DISTANCE
F[5] = HOUR
F[6] = MINUTES
F[7] = SECTIME
F[8] = AVERAGE
F[9] = NOTE1
F[10] = NOTE2
F[11] = NOTE3
F[12] = NOTE4
F[13] = NOTE5
F[14] = F[15]
F[18] = F[19]
DO tot_RL1
gl_fields = .T.
RETURN

*******************
PROCEDURE tot_RL1
* accumulate totals
*******************
F[16] = F[16] + DISTANCE
F[17] = F[17] + SECTIME
F[20] = F[20] + F[19]
F[21] = IF(SECTIME=0,0,INT((F[17]/F[20])/60)+((((F[17]/F[20])/60)-INT((F[17]/F[20])/60))*.6))
IF CALORIE <> 0
	F[23] = F[23] + CALORIE
ENDIF
IF F[25]
	IF WEIGHT > F[24]
		F[24] = WEIGHT
	ENDIF
ELSE
	F[25] = .T.
	F[24] = WEIGHT
ENDIF
IF F[27]
	IF WEIGHT < F[26]
		F[26] = WEIGHT
	ENDIF
ELSE
	F[27] = .T.
	F[26] = WEIGHT
ENDIF
RETURN


********************
PROCEDURE clrg_RL1
* clear grand totals
********************
F[16] = 0
F[17] = 0
F[20] = 0
F[23] = 0
F[24] = 0
F[25] = .F.
F[26] = 0
F[27] = .F.
RETURN

******************
PROCEDURE body_RL1
* print body lines
******************
gn_head = 0
IF .NOT. m->gl_body
	DO fld_RL1
	RETURN
ENDIF
IF m->gn_lno > 55
	DO ff_RL1
ENDIF
DO fld_RL1
DO newp_RL1
DO endp_RL1
DO rr_outfs WITH edit_df(F[1],1), 'Bui00'
DO rr_outf WITH SPACE(21 - m->gn_outcol)
DO rr_outf WITH edit_fp(F[4],5,1,' 0F')
DO rr_outf WITH SPACE(30 - m->gn_outcol)
DO rr_outf WITH edit_fp(F[5],1,0,'  F')
DO rr_outf WITH SPACE(31 - m->gn_outcol)
DO rr_outf WITH RTRIM(LEFT(F[14],1))
DO rr_outf WITH SPACE(32 - m->gn_outcol)
DO rr_outf WITH edit_fp(F[6],2,2,'  F')
DO rr_outf WITH SPACE(40 - m->gn_outcol)
DO rr_outf WITH edit_fp(F[8],2,2,'  F')
DO rr_outf WITH SPACE(49 - m->gn_outcol)
DO rr_outf WITH edit_fp(F[2],3,0,' 0F')
DO rr_outf WITH SPACE(58 - m->gn_outcol)
DO rr_outf WITH edit_fp(F[3],5,0,'  F')
DO rr_outf WITH SPACE(67 - m->gn_outcol)
DO rr_outf WITH edit_fp(F[16],6,1,' 0F')
DO rr_outl WITH .T.
IF LEN(TRIM(F[9])) <> 0
	DO endp_RL1
	DO rr_outl WITH .F.
ENDIF
DO endp_RL1
DO rr_outf WITH SPACE(4)
DO rr_outf WITH RTRIM(LEFT(F[9],64))
DO rr_outl WITH .T.
DO endp_RL1
DO rr_outf WITH SPACE(4)
DO rr_outf WITH RTRIM(LEFT(F[10],64))
DO rr_outl WITH .T.
DO endp_RL1
DO rr_outf WITH SPACE(4)
DO rr_outf WITH RTRIM(LEFT(F[11],64))
DO rr_outl WITH .T.
DO endp_RL1
DO rr_outf WITH SPACE(4)
DO rr_outf WITH RTRIM(LEFT(F[12],64))
DO rr_outl WITH .T.
DO endp_RL1
DO rr_outf WITH SPACE(4)
DO rr_outf WITH RTRIM(LEFT(F[13],64))
DO rr_outl WITH .T.
DO endp_RL1
DO rr_outf WITH '様様様様様様様様様様様様様様様様様様様様様様様様様様様様様様�';
	+'様様様様様様様様'
DO rr_outl WITH .T.
RETURN

****************************
PROCEDURE gfr_RL1
* get first composite record
****************************
SELECT 1
SET FILTER TO &xfilter
GO TOP
gc_key1 = INDEXKEY(1)
gn_rno = 1
DO gfr0_RL1
DO WHILE .T.
	IF m->gl_eof
		RETURN
	ENDIF
	IF query_RL1()
		RETURN
	ENDIF
	DO gnr0_RL1
ENDDO

***************************
PROCEDURE gnr_RL1
* get next composite record
***************************
gn_rno = m->gn_rno + 1
DO WHILE .T.
	DO gnr0_RL1
	IF m->gl_eof
		RETURN
	ENDIF
	IF query_RL1()
		RETURN
	ENDIF
ENDDO

*************************************
PROCEDURE gfr0_RL1
* get first composite record, level 0
*************************************
gl_eof = .F.
SELECT 1
DO WHILE .T.
	IF EOF()
		gl_eof = .T.
		RETURN
	ENDIF
	F[15] = IIF(HOUR>0,':',' ')
	F[19] = IIF(SECTIME>0,DISTANCE,0)
	EXIT
ENDDO
RETURN

************************************
PROCEDURE gnr0_RL1
* get next composite record, level 0
************************************
gl_eof = .F.
DO WHILE .T.
	SELECT 1
	SKIP
	IF EOF()
		gl_eof = .T.
		RETURN
	ENDIF
	F[15] = IIF(HOUR>0,':',' ')
	F[19] = IIF(SECTIME>0,DISTANCE,0)
	EXIT
ENDDO
RETURN

**********************************
FUNCTION query_RL1
* query and 'print which' function
**********************************
IF &xfilter .AND. .NOT. DELETED()
   REPLACE TAG WITH .T.
   RETURN .T.
ENDIF
RETURN .F.