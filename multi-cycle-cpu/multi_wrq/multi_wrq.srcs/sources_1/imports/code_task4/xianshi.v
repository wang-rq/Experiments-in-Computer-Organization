`timescale 1ns / 1ps
module Xianshi(
    input CLK,      
    input RST,    
    input[1:0] SW,  
    input[31:0] CurPC,
    input[31:0] NextPC,     
    input[4:0] rs,
    input[31:0] ReadData1,
    input[4:0] rt,             
    input[31:0] ReadData2,    
    input[31:0] result,
    input[31:0] DB,      
    output[3:0] AN,   
    output[7:0] DispCode   
);
    
    wire[1:0] cnt;
    reg[3:0] num;    
    wire[3:0] ANf;
    reg[3:0] Data0, Data1, Data2, Data3; 
    
    assign AN = ~ANf;
    SegLED SegLED_(num, DispCode);
    YMQ YMQ_(cnt[0], cnt[1], ANf);
    counter counter_(CLK, RST, cnt);
    
    
    always@(*) begin
        case(SW)
            2'b00: begin  
                Data0<=CurPC[7:4];
                Data1<=CurPC[3:0];
                Data2<=NextPC[7:4];
                Data3<=NextPC[3:0];
            end
            2'b01: begin  
                Data0<={3'b000,rs[4]};
                Data1<=rs[3:0];
                Data2<=ReadData1[7:4];
                Data3<=ReadData1[3:0];
            end
            2'b10: begin  
                Data0<={3'b000,rt[4]};
                Data1<=rt[3:0];
                Data2<=ReadData2[7:4];
                Data3<=ReadData2[3:0];            
            end
            2'b11: begin  
                Data0<=result[7:4];
                Data1<=result[3:0];
                Data2<=DB[7:4];
                Data3<=DB[3:0];          
            end 
            default: begin
                Data0<=4'bx;
                Data1<=4'bx;
                Data2<=4'bx;
                Data3<=4'bx;  
            end      
        endcase

        case(cnt)
            2'b00:num<=Data3;
            2'b01:num<=Data2;
            2'b10:num<=Data1;
            2'b11:num<=Data0;
            default: num<=4'bx; 
        endcase

    end
    
endmodule

