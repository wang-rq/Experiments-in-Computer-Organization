`timescale 1ns / 1ps
module Fangdou(
    input CLK,         
    input bottom, 
    output myCLK  
);
    reg temp3,temp2,temp1;
    always @(posedge CLK) begin
        temp1<=bottom;
        temp2<=temp1;
        temp3<=temp2;
    end   
    assign myCLK=temp3 && temp2 && temp1;    
endmodule
