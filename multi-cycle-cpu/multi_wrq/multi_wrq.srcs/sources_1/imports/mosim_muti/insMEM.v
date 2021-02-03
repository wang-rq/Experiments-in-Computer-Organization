`timescale 1ns / 1ps
module insMEM(
    input RW,
    input[31:0] IAddr,
    output reg[31:0] IDataOut
);
    reg[7:0] instruction[0:255];
    initial begin
      $readmemh("C:/Users/DELL/Desktop/multi_wrq/input.txt",instruction);
    end
    always@(RW or IAddr)begin
      if(RW)begin
        IDataOut[31:24]=instruction[IAddr];
        IDataOut[23:16]=instruction[IAddr+1];
        IDataOut[15:8]=instruction[IAddr+2];
        IDataOut[7:0]=instruction[IAddr+3];
      end
    end
endmodule