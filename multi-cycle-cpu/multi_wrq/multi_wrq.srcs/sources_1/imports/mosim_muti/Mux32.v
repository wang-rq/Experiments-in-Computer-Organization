`timescale 1ns / 1ps
module Mux32(
    input choice,
    input[31:0] in0,
    input[31:0] in1,
    output[31:0] out
);
    assign out=choice?in1:in0;
endmodule