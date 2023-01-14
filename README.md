# RISC-SPM
>A final project of the course "Digital Design using VHDL"
## Overview
Reduced instruction-set computers (RISC) are designed to have a small set of instructions that execute in short clock cycles, with a small number of cycles per instruction. RISC machines are optimized to achieve efficient pipelining of their instruction streams. The machine also serves as a starting point for developing architectural variants and a more robust instruction set. Designers make high-level tradeoffs in selecting an architecture that serves an
application. Once an architecture has been selected, a circuit that has sufficient performance (speed) must be synthesized. Hardware description languages (HDLs) play a key role in this process by modeling the system and serving as a descriptive medium
that can be used by a synthesis tool.

RISC-SPM or Reduced Instruction Set Computer Store Program Machine consists of three functional units :
- Processor
- Controller
- Memory

Program instructions and data are stored in memory

Instructions are fetched from memory synchronously, decoded and executed to : 
- Operate on data with ALU
- Change the contents of storage registers
- Change the content of the program counter (PC), instruction register (IR) and the address register (ADD_R)
- Change the content of memory
- Retrieve data and instructions from memory
- Control the movement of data on the system busses

The Program Counter (PC) contains the address of the next instruction to be executed

The Instruction Register (IR) contains the instruction that currently being executed

The address register (Add_R) contains the address of the memory location that will be addressed next by a read or write operation.

The Overall Architecture of a simple RISC-SPM is shown below

![Architecture RISC-SPM](https://github.com/canh25xp/RISC-SPM/blob/main/assets/RISC-SPM.png)


## Control Unit
Functions of the control unit:
- Determine when to load registers
- Select the path of data through the multiplexers
- Determine when data should be written to memory
- Control the three-state busses in the architecture.

![Control Signals](https://github.com/canh25xp/RISC-SPM/blob/main/assets/Control_Signals.png)

