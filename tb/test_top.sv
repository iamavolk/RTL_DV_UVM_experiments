timeunit 1ns/1ps;

class Stim;
    const bit [31:0] CONGEST_ADDR = 42;
    typedef enum { read, write, control } stim_e;

    randc stim_e kind;

    rand bit [31:0] length, src, dst;
    rand bit        congestion_test;

    constraint c_stim {
        length < 1000;
        length > 0;
        if (congestion_test) {
            dst inside { [CONGEST_ADDR-10:CONGEST_ADDR+10] };
            src == CONGEST_ADDR;
        } else {
            src inside { 0, [2:10], [100:107] };
        }
    }

endclass: Stim

class Transaction;
    rand bit [1:0] src, dst;
    constraint c_dist {
        //      what's going on here is the following:
        //      for 'src' weights are assigned in the aggerate manner:
        //          0: 40, 1: 60, 2: 60, 3: 60, for the total of 220
        //          the odds, therefore, are: 40/220 for 0, 60/220 for 1, etc.
        //
        //      for 'dst' weights are assigned as follows:
        //          0: 40, 1 through 3 together get 60 (i.e. 20 each)
        //          the odds: 40/100 for 0, 20/100 for 1, etc
        src dist { 0:=90, [1:3]:=10 };
        dst dist { 0:/40, [1:3]:/60 };
    }
endclass: Transaction

task automatic run_stim();
    Stim s;
    s = new();
    repeat(4) begin
        if (!s.randomize())
            $display("something went wrong");
        $display("\t kind=%s,\t len=%0d,\t src=%0d,\t dst=%0d,\t congestion=%0d",
            s.kind.name(), s.length, s.src, s.dst, s.congestion_test);
    end
endtask: run_stim

task automatic test_distribution();
    Transaction tr;
    tr = new();
    repeat (50) begin
        if (!tr.randomize())
            $display("something went wrong");
        $display("\t src=%0d,\t dst=%0d", tr.src, tr.dst);
    end
endtask: test_distribution

task automatic misc_tests();
    utils_pkg::fixed_array5_t values_array;
    values_array = utils_pkg::init(8);
    $display("%p", values_array);
endtask: misc_tests

module test_top;
    bit clk = 0;

    initial
        forever #50 clk = ~clk;

    //      fork/join spawn dynamic "coroutine"-like simulator threads
    initial
    begin: concurrent
        fork
            misc_tests();
            test_distribution();
            run_stim();
        join

        $finish();
    end: concurrent

endmodule: test_top
