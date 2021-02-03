`timescale 1ns/1ps
module basys(
    input CLK,
    input[1:0] SW,
    input RST,
    input Botton,
    output[3:0] AN,
    output[7:0] Data,
    output light1,
    output light2,
    output light3,
    output light4,
    output light5
);
    wire[31:0] curPC;
    wire[31:0] nextPC;
    wire[4:0] Reg1_addr;
    wire[4:0] Reg2_addr;
    wire[31:0] ReadData1;
    wire[31:0] ReadData2;
    wire[31:0] result;
    wire[31:0] DB;
    wire[2:0] state;
    wire myCLK;
    wire DIVout;
    assign light1=(state==3'b000);
    assign light2=(state==3'b001);
    assign light3=(state==3'b110||state==3'b101||state==3'b010);
    assign light4=(state==3'b011);
    assign light5=(state==3'b111||state==3'b100);
    DIV DIV_(CLK, DIVout);
    Top Top_(myCLK,RST,curPC,nextPC,Reg1_addr,ReadData1,Reg2_addr,ReadData2,result,DB,state);
    Fangdou Fangdou_(DIVout,Botton,myCLK);
    Xianshi Xianshi_(DIVout,RST,SW,curPC,nextPC,Reg1_addr,ReadData1,Reg2_addr,ReadData2,result,DB,AN,Data);
endmodule
