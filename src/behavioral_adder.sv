module behavioral_adder (
    input  logic [13:0] a,
    input  logic [13:0] b,
    output logic [14:0] sum
);
    timeunit 1ns/1ps;

    always_comb
    begin: sum_ab
        sum = a + b;
    end: sum_ab

endmodule: behavioral_adder
