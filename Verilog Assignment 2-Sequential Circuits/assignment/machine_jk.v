module machine_jk(
    input wire x,
    input wire CLK,
    input wire RESET,
    output wire F,
    output wire [2:0] S
);
    // Your code goes here.  DO NOT change anything that is already given! Otherwise, you will not be able to pass the tests!
    jkff jkffA(.J(S[1] & ~x), .K(1'b0), .CLK(CLK), .RESET(RESET), .Q(S[2]));
    jkff jkffB(.J(~x), .K(~S[2] & ~x), .CLK(CLK), .RESET(RESET), .Q(S[1]));
    jkff jkffC(.J(x), .K(x), .CLK(CLK), .RESET(RESET), .Q(S[0]));

    and (F, S[2], S[1], ~S[0]);
endmodule