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

module Memory_Unit_tb;
    reg [7:0] data_in, data_out, address;
    reg write, clk;

    Memory_Unit RAM(data_out,data_in,address, write, clk);

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        RAM.memory[0]= 8'b0000_00_00;  //NOP
        RAM.memory[1]= 8'b0101_00_10;  // Read 130 to R2
        RAM.memory[2]= 130;
        RAM.memory[3]= 8'b0101_00_11;  // Read 131 to R3
        RAM.memory[4]= 131;
        RAM.memory[5]= 8'b0101_00_01;  // Read 128 to R1
        RAM.memory[6]= 128;
        RAM.memory[7]= 8'b0101_00_00;  // Read 129 to R0
        RAM.memory[8]= 129;

        RAM.memory[9]= 8'b0010_00_01;   //Sub R1-R0 to R1

        RAM.memory[10]=8'b1000_00_00;   //BRZ
        RAM.memory[11]=134;             // hold address for BRZ

        RAM.memory[12]= 8'b0001_10_11;  //add R2+R3 to R3
        RAM.memory[13]= 8'b0111_00_11;  // BR
        RAM.memory[14]= 140;

        //Load data
        RAM.memory[128]=6;
        RAM.memory[129]=1;
        RAM.memory[130]=2;
        RAM.memory[131]=0;
        RAM.memory[134]=139;
        RAM.memory[135]=0;
        RAM.memory[139]=8'b1111_00_00;  //HALT
        RAM.memory[140]=9;              //Recycle
            
    end

    initial begin
        #0 address = 8'b00000000; write = 0;
        #5 write = 1;
        #10 write = 0;
    end
    



endmodule