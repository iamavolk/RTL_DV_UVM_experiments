timeunit 1ns/1ps;

module tb_top;
    bit clk = 0;
    always #50 clk = ~clk;

    arb_if              arbif   ( clk );
    simple_arbiter      a1      ( arbif.DUT );
    test_with_clocking  t1      ( arbif.TEST );

    // initial
    //     utils_pkg::monitor_time(clk);

    fifo_ext_hshake_if  fifo_if     ( clk );
    fifo_ext_hshake     fifo_dut    ( fifo_if.DUT );

    initial
        $timeformat(-9, 0, " ns", 10);

    // initial
    //     begin: dynamic_array_test
    //         utils_pkg::fixed_array5_t values_array;
    //         values_array = utils_pkg::init(8);
    //         $display("%p", values_array);
    //     end: dynamic_array_test

    ed_if                   edif    ( clk );
    edge_detector           dut     ( edif.DUT );
    edge_detector_basic_tb  ed_test ( edif.TEST );

    initial begin
        $dumpfile("tb/waves/edge.fst");
        $dumpvars(0, tb_top);
    end

    initial begin
        repeat (100)
            @(posedge clk);
        utils_pkg::say_hi();
        $finish();
    end

endmodule: tb_top
