`timescale 1ns/10ps

module full_adder_tb;
    // Your code goes here.  DO NOT change anything that is already given! Otherwise, you will not be able to pass the tests!
    reg A, B, Cin;
   	wire S, Cout;

	full_adder UUT(A, B, Cin, S, Cout);

   	initial begin
      	$dumpfile("tb.vcd");
      	$dumpvars;
      	A = 0; B = 0; Cin = 0;
	  
		for (integer i = 0; i < 2 ; i++) begin
			for (integer j = 0; j < 2 ; j++) begin
                for (integer k = 0; k < 2 ; k++) begin
				A = i; B = j; Cin = k;
				#10;
			    end
			end
		end

      $finish;
   end
    
endmodule
