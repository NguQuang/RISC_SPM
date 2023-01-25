module D_ff(output reg data_out, input data_in, load, clk, rst);
    always @(posedge clk or negedge rst)
    if (!rst)
        data_out <= 0;
    else if (load)
        data_out <= data_in;
endmodule

module D_ff_tb;
    reg clk, rst, data_in, load;
    wire data_out;
    D_ff Test_D_ff(data_out, data_in, load, clk, rst);
    initial clk=1'b0;
    always #5 clk=~clk;
    initial begin
        rst=1;load=0;data_in=1;
        #2 rst=0;
        #2 rst=1;
        #8 load=1;
        #10 load=0;
        #5 rst=0;
        #5 rst=1;
        #5 data_in=0;
        #5 load=1;
        #10 load=0;
        #20 $stop;
    end
endmodule
