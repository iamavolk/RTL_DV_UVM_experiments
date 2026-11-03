interface confidence_if(
    input logic clk
);

    logic data_match, cmp_en, data_syncd, rst_n;
    logic [3:0] ref_count_dbg;

    clocking cb @(posedge clk);
        output data_match;
        output cmp_en;

        input  data_syncd;
    endclocking: cb

    clocking mon_cb @(posedge clk);
        input cmp_en;
        input data_match;
    endclocking: mon_cb

    modport DUT (
        input  clk, rst_n,
        input  data_match, cmp_en,
        output data_syncd
    );

    modport TEST (
        clocking cb,
        clocking mon_cb,
        input    clk,
        output   rst_n
    );

endinterface: confidence_if
