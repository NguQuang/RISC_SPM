`define NOP     4'b0000 
`define ADD     4'b0001
`define SUB     4'b0010
`define AND     4'b0011
`define NOT     4'b0100
`define RD      4'b0101
`define WR      4'b0110
`define BR      4'b0111
`define BRZ     4'b1000
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
            `NOT :      ALU_out =        ~ data_2;
            default :   ALU_out = 0;
        endcase
    end
endmodule 

module Arithmetic_Logic_Unit_tb;
    reg [7:0] data_1, data_2;
    reg [3:0] opcode;
    wire[7:0] out;
    wire      Zflag;            
    Arithmetic_Logic_Unit ALU(out, Zflag, data_1, data_2, opcode);
    initial begin
        #0 data_1 = 64; data_2 = 128; opcode = `NOP;
        // 64 =  01000000
        // 128 = 10000000
        #5 opcode = `ADD; //result should be 192
        #5 opcode = `SUB; //result should be 64
        #5 opcode = `AND; //result should be 0
        #5 opcode = `NOT; //result should be 127
    end
endmodule