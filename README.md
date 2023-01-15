# RISC-SPM
>A final project of the course "Digital Design using VHDL"
## **Overview**
Reduced instruction-set computers (RISC) are designed to have a small set of instructions that execute in short clock cycles, with a small number of cycles per instruction. RISC machines are optimized to achieve efficient pipelining of their instruction streams. The machine also serves as a starting point for developing architectural variants and a more robust instruction set. Designers make high-level tradeoffs in selecting an architecture that serves an
application. Once an architecture has been selected, a circuit that has sufficient performance (speed) must be synthesized. Hardware description languages (HDLs) play a key role in this process by modeling the system and serving as a descriptive medium
that can be used by a synthesis tool.

RISC-SPM or Reduced Instruction Set Computer Store Program Machine consists of three functional units :
1. Processing Unit ( Processor )
2. Controll Unit ( Controller )
3. Memory Unit ( RAM )

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

## **Processing Unit**
The processor includes *registers*, *buses*, *control lines*, and an *ALU* capable of performing arithmetic and logic operations on its operands depends on the opcode held in the instruction register.

There are 2 multiplexers in the Processing Unit : 
- Mux_1 : it's a 5-1 multiplexer
    - Output : Bus_1
    - Input : R0, R1, R2, R3, PC
- Mux_2 : it's a 3-1 multiplexer
    - Output : Bus_2
    - Input : ALU's output, Bus_1

An instruction can be fetched from memory, placed on Bus_2, and loaded into the instruction register. A word of data can be fetched from memory, and steered to a general-purpose register or to the operand register (Reg_Y) prior to an operation of the ALU. The result of an ALU operation can be placed on Bus_2, loaded into a register, and subsequently transferred to memory. A dedicated register (Reg_Z) holds a flag indicating that the result of an ALU operation is 0.

## **Arithmetic Logic Unit**
For the purposes of this example, the ALU has two operand datapaths, data_1 and data_2, and its instruction set is limited to only 4 instructions, that is :
Opcode|Action
-|-
ADD | Adds the datapaths to form data_1 + data_2
SUB | Subtracts the datapaths to form data_1 - data_2
AND | Takes the bitwise and of the datapaths data_1 & data_2
NOT | Takes the bitwise Boolean complement of data_1

## **Control Unit**
### Functions of the control unit:
1. Determine when to load registers
2. Select the path of data through the multiplexers
3. Determine when data should be written to memory
4. Control the three-state busses in the architecture.

### Control Signals :
Control Signal|Action
-|-
Load_Add_R|Loads the address register
Load_PC|Loads Bus_2to the program counter
Load_IR|Loads Bus_2 to the instruction register
Inc_PC|Increments the program counter
Sel_Bus_1_Mux | Selects among the Program_Counter, R0, R1, R2, and R3 to drive Bus_1
Sel_Bus_2_Mux|Selects among Alu_out, Bus_1, and memory to drive Bus_2
Load_R0|Loads general purpose register R0
Load_R1|Loads general purpose register R1
Load_R2|Loads general purpose register R2
Load_R3|Loads general purpose register R3
Load_Reg_Y|Loads Bus_2 to the register Reg_Y
Load_Reg_Z|Stores output of ALU in register Reg_Z
write|Loads Bus_1 into the SRAM memory

### Instruction Set
...
### Controller States
...
### Controller ASM
...

## **Memory Unit**
For simplicity, the memory unit of the machine is modeled as an array of D flip-flops that form a **256 bytes** RAM 

## **Testbench**
To ensure the working of the machine, each module has it own testbench : Memory Unit, Control Unit, Register Unit, Arithmetic Logic Unit.