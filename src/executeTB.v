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
module executetb();

	reg clk;
	reg rst;

	//IDEXReg input
	reg [31:0] pcp1in;
	reg [31:0] regAin;
	reg [31:0] regBin;
	reg [31:0] instrin;

	//IDEXReg ouput wires -- DUT input
	wire [31:0] pcp1;
	wire [31:0] regA;
	wire [31:0] regB;
	wire [31:0] instr;

	//DUT input
	reg muxenable;
	reg aluenable;
	
	//DUT output -- EXMEMReg input
	wire [31:0] pcpo;
	wire [31:0] aluout;
	wire equalbit;

	//EXMEMReg output
	wire [31:0] instrout;
	wire [31:0] pcpoout;
	wire [31:0] aluout2;
	wire [31:0] regBout;
	wire eqout;

	IDEXReg inreg(pcp1in, regAin, regBin, instrin, pcp1, regA, regB, instr, clk, rst);

	execute DUT(pcp1, regA, regB, instr, pcpo, aluout, equalbit, muxenable, aluenable);

	EXMEMReg outreg(pcpo, aluout, equalbit, regB, instr, pcpoout, aluout2, eqout, regBout, instrout, clk, rst);

	always #1 clk = !clk;

	initial begin
		$dumpfile("test.vcd");
		$dumpvars(0, DUT);
		clk = 0;
		rst = 0;
		instrin = 32'd0;
		regAin = 32'd0;
		regBin = 32'd0;
		pcp1in = 32'd0;
		muxenable = 0;
		aluenable = 0;

		#11; //input add, no process/output
		instrin = 32'b00000000001000100000000000000011;
		regAin = 32'd36; //Reg $1 = 36
		regBin = 32'd9;	//Reg $2 = 9
		pcp1in = 32'd1;


		#1; //input nor, process add, no output		
		$display("IDEX UPDATED:");
		$display("PCP1: %d", pcp1);
		$display("REGA: %d", regA);
		$display("REGB: %d", regB);
		$display("INSTR: %b", instr);
		$display("OFFSET: %d", instr[15:0]);
		$display();
		$display("EXMEM UPDATED:");
		$display("PCPO: %d", pcpoout);
		$display("EQBIT: %b", eqout);
		$display("ALURESULT: %d", $signed(aluout2));
		$display("REGB: %d", regBout);
		$display("INSTR: %b", instrout);
		$display("OFFSET: %d", instrout[15:0]);
		$display();
		instrin = 32'b00000000100001010000000000000110; // nand $6, $4, $5
		regAin = 32'd18;
		regBin = 32'd7;
		pcp1in = 32'd2;

		#2; //input lw, process nor, output add
		$display("Add 1 2 3");
		$display("pcpo = %d == 4?", pcpoout);
		$display("aluresult = %d == 45?", aluout2);
		$display("eqbit == %b == 0?", eqout);
		$display("regB = %d == 9?", regBout);
		$display("instr = %b == 00000000001000100000000000000011?", instrout);
		$display("***** *****");
		instrin = 32'b00000000010001000000000000010100;
		regAin =32'd9;
		regBin = 32'd18;
		pcp1in = 32'd3;
		aluenable = 1;

		#2; //input add2, process lw, output nor
		$display("Nor 4 5 6");
		$display("pcpo = %d == 8?", pcpoout);
		$display("aluresult = %d == -24 ", $signed(aluout2));
		$display("eqbit == %b == 0?", eqout);
		$display("regB = %d == 7?", regBout);
		$display("instr = %b == 00000000100001010011000000000110?", instrout);
		$display("***** *****");		
		instrin = 32'b00000000010001010000000000000101;
		regAin = 32'd9;
		regBin = 32'd7;
		pcp1in = 32'd4;
		aluenable = 0;
		muxenable = 1;

		#2; //input sw, process add2, output lw
		$display("lw 2 4 20");
		$display("pcpo = %d == 23?", pcpoout);
		$display("aluresult = %d == 29? ", aluout2);
		$display("eqbit == %b == 0?", eqout);
		$display("regB = %d == 18?", regBout);
		$display("instr = %b == 00000000010001000000000000010100?", instrout);
		$display("***** *****");
		instrin = 32'b00000000011001110000000000001010;
		regAin = 32'd45;
		regBin = 32'd22;
		pcp1in = 32'd5;
		muxenable = 0;

		#2; //no input, process sw, output add2
		$display("add 2 5 5");
		$display("pcpo = %d == 9?", pcpoout);
		$display("aluresult = %d == 16? ", aluout2);
		$display("eqbit == %b == 0?", eqout);
		$display("regB = %d == 7?", regBout);
		$display("instr = %b == 00000000010001010000000000000101?", instrout);
		$display("***** *****");
		muxenable = 1;

		#2; //no input, no process, output sw
		$display("sw 3 7 10");
		$display("pcpo = %d == 15?", pcpoout);
		$display("aluresult = %d == 55? ", aluout2);
		$display("eqbit == %b == 0?", eqout);
		$display("regB = %d == 22?", regBout);
		$display("instr = %b == 00000000011001110000000000001010?", instrout);
		$display("***** *****");
		muxenable = 0;

		$finish();
	end

endmodule
