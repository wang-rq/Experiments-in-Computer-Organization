`timescale 1ns/1ps 
module Top(
    input CLK,
    input RST,
    output[31:0] PCout,
    output[31:0] PCin,
    output[4:0] reg1_addr,
    output[31:0] ReadData1,
    output[4:0] reg2_addr,
    output[31:0] ReadData2,
    output[31:0] result,
    output[31:0] DBout,
    output[2:0] state
);
    wire PCWre;
    wire IRWre;
    wire ALUSrcA;
    wire ALUSrcB;
    wire DBDataSrc;
    wire RegWre;
    wire InsMemRW;
    wire mRD;
    wire mWR;
    wire WrRegDSrc;
    wire[1:0] RegDst;
    wire ExtSel;
    wire[2:0] ALUOp;
    wire[1:0] PCSrc;
    wire[31:0] IDataOut;
    wire[4:0] WriteRegIn;
    wire[31:0] DBin;
    wire[31:0] WriteData;
    wire[31:0] ALUAin;
    wire[31:0] ALUBin;
    wire zero;
    wire sign;
    wire[31:0] ExtendOut;
    wire ifNeedOf;
    wire overflow;
    wire iflhu;
    wire[31:0] IRout;
    wire[31:0] ADRout;
    wire[31:0] BDRout;
    wire[31:0] ALUoutDRout;
    wire[31:0] DataOut;
    assign reg1_addr=IRout[25:21];
    assign reg2_addr=IRout[20:16];

    //module controlUnit(output PCWre, output ALUSrcA,  output ALUSrcB,  output DBDataSrc,  output RegWre,  output WrRegDSrc,  output InsMemRW,  output mRD,  output mWR,  output IRWre,  output ExtSel,
    //output [2:0] ALUOp,  output [1:0] RegDst,  output [1:0] PCSrc,  output ifNeedOf,  output iflhu,  input zero,  input sign,  input[5:0] OP,  input[5:0] func,  input RST,  input CLK,  input overflow,  input B);	
    controlUnit controlUnit_(PCWre, ALUSrcA, ALUSrcB, DBDataSrc, RegWre, WrRegDSrc, InsMemRW, mRD, mWR, IRWre, ExtSel, ALUOp, RegDst, PCSrc, ifNeedOf, iflhu, zero, sign, IRout[31:26], IRout[5:0], RST, CLK, overflow, ALUBin, state, HALT);

    //module IR(input[31:0] ins_in, input IRWre, input CLK, output reg[31:0] IRout);
    IR IR_(IDataOut, IRWre, CLK, RST, IRout);

    //module DR(  input CLK,  input [31:0] in,  output reg[31:0] out);
    DR ADR(CLK, ReadData1, ADRout);
    DR BDR(CLK, ReadData2, BDRout);
    DR DBDR(CLK, DBin, DBout);
    DR ALUoutDR(CLK, result, ALUoutDRout);

    //module Mux5(  input[1:0] choice,  input[4:0] in0,  input[4:0] in1,  input[4:0] in2,  output[4:0] out);
    Mux5 Mux5_1(RegDst, 5'b11111, IRout[20:16], IRout[15:11], WriteRegIn);

    //module Mux32( input choice, input[31:0] in0, input[31:0] in1, output[31:0] out);
    Mux32 Mux32_1(WrRegDSrc, PCout+4, DBout, WriteData);
    Mux32 Mux32_2(ALUSrcA, ADRout, {27'b000000000000000000000000000,IRout[10:6]},ALUAin);
    Mux32 Mux32_3(ALUSrcB, BDRout, ExtendOut, ALUBin);
    Mux32 Mux32_4(DBDataSrc, result, DataOut, DBin);

    //module signzeroextend(  input wire[15:0] immediate,  input ExtSel,  output reg[31:0] extended);
    signzeroextend signzeroextend_(IRout[15:0], ExtSel, ExtendOut);

    //module ALU( input[31:0] A, input[31:0] B, input[2:0] ALUOp, input ifNeedOf, output sign, output zero, output overflow, output reg[31:0] result);
    ALU ALU_(ALUAin, ALUBin, ALUOp, ifNeedOf, sign, zero, overflow, result);

    //module RegisterFile(  input CLK, input WE, input iflhu, input[4:0] ReadReg1, input[4:0] ReadReg2, input[4:0] WriteReg, input[31:0] WriteData, output [31:0] ReadData1, output [31:0] ReadData2);
    RegisterFile RegisterFile_(CLK, RegWre, iflhu, IRout[25:21], IRout[20:16], WriteRegIn, WriteData, RST, ReadData1, ReadData2);

    //module insMEM( input RW, input[31:0] IAddr, output reg[31:0] IDataOut);
    insMEM insMEM_(InsMemRW, PCout, IDataOut);

    //module PCchoose( input[1:0] PCSrc, input[1:0] rs, input[31:0] singedImmediate, input[31:0] curPC, input[31:0] addr, output reg[31:0] nextPC);
    PCchoose PCchoose_(PCSrc,ReadData1, ExtendOut, PCout, IRout, RST, HALT, PCin);

    //module PC(  input PCWre,  input[31:0] inPC,  input CLK,  input Reset,  output reg[31:0] nextPC  );
    PC PC_(PCWre, PCin, CLK, RST, PCout);

    //module DataMem(  input CLK,  input RD,  input WR,  input[31:0] DAddr, input[31:0] DataIn, output reg[31:0] DataOut);
    DataMem DataMem_(CLK, mRD, mWR, ALUoutDRout, BDRout, DataOut);

endmodule