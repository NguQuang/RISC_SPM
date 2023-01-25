module RISC_SPM_tb1;
    reg rst, clk;
    reg[8:0]i;

    RISC_SPM MCU (clk,rst);

    initial begin
        clk = 0; // initiate clock to 0
        forever #5 clk = ~clk;
    end

    initial begin
        #2 rst=0;
            for(i=0;i<=255;i=i+1)
                MCU.Ram.memory[i]=0; // initiate memory space to 0
        #10 rst=1;
    end

    initial begin
        MCU.Ram.memory[0]= 8'b00000000;
        MCU.Ram.memory[1]= 8'b01010000;
        MCU.Ram.memory[2]= 8'b00000011;
        MCU.Ram.memory[3]= 8'b01000000;
        MCU.Ram.memory[4]= 8'b10000000;
    end


endmodule