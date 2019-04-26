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
 output wire [7:0] L2_led
 //assign C_out;
 
 //if(gl_subtract ==1) begin
	//assign gl_r1 = Gl_r1[3:0];
	//assign g2_r2 = Gl_r2[3:0];
	//g2_r2 = ~gl_r2 1;
 //end else begin
		   	
	fullAdder(
         .A(Gl_r1[0]),
			.B(Gl_r2[0]),
			0,
			.S(L2_LED[0]),
			C_out1);
			
	fullAdder(
         Gl_r1[1]
			Gl_r2[1],
			C_out1,
			S[1],
			C_out2);
			
	fullAdder(
         Gl_r1[2]
			Gl_r2[2],
			C_out2,
			S[2],
			C_out3);
			
	fullAdder(
         Gl_r1[3]
			Gl_r2[3],
			C_out3,
			S[3],
			C_out4);
			
	L2_adder_data[0] =S[0];
	L2_adder_data[1] =S[1];
	L2_adder_data[2] =S[2];
	L2_adder_data[3] =S[3];
	L2_adder_data[4] = C_out4;
	
 
	
    
 
 
);

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

wire A;
wire B;
wire S, C;
assign S = (A ^ B) ^ C_in;
assign C_out = (A & B) | C_in & (A ^ B);



end module
		