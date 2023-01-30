module RISC_SPM_tb1;
    reg rst, clk;
    reg[8:0]i;

    RISC_SPM MCU (clk,rst);

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        #2 rst=0;
            for(i=0;i<=255;i=i+1)
                MCU.Ram.memory[i]=0;
        #10 rst=1;
        #2000 rst = 0;
        #10 rst = 1;
    end

    initial begin
        #5
        MCU.Ram.memory[0]= 8'b0000_00_00;  //NOP
        MCU.Ram.memory[1]= 8'b0101_00_00;  //READ R0 = memory[130] = 1
        MCU.Ram.memory[2]= 130;
        MCU.Ram.memory[3]= 8'b0101_01_00;  //READ R1 = memory[130] = 1
        MCU.Ram.memory[4]= 131;
        MCU.Ram.memory[5]= 8'b0001_01_00;  //ADD R1 = R1 + R0
        MCU.Ram.memory[6]= 8'b0110_00_01;  //WRITE memory[130] = R1
        MCU.Ram.memory[6]= 130;
        MCU.Ram.memory[7]= 8'b0111_00_11;  //BRANCH to memory[131] = 1
        MCU.Ram.memory[8]= 131;

        MCU.Ram.memory[130]=1;
        MCU.Ram.memory[131]=1;
        MCU.Ram.memory[132]=1;
    end

    initial #2800 $stop;
endmodule