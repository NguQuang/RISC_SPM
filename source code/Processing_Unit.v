module Processing_Unit(
    output [7:0] instruction, address, Bus_1,
    output Zflag,
    input [7:0] mem_word,
    input Load_R0, Load_R1, Load_R2, Load_R3, Load_PC, Inc_PC,
    input Load_IR, Load_Add_R, Load_Reg_Y, Load_Reg_Z,
    input [2:0] Sel_Bus_1_Mux,
    input [1:0] Sel_Bus_2_Mux,
    input clk, rst
);
    wire [7:0] Bus_2, R0_out, R1_out, R2_out, R3_out, PC_count, Y_out, ALU_out;
    wire ALU_Zflag;
    wire [3:0] opcode = instruction [7:4];
    
    Register_Unit R0(R0_out, Bus_2,Load_R0, clk,rst);
    Register_Unit R1(R1_out, Bus_2,Load_R1, clk,rst);
    Register_Unit R2(R2_out, Bus_2,Load_R2, clk,rst);
    Register_Unit R3(R3_out, Bus_2,Load_R3, clk,rst);
    Register_Unit Reg_Y(Y_out, Bus_2, Load_Reg_Y, clk, rst);
    Register_Unit Add_R(address, Bus_2, Load_Add_R, clk, rst);
    Register_Unit IR(instruction, Bus_2, Load_IR, clk, rst);

    D_ff Reg_Z(Zflag, ALU_Zflag, Load_Reg_Z, clk,rst);

    Program_Counter PC(PC_count, Bus_2, Load_PC, Inc_PC, clk, rst);
    
    Mux_5_1 Mux_1(Bus_1, R0_out, R1_out, R2_out,  R3_out, PC_count, Sel_Bus_1_Mux);
    Mux_3_1 Mux_2(Bus_2, ALU_out, Bus_1, mem_word, Sel_Bus_2_Mux);

    Arithmetic_Logic_Unit ALU(ALU_out, ALU_Zflag, Y_out, Bus_1, opcode);
endmodule


