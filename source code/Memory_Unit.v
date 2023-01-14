module Memory_Unit(output [7:0] data_out, input [7:0] data_in, input [7:0] address, input write, clk );
    reg [7:0] memory [255:0]; //256 bytes ram

    always @(posedge clk) begin
        if(write)
            memory[address] <= data_in;            
    end
    assign data_out = memory[address];
endmodule