`timescale 1ns/10ps

module multiplier (
    input [2:0] A, B,
    output [5:0] P
);

	// Your code goes here.  DO NOT change anything that is already given! Otherwise, you will not be able to pass the tests!
    // gatelere veya modüllere inputları a'yı b'ye b'ye a'ya taktığından olabilir hata varsa!!
    wire t1, t2, t3, t4, t5, t6, t7, t8, c1, c2, c3, s1, s2, cout1, cout2;
    and (P[0], A[0], B[0]);
    and (t1, A[1], B[0]);
    and (t2, A[0], B[1]);
    half_adder ha1(t1, t2, P[1], c1);
    and (t3, A[2], B[0]);
    and (t4, A[1], B[1]);
    half_adder ha2(t3, t4, s1, c2);
    and (t5, A[0], B[2]);
    full_adder fa1(t5, s1, c1, P[2], cout1);
    and (t6, A[2], B[1]);
    and (t7, A[1], B[2]);
    full_adder fa2(t6, t7, c2, s2, cout2);
    half_adder ha3(s2, cout1, P[3], c3);
    and (t8, A[2], B[2]);
    full_adder fa3(t8, cout2, c3, P[4], P[5]);

endmodule
