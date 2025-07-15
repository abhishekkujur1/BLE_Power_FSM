# 🔋 BLE SoC Power Controller FSM

![State Diagram](docs/fsm1.png)  
*Power state transition diagram*

A Verilog implementation of a power management finite state machine for Bluetooth Low Energy (BLE) SoCs, featuring four optimized power states.

## 📁 Project Structure
```
FSM/
├── rtl/                # Design source
│ └── power_fsm.v       # Main FSM implementation
├── tb/                 # Testbench
│ └── testbench.v       # Verification environment
├── docs/               # Documentation
│ ├── spec.md           # Design specifications
│ └── state_diagram.png
└── waveforms/          # Sample outputs
  └── simulation.png    # GTKWave screenshot
```


---

## 🚀 Quick Start

### 💻 Run Simulation with Icarus Verilog

```bash
# Compile the design and testbench
iverilog -g2012 -o sim.out rtl/power_fsm.v tb/testbench.v

# Run the simulation
vvp sim.out

# View waveform 
gtkwave waves.vcd
```

## 📊 Simulation Results
![GTKWave Screenshot](docs/waveform/simulation_waveform.png)  


## 📊 Power State Definitions

| State       | Current Draw | Wakeup Time | Description                              |
| ----------- | ------------ | ----------- | ---------------------------------------- |
| `SHUTDOWN`  | \~100 μA     | \~10 ms     | Almost completely powered off            |
| `DEEPSLEEP` | \~500 μA     | \~1 ms      | Memory retention, lowest dynamic power   |
| `SLEEP`     | \~1.5 mA     | \~100 μs    | Ready to wake quickly, some logic active |
| `ACTIVE`    | \~10 mA      | <10 μs      | Full operation mode                      |

## 🧪 Testbench Behavior

The simulation drives the FSM through realistic event transitions using the following signals:

    WAKE — user/system wakeup event

    RAD_REQ — BLE radio activity request

    RESET — FSM reset signal

## 🧠 Key Features

✅ FSM design with clean, synchronous transitions

✅ Verilog-2001/2012 compatible

✅ Testbench driven by real-world event patterns

✅ Waveform visualization via GTKWave

✅ Designed with BLE power constraints in mind
