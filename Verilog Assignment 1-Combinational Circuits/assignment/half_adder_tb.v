`timescale 1ns/10ps

module half_adder_tb;

	// Your code goes here.  DO NOT change anything that is already given! Otherwise, you will not be able to pass the tests!
	reg A, B;
   	wire S, C;

	half_adder UUT(A, B, S, C);

   	initial begin
      	$dumpfile("tb.vcd");
      	$dumpvars;
      	A = 0; B = 0;
	  
		for (integer i = 0; i < 2 ; i++) begin
			for (integer j = 0; j < 2 ; j++) begin
				A = i; B = j;
				#10;
			end
		end

      $finish;
   end

endmodule
