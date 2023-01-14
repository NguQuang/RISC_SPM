module Register_Unit(output reg [7:0] data_out, input [7:0] data_in, input load, clk, rst);
    always @(posedge clk or negedge rst)
    if (!rst)
        data_out <= 0;
    else if (load)
        data_out <= data_in;
endmodule

module Register_Unit_tb;
    reg clk,rst, load;
    reg [7:0] data_in = 8'b00110011;
    wire [7:0] data_out;
    Register_Unit Test_Register(data_out, data_in, load, clk, rst);
    initial clk=1'b0;
    always #5 clk=~clk;
    initial begin
            rst=1'b1; load=0'b0;
        #17 load=1'b1;
        #21 load=0'b0;
        #15 data_in = 8'b11001100;
        #3  load=1'b1;
        #5  load=0'b0;
        #10 rst=0'b0;
        #10 $stop;
    end
endmodule

