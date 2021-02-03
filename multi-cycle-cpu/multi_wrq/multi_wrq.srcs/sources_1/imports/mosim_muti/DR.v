 `timescale 1ns / 1ps
module DR(
    input CLK,
    input [31:0] in,
    output reg[31:0] out
);
    always@(posedge CLK)begin
        out<=in;
    end
endmodule