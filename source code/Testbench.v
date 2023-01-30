module RISC_SPM_tb;
    reg rst, clk;
    reg[8:0]i;

    RISC_SPM MCU (clk,rst);

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        #0 rst=0;
            for(i=0;i<=255;i=i+1)
                MCU.Ram.memory[i]=0;
        #10 rst=1;
    end

    initial begin
        #5
        MCU.Ram.memory[0]= 8'b0000_00_00;  //NOP
        MCU.Ram.memory[1]= 8'b0101_01_00;  //R1 = memory[128] = 6 
        MCU.Ram.memory[2]= 128;
        MCU.Ram.memory[3]= 8'b0101_00_00;  //R0 = memory[129] = 1
        MCU.Ram.memory[4]= 129;
        MCU.Ram.memory[5]= 8'b0010_01_00;   //R1 = R1 - R0
        MCU.Ram.memory[6]=8'b1000_00_00;   //BRZ to memory[130] = 10 ( HALT )
        MCU.Ram.memory[7]=130;
        MCU.Ram.memory[8]= 8'b0111_00_11;  //BR to memory[131] = 5
        MCU.Ram.memory[9]= 131;
        MCU.Ram.memory[10]=8'b1111_00_00;  //HALT

        //Load data
        MCU.Ram.memory[128]=6;
        MCU.Ram.memory[129]=1;
        MCU.Ram.memory[130]=10;
        MCU.Ram.memory[131]=5; 
    end

    initial #2800 $stop;
endmodule