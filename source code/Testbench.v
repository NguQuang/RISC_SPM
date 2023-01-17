module RISC_SPM_tb;
    reg rst, clk;
    reg[8:0]i;

    RISC_SPM MCU (clk,rst);

    wire[7:0]   word0, word1, word2, word3, word4, word5, word6,word7, 
                word8, word9, word10, word11, word12, word13, word14;

    wire[7:0]   word123, word129, word130, word131, word132, word133,word134,
                word135, word136, word137, word138, word139, word140, word255;

    assign word0 = MCU.Ram.memory[0];
    assign word1 = MCU.Ram.memory[1];
    assign word2 = MCU.Ram.memory[2];
    assign word3 = MCU.Ram.memory[3];
    assign word4 = MCU.Ram.memory[4];
    assign word5 = MCU.Ram.memory[5];
    assign word6 = MCU.Ram.memory[6];
    assign word7 = MCU.Ram.memory[7];
    assign word8 = MCU.Ram.memory[8];
    assign word9 = MCU.Ram.memory[9];
    assign word10 = MCU.Ram.memory[10];
    assign word11 = MCU.Ram.memory[11];
    assign word12 = MCU.Ram.memory[12];
    assign word13 = MCU.Ram.memory[13];
    assign word14 = MCU.Ram.memory[14];

    assign word128 = MCU.Ram.memory[128];
    assign word129 = MCU.Ram.memory[129];
    assign word130 = MCU.Ram.memory[130];
    assign word131 = MCU.Ram.memory[131];
    assign word132 = MCU.Ram.memory[132];
    assign word133 = MCU.Ram.memory[133];
    assign word134 = MCU.Ram.memory[134];
    assign word135 = MCU.Ram.memory[135];
    assign word136 = MCU.Ram.memory[136];
    assign word137 = MCU.Ram.memory[137];
    assign word138 = MCU.Ram.memory[138];
    assign word139 = MCU.Ram.memory[139];
    assign word140 = MCU.Ram.memory[140];

    assign word255 = MCU.Ram.memory[255];


    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    initial begin
        #2 rst=0;
            for(i=0;i<=255;i=i+1)
                MCU.Ram.memory[i]=0;
        #10 rst=1;
    end

    initial begin
        #5
        MCU.Ram.memory[0]= 8'b0000_00_00;  //NOP
        MCU.Ram.memory[1]= 8'b0101_00_10;  // Read 130 to R2
        MCU.Ram.memory[2]= 130;
        MCU.Ram.memory[3]= 8'b0101_00_11;  // Read 131 to R3
        MCU.Ram.memory[4]= 131;
        MCU.Ram.memory[5]= 8'b0101_00_01;  // Read 128 to R1
        MCU.Ram.memory[6]= 128;
        MCU.Ram.memory[7]= 8'b0101_00_00;  // Read 129 to R0
        MCU.Ram.memory[8]= 129;

        MCU.Ram.memory[9]= 8'b0010_00_01;   //Sub R1-R0 to R1

        MCU.Ram.memory[10]=8'b1000_00_00;   //BRZ
        MCU.Ram.memory[11]=134;             // hold address for BRZ

        MCU.Ram.memory[12]= 8'b0001_10_11;  //add R2+R3 to R3
        MCU.Ram.memory[13]= 8'b0111_00_11;  // BR
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

    initial #2800 $finish;
endmodule