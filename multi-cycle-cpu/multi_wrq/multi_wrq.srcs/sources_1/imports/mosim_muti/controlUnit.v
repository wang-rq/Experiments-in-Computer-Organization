`timescale 1ns / 1ns
module controlUnit(
	output PCWre,
    output ALUSrcA,
    output ALUSrcB,
    output DBDataSrc,
    output RegWre,
    output WrRegDSrc,
    output InsMemRW,
    output mRD,
    output mWR,
    output IRWre,
    output ExtSel,
    output [2:0] ALUOp,
    output [1:0] RegDst,
    output [1:0] PCSrc,
    output ifNeedOf,
    output iflhu,
    input zero,
    input sign,
    input[5:0] OP,
    input[5:0] func,
    input RST,
    input CLK,
    input overflow,
    input[31:0] B,
    output reg[2:0] state,
    output HALT
);	
    
    reg [2:0] nextstate;
    parameter Rtype=6'b000000, addiu=6'b001001, andi=6'b001100, ori=6'b001101, slti=6'b001010,
                sw=6'b101011, lw=6'b100011, beq=6'b000100, bne=6'b000101, bltz=6'b000001,
                 j=6'b000010, halt=6'b111111, addi=6'b001000, jal=6'b000011, lhu=6'b100101;
    parameter add=6'b100000, sub=6'b100010, and_=6'b100100, or_=6'b100101, sll=6'b000000, slt=6'b101010, movn=6'b001011, jr=6'b001000;
    parameter IF=3'b000, ID=3'b001, EXEa=3'b110, EXEb=3'b101, EXEls=3'b010, MEM=3'b011, WBa=3'b111, WBm=3'b100; 
    
    always@(posedge CLK)begin
        if(RST) state<=nextstate;
        else state<=IF;
    end

    always@(*)begin
      if(RST)begin
        case(state)
            IF:nextstate=ID;
            ID:begin
                if(OP==beq||OP==bne||OP==bltz) nextstate<=EXEb;
                else if(OP==sw||OP==lw||OP==lhu) nextstate<=EXEls;
                else if(OP==j||OP==jal||(OP==Rtype&&func==jr)) nextstate<=IF;
                else if(OP==halt);
                else nextstate<=EXEa;
            end
            EXEa:nextstate<=WBa;
            EXEb:nextstate<=IF;
            EXEls:nextstate<=MEM;
            MEM:begin
                if(OP==lw||OP==lhu) nextstate<=WBm;
                else nextstate<=IF;
            end
            WBa:nextstate<=IF;
            WBm:nextstate<=IF;
            default:nextstate<=IF;
        endcase   
      end 
    end
    assign HALT=(OP==halt);
    assign iflhu=(OP==lhu);
    assign PCWre=(nextstate==IF && OP!=halt);
    assign ALUSrcA=(OP==Rtype&&func==sll);
    assign ALUSrcB=(OP==addiu||OP==andi||OP==ori||OP==slti||OP==sw||OP==lw||OP==addi||OP==lhu);
    assign DBDataSrc=(OP==lw||OP==lhu);
    assign RegWre=(state==ID&&OP==jal||(state==WBa&&(!overflow)&&(!(OP==Rtype&&func==movn&&B==0)))||(state==WBm));
    assign WrRegDSrc=(OP!=jal);
    assign InsMemRW=1;
    assign mRD=(state==MEM&&(OP==lw||OP==lhu));
    assign mWR=(state==MEM&&OP==sw);
    assign RegDst[0]=(OP==lw||OP==lhu||OP==addiu||OP==addi||OP==andi||OP==ori||OP==slti);
    assign RegDst[1]=(OP==Rtype&&OP!=jr);
    assign IRWre=(state==IF);
    assign ExtSel=(OP!=andi&&OP!=ori&&OP!=lhu);
    assign ALUOp[0]=(OP==Rtype&&func==sub||OP==Rtype&&func==or_||OP==ori||OP==beq||OP==bne||OP==bltz||OP==Rtype&&func==movn);
    assign ALUOp[1]=(OP==Rtype&&func==or_||OP==ori||OP==Rtype&&func==sll||OP==Rtype&&func==slt||OP==slti||OP==Rtype&&func==movn);
    assign ALUOp[2]=(OP==andi||OP==Rtype&&func==and_||OP==slti||OP==Rtype&&func==slt||OP==Rtype&&func==movn);
    assign PCSrc[0]=(OP==beq&&zero==1||OP==bne&&zero==0||OP==bltz&&sign==1||OP==j||OP==jal);
    assign PCSrc[1]=(OP==j||(OP==Rtype&&func==jr)||OP==jal);
    assign ifNeedOf=(OP==add||OP==sub||OP==addi);
endmodule
