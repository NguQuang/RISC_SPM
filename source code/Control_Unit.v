`define idle    0
`define fet1    1
`define fet2    2
`define dec     3
`define ex1     4
`define rd1     5
`define rd2     6
`define wr1     7
`define wr2     8
`define br1     9
`define br2     10
`define halt    11
`define NOP     4'b0000
`define ADD     4'b0001
`define SUB     4'b0010
`define AND     4'b0011
`define NOT     4'b0100
`define RD      4'b0101
`define WR      4'b0110
`define BR      4'b0111
`define BRZ     4'b1000
module Control_Unit(
    output reg Load_R0, Load_R1, Load_R2, Load_R3, Load_PC, Inc_PC, Load_IR, Load_Add_R, Load_Reg_Y, Load_Reg_Z, write,
    output reg [2:0] Sel_Bus_1_Mux,
    output reg [1:0] Sel_Bus_2_Mux,
    input [7:0] instruction,
    input Zflag, clk, rst
);

    reg [3:0] state, next_state;
    reg err_flag;

    wire [3:0] opcode = instruction[7:4];
    wire [1:0] src = instruction [3:2];
    wire [1:0] dst = instruction [1:0];

    always @ (posedge clk or negedge rst) begin
        if(!rst)
            state <= `idle;
        else
            state <= next_state;
    end

    always @ (state or opcode or src or dst or Zflag) begin
        Sel_Bus_1_Mux = 3'bx ; Sel_Bus_2_Mux = 2'bx;
        Load_R0 = 0; Load_R1 = 0; Load_R2 = 0; Load_R3 = 0; Load_Reg_Y = 0; Load_Reg_Z = 0;
        Load_PC = 0; Inc_PC = 0; Load_IR = 0; Load_Add_R = 0;
        write = 0;
        err_flag = 0;
        next_state = state;
        case (state)
            `idle : next_state = `fet1;
            `fet1 :begin
                next_state = `fet2;
                Sel_Bus_1_Mux = 4;
                Sel_Bus_2_Mux = 1;
                Load_Add_R = 1; 
            end
            `fet2:begin
                next_state = `dec;
                Sel_Bus_2_Mux = 2;
                Load_IR = 1;
                Inc_PC = 1;
            end
            `dec :begin
                case(opcode)
                    `NOP : next_state = `fet1;
                    `ADD, `SUB, `AND : begin
                        next_state = `ex1;
                        Sel_Bus_2_Mux = 1;
                        Load_Reg_Y = 1;
                        case (src)
                            0 : Sel_Bus_1_Mux = 0;
                            1 : Sel_Bus_1_Mux = 1;
                            2 : Sel_Bus_1_Mux = 2;
                            3 : Sel_Bus_1_Mux = 3;
                            default : err_flag = 1;
                        endcase
                    end
                    `NOT : begin
                        next_state = `fet1;
                        Load_Reg_Z = 1;
                        Sel_Bus_2_Mux = 1;
                        Sel_Bus_2_Mux = 0;
                        case (src)
                            0 : Sel_Bus_1_Mux = 0;
                            1 : Sel_Bus_1_Mux = 1;
                            2 : Sel_Bus_1_Mux = 2;
                            3 : Sel_Bus_1_Mux = 3;
                            default : err_flag = 1;
                        endcase
                        case (dst)
                            0 : Load_R0 = 1;
                            1 : Load_R1 = 1;
                            2 : Load_R2 = 1;
                            3 : Load_R3 = 1;
                            default err_flag = 1;
                        endcase
                    end
                    `RD : begin
                        next_state = `rd1;
                        Sel_Bus_1_Mux = 4;
                        Sel_Bus_2_Mux = 1;
                        Load_Add_R = 1;
                    end
                    `WR : begin
                        next_state = ` wr1;
                        Sel_Bus_1_Mux = 4;
                        Sel_Bus_2_Mux = 1;
                        Load_Add_R = 1;
                    end
                    `BR : begin
                        next_state = `br1;
                        Sel_Bus_1_Mux = 4;
                        Sel_Bus_2_Mux = 1;
                        Load_Add_R = 1;
                    end
                    `BRZ : begin
                        if (Zflag == 1) begin
                            next_state = `br1;
                            Sel_Bus_1_Mux = 4;
                            Sel_Bus_2_Mux = 1;
                            Load_Add_R = 1;
                        end
                        else begin
                            next_state = `fet1;
                        end
                    end
                endcase
            end
            `ex1 :begin

            end
            `rd1 :begin
            end
            `wr1 :begin
            end
            `rd2 :begin
            end 
            `wr2 :begin
            end
            `br1 :begin
            end
            `br2 :begin
            end
            `halt :begin
            end
        endcase
    end

endmodule
