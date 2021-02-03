`timescale 1ns / 1ps
module YMQ(
    input A,
    input B,
    output reg [3:0] Y_Out
);
    always@(A or B) begin
        case({B,A})
            2'b000: Y_Out = 4'b0001;
            2'b001: Y_Out = 4'b0010;
            2'b010: Y_Out = 4'b0100;
            2'b011: Y_Out = 4'b1000;
            default: Y_Out = 4'b0000;
        endcase
    end
endmodule