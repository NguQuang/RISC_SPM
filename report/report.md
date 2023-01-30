# **I. Overview**
Reduced instruction-set computers (RISC) are designed to have a small set of instructions that execute in short clock cycles, with a small number of cycles per instruction. RISC machines are optimized to achieve efficient pipelining of their instruction streams. The machine also serves as a starting point for developing architectural variants and a more robust instruction set. Designers make high-level tradeoffs in selecting an architecture that serves an
application. Once an architecture has been selected, a circuit that has sufficient performance (speed) must be synthesized. Hardware description languages (HDLs) play a key role in this process by modeling the system and serving as a descriptive medium
that can be used by a synthesis tool.

# **II. Hardware composition**

RISC-SPM or Reduced Instruction Set Computer Store Program Machine consists of three functional units :
1. Processing Unit ( Processor )
2. Controll Unit ( Controller )
3. Memory Unit ( RAM )

The Overall Architecture of a simple RISC-SPM is shown below

![Architecture RISC-SPM](https://raw.githubusercontent.com/canh25xp/RISC-SPM/main/assets/RISC-SPM.png)

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

## **1. Processing Unit**
The processor includes *registers*, *buses*, *control lines*, and an *ALU* capable of performing arithmetic and logic operations on its operands depends on the opcode held in the instruction register.

### 1.1 Arithmetic Logic Unit

For the purposes of this example, the ALU has two operand datapaths, data_1 and data_2, and its instruction set is limited to only 4 instructions, that is :

Opcode|Action
-|-
ADD | Adds the datapaths to form data_1 + data_2
SUB | Subtracts the datapaths to form data_1 - data_2
AND | Takes the bitwise and of the datapaths data_1 & data_2
NOT | Takes the bitwise Boolean complement of data_1

```verilog
module Arithmetic_Logic_Unit(
    output reg [7:0] ALU_out,
    output ALU_Zflag,
    input [7:0] data_1, data_2,
    input [3:0] opcode
);
    
    assign ALU_Zflag = ~|ALU_out; //reduction nor
    always @(opcode or data_1 or data_2) begin
        case(opcode)
            `ADD :      ALU_out = data_2 + data_1;
            `SUB :      ALU_out = data_2 - data_1;
            `AND :      ALU_out = data_1 & data_2;
            `NOT :      ALU_out = ~ data_1;
            default :   ALU_out = 0;
        endcase
    end
endmodule 
```

### 1.2. Register Unit

There are 9 registers in our design :
- 5 general-purpose registers R0, R1, R2, R3, Reg_y ( 8-bit )
- 3 special purpose register PC, IR, Add_R ( 8-bit )
- 1 flag register Reg_Z ( 1-bit )

All register has a load signal to store data, a clock signal (clk) to synchronize and a reset signal (rst) to erase data (all bits are set to 0)

The zero flag register Reg_Z is a 1-bit register, so basically it is a D flip flop.

The Program Counter Register (PC) has an additional signal Inc_PC to increase PC by 1 unit.

```verilog
module Register_Unit(output reg [7:0] data_out, input [7:0] data_in, input load, clk, rst);
    always @(posedge clk or negedge rst)
    if (!rst)
        data_out <= 0;
    else if (load)
        data_out <= data_in;
endmodule
```

```verilog
module D_ff(output reg data_out, input data_in, load, clk, rst);
    always @(posedge clk or negedge rst)
    if (!rst)
        data_out <= 0;
    else if (load)
        data_out <= data_in;
endmodule
```

```verilog
module Program_Counter(output reg [7:0] count, input [7:0] data_in, input Load_PC, Inc_PC, clk, rst);
    always @(posedge clk or negedge rst)
    if (!rst)
        count <= 0;
    else if (Load_PC)
        count <= data_in;
    else if (Inc_PC)
        count <= count+1;
endmodule
```

### 1.3. Multiplexer

There are 2 multiplexers in the Processing Unit : 
- Mux_1 : it's a 5-1 multiplexer
    - Output : Bus_1
    - Input : R0, R1, R2, R3, PC
- Mux_2 : it's a 3-1 multiplexer
    - Output : Bus_2
    - Input : ALU's output, Bus_1

```verilog
module Mux_3_1 (output reg [7:0] out, input [7:0] in0, in1, in2, input [1:0] sel);
    always @(in0 or in1 or in2 or sel)
    case(sel)
        2'b00 : out = in0;
        2'b01 : out = in1;
        2'b10 : out = in2;
        default : out = 'bx;
    endcase
endmodule
```

```verilog
module Mux_5_1 (output reg [7:0] out, input [7:0] in0, in1, in2, in3, in4, input [2:0] sel);
    always @(in0 or in1 or in2 or in3 or in4 or sel)
    case(sel)
        3'b000 : out = in0;
        3'b001 : out = in1;
        3'b010 : out = in2;
        3'b011 : out = in3;
        3'b100 : out = in4;
        default : out = 'bx;
    endcase
endmodule
```

An instruction can be fetched from memory, placed on Bus_2, and loaded into the instruction register. A word of data can be fetched from memory, and steered to a general-purpose register or to the operand register (Reg_Y) prior to an operation of the ALU. The result of an ALU operation can be placed on Bus_2, loaded into a register, and subsequently transferred to memory. A dedicated register (Reg_Z) holds a flag indicating that the result of an ALU operation is 0.

## **2. Control Unit**

### 2.1. Functions of the control unit :

1. Determine when to load registers
2. Select the path of data through the multiplexers
3. Determine when data should be written to memory
4. Control the three-state busses in the architecture.

### 2.2. Control Signals :

Control Signal|Action
-|-
Load_Add_R|Loads the Address Register
Load_PC|Loads Bus_2 to the Program Counter
Load_IR|Loads Bus_2 to the Instruction Register
Inc_PC|Increments the Program Counter
Sel_Bus_1_Mux|Selects among the Program Counter, R0, R1, R2, and R3 to drive Bus_1
Sel_Bus_2_Mux|Selects among ALU_out, Bus_1, and memory to drive Bus_2
Load_R0|Loads general purpose register R0
Load_R1|Loads general purpose register R1
Load_R2|Loads general purpose register R2
Load_R3|Loads general purpose register R3
Load_Reg_Y|Loads Bus_2 to the register Reg_Y
Load_Reg_Z|Stores the zero Flag of ALU in register Reg_Z
write|Loads Bus_1 into the memory

### 2.3. Instruction Set

A machine language program consists of a stored sequence of 8-bit words (bytes). The format of an instruction of RISC_SPM can be long or short, depending on the operation : 
- Short instructions : requires 1 byte of memory to specifies 4-bit opcode, 2-bit source register address, a 2-bit destination register address.
- Long instruction : requires 2 bytes of memory. The first word of a long instruction contains a 4-bit opcode. The remaining 4 bits of the word can be used to specify addresses of a pair of source and destination registers, depending on the instruction. The second word contains the address of the memory word that holds an operand required by the instruction

Opcode|Dst|Src
-|-|-
0  0 1 0|0 1|1 0

Opcode|Dst|Src|Address
-|-|-|-
0 1 1 0|x x|1 0|0 0 0 1 1 1 0 1

The instruction mnemonics and their actions are listed below.

Short instruction|Action
-|-
NOP|No operation is performed; all registers retain their values. The addresses of the source and destination register are don't-cares, they have no effect.
ADD|Adds the contents of the source and destination registers and stores the result into the destination register.
SUB|Subtracts the content of the source register from the destination register and stores the result into the destination register.
AND|Forms the bitwise and of the contents of the source and destination registers and stores the result into the destination register.
NOT|Forms the bitwise complement of the content of the source register and stores the result into the destination register.
HALT|Halts execution until reset

Long instruction|Action
-|-
RD|Reads a word from the location specified by the second byte and loads the result into the destination register. The source register bits are don't-cares.
WR|Writes the contents of the source register to the word in memory specified by the address held in the second byte. The destination register bits are don't-cares.
BR|Branches the activity flow by loading the program counter with the word at the address specified by the second byte of the instruction. The source and destination bits are don't-cares.
BRZ|Branches if the zero flag register is asserted.

The RISC_SPM instruction set is summarized below.

Ins|Opcode|Dst|Src|Action
-|-|-|-|-
NOP|0000|xx|xx|none
ADD|0001|dst|src|dst <= src + dst
SUB|0010|dst|src|dst <= dst - src
AND|0011|dst|src|dst <= src && dst
NOT|0100|dst|src|dst <= ~ src
RD|0101|dst|xx|dst <= memory [Add_R]
WR|0110|xx|src|memory[Add_R] < = src
BR|0111|xx|xx|PC <= memory[Add_R]
BRZ|1000|xx|xx|PC <= memory[Add_R]
HALT|1111|xx|xx|Halts execution until reset (Finish programm)


### 2.4. Controller States
Three phases of operation: fetch, decode, and execute.
- Fetching : Retrieves an instruction from memory (2 clock cycles)
- Decoding : Decodes the instruction, manipulates datapaths ,and loads registers (1 clock cycle)
- Execution : Generates the results of the instruction (0, 1 or 2 clock cycles)
    - ALU operations
    - Update storage registers
    - Update program counter (PC)
    - Update the instruction register (IR)
    - Update the address register (ADD_R)
    - Update memory
    - Control datapaths

State|Action
-|-
idle|State entered after reset is asserted. No action.
fet1|Load the Add_R with the contents of the PC. (Note: PC is initialized to the starting address 00H by the reset action.) The state is entered at the first active clock after reset is de-asserted, and is revisited after a NOP instruction is decoded.
fet2|Load the IR with the word addressed by the Add_R, and increment the PC to point to the next location in memory, in anticipation of the next instruction or data fetch.
dec|Decode the IR and assert signals to control datapaths and register transfers.
exe|Execute the ALU operation for a single-byte instruction, conditionally assert the zero flag, and load the destination register.
rd1|Load the Add_R with the second byte of a RD instruction, and increment the PC.
rd2|Load the destination register with the memory word addressed by the byte loaded in rd1.
wr1|Load the Add_R with the second byte of a WR instruction, and increment the PC.
wr2|Load the source register with the memory word addressed by the byte loaded in wr1.
br1|Load the Add_R with the second byte of a BR instruction, and increment the PC.
br2|Load the PC with the memory word addressed by the byte loaded in br1.
halt|Default state to trap failure to decode a valid instruction.

### 2.5. State transition diagram

![State transition diagram](https://raw.githubusercontent.com/canh25xp/RISC-SPM/main/assets/State_Transitions.drawio.png)

### 2.6. ASM chart

![ASM](https://raw.githubusercontent.com/canh25xp/RISC-SPM/main/assets/ASM.drawio.png)

## **3. Memory Unit**

For simplicity, the memory unit of the machine is modeled as an array of D flip-flops that form a **256 bytes** RAM.

```verilog
module Memory_Unit(
    output [7:0] data_out,
    input [7:0] data_in, address,
    input write, clk
);

    reg [7:0] memory [255:0]; //256 bytes ram

    always @(posedge clk) begin
        if(write)
            memory[address] <= data_in;            
    end
    assign data_out = memory[address];
endmodule
```

# **III. Design verification**

To ensure the working of the machine, each module has it own testbench : Memory Unit, Control Unit, Register Unit, Arithmetic Logic Unit. 

## 1. Waveform

![Wave form](https://raw.githubusercontent.com/canh25xp/RISC-SPM/main/assets/waveform.png)

## 2.Schematic

![Schematic](https://raw.githubusercontent.com/canh25xp/RISC-SPM/main/assets/Schematic.png)

## 3.Memory Data

![Memory Data](https://raw.githubusercontent.com/canh25xp/RISC-SPM/main/assets/memory_data.png)


