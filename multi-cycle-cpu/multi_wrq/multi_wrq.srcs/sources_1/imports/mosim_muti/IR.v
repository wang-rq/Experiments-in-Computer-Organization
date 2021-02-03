 `timescale 1ns / 1ps
 module IR(
    input[31:0] ins_in,
    input IRWre,
    input CLK,
    input RST,
    output reg[31:0] IRout
 );
    always@(posedge CLK or negedge RST)begin
        if(RST==0) IRout<=ins_in;
        else if(IRWre) IRout<=ins_in;
    end 
 endmodule