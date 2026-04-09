# SAYEH-Cache

A 2-way set-associative cache memory subsystem implemented in VHDL, designed to interface with the SAYEH (Simple Architecture Yet Enough Hardware) processor. The design includes a fully functional cache hierarchy with a write-allocate policy, an MRU-based replacement policy, and a cache controller that arbitrates between the cache and a backing main memory.

---

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
  - [Address Breakdown](#address-breakdown)
  - [Block Diagram](#block-diagram)
- [Module Descriptions](#module-descriptions)
- [Signal Reference](#signal-reference)
- [Replacement Policy](#replacement-policy)
- [Testbench](#testbench)
- [Getting Started](#getting-started)
- [Authors](#authors)

---

## Overview

| Parameter         | Value                     |
|-------------------|---------------------------|
| Cache type        | 2-way set-associative     |
| Number of sets    | 64                        |
| Line (word) size  | 32 bits                   |
| Tag width         | 4 bits                    |
| Index width       | 6 bits                    |
| Cache address bus | 10 bits                   |
| System address bus| 16 bits                   |
| Data bus width    | 32 bits                   |
| Replacement policy| Most Recently Used (MRU)  |
| Write policy      | Write-allocate            |
| Main memory size  | 1024 × 32-bit words       |
| HDL               | VHDL (IEEE 1076)          |

---

## Architecture

### Address Breakdown

The `cacheController` accepts a **16-bit** system address. Bits `[15:6]` are forwarded to the `Cache` entity as a **10-bit** cache address, which is interpreted as follows:

```
 15        10   9          6   5              0
 ┌──────────────┬────────────┬────────────────┐
 │  (unused)    │  Tag [3:0] │  Index [5:0]   │
 └──────────────┴────────────┴────────────────┘
                  ↑ 4 bits      ↑ 6 bits
                  Selects tag   Selects 1-of-64 sets
```

Each set holds **2 ways**. Each way stores one 32-bit data word and a 5-bit tag/valid entry (`{valid, tag[3:0]}`).

### Block Diagram

```
                         ┌─────────────────────────────────────────────┐
                         │               cacheController               │
                         │                                             │
   clock ──────────────► │                                             │
   readmem ─────────────►│  ┌───────────────────────────────────────┐  │
   writemem ────────────►│  │                  Cache                │  │
   reset_n ─────────────►│  │                                       │  │
   address[15:0] ───────►│  │  ┌──────────┐      ┌──────────┐       │  │
   databus[31:0] ◄──────►│  │  │ dataArray│(Way0)│ dataArray│(Way1) │  │
                         │  │  └────┬─────┘      └────┬─────┘       │  │
                         │  │       │                  │            │  │
                         │  │  ┌────┴─────┐      ┌────┴─────┐       │  │
                         │  │  │tagValid  │(Way0)│tagValid  │(Way1) │  │
                         │  │  │  Array   │      │  Array   │       │  │
                         │  │  └────┬─────┘      └────┬─────┘       │  │
                         │  │       └──────┬───────────┘            │  │
                         │  │        ┌─────▼──────┐                 │  │
                         │  │        │missHitLogic│                 │  │
                         │  │        └─────┬──────┘                 │  │
                         │  │        ┌─────▼──────┐                 │  │
                         │  │        │dataSelection│                │  │
                         │  │        └─────┬──────┘                 │  │
                         │  │        ┌─────▼──────┐                 │  │
                         │  │        │ MRUPolicy  │                 │  │
                         │  │        └────────────┘                 │  │
                         │  └───────────────────────────────────────┘  │
                         │                                             │
                         │  ┌───────────────────────────────────────┐  │
                         │  │         memory (main memory)          │  │
                         │  └───────────────────────────────────────┘  │
                         └─────────────────────────────────────────────┘
```

---

## Module Descriptions

### `cacheController.vhd`
Top-level integration module. Connects the `Cache` and `memory` components and implements the read/write arbitration logic:

- **Read hit**: Data is returned directly from the cache.
- **Read miss**: Waits for main memory (`memdataready`), forwards the data to the CPU, and writes it into the cache (write-allocate).
- **Write**: Data is always written into the cache. On a miss, the data is also written to main memory.

| Port        | Direction | Width | Description                          |
|-------------|-----------|-------|--------------------------------------|
| `clock`     | in        | 1     | System clock                         |
| `readmem`   | in        | 1     | Asserted to initiate a read          |
| `writemem`  | in        | 1     | Asserted to initiate a write         |
| `reset_n`   | in        | 1     | Active-high synchronous reset        |
| `address`   | in        | 16    | Memory address                       |
| `databus`   | inout     | 32    | Shared data bus                      |

---

### `Cache.vhd`
The core 2-way set-associative cache. Instantiates two data arrays, two tag/valid arrays, miss/hit logic, data selection, and the MRU policy engine. The internal process controls write-enable signals to each way based on occupancy and the replacement decision.

| Port         | Direction | Width | Description                          |
|--------------|-----------|-------|--------------------------------------|
| `clock`      | in        | 1     | System clock                         |
| `reset_n`    | in        | 1     | Active-high synchronous reset        |
| `writeCache` | in        | 1     | Write enable                         |
| `address`    | in        | 10    | Cache address (`{tag[3:0], index[5:0]}`) |
| `dataIn`     | in        | 32    | Data to write into the cache         |
| `data`       | out       | 32    | Data read from the cache             |
| `hit`        | out       | 1     | Asserted when address hits in cache  |

---

### `dataArray.vhd`
A synchronous 64 × 32-bit RAM used to store cache line data for one way. On a rising clock edge, if `wren` is high, the word at `address` is updated with `wrdata`; otherwise the stored word is driven on `data`.

| Port      | Direction | Width | Description                      |
|-----------|-----------|-------|----------------------------------|
| `clock`   | in        | 1     | System clock                     |
| `address` | in        | 6     | Set index (0–63)                 |
| `wren`    | in        | 1     | Write enable                     |
| `wrdata`  | in        | 32    | Data to write                    |
| `data`    | out       | 32    | Data read from the selected set  |

---

### `tagValidArray.vhd`
A synchronous 64 × 5-bit RAM storing `{valid, tag[3:0]}` for one way. A reset clears all entries. The `invalidate` input forces the valid bit low when writing.

| Port        | Direction | Width | Description                          |
|-------------|-----------|-------|--------------------------------------|
| `clock`     | in        | 1     | System clock                         |
| `reset_n`   | in        | 1     | Active-high synchronous reset (clears all entries) |
| `address`   | in        | 6     | Set index (0–63)                     |
| `wren`      | in        | 1     | Write enable                         |
| `invalidate`| in        | 1     | When high during a write, clears the valid bit |
| `wrdata`    | in        | 4     | Tag to write                         |
| `data_out`  | out       | 5     | `{valid, tag[3:0]}` for selected set |

---

### `missHitLogic.vhd`
Combinational logic that compares the requested tag against both ways' stored tag/valid entries to produce a hit signal and per-way validity flags.

| Port       | Direction | Width | Description                            |
|------------|-----------|-------|----------------------------------------|
| `tag`      | in        | 4     | Tag from the incoming address          |
| `w0`       | in        | 5     | `{valid, tag}` from way 0              |
| `w1`       | in        | 5     | `{valid, tag}` from way 1              |
| `hit`      | out       | 1     | High if tag matches a valid entry      |
| `w0_valid` | out       | 1     | High if hit is in way 0                |
| `w1_valid` | out       | 1     | High if hit is in way 1                |

---

### `dataSelection.vhd`
Selects the output data word from the way that produced a hit, and reports which way was selected (used by the MRU policy).

| Port          | Direction | Width | Description                      |
|---------------|-----------|-------|----------------------------------|
| `clock`       | in        | 1     | System clock                     |
| `data0`       | in        | 32    | Data from way 0                  |
| `data1`       | in        | 32    | Data from way 1                  |
| `w0_valid`    | in        | 1     | Way 0 hit indicator              |
| `w1_valid`    | in        | 1     | Way 1 hit indicator              |
| `data`        | out       | 32    | Selected data output             |
| `selectedWay` | out       | 1     | `0` = way 0 selected, `1` = way 1|

---

### `MRUPolicy.vhd`
Tracks the most recently used way and outputs the way to evict on a miss when both ways are occupied. On each rising clock edge, the `recentUsed` signal is latched; the `replace` output indicates the *other* way as the eviction candidate.

| Port         | Direction | Width | Description                                |
|--------------|-----------|-------|--------------------------------------------|
| `clock`      | in        | 1     | System clock                               |
| `recentUsed` | in        | 1     | Which way was last accessed (`0`=way0, `1`=way1) |
| `replace`    | out       | 1     | Way to evict on the next miss              |

---

### `memory.vhd`
A simple synchronous main memory model (1024 × 32-bit words) with a 16-bit address bus. `memdataready` is asserted one cycle after a valid read or write command.

| Port           | Direction | Width | Description                     |
|----------------|-----------|-------|---------------------------------|
| `clk`          | in        | 1     | System clock                    |
| `readmem`      | in        | 1     | Read enable                     |
| `writemem`     | in        | 1     | Write enable                    |
| `addressbus`   | in        | 16    | Memory address                  |
| `databus`      | inout     | 32    | Bidirectional data bus          |
| `memdataready` | out       | 1     | High when data is ready         |

---

### `testBench.vhd`
A self-contained simulation testbench that instantiates `cacheController` and exercises a basic write-then-read sequence:

1. **Reset** (`reset_n = '1'`) for the first 10 ns.
2. **Write** phase (`writemem = '1'`): address `0x0000`, data `0x00FF00FF` for 100 ns.
3. **Read** phase (`readmem = '1'`): address `0xFFFF` for 100 ns, expecting the previously written data to be returned from cache.

The clock runs at **100 MHz** (10 ns period) for a total simulation window of 10 µs.

---

## Replacement Policy

The **MRU (Most Recently Used)** policy tracks which of the two ways was last accessed. On a cache miss when both ways are occupied:

- The way that was **not** most recently used is selected for eviction.
- `recentUsed` is updated on every read (via `selectedWay`) and every write.

This effectively implements **LRU (Least Recently Used)** behaviour in a 2-way cache, since with only two ways, the least recently used way is always the complement of the most recently used way.

---

## Getting Started

### Prerequisites

- A VHDL simulator such as [GHDL](https://ghdl.github.io/ghdl/), ModelSim, or Questa.
- (Optional) [GTKWave](http://gtkwave.sourceforge.net/) for waveform visualisation.

### Simulate with GHDL

```bash
# Analyse all source files
ghdl -a tagValidArray.vhd
ghdl -a dataArray.vhd
ghdl -a missHitLogic.vhd
ghdl -a dataSelection.vhd
ghdl -a MRUPolicy.vhd
ghdl -a Cache.vhd
ghdl -a memory.vhd
ghdl -a cacheController.vhd
ghdl -a testBench.vhd

# Elaborate the testbench
ghdl -e testBench

# Run the simulation and dump a VCD waveform
ghdl -r testBench --vcd=wave.vcd --stop-time=10000ns

# View the waveform
gtkwave wave.vcd
```

---

## Authors

| Name                  | Email                          | Contribution              |
|-----------------------|--------------------------------|---------------------------|
| Mohammad Mahdi Rahimi | mohammadmahdi76@gmail.com      | Cache design & controller |
| Parham Alvani         | parham.alvani@gmail.com        | Main memory module        |
