`timescale 1ns / 1ps
module simu;
    reg CLK=1;
    reg Reset=0;
    reg[31:0] i;
    Top Top_(CLK,Reset,curPC,nextPC,Reg1_addr,ReadData1,Reg2_addr,ReadData2,result,DB);
    initial begin 
    #1 Reset=1;
      for(i=0;i<256;i=i+1)begin
      # 1 CLK=0;
      # 1 CLK=1;
      end
    end
endmodule