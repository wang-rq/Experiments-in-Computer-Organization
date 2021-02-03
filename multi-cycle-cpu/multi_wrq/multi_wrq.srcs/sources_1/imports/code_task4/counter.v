`timescale 1ns / 1ps
module counter(
    input CLK, 
    input RST,
    output reg [1:0] num
);
    always@(posedge CLK or negedge RST) begin
        if(RST==0) num<=2'b00; 
        else begin
            if(num==2'b11)num<=2'b00;
            else num<=num+2'b01; 
        end
    end
endmodule