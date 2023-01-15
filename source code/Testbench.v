module RISC_SPM_tb;
    reg rst, clk;
    reg[8:0]i;

    RISC_SPM test (clk,rst);

    //define probes
    wire[7:0] word0, word1, word2, word3, word4, word5, word6;
    wire[7:0] word7, word8, word9, word10, word11, word12, word13;
    wire[7:0] word14;

    wire[7:0] word123, word129, word130, word131, word132, word255;
    wire[7:0] word133, word134, word135, word136, word137;
    wire[7:0] word138, word139, word140;
    assign word0 = test.Ram.memory[0];
    assign word1 = test.Ram.memory[1];
    assign word2 = test.Ram.memory[2];
    assign word3 = test.Ram.memory[3];
    assign word4 = test.Ram.memory[4];
    assign word5 = test.Ram.memory[5];
    assign word6 = test.Ram.memory[6];
    assign word7 = test.Ram.memory[7];
    assign word8 = test.Ram.memory[8];
    assign word9 = test.Ram.memory[9];
    assign word10 = test.Ram.memory[10];
    assign word11 = test.Ram.memory[11];
    assign word12 = test.Ram.memory[12];
    assign word13 = test.Ram.memory[13];
    assign word14 = test.Ram.memory[14];

    assign word128 = test.Ram.memory[128];
    assign word129 = test.Ram.memory[129];
    assign word130 = test.Ram.memory[130];
    assign word131 = test.Ram.memory[131];
    assign word132 = test.Ram.memory[132];
    assign word133 = test.Ram.memory[133];
    assign word134 = test.Ram.memory[134];
    assign word135 = test.Ram.memory[135];
    assign word136 = test.Ram.memory[136];
    assign word137 = test.Ram.memory[137];
    assign word138 = test.Ram.memory[138];
    assign word139 = test.Ram.memory[139];
    assign word140 = test.Ram.memory[140];

    assign word255 = test.Ram.memory[255];


    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    initial begin
        #2 rst=0;
            for(i=0;i<=255;i=i+1)
                test.Ram.memory[i]=0;
        #10 rst=1;
    end

    initial begin
        #5
        test.Ram.memory[0]= 8'b0000_00_00;  //NOP
        test.Ram.memory[1]= 8'b0101_00_10;  // Read 130 to R2
        test.Ram.memory[2]= 130;
        test.Ram.memory[3]= 8'b0101_00_11;  // Read 131 to R3
        test.Ram.memory[4]= 131;
        test.Ram.memory[5]= 8'b0101_00_01;  // Read 128 to R1
        test.Ram.memory[6]= 128;
        test.Ram.memory[7]= 8'b0101_00_00;  // Read 129 to R0
        test.Ram.memory[8]= 129;

        test.Ram.memory[9]= 8'b0010_00_01;   //Sub R1-R0 to R1

        test.Ram.memory[10]=8'b1000_00_00;   //BRZ
        test.Ram.memory[11]=134;             // hold address for BRZ

        test.Ram.memory[12]= 8'b0001_10_11;  //add R2+R3 to R3
        test.Ram.memory[13]= 8'b0111_00_11;  // BR
        test.Ram.memory[14]= 140;

        //Load data
        test.Ram.memory[128]=6;
        test.Ram.memory[129]=1;
        test.Ram.memory[130]=2;
        test.Ram.memory[131]=0;
        test.Ram.memory[134]=139;
        test.Ram.memory[135]=0;
        test.Ram.memory[139]=8'b1111_00_00;  //HALT
        test.Ram.memory[140]=9;              //Recycle
    end

    initial #2800 $finish;
endmodule