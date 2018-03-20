module full_control(instr, signals_out, imm_dec);

input [15:0] instr;

output [11:0] signals_out;

output [15:0] imm_dec;

wire [3:0] Opcode;

//ALU Opcode specifications
// all with leading 0
// ADD: 000
// SUB: 001
// RED: 010 TODO
// XOR: 011
// SLL: 100
// SRA: 101
// ROR: 110
// PADDSB: 111

//signals out designation
//[8] HLT
//[7] PCS
//[6] Jump
//[5] Branch
//[4] MemRead
//[3] MemToReg
//[2] MemWrite
//[1] ALUsrc
//[0] RegWrite

localparam ADD	= 4'b0000;
localparam SUB	= 4'b0001;
localparam RED	= 4'b0010;
localparam XOR 	= 4'b0011;
localparam SLL 	= 4'b0100;
localparam SRA 	= 4'b0101;
localparam ROR 	= 4'b0110;
localparam PADDSB = 4'b0111;
localparam LW 	= 4'b1000;
localparam SW 	= 4'b1001;
localparam LHB 	= 4'b1010;
localparam LLB 	= 4'b1011;
localparam B 	= 4'b1100;
localparam BR 	= 4'b1101;
localparam PCS	= 4'b1110;
localparam HLT 	= 4'b1111;

assign Opcode = instr[15:12];

assign signals_out[11] = ((Opcode == ADD) ||
				(Opcode == SUB) ||
				(Opcode == XOR)	||	
				(Opcode == SLL)	||
				(Opcode == SRA) ||
				(Opcode == ROR)) ? 1'b1 : 1'b0;

assign signals_out[10] =    ((Opcode == SW)) ? 1'b1 : 1'b0; 

assign signals_out[9] = 	((Opcode == LHB) || (Opcode == LLB)) ? 1'b1 : 1'b0; //unique case for rd = rs

assign signals_out[8] = 	(Opcode == HLT) ? 1'b1 : 1'b0; //HLT

assign signals_out[7] = 	(Opcode == PCS) ? 1'b1 : 1'b0; //PCS

assign signals_out[6] = (	(Opcode == BR) ) ? 1'b1 : 1'b0; //Jump Register

assign signals_out[5] = (	(Opcode == BR) || 
				(Opcode == B)) ? 1'b1 : 1'b0; //Branch						

assign signals_out[4] = (   	(Opcode == LW) ) ? 1'b1 : 1'b0; //MemRead

assign signals_out[3] = (   	(Opcode == LW) ) ? 1'b1 : 1'b0; //MemToReg

assign signals_out[2] = (   	(Opcode == SW) ) ? 1'b1 : 1'b0; //MemWrite

assign signals_out[1] = (   	(Opcode == PCS) ||
				(Opcode == SLL) ||
				(Opcode == ROR)	||	
				(Opcode == SRA)	||
				(Opcode == LW ) ||
				(Opcode == SW ) ||
				(Opcode == LHB) ||
				(Opcode == LLB)) ? 1'b1 : 1'b0; //ALUsrc
							
assign signals_out[0] = (   	(Opcode == B  ) ||
				(Opcode == BR ) ||
				(Opcode == HLT) ||
				(Opcode == SW)) ? 1'b0 : 1'b1; //RegWrite
							
assign imm_dec = ( 		(Opcode == LLB)	|| (Opcode == LHB) ) ? 
					{{8{instr[7]}}, instr[7:0]} :
				(Opcode == PCS) ? 16'h0002 :
				 	{{12{instr[3]}}, instr[3:0]}; //ROR, SLL, SRA, LW, SW
			
endmodule