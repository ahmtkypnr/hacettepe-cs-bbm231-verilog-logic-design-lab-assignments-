`timescale 1ns/10ps

module full_adder(
    input A, B, Cin,
    output S, Cout
);

	// Your code goes here.  DO NOT change anything that is already given! Otherwise, you will not be able to pass the tests!
    
    wire t1, t2, t3;
    half_adder ha1(.A(A), .B(B), .S(t1), .C(t2));
    half_adder ha2(.A(t1), .B(Cin), .S(S), .C(t3));
    or (Cout, t2, t3);

endmodule
