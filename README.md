# Runner's Log

A vintage fitness tracking application for runners and walkers, built with Clipper 5.x for DOS.

**Developed by Hacksoft Inc. (1989-2025)**

## Overview

Runner's Log allows users to track running and walking activities with detailed metrics including:
- Distance (miles/kilometers)
- Time and pace
- Split times (up to 30 per run)
- Calories burned
- Personal notes

## Requirements

- Clipper 5.2 compiler
- Blinker overlay linker
- DGE Graphics Library (DGECL5.LIB)
- DOS environment or emulator (DOSBox, x86 emulator)

## Project Structure

```
/PROD/
├── Source Code
│   ├── runner.prg      - Main entry point & menu system
│   ├── runovl.prg      - Core module: add/edit/browse runs
│   ├── rungraph.prg    - Graphics & charting
│   ├── rrfuncts.prg    - Report utilities
│   ├── detail.prg      - Detailed report generation
│   ├── help.prg        - Online help system
│   ├── convert.prg     - Data format migration
│   └── run.prg         - Display/report module
│
├── Libraries & Headers
│   ├── HACKLIB.LIB     - Custom utility library
│   ├── DGECL5.LIB      - DGE graphics library
│   ├── GRUMP.CH        - Grumpfish UI macros
│   └── DGEDEFS.CH      - DGE graphics definitions
│
├── Data Files (./DATA/)
│   ├── *.DBF           - dBASE data files
│   └── *.NTX           - Index files
│
└── Resources
    ├── UTIL.DBF        - Configuration database
    ├── HELP.DBF        - Help content
    └── *.PCX/*.BMP     - Splash screens
```

## Building

Run the build script:
```
Build.bat
```

Or manually link using the linker configuration:
```
blinker @runner.lnk
```

## Database Schema

### RUN.DBF (Main Log)

| Field      | Type    | Description              |
|------------|---------|--------------------------|
| DATE       | Date    | Run date                 |
| WEIGHT     | Numeric | Weight in pounds         |
| CALORIE    | Numeric | Calories burned          |
| RACE       | Char(1) | Race flag (Y/N)          |
| DISTANCE   | Numeric | Distance in miles        |
| DISTANCEK  | Numeric | Distance in kilometers   |
| HOUR       | Numeric | Hours                    |
| MINUTES    | Numeric | Minutes + seconds        |
| SECTIME    | Numeric | Total time in seconds    |
| FIRST-THIRTY | Numeric | Split times (30 fields) |
| TAG        | Logical | Selection flag           |

### UTIL.DBF (Configuration)

| Field     | Type    | Description              |
|-----------|---------|--------------------------|
| NAME      | Char    | Config name              |
| MORK      | Char    | Units: "MILE" or "KILO"  |
| DIRECTORY | Char    | Default log path         |
| GSTRING   | Char    | Graph title              |
| COLOR     | Char    | Display color scheme     |

## Main Menu Options

1. **Add Runs to Log** - Enter new run data with splits
2. **Display/Print Specific Runs** - Filter and report selected runs
3. **Display/Print All Runs** - Full log report
4. **Best Times** - View top performances by distance
5. **Browse Runs** - Interactive database browser/editor
6. **Create/Load New Log** - Manage multiple log files
7. **Display Graphics** - Chart pace trends
8. **Exit**

## Keyboard Shortcuts

| Key | Function                    |
|-----|-----------------------------|
| F1  | Context-sensitive help      |
| F2  | Calendar for date selection |
| F3  | Search/Filter               |
| F4  | Print tagged records        |
| F5  | Copy to new log             |
| F6  | Display tagged only         |
| F7  | Delete record               |

## Command Line Options

```
RUNNER      - Normal startup (auto-detect colors)
RUNNER M    - Monochrome mode
```

## Key Source Files

### runner.prg
Main entry point. Handles:
- Color mode detection (CGA/EGA/VGA)
- Splash screen display
- Main menu navigation
- Global initialization

### runovl.prg
Core application logic with 6 main procedures:
- `RUN1()` - Add new runs
- `RUN2()` - Display filtered runs
- `RUN3()` - Display all runs
- `RUN4()` - Best times report
- `RUN5()` - Browse/edit runs
- `RUN6()` - Create/load logs

Key functions:
- `USE_DB()` - Open current log database
- `SEEK_IT()` - Search/filter runs
- `PAGE_RUN()` - Full-screen record editor
- `CALC_UPD()` - Recalculate derived fields

### rungraph.prg
Graphics module for charting:
- Line charts for pace trends
- Bar/line combination charts
- DGE graphics library integration

### rrfuncts.prg
Report utilities (R&R Report Writer generated):
- Date math: `adddays()`, `addmons()`, `addyrs()`
- Formatting: `rr_outf()`, `rr_outl()`
- Text wrapping: `rr_cwrap()`

## Version History

| Version | Date       | Changes                              |
|---------|------------|--------------------------------------|
| 5.24    | 01/05/2025 | Added DGE graphics back in           |
| 5.23    | 12/06/2020 | Set CENTURY ON fix                   |
| 5.22    | 06/27/2020 | Set cursor off on intro              |
| 5.21    | 06/02/2020 | Updated VAL_TIME()                   |
| 5.2     | 04/30/2020 | Added 100th digit to distance        |
| 5.1     | 04/11/2020 | Century date support                 |
| 5.0     | 01/18/2020 | Built with Clipper 5.2 on Mac        |
| 4.41    | 04/29/1992 | Build util.dbf if doesn't exist      |
| 4.4     | 08/22/1991 | UI optimization                      |

## License

Copyright (c) 1989-2025 Hacksoft Inc.
