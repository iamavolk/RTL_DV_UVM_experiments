module clocker
(
    //
);

    timeunit 1ns/1ps;

    bit clk;
    initial clk = 0;
    always #5 clk = ~clk;

endmodule: clocker
