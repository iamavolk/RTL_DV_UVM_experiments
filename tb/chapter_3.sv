program chapter_3
(
    output logic clk
);
    import utils_pkg::*;

    timeunit 1us/1ps;

    initial
    forever #4 clk = ~clk;

    initial
    begin: long
        repeat(100) @(posedge clk);
        $display("100 edges passed");
        $finish;
    end: long

    initial
    begin: short
        repeat(40) @(posedge clk);
        $display("40 edges passed");
    end: short

endprogram: chapter_3
