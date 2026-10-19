module test_with_clocking
(
    arb_if.TEST arbif
);

    initial
        begin: basic_tb_with_cb
            arbif.rst = '1;

            repeat (2)
                @(arbif.cb);

           arbif.rst = '0;

            @(arbif.cb);
            arbif.cb.request <= 2'b01;
            $display("driving request");

            @(arbif.cb);
            $display("@%0t: Grant = %b", $time, arbif.cb.grant);

            @(arbif.cb);
            $display("@%0t: Grant = %b", $time, arbif.cb.grant);

            // $finish();
        end: basic_tb_with_cb

endmodule: test_with_clocking
