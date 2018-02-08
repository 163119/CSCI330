/*
 *	Student Name:		Christopher Aumen
 *	Program Name:		Execute Stage of 5 Stage Pipelined Processor
 *	Creation Date:		March 15, 2017
 *	Last Modified Date:	Febuary 7, 2018
 *	CSCI Course:		CSCI-330 Computer Architecture
 *	Grade Received:		A
 *	Comments regarding design:
 *		This is a software representation of a processor (hardware).  The executeTB.v provides inputs to test the program
 */

module execute(pcp1, regA, regB, instr, pcpo, aluout, equalbit, muxenable, aluenable);

input [31:0] pcp1;
input [31:0] regA;
input [31:0] regB;
input [31:0] instr;
input muxenable;
input aluenable;

wire [31:0] offset;
wire [31:0] muxout;

output [31:0] pcpo;
output [31:0] aluout;
output equalbit;

signextend se(instr[15:0], offset);
adder32 add(pcp1, offset, pcpo);
MUX21_32B mux(regB, offset, muxenable, muxout);
alu alu(regA, muxout, aluenable, equalbit, aluout);

endmodule

module IDEXReg(pcp1in, regAin, regBin, instrin, pcp1out, regAout, regBout, instrout, clk, rst);

input [31:0] pcp1in;
input [31:0] regAin;
input [31:0] regBin;
input [31:0] instrin;
input clk;
input rst;

reg [31:0] pcp1;
reg [31:0] regA;
reg [31:0] regB;
reg [31:0] instr;

output [31:0] pcp1out;
output [31:0] regAout;
output [31:0] regBout;
output [31:0] instrout;

always @(posedge rst, posedge clk) begin
	if (rst == 1) begin
		pcp1 <= 32'd0;
		regA <= 32'd0;
		regB <= 32'd0;
		instr <= 32'd0;
	end
end

always @(posedge clk) begin
	pcp1 <= pcp1in;
	regA <= regAin;
	regB <= regBin;
	instr <= instrin;
end

assign pcp1out = pcp1;
assign regAout = regA;
assign regBout = regB;
assign instrout = instr;

endmodule

module EXMEMReg(pcpoin, aluin, eqin, regBin, instrin, pcpoout, aluout, eqout, regBout, instrout, clk, rst);

input [31:0] pcpoin;
input [31:0] aluin;
input [31:0] regBin;
input [31:0] instrin;
input eqin;
input clk;
input rst;

reg [31:0] pcpo;
reg [31:0] alu;
reg [31:0] regB;
reg [31:0] instr;
reg equalbit;

output [31:0] pcpoout;
output [31:0] aluout;
output [31:0] regBout;
output [31:0] instrout;
output eqout;

always @(posedge rst, posedge clk) begin
	if (rst == 1) begin
		pcpo <= 32'd0;
		alu <= 32'd0;
		regB <= 32'd0;
		instr <= 32'd0;
		equalbit <= 0;
	end
end

always @(posedge clk) begin
	pcpo <= pcpoin;
	alu <= aluin;
	regB <= regBin;
	instr <= instrin;
	equalbit <= eqin;
end

assign pcpoout = pcpo;
assign aluout = alu;
assign regBout = regB;
assign instrout = instr;
assign eqout = equalbit;

endmodule

//A Full Adder
module adder(A, B, sum, cin, cout);
  input A, B, cin;
  output sum, cout;

  wire AB, AxorBcin, AxorB;

  xor(AxorB, A, B);
  xor(sum, AxorB, cin);//sum out

  and(AxorBcin, AxorB, cin);
  and(AB, A , B);
  or(cout, AxorBcin, AB);//carry out
endmodule

//A 32-bit Adder
module adder32(A, B, sum);
  input [31:0] A, B;
  output [31:0] sum;
  output [31:0] cout;

  genvar i;
  adder f1(A[0], B[0], sum[0], 1'b0, cout[0]);
  generate
    for(i = 1; i <= 31; i = i+1)
     begin : adders
      adder f2(A[i], B[i], sum[i], cout[i-1], cout[i]);
    end
  endgenerate

endmodule

module signextend(in, out);

input [15:0] in;

output [31:0] out;

//take the MSB (most significant bit) and concatenate it/replicate
assign out = {{16{in[15]}}, in};

endmodule

module MUX21_32B(a, b, s, o);

input wire [31:0] a;
input wire [31:0] b;
input wire s;

output wire [31:0] o;

wire ns;
not(ns, s);

wire [31:0] as;
wire [31:0] bs;

genvar bit;
generate
  for (bit = 0; bit < 32; bit = bit + 1) begin : select
    and(as[bit], a[bit], ns);
    and(bs[bit], b[bit], s);
    or(o[bit], as[bit], bs[bit]);
  end
endgenerate

endmodule

//LC330 ALU
module alu(A, B, op, eq, out);
    input [31:0] A, B;
    input op; //opcode
    output [31:0] out; // output
    output eq; // equality bit

    assign out = (op==0)?(A + B): // add
                 (op==1)?(A ~| B):1'bx; // nand
    assign eq  = (A == B); // eq
endmodule

