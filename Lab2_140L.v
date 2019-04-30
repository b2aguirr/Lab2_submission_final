// --------------------------------------------------------------------
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
// --------------------------------------------------------------------
// Copyright (c) 2019 by UCSD CSE 140L
// --------------------------------------------------------------------
//
// Permission:
//
//   This code for use in UCSD CSE 140L.
//   It is synthesisable for Lattice iCEstick 40HX.  
//
// Disclaimer:
//
//   This Verilog source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  
//
module Lab2_140L (
 input wire Gl_rst,                  // reset signal (active high)
 input wire clk,                     // global clock
 input wire Gl_adder_start,          // r1, r2, OP are ready  
 input wire Gl_subtract,             // subtract (active high)
 input wire [7:0] Gl_r1           , // 8bit number 1
 input wire [7:0] Gl_r2           , // 8bit number 1
 output wire [7:0] L2_adder_data   ,   // 8 bit ascii sum
 output wire L2_adder_rdy          , //pulse
 output wire [7:0] L2_led);
 
 //wire G1_r2_new;
 wire [3:0] Gl_r2_new;
 //wire [3:0] neg;
 wire S1;
 wire S2;
 wire S3;
 wire S4;
 wire C_out1;
 wire C_out2;
 wire C_out3;
 wire C_out4;
 reg [7:0] result_temp;
 reg [7:0] neg;
 //reg [7:0] led_temp;
 
 	
			//when G1_subtract = 0, G1_r2
			//When G2_subtract = 1, ~G1_r2
			//assign G1_r2_new = Gl_subtract ^ Gl_r2[0];
			//assign G1_r2_new = Gl_subtract ^ Gl_r2;
 assign Gl_r2_new[0] = Gl_subtract ^ Gl_r2[0];
 assign Gl_r2_new[1] = Gl_subtract ^ Gl_r2[1];
 assign Gl_r2_new[2] = Gl_subtract ^ Gl_r2[2];
 assign Gl_r2_new[3] = Gl_subtract ^ Gl_r2[3];
 
			/*
				fullAdder(
         .A(Gl_r1[0]),
			.B(Gl_r2_new),
			.C_in(Gl_subtract),
			.S(S1),
			.C_out(C_out1));
			*/
	fullAdder f1(
         .A(Gl_r1[0]),
			.B(Gl_r2_new[0]),
			.C_in(Gl_subtract),
			.S(S1),
			.C_out(C_out1));
			

			
	fullAdder f2(
         .A(Gl_r1[1]),
			.B(Gl_r2_new[1]),
			.C_in(C_out1),
			.S(S2),
			.C_out(C_out2));
			
	fullAdder f3(
        .A(Gl_r1[2]),
			.B(Gl_r2_new[2]),
			.C_in(C_out2),
			.S(S3),
			.C_out(C_out3));
			
	fullAdder f4(
         .A(Gl_r1[3]),
			.B(Gl_r2_new[3]),
			.C_in(C_out3),
			.S(S4),
			.C_out(C_out4));

	//assign L2_led = {1'b0,1'b0,1'b0,C_out4, S4,S3,S2,S1};
	sigDelay sDelay(
				.sigOut(L2_adder_rdy),
				.sigIn(Gl_adder_start),
				.clk(clk),
				.rst(Gl_rst)
				);
	
	//assign L2_led = {1'b0,1'b0,1'b0,C_out4 ^ Gl_subtract, S4,S3,S2,S1};
	assign L2_led = {1'b0,1'b0,1'b0, C_out4 ^ Gl_subtract, S4,S3,S2,S1};
	
	
	//assign L2_adder_data = { 1'b0, 1'b0, 1'b1, C_out4, S4, S3, S2, S1};
	always @ (*) begin
	 if(C_out4) begin // carry out == 0
		//result_temp = { 1'b0, 1'b1, 1'b0,1'b1, S4, S3, S2, S1};
		result_temp = { 1'b0, 1'b1, 1'b0,1'b1, S4, S3, S2, S1};
		if(Gl_subtract)begin
			result_temp = { 1'b0, 1'b0, 1'b1, 1'b1, S4, S3, S2, S1};
		end
		/*if(Gl_subtract == 1'b1) begin
		   neg = ~result_temp;
			result_temp[0] = neg[0];
			result_temp[1] = neg[1];
			result_temp[2] = neg[2];
			result_temp[3] = neg[3];
			end
		*/
	//	led_temp = { 1'b0, 1'b0, 1'b0, C_out4, S4, S3, S2, S1};
	 end else begin
		result_temp = { 1'b0, 1'b0, 1'b1, 1'b1, S4, S3, S2, S1};
		if(Gl_subtract)begin
			result_temp = { 1'b0, 1'b1, 1'b0, 1'b1, S4, S3, S2, S1};
		end
		//led_temp = { 1'b0, 1'b0, 1'b0, C_out4, S4, S3, S2, S1};
	 end
	 
		end  
	 
	 assign L2_adder_data = {result_temp[7],result_temp[6],result_temp[5],result_temp[4],result_temp[3],result_temp[2],result_temp[1],result_temp[0]};
	// assign L2_led = led_temp[7:0];
	   
endmodule

module sigDelay(
		  output      sigOut,
		  input       sigIn,
		  input       clk,
		  input       rst);

   parameter delayVal = 4;
   reg [15:0] 		      delayReg;


   always @(posedge clk) begin
      if (rst)
	delayReg <= 16'b0;
      else begin
	 delayReg <= {delayReg[14:0], sigIn};
      end
   end

   assign sigOut = delayReg[delayVal];
endmodule // sigDelay


module fullAdder(
         input A,
			input B,
			input C_in,
			output S,
			output C_out);

	
	assign S = (A ^ B) ^ C_in;
	assign C_out = (A & B) | C_in & (A ^ B);
endmodule 


//endmodule
		