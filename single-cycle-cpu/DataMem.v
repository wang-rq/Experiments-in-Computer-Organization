`timescale 1ns / 1ns
module DataMem(
    input CLK,
    input RD,
    input WR,
    input[31:0] DAddr,
    input[31:0] DataIn,
    output reg[31:0] DataOut
);
    // initial begin
    //     DataOut<=31'b0;
    // end
    reg[7:0] data[0:127];
    always@(RD or DAddr)begin
        if(RD)begin
            DataOut[31:24]=data[DAddr];
            DataOut[23:16]=data[DAddr+1];
            DataOut[15:8]=data[DAddr+2];
            DataOut[7:0]=data[DAddr+3];
        end
    end
    always@(negedge CLK)begin
        if(WR)begin
            data[DAddr]=DataIn[31:24];
            data[DAddr+1]=DataIn[23:16];
            data[DAddr+2]=DataIn[15:8];
            data[DAddr+3]=DataIn[7:0];
        end
    end
endmodule