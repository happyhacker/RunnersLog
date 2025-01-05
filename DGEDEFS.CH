*       DGEDEFS.CH
*
*       Manifest constants for dGE
*
*       (c)     Bits Per Second Ltd
*               Brighton, England

* !! VSCROLL and HSCROLL renamed to _VSCROLL  _HSCROLL
* because of conflict with Funkey

#define VSCROLL _VSCROLL
#define HSCROLL _HSCROLL
#define vscroll _vscroll
#define hscroll _hscroll
#define VScroll _VScroll
#define HScroll _HScroll
#define PrintFile PrnFile
#define PRINTFILE PRNFILE
#define printfile prnfile

***************************
*       GGI constants
***************************

* Video mode
#define M640200_2        6
#define M720348_2        7
#define M640350_16      16
#define M640480_2       17
#define M640480_16      18
#define M320200_256     19
#define M800600_16     258
#define M1024768_16    260
#define M640480_256    257
#define M800600_256    259
#define M1024768_256   261

* ROP2 mode
#define ROPREPLACE        0
#define ROPOR             1
#define ROPXOR            2
#define ROPNOT            3
#define ROPAND            4

* pen style
#define PENNULL             0
#define PENSOLID            1
#define PENDASH             2
#define PENDOT              3
#define PENDASHDOT          4
#define PENDASHDD           5

* Brush Pattern tool
#define BRNULL           0
#define BRSOLID          1
#define BRHATCH          2
#define BRBITMAP         3

* Background mode
#define BKOPAQUE         0
#define BKTRANSPARENT    1

* Polyfill mode
#define WINDING          0

* Max brush hatches/bitmaps
#define BRHATCHMAX       6
#define BRBITMAPMAX      16

* Standard 16 colors
#define BLACK             0
#define BLUE              1
#define GREEN             2
#define CYAN              3
#define RED               4
#define MAGENTA           5
#define BROWN             6
#define WHITE             7
#define GREY              8
#define GRAY              8
#define LIGHT             8
#define HIBLUE            9
#define HIGREEN          10
#define HICYAN           11
#define HIRED            12
#define HIMAGENTA        13
#define YELLOW           14
#define HIWHITE          15

/*
** SUPER TEXT .. CSet param in all text functions
*/
#define TXREPLACE  4 /* additive */
#define TXOR       8 /* additive */
#define TXXOR      16 /* additive */
#define TXBLACK    32 /* additive */
#define TXINVERSE  64 /* additive */

/*
** SUPER TEXT & VECTOR TEXT .. Justification
*/
#define TXHMID     8 /* additive */
#define TXHRIGHT   16 /* additive */
#define TXVMID     64 /* additive */
#define TXVTOP     128 /* additive */

/*
**  BARGRAPH       BG
*/
#define BGSIMPLE   0
#define BGSTACK    1
#define BGCLUST    2
#define BGHORIZ    4 /* additive */
#define BGNOSPACE  8 /* additive */
#define BG3DCLEAR  16 /* additive */
#define BG3DFILL   32 /* additive */

/*
**  BESTFIT        BF
*/
#define BFUSEWIN   0

/*
**  BOXFILL        BX
*/
#define BXCLEAR    20
#define BXNOFILL   64 /* additive */
#define BXNOBOX    128 /* additive */

/*
**  DISKFILE       DF
*/
#define DFREAD     0
#define DFWRITE    1
#define DFPCX      2 /* additive */

/*
**  DRAWCIRCLE     DC
*/
#define DCRADIUS   4  /* additive */
#define DCFILL     8  /* additive */

/*
** DRAWICON        DI
*/
#define DIXY       0
#define DIRA       1
#define DIREPLACE  4 /* additive */
#define DIOR       8 /* additive */
#define DIXOR      16 /* additive */
#define DIBLACK    32 /* additive */
#define DIINVERSE  64 /* additive */
#define DISUPER    16 /* additive */

/*
**  DRAWLINE       DL    (also most other abs and rel line functions)
*/
#define DLREPLACE  0
#define DLOR       1
#define DLXOR      2
#define DLBLACK    3
#define DLCONT     16 /* additive */
#define DLPLOTNDX  128 /* additive */

/*
**  DRAWVEC        DV
*/
#define DVUPDATE   0
#define DVNOUPDATE 1

/*
**  DRAWVTEXT      VT
*/
#define VTREPLACE  0
#define VTOR       8 /* additive */
#define VTBLACK    32 /* additive */
#define VTBOLD     128 /* additive */

/*
**  EDSTRING       ES    (also GETSTRING)
*/
#define ESCHAIN    0

/*
**  GANTT          GT
*/
#define GTNOSPACE  1 /* additive */
#define GT3DCLEAR  2 /* additive */
#define GT3DFILL   4 /* additive */

/*
**  GETCHAR        GC
*/
#define GCWAIT     0
#define GCSAMPLE   1
#define GCVERSION  2

/*
**  GETFONTINF     GF
*/
#define GFFONTWID  0
#define GFFONTHT   1
#define GFICONWID  2
#define GFICONHT   3

/*
** GETVIDEO        GV
*/
#define GVADAPTER  0
#define GVBIOS     1
#define GVDRIVER   2

/*
**  GETSIN         GS    (also GETASIN)
*/
#define GSSIN      0
#define GSCOS      1

/*
**  HLCGRAPH       HL
*/
#define HLSCATTER  0
#define HLWSJ      256 /* additive */

/*
**  LABELPIE       LP
*/
#define LPPC       4 /* additive */
#define LPNOLINES  8 /* additive */

/*
**  LABELX         LX
*/
#define LXSTAGGER  256 /* additive */

/*
**  LOADMPRN       LM
*/
#define LMHORIZ    0
#define LMVERT     1

/*
**  MPCONFIG       MP
*/
#define MPCOLOR    2 /* additive */

/*
**  PICREAD        PR
*/
#define PRXOR      8 /* additive */
#define PRMONOREV  16 /* additive */

/*
**  PIECHART       PC
*/
#define PCEXPL     1

/*
**  PLOTCSET       PCS
*/
#define PCNORMAL   100
#define PCUS       0
#define PCUK       2
#define PCGERMAN   33
#define PCFRENCH   34

/*
**  PLOTON         PON
*/
#define POHOFF     40          /* for A3 paper */
#define POVOFF     40
#define POXLEN     300
#define POHORIZ    0
#define POVERT     1
#define POSERIAL1  2
#define POSERIAL2  4
#define PORESET    8
#define POEJECT    16
#define POUNIT     40

/*
**  POLARAXES      PA
*/
#define PAGRIDS    128        /* additive */

/*
**  POLARGRAPH     PG
*/
#define PGSCATTER  0
#define PGCHAIN    0
#define PGICON     1
#define PGCHICON   2
#define PGSTICKS   3

/*
**  POLYVEC        PV
*/
#define PVXYORG    0
#define PVRAORG    1
#define PVXYDATA   0  /* additive */
#define PVRADATA   2  /* additive */
#define PVDRAG     4  /* additive */
#define PVMIRRORV  8  /* additive */
#define PVMIRRORH  16 /* additive */

/*
**  PRINTFILE      PF
*/
#define PFDISABLE  0
#define PFENABLE   1
#define PFAPPEND   2  /* additive */

/*
**  PRINTPCL       PP
*/
#define PPRESET    1
#define PFFF       2  /* additive */
#define PPCORRECT  4 /* additive */
#define PPCOLOR    8 /* additive */
#define PPREVERSE  16 /* additive */
#define PPLANDSCP  32 /* additive */
#define PPMONOREV  64 /* additive */

/*
** PRINTPS
*/

#define PPSLANDS   1
#define PPSREV     2

/*
**  SAYSTRING      SS   (also LABELX, LABELY, VECSTRING)
*/
#define SSHORIZ    0
#define SSVERT     1
#define SSNOCLEAR  2  /* additive */
#define SSDESCEND  4  /* additive */
#define SSMID      8  /* additive */
#define SSRIGHT    16 /* additive */
#define SSCONCAT   32 /* additive */

/*
**  SETDELIM       SD
*/
#define SDNONE     0

/*
**  SETHIRES       SH
*/
#define SHNOCLEAR  64 /* additive */

/*
**  SETVIDEO       SV
*/
#define SVHERC     3
#define SVCGAMONO  4
#define SVCGACLR   5
#define SVEGA      6
#define SVVGA      7

/*
**  SETPRN         SP
*/
#define SPCOM1     0
#define SPCOM2     1
#define SPNONE     0
#define SPODD      1
#define SPEVEN     2
#define SP7BIT     0
#define SP8BIT     1
#define SP1STOP    0
#define SP2STOP    1

/*
**  STATS          STA
*/
#define STMEAN     0
#define STSTDEV    1  /* additive */

/*
**  TIMEGRAPH      TG
*/
#define TGDISABLE  0
#define TGINDEX    128        /* additive */
#define TGMEAN     256        /* additive */
#define TGSTDEV    512        /* additive */

/*
**  VECICON        VI
*/
#define VIUSER     0
#define VILIB      1

/*
**  XYAXES         XA
*/
#define XANEGY     1
#define XANEGX     2  /* additive */
#define XAYGRIDA   4  /* additive */
#define XAYGRIDB   8  /* additive */
#define XAYGRIDC   12 /* additive */
#define XAXGRIDA   16 /* additive */
#define XAXGRIDB   32 /* additive */
#define XAXGRIDC   48 /* additive */
#define XAFRAME    32 /* additive */

/*
**  XYGRAPH        XG
*/
#define XGSCATTER  0
#define XGCHAIN    0
#define XGICON     1
#define XGCHICON   2
#define XGSTICKS   3
#define XGICONXOR  4 /* additive */
