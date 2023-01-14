module Mux_3_1 (output reg [7:0] out, input [7:0] in0, in1, in2, input [1:0] sel);
    always @(in0 or in1 or in2 or sel)
    case(sel)
        2'b00 : out = in0;
        2'b01 : out = in1;
        2'b10 : out = in2;
        default : out = 'bx;
    endcase
endmodule

module Mux_3_1_tb;
    reg [7:0] in0, in1, in2;
    reg [1:0] sel;
    wire [7:0] out;
    Mux_3_1 Test_Mux (out, in0, in1, in2, sel);
    initial begin
        in0 = 0; in1 = 128; in2 = 255;
        #5 sel = 2'b00;
        #5 sel = 2'b01;
        #5 sel = 2'b10;
        #5 sel = 2'b11;
    end
endmodule

