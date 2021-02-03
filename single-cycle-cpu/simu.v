module simu;
    reg CLK=1;
    reg Reset=0;
    reg[31:0] i;
    Top Top_(CLK,Reset,curPC,Reg1,Reg2,ALU);
    initial begin 
    #1 Reset=1;
      for(i=0;i<128;i=i+1)begin
      # 1 CLK=0;
      # 1 CLK=1;
      end
    end
endmodule
