module RISC_SPM(input clk,rst);
    wire [2:0] Sel_Bus_1_Mux; //5 to 1 multiplexer
    wire [1:0] Sel_Bus_2_Mux; //3 to 1 multiplexer
    wire [7:0] instruction, address, Bus_1, mem_word; 
    wire Load_R0, Load_R1, Load_R2, Load_R3, Load_PC, Inc_PC, Load_IR, Load_Add_R, Load_Reg_Y, Load_Reg_Z, write, Zflag;

    Control_Unit Controller(
        Load_R0, Load_R1, Load_R2, Load_R3, Load_PC, Inc_PC, Load_IR, Load_Add_R, Load_Reg_Y, Load_Reg_Z, write,
        Sel_Bus_1_Mux,
        Sel_Bus_2_Mux,
        instruction,
        Zflag, clk, rst
    );

    Processing_Unit Processor(
        instruction, address, Bus_1,
        Zflag,
        mem_word,
        Sel_Bus_1_Mux,
        Sel_Bus_2_Mux,
        Load_R0, Load_R1, Load_R2, Load_R3, Load_PC, Inc_PC, Load_IR, Load_Add_R, Load_Reg_Y, Load_Reg_Z, clk, rst
    );

    Memory_Unit Ram(
        mem_word,
        Bus_1, address,
        write, clk
    );
endmodule
