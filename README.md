# RISC-SPM
>A final project of the course "Digital Design using VHDL"
## Introduction
RISC-SPM or Reduced Instruction Set Computer Store Program Machine consists of three functional units :
- Processor
- Controller
- Memory

![Architecture RISC-SPM](https://github.com/canh25xp/RISC-SPM/blob/main/assets/RISC-SPM.png)

Program instructions and data are stored in memory

Instructions are fetched from memory synchronously, decoded and executed to : 
- Operate on data with ALU
- Change the contents of storage registers
- Change the content of the program counter (PC), instruction register (IR) and the address register (ADD_R)
- Change the content of memory
- Retrieve data and instructions from memory
- Control the movement of data on the system busses



