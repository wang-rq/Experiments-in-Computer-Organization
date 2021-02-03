`timescale 1ns / 1ps
module Mux5(
    input[1:0] choice,
    input[4:0] in0,
    input[4:0] in1,
    input[4:0] in2,
    output[4:0] out
);
    // if(choice==2'b00) out<=in0;
    // else if(choice==2'b01) out<=in1;
    // else if(choice==2'b10) out<=in2;
    assign out= choice==2'b00 ? in0 : (choice==2'b01 ? in1 : in2);
endmodule