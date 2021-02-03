`timescale 1ns / 1ns
module RegisterFile(
    input CLK,
    input WE,
    input[4:0] ReadReg1,
    input[4:0] ReadReg2,
    input[4:0] WriteReg,
    input[31:0] WriteData,
    output [31:0] ReadData1,
    output [31:0] ReadData2
);
    reg[31:0] register[0:31];
    integer i;
    initial begin
      for(i=0;i<32;i=i+1)register[i]<=0;
    end

    assign ReadData1=(ReadReg1==0)?0:register[ReadReg1];
    assign ReadData2=(ReadReg2==0)?0:register[ReadReg2];
    
    always@(negedge CLK)begin
        if (WriteReg && WE) begin
            register[WriteReg]<=WriteData;
        end
    end
endmodule