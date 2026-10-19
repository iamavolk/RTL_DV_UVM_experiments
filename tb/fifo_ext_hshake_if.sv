interface fifo_ext_hshake_if
#(
    parameter int DWIDTH = 8,
    parameter int AWIDTH = 4
)(
    input logic clk
);
    timeunit 1ns/1ps;

    logic               rst_n, w_en, r_en;
    logic [DWIDTH-1:0]  d_in, d_out;
    logic               full, empty;

    clocking cb @(posedge clk);
        output d_in;
        output r_en;
        output w_en;

        input  d_out;
        input  full;
        input  empty;
    endclocking: cb

    modport DUT (
        input  clk, rst_n,
        input  w_en, r_en,
        input  d_in,
        output d_out,
        output full, empty
    );

    modport TEST (
       clocking cb,
       input    clk,
       output   rst_n
    );

endinterface: fifo_ext_hshake_if
