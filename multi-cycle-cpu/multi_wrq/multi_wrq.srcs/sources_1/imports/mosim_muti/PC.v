`timescale 1ns / 1ns
module PC(
    input PCWre,
    input[31:0] inPC,
    input CLK,
    input Reset,
    output reg[31:0] nextPC
);
    initial begin
        nextPC<=0;
    end
    always@(posedge CLK or negedge Reset)begin
        if(Reset==0)begin
            nextPC=0;
        end
        if(Reset!=0&&PCWre==1)begin
            nextPC=inPC;
        end
    end
endmodule