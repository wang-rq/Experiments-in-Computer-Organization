`timescale 1ns / 1ns
module Mux5(
    input choice,
    input[4:0] in0,
    input[4:0] in1,
    output[4:0] out
);
    assign out=choice?in1:in0;
endmodule