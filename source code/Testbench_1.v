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
        MCU.Ram.memory[1]= 8'b0101_10_00;  // Read 130 to R2 (2)
        MCU.Ram.memory[2]= 130;
        MCU.Ram.memory[3]= 8'b0101_11_00;  // Read 131 to R3 (0)
        MCU.Ram.memory[4]= 131;
        MCU.Ram.memory[5]= 8'b0101_01_00;  // Read 128 to R1 (6)
        MCU.Ram.memory[6]= 128;
        MCU.Ram.memory[7]= 8'b0101_00_00;  // Read 129 to R0 (1)
        MCU.Ram.memory[8]= 129;

        MCU.Ram.memory[9]= 8'b0010_01_00;   //Sub R1-R0 to R1 (5)

        MCU.Ram.memory[10]=8'b1000_00_00;   //BRZ
        MCU.Ram.memory[11]=134;             //hold address for BRZ

        MCU.Ram.memory[12]= 8'b0001_11_10;  //add R2+R3 to R3
        MCU.Ram.memory[13]= 8'b0111_00_11;  //BR
        MCU.Ram.memory[14]= 140;

        //Load data
        MCU.Ram.memory[128]=6;
        MCU.Ram.memory[129]=1;
        MCU.Ram.memory[130]=2;
        MCU.Ram.memory[131]=0;
        MCU.Ram.memory[134]=139;
        MCU.Ram.memory[135]=0;
        MCU.Ram.memory[139]=8'b1111_00_00;  //HALT
        MCU.Ram.memory[140]=9;              //Recycle
    end

    initial #2800 $stop;
endmodule