timeunit 1ns/1ps;

module test_top;
    bit clk = 0;

    initial
        forever #50 clk = ~clk;

    initial
        begin: dynamic_array_test

            utils_pkg::fixed_array5_t values_array;
            values_array = utils_pkg::init(8);
            // $display("%p", values_array);

        end: dynamic_array_test

    initial
        begin: test_core

        end: test_core

    // no simulator time
    initial
        $finish();

endmodule: test_top
