# 📄 FSM Design Specification — BLE SoC Power Controller

## 1. Overview

This document describes the finite state machine (FSM) for managing power states in a Bluetooth Low Energy (BLE) System-on-Chip (SoC). The FSM is implemented in Verilog and simulates transitions between key power modes to optimize energy efficiency while maintaining performance.

---

## 2. Power States

| State      | Description                                     | Current Draw | Wakeup Time |
|------------|-------------------------------------------------|--------------|-------------|
| SHUTDOWN   | Almost all power off, slow wake                 | ~100 μA      | ~10 ms      |
| DEEPSLEEP  | RAM retention mode, minimal logic powered       | ~500 μA      | ~1 ms       |
| SLEEP      | Low-power standby, fast wake                    | ~1.5 mA      | ~100 μs     |
| ACTIVE     | Full SoC operation, radio and logic active      | ~10 mA       | <10 μs      |

---

## 3. FSM Architecture

### Inputs:
- `clk` (clock)
- `rst_n` (active-low reset)
- `wake` (external wake-up event)
- `rad_req` (radio request signal)

### Output:
- `state` (enumerated current FSM state)

---

## 4. State Transition Logic

| Current State | Event           | Next State |
|---------------|------------------|------------|
| SHUTDOWN      | `wake = 1`       | DEEPSLEEP  |
| DEEPSLEEP     | `rad_req = 1`    | ACTIVE     |
| ACTIVE        | `rad_req = 0`    | DEEPSLEEP  |
| DEEPSLEEP     | `wake = 0`       | Remain     |
| Others        | `rst_n = 0`      | SHUTDOWN   |

---

## 5. Verilog Implementation

- RTL file: [`rtl/power_fsm.v`](../rtl/power_fsm.v)
- Synchronous design using `always_ff` (Verilog-2012)
- Parameters and enums used for readability

---

## 6. Testbench Overview

Testbench simulates real-world signals:

- Applies `wake` and `rad_req` sequences
- Generates `.vcd` waveform file
- Validates correct transitions across all states

File: [`tb/testbench.v`](../tb/testbench.v)

---

## 7. Waveform Analysis

Waveform output confirms:

- Proper startup in `SHUTDOWN`
- Correct transition to `DEEPSLEEP` on `wake`
- Shift to `ACTIVE` on `rad_req`
- Timeout return to `DEEPSLEEP`

See: [`waveforms/simulation.png`](../docs/waveform/simulation_waveform.png)

---

## 8. Tools & Environment

- Simulator: **Icarus Verilog (`iverilog`)**
- Waveform Viewer: **GTKWave**
- Compatible with Linux, Windows (PowerShell), and WSL

---

## 9. Future Improvements

- Add `SLEEP` state handling
- Parametrize timing (delays, counters)
- Integrate with TI BLE firmware stack (future hardware test)

---

## 10. Author

**Abhishek Kujur**  
[Email](mailto:abhishekkujur@gmail.com)
