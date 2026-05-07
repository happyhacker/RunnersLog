# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Runner's Log — a vintage fitness tracking application (v5.24, 1989–2025) written in **CA-Clipper 5.2** (a dBASE-derived DOS language). The compiled output is a 16-bit DOS `.EXE`. Development and compilation require a DOS environment or x86 emulator (DOSBox).

## Building

**Compile all source files** (run individually via `clipall.bat`):
```
CLIPPER <filename> /M/TE:\
```

**Full build** (compile + link):
```
Build.bat
```
Which runs: `clipper @runner.clp` then `rtlink file runner,dgedefs lib hacklib,DGECL5`

**Link only** (using Blinker overlay linker):
```
blinker @runner.lnk
```

Output is `RUNNER.EXE` one directory up (`../RUNNER.EXE`).

**Run**:
```
RUNNER        (auto-detect color)
RUNNER M      (monochrome mode)
```

## Source File Roles

| File | Role |
|------|------|
| `runner.prg` | Entry point: global init, color detection, splash screen, main menu loop |
| `runovl.prg` | Core overlay: all six menu procedures (`RUN1`–`RUN6`), `USE_DB()`, `SEEK_IT()`, `PAGE_RUN()`, `CALC_UPD()` |
| `rungraph.prg` | DGE graphics: line charts and bar/line combo charts of pace trends |
| `rrfuncts.prg` | R&R Report Writer output utilities: date math, formatting, text wrap |
| `detail.prg` | Detailed per-run report generation |
| `run.prg` | Display/print report module; also contains the `Spread()` splash animation |
| `help.prg` | Context-sensitive help (reads `HELP.DBF`) |
| `convert.prg` | One-time data migration utility |

## Architecture

### Memory Overlay Model
Blinker's `BEGINAREA`/`ENDAREA` in `runner.lnk` groups the heavy modules (`RUNOVL`, `RUNGRAPH`, `RRFUNCTS`, `HELP`, DGE driver objects) into a swappable overlay segment (`OPSIZE 55`). This is the standard DOS technique for fitting the app into 640 KB conventional memory.

### Global State (set in `runner.prg`, used everywhere)
- `db` — current log name (e.g., `"RUN"`); passed implicitly to `USE_DB()` which opens `<db>.DBF`
- `xfilter` — active Clipper filter expression string (default `".T."`)
- `xpara` — `"Y"` (color) or `"M"` (monochrome), from command-line arg
- Color scheme variables (`wbbrbg`, `wbgwbr`, `RB`, etc.) — set once at startup based on `ISCOLOR()` and `xpara`; referenced throughout all modules

### Data Layer
- All data is stored in dBASE III `.DBF` files with `.NTX` Clipper indexes
- `RUN.DBF` (or any user-created `<name>.DBF`) — the active run log; opened via `USE_DB()`
- `UTIL.DBF` — app configuration (units, graph title, color scheme, default directory); auto-created on first run if missing
- `HELP.DBF` / `HELP.DBT` — memo-field help content
- `DATA/` — archived per-person logs (`LARRY.DBF`, `BRENDA.DBF`, etc.)

### Graphics
`rungraph.prg` calls the **DGE library** (`DGECL5.LIB`) for EGA/VGA/CGA graphics. `DGEDEFS.CH` defines video mode constants. The splash screen (`RUNMAN.PCX`) is displayed via `PICREAD()` if the video adapter supports it (`GETVIDEO(0) >= 6` for EGA+).

### Libraries & Headers
- `HACKLIB.LIB` — custom utility functions (calendar `HACKCAL`, `SHDOW_BX`, `SHOWMEM`, etc.)
- `DGECL5.LIB` — DGE graphics engine (Bits Per Second Ltd)
- `GRUMP.CH` — Grumpfish Library macros (`SINGLEBOX`, `DOUBLEBOX`, `CENTER`, `SPREAD`)
- `DGEDEFS.CH` — DGE constants; must be compiled to `DGEDEFS.OBJ` and linked in

## Key Clipper Conventions

- `DO <proc>` calls a procedure; `<func>()` calls a function
- `PRIVATE` variables are dynamically scoped (visible to all callees); used for color vars and `db`
- `BEGIN SEQUENCE` / `END SEQUENCE` with `SET KEY 27 TO EXIT` is the standard ESC-to-exit pattern used in data entry screens
- `SET FILTER TO &xfilter` evaluates the filter string as a macro — changes to `xfilter` take effect on the next `USE_DB()` or explicit `SET FILTER`
- Index files (`.NTX`) must match their `.DBF` or records won't sort/seek correctly; `USE_DB()` handles opening both
