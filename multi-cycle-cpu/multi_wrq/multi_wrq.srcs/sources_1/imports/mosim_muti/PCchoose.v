`timescale 1ns / 1ns
module PCchoose(
    input[1:0] PCSrc,
    input[31:0] rs,
    input[31:0] singedImmediate,
    input[31:0] curPC,
    input[31:0] addr,
    input RST,
    input HALT,
    output reg[31:0] nextPC
);
    initial begin
        nextPC<=0;
    end
    wire[31:0] PC4=curPC+4; 
    always@(*)begin
      if(!RST) nextPC<=0;
      else begin
        if(PCSrc==2'b00)begin
            nextPC<=PC4;
        end 
        if(PCSrc==2'b01)begin
            nextPC<=PC4+singedImmediate*4;
        end
        if(PCSrc==2'b10)begin
            nextPC<=rs;
        end
        if(PCSrc==2'b11&&!HALT)begin
            nextPC<={PC4[31:28],addr[25:0],2'b00};
        end
      end
    end
endmodule