/*
        Quick-and-dirty QoL tricks that improve
        DV/simulation experience in a variety of ways

        ...WIP...
*/

//      SV lacks a foreach syntactic sugar for an intergral value- based
//      range, so a macro like the one below would do

`define for_range(count)            \
    for (int i = 0; i < count; ++i) \

//      a few notes no the macro syntax:
//         --   `__FILE__, etc, are SV preprocessor macro defines
//
//         --   wrappers `" <...> `" are needed to expand r, since r itself
//              is an expression (otherwire r is simply substituted, i.e. "r")
//
//         --   the semicolon literal (;) is intended to be used with the macro
//              'do begin .. end while(0)' style assumes this style:
//
//                  rand_check(tx.randomize(t));
//
`define rand_check(r)                                       \
    do begin                                                \
        if (!(r)) begin                                     \
            $display("%s:%0d: randomization failed \"%s\"", \
                     `__FILE__, `__LINE__, `"r`");          \
            $finish();                                      \
        end                                                 \
    end while(0)

//          juggling #(delay)s within a directed testbench can
//          quickly become unwieldy; 'wait_until' to the rescue
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
