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

module Mux_5_1_tb;
    reg [7:0] in0, in1, in2, in3, in4;
    reg [2:0] sel;
    wire[7:0] out;
    Mux_5_1 Test_Mux (out, in0, in1, in2, in3, in4, sel);
    initial begin
        in0 = 0; in1 = 31; in2 = 63; in3 = 127; in4 = 255;
        #5 sel = 0;
        #5 sel = 1;
        #5 sel = 2;
        #5 sel = 3;
        #5 sel = 4;
    end
endmodule
