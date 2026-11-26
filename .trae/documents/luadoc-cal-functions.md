# Add LuaDoc Headers to Two Calibration Functions in TEST_API.lua

## Summary
Add LDoc-style documentation headers (matching the `VPG_SetActiveArea` format in [IC.lua](file:///c:/Users/JZD/Documents/Tab_HAWK_Test_CP2_1026_beta/Tab_HAWK_Test_CP2_1026_beta/IC.lua#L470-483)) to:

1. `Pixel_Current_DAC_Cal_binary()` — [TEST_API.lua L1266](file:///c:/Users/JZD/Documents/Tab_HAWK_Test_CP2_1026_beta/Tab_HAWK_Test_CP2_1026_beta/TEST_API.lua#L1266-1401)
2. `Temp_Sensor_Cal(side)` — [TEST_API.lua L2870](file:///c:/Users/JZD/Documents/Tab_HAWK_Test_CP2_1026_beta/Tab_HAWK_Test_CP2_1026_beta/TEST_API.lua#L2870-3021)

**Documentation only. No code-logic changes.**

## Current State Analysis

### Reference format (IC.lua L470–483)
- `---` one-sentence summary line (includes register numbers)
- `--` detail lines: behavior, what is read/written, defaults, edge cases
- `-- @param name type description. Default = ...`
- `-- @usage` examples with trailing `-- comment`
- `-- @see` cross-references to related functions

### Target 1: `Pixel_Current_DAC_Cal_binary()` (TEST_API.lua L1266–1401)
- Currently **no header doc**; only internal body comments (measure/cache block L1316–1319, binary-search explanation L1347–1355 — both kept as-is).
- Behavior (from code + test plan image "Pixel Current DAC - Calibration"):
  - PPMU 5 V on; GPIO6=1/GPIO3=0/GPIO2=1 routes analog mux **Y5 to AMON** (tested pins: AMON, I3C_SCL, I3C_SDA).
  - `SMU2(ON, 1, 0x85)` constant-current (measure voltage); current derived via `I(uA) = V / R_AMUX(100 kOhm) * 1e6`.
  - Unlocks F0h/F1h/FCh keys, writes **FDh ANALOGTEST = {0x00, 0x02, 0x94}** (VDC_TPXL_EN analog-test-item path, 3rd P = DRV_STR/ANA_TMUX/ANA_TEST_SET).
  - Binary-searches the **9-bit PBIAS_IPXL_TRIM code (0–511)** in **F8h TRIM bytes 14–15** with per-code caching; target **5.2 uA**; ~11 measurements instead of full sweep. Out-of-range target → closest end code + warning.
  - Sets global `DAC_calibration_code` (L1382); returns `0, json` where json = `[best_trim, best_current_uA]`.

### Target 2: `Temp_Sensor_Cal(side)` (TEST_API.lua L2870–3021)
- Currently has an **informal 6-line comment block inside the function body** (L2871–2876) instead of a header.
- Behavior (from code + test plan image "Temperature Sensor Cal (TSR/TSL)"):
  - Trims `<side>_TOP_TRIM[5:0]` and `<side>_BOT_TRIM[5:0]` together (**F8h bytes 25–28**) via binary search over 0–63 until `<side>_DATA_OUT` = 50 °C.
  - Temperature relation from **E1h Temperature State** datasheet: `Code = 392 + 4 * T(°C)` → 50 °C = code **592**. E1h bytes 1–2 = TSL_DATA_OUT[9:0], bytes 3–4 = TSR_DATA_OUT[9:0].
  - Setup: F0h/F1h/FCh keys, **FEh LOGICIPTEST = {0x02, 0x03}**, then the 3× **E0h Temperature Control** write sequence (re-issued inside `measure()` before each read); first E1h read is a dummy.
  - Keeps the other sensor's already-calibrated trim (`TSL_calibration_code` / `TSR_calibration_code`) in the payload.
  - Calls `VPG_SetFlatField(0)` first; sets global `TSR_calibration_code` or `TSL_calibration_code`; returns `0, json` = `[best_trim, best_temp_C]`, or `1, json` for a bad `side` argument.

## Proposed Changes

### Change 1 — TEST_API.lua: insert LuaDoc header directly above `function Pixel_Current_DAC_Cal_binary()` (before L1266)

```lua
--- Calibrates the pixel-current DAC (PBIAS_IPXL_TRIM[8:0], F8h TRIM bytes 14-15)
-- so the AMON-monitored pixel current hits the 5.2 uA target.
-- Routes analog mux Y5 to AMON (GPIO6=1, GPIO3=0, GPIO2=1), enables the analog
-- test path (FDh ANALOGTEST = {0x00, 0x02, 0x94}), then forces constant current
-- with SMU2 and measures the voltage across R_AMUX (100 kOhm):
-- I(uA) = Vmeas / 100k * 1e6.
-- Binary search over the 9-bit trim code (0~511) with per-code result caching,
-- so no code is measured twice (~11 measurements instead of a full sweep).
-- If 5.2 uA lies outside the DAC range, the closest end code is kept and a
-- warning is logged (notFound=1 in the log).
-- The winning code is left written to F8h and stored in global DAC_calibration_code.
-- @usage Pixel_Current_DAC_Cal_binary()   -- stores result in DAC_calibration_code
-- @return number status  Always 0 (out-of-range target is reported in the log only).
-- @return string json    cjson array [best_trim, best_current_uA].
-- @see DAC_Full_Range_Calibration, apply_DAC_calibration_code
```

### Change 2 — TEST_API.lua: insert LuaDoc header directly above `function Temp_Sensor_Cal(side)` (before L2870) and remove the now-redundant inline block at L2871–2876 (its content is folded into the header)

```lua
--- Calibrates one on-chip temperature sensor (TSR or TSL) so its DATA_OUT reads 50'C.
-- Trims <side>_TOP_TRIM[5:0] and <side>_BOT_TRIM[5:0] together with a binary
-- search over 0~63 until <side>_DATA_OUT equals the 50'C code.
-- Temperature relation (E1h datasheet): Code = 392 + 4 * T('C), so 50'C = 592.
-- F8h data : [25] TSL_TOP, [26] TSR_TOP, [27] TSL_BOT, [28] TSR_BOT.
-- E1h data : bytes 1-2 = TSL_DATA_OUT[9:0], bytes 3-4 = TSR_DATA_OUT[9:0].
-- Setup per test plan: F0h/F1h/FCh keys, FEh LOGICIPTEST = {0x02, 0x03}, then the
-- 3x E0h Temperature Control sequence (re-issued before every read; the first E1h
-- read of each measurement is a dummy).
-- If the other sensor was already calibrated, its trim code (TSL_calibration_code /
-- TSR_calibration_code) is preserved in the F8h payload while this side is searched.
-- The winning code is left written to F8h and stored in global TSR_calibration_code
-- or TSL_calibration_code.
-- @param side string  "TSR" (right sensor) or "TSL" (left sensor).
-- @usage Temp_Sensor_Cal("TSR")   -- calibrate right sensor, sets TSR_calibration_code
-- @usage Temp_Sensor_Cal("TSL")   -- calibrate left sensor,  sets TSL_calibration_code
-- @return number status  0 on completion, 1 if side is not "TSR"/"TSL".
-- @return string json    cjson array [best_trim, best_temp_C].
-- @see VPG_SetFlatField
```

## Assumptions & Decisions
- Docs in **English**, matching the reference and existing comments.
- `-- @return` is added although the reference function does not use it — the reference returns nothing, these two return `status, json`; same LDoc style (`-- @return` with space) is kept.
- All **existing body comments stay untouched** (binary-search explanation, caching note, etc.). Only Temp_Sensor_Cal's L2871–2876 block is removed because the header supersedes it.
- `@see` targets chosen from actually-existing functions (`DAC_Full_Range_Calibration` L1403, `apply_DAC_calibration_code` L2340, `VPG_SetFlatField` in IC.lua).
- **Observation only, not changed** (per "don't change the code logic"): the guard at L2903 `if side ~= "TSR" or side ~= "TSL"` is always true (likely intended `and`); flagged here for your awareness, left as-is.
- Exact wording of the two headers above may be fine-tuned at edit time, but structure (summary / details / @param / @usage / @return / @see) and factual content (registers, byte positions, 5.2 uA target, 0–511 / 0–63 ranges, Code = 392 + 4·T) will not change.

## Verification
1. `git diff` shows comment lines only — zero executable lines added/removed/modified.
2. File still parses (visual check of comment syntax; no Lua toolchain assumed on this machine).
3. Both headers render as hover documentation in the IDE (Lua language server picks up `---` blocks).
