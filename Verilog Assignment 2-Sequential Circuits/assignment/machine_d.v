module machine_d(
    input wire x,
    input wire CLK,
    input wire RESET,
    output wire F,
    output wire [2:0] S
);
    // Your code goes here.  DO NOT change anything that is already given! Otherwise, you will not be able to pass the tests!

    dff dffA(.D((S[1] & ~x) | S[2]), .CLK(CLK), .RESET(RESET), .Q(S[2]));
    dff dffB(.D((~S[1] & ~x) | (S[1] & x) | (S[2] & ~x)), .CLK(CLK), .RESET(RESET), .Q(S[1]));
    dff dffC(.D((~S[0] & x) | (S[0] & ~x)), .CLK(CLK), .RESET(RESET), .Q(S[0]));

    and (F, S[2], S[1], ~S[0]);
    
endmodule