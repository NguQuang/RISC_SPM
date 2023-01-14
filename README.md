# RISC-SPM
>A final project of the course "Digital Design using VHDL"
## Overview
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

The address register ()

The Overall Architecture of a simple RISC-SPM is shown below

![Architecture RISC-SPM](https://github.com/canh25xp/RISC-SPM/blob/main/assets/RISC-SPM.png)


## Control Unit
Functions of the control unit:
- Determine when to load registers
- Select the path of data through the multiplexers
- Determine when data should be written to memory
- Control the three-state busses in the architecture.

![Control Signals](https://github.com/canh25xp/RISC-SPM/blob/main/assets/Control_Signals.png)

