module Program_Counter(output reg [7:0] count, input [7:0] data_in, input Load_PC, Inc_PC, clk, rst);
    always @(posedge clk or negedge rst)
    if (!rst)
        count <= 0;
    else if (Load_PC)
        count <= data_in;
    else if (Inc_PC)
        count <= count+1;
endmodule

module Program_Counter_tb;
    reg clk,rst, Load_PC, Inc_PC;
    reg [7:0] data_in;
    wire[7:0] count;
    Program_Counter Test_Counter(count, data_in, Load_PC, Inc_PC, clk, rst);
    initial clk=1'b0;
    always #5 clk=~clk;
    initial begin
                rst=1;Load_PC=0;
        #5      data_in=8'b00000001;
        #5      Load_PC=1;
        #10     Load_PC=0;
        #20     Inc_PC=1;
        #100    Inc_PC=0;
        #5      rst=0;
        #5      rst=1;
        #5      data_in=8'b10000000; 
        #5      Load_PC=1;
        #10     Load_PC=0;
    end
endmodule

