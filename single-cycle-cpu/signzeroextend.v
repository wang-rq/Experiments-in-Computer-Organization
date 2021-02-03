`timescale 1ns / 1ns
module signzeroextend(
    input wire[15:0] immediate,
    input ExtSel,
    output reg[31:0] extended
);
    always@(*)begin
      extended[15:0]<=immediate;
      if(ExtSel==0)begin
        extended[31:16]<=16'h0000;
      end
      else begin
        extended[31:16]<=immediate[15] ? 16'hffff : 16'h0000;
      end
    end
endmodule