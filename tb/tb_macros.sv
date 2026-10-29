/*
        Quick-and-dirty QoL tricks that improve
        DV/simulation experience in a variety of ways

        ...WIP...
*/

//      SV doesn't lacks a foreach loop for a intergral value range,
//      so a macro would do

`define for_range(count)            \
    for (int i = 0; i < count; ++i) \

//      juggling #(delay)s within a directed testbench can
//      quickly become unwieldy; wait_until to the rescue
//
task automatic wait_until(input time target);
    if (target > $time)
        #(target - $time);
endtask: wait_until

module incr(ref int c, d);
    always @(c) #1 d = c++;
endmodule: incr

module tb_macros;

    initial begin
        `for_range(5)
            $write("i=%0d, ", i);
        $display("");
    end

    int c, d;
    incr incr_one(c, d);
    initial begin
        $monitor("@%0d: c=%0d, d=%0d", $stime, c, d);

        wait_until(10ns);
        c = 1;

        wait_until(22ns);
        c = 5;
    end

endmodule: tb_macros
