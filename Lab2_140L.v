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

// Module Lab2_140L
// implements a 4 bit full adder and and takes that results
// to display the LED respresentation of the result and also
// the ascii sum of the value
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
 

 wire [3:0] Gl_r2_new; // temp variable holding first 4 bits of Gl_r2
 wire S1; // Sum of first full adder
 wire S2; // Sum of second full adder
 wire S3; // Sum of third full adder
 wire S4; // Sum of fourth full adder
 wire C_out1; // Output of first full adder
 wire C_out2; // Output of second full adder
 wire C_out3; // Output of third full adder
 wire C_out4; // Output of fourth full adder
 reg [7:0] result_temp; // temp variable to hold ascii sum 

 
 //Negate the first 4 bits of Gl_r2 if subtract is 1 by XOR'ing
 assign Gl_r2_new[0] = Gl_subtract ^ Gl_r2[0]; 
 assign Gl_r2_new[1] = Gl_subtract ^ Gl_r2[1];
 assign Gl_r2_new[2] = Gl_subtract ^ Gl_r2[2];
 assign Gl_r2_new[3] = Gl_subtract ^ Gl_r2[3];
 
 // First call to full adder  
 fullAdder f1(
         	.A(Gl_r1[0]), 		// First bit of Gl_r1
		.B(Gl_r2_new[0]), 	// First bit of Gl_r2
		.C_in(Gl_subtract), 	// C_in is 1 if subtract else 0
		.S(S1), 	 	// First Sum
		.C_out(C_out1)		// First C_out
	     );
			

 // Second call to full adder  
 fullAdder f2(
         	.A(Gl_r1[1]),		// Second bit of Gl_r1
		.B(Gl_r2_new[1]),	// Second bit of Gl_r2
		.C_in(C_out1),		// C_in is C_out of f1
		.S(S2),			// Second sum
		.C_out(C_out2)		// Secound C_out
	     );
			
 // Third call to full adder  
 fullAdder f3(
 	      	.A(Gl_r1[2]),		// Third bit of Gl_r1
		.B(Gl_r2_new[2]),	// Third bit of Gl_r2
		.C_in(C_out2),		// C_in is C_out of f2
		.S(S3),			// Third Sum
		.C_out(C_out3)		// Third C_out
	     );
			
 // Fourth call to full adder  
 fullAdder f4(
         	.A(Gl_r1[3]),		// Fourth bit of Gl_r1
		.B(Gl_r2_new[3]),	// Fourth bit of Gl_r2
		.C_in(C_out3),		// C_in is C_out of f3
		.S(S4),			// Fourth sum
		.C_out(C_out4)		// Fourth C_out
	     );

	
	
	
 assign L2_led = {1'b0,1'b0,1'b0, C_out4 ^ Gl_subtract, S4,S3,S2,S1}; // Assign all sum bits of full adders and last C_out
		
	always @ (*) begin
	 if(C_out4) begin // carry out == 0
		
		result_temp = { 1'b0, 1'b1, 1'b0,1'b1, S4, S3, S2, S1};
		if(Gl_subtract)begin
			result_temp = { 1'b0, 1'b0, 1'b1, 1'b1, S4, S3, S2, S1};
		end
		
	 end else begin
		result_temp = { 1'b0, 1'b0, 1'b1, 1'b1, S4, S3, S2, S1};
		if(Gl_subtract)begin
			result_temp = { 1'b0, 1'b1, 1'b0, 1'b1, S4, S3, S2, S1};
		end
	 end
	 
		end  
	 
 
 assign L2_adder_data = result_temp[7:0]; // Assign all bits of full adders and last C_out
 					  // Also assign the MSB 4 bits to
					  // correct ascii bits
 
 // Call to sig delay
 sigDelay sDelay(
		 .sigOut(L2_adder_rdy),
		 .sigIn(Gl_adder_start),
		 .clk(clk),
		 .rst(Gl_rst)
		);
	
	   
endmodule

// Module sigDelay
// Delays the input to the output by a set number
// of clock cycles
//
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

// Module fulladder
// takes in 3 1 bit inputs and outputs
// the sum of two bits and the carry if any
//
module fullAdder(
         		input A, 	// Input bit
			input B, 	// Input bit
			input C_in, 	// Input bit
			output S, 	// Sum of 3 inputs
			output C_out);  // C_out of 3 inputs
	
	assign S = (A ^ B) ^ C_in; // Sum of 3 inputs
	assign C_out = (A & B) | C_in & (A ^ B); // C_out of 3 inputs
endmodule 


//endmodule
		
