`timescale 1ns/10ps

module multiplier_tb;

	// Your code goes here.  DO NOT change anything that is already given! Otherwise, you will not be able to pass the tests!
	reg[2:0] A, B;
   	wire[5:0] P;

	multiplier UUT(A, B, P);

   	initial begin
      	$dumpfile("tb.vcd");
      	$dumpvars;
      	A[0] = 0; A[1] = 0; A[2] = 0; B[0] = 0; B[1] = 0; B[2] = 0;
	  
		for (integer i = 0; i < 2 ; i++) begin
			for (integer j = 0; j < 2 ; j++) begin
                for (integer k = 0; k < 2 ; k++) begin
					for (integer l = 0; l < 2 ; l++) begin
						for (integer m = 0; m < 2 ; m++) begin
							for (integer n = 0; n < 2 ; n++) begin
								A[0] = i; A[1] = j; A[2] = k; B[0] = l; B[1] = m; B[2] = n;
								#10;
							end
						end
					end
				end
			end
		end

      $finish;
   end

endmodule
