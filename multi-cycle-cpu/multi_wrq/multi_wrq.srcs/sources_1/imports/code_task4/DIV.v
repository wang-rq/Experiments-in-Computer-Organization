`timescale 1ns / 1ps
module DIV(
	input clk,                 
	output reg DIVout     
);
    initial begin
        DIVout<=0;
    end
   
	integer i=0;             
	always @(posedge clk) begin
        if(i>=49999) begin    
            DIVout<=~DIVout;             
            i<=0;
        end
        else i<=i+1;  
    end
endmodule