`timescale 1ns / 1ns
module controlUnit(
	output PCWre,
    output ALUSrcA,
    output ALUSrcB,
    output DBDataSrc,
    output RegWre,
    output InsMemRW,
    output mRD,
    output mWR,
    output RegDst,
    output ExtSel,
    output[2:0] ALUOp,
    output[1:0] PCSrc,
    input zero,
    input[5:0] OP,
    input[5:0] func,
    input sign 
    );	
    parameter Rtype=6'b000000, addiu=6'b001001, andi=6'b001100, ori=6'b001101, slti=6'b001010, sw=6'b101011, lw=6'b100011, beq=6'b000100, bne=6'b000101, bltz=6'b000001, j=6'b000010, halt=6'b111111;
    parameter add=6'b100000, sub=6'b100010, and_=6'b100100, or_=6'b100101, sll=6'b000000;
    
    assign PCWre=(OP!=halt);
    assign ALUSrcA=(OP==Rtype&&func==sll);
    assign ALUSrcB=(OP==addiu||OP==andi||OP==ori||OP==slti||OP==sw||OP==lw);
    assign DBDataSrc=(OP==lw);
    assign RegWre=( OP!=sw && OP!=beq && OP!=bne && OP!=bltz && OP!=j && OP!=halt);
    assign InsMemRW=1;
    assign mRD=(OP==lw);
    assign mWR=(OP==sw);
    assign RegDst=(OP==Rtype);
    assign ExtSel=(OP!=andi&&OP!=ori);
    assign ALUOp[0]=(OP==Rtype&&func==sub||OP==Rtype&&func==or_||OP==ori||OP==beq||OP==bne||OP==bltz);
    assign ALUOp[1]=(OP==Rtype&&func==or_||OP==ori||OP==Rtype&&func==sll||OP==slti);
    assign ALUOp[2]=(OP==andi||OP==Rtype&&func==and_||OP==slti);
    assign PCSrc[0]=(OP==beq&&zero==1||OP==bne&&zero==0||OP==bltz&&sign==1||OP==halt);
    assign PCSrc[1]=(OP==j||OP==halt);
endmodule
