`timescale 1ns / 1ps

module machine_d_tb;
    // Your code goes here.  DO NOT change anything that is already given! Otherwise, you will not be able to pass the tests!
    reg x;
    reg CLK;
    reg RESET;
    wire F;
    wire [2:0] S;

    machine_d UUT(.x(x), .CLK(CLK), .RESET(RESET), .F(F), .S(S));

    reg [19:0] input_data;
    integer shift_amount;

    initial begin
        $dumpfile("tb.vcd");
      	$dumpvars;
        input_data = 20'b10000111010011011011;
        x = 0;
        //20'b11011011001011100001;
        //11011011001011100001;
        //10000111010011011011;
        //10000111010011011011
        shift_amount = 0;
        RESET = 1; #5;
        RESET = 0; #264;
        RESET = 1; #5;
        RESET = 0; #126; $finish;
    end

    initial begin
        CLK = 0;
        forever begin
            #10;
            CLK = ~CLK;
        end
    end

    always @(posedge CLK) begin
        x = input_data>>shift_amount;
        shift_amount = shift_amount + 1;
    end
endmodule