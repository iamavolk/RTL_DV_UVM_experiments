module fifo_ext_hshake
#(
    parameter int DWIDTH = 8,
    parameter int AWIDTH = 4
)(
    input   logic               clk, rst_n, w_en, r_en,
    input   logic [DWIDTH-1:0]  d_in,

    output  logic [DWIDTH-1:0]  d_out,
    output  logic               full, empty
);
    timeunit 1ns/1ps;
    localparam int DEPTH = 1 << AWIDTH;

    // ----------
    //  Buffer
    // ----------
    logic [DWIDTH-1:0] buff [DEPTH];

    // ----------
    //  Pointers
    // ----------
    logic [AWIDTH:0] wr_ptr;
    logic [AWIDTH:0] rd_ptr;

    // ----------
    //  SEQ
    // ----------
    always_ff @(posedge clk, negedge rst_n)
    begin: fifo_state

        if (!rst_n)
        begin: reset_active_low
            wr_ptr  <= '0;
            rd_ptr  <= '0;
            d_out   <= '0;
        end: reset_active_low

        else
        begin: regular_op

            if (w_en && !full)
            begin: enqueue
                buff[wr_ptr[AWIDTH-1:0]]    <= d_in;
                wr_ptr                      <= wr_ptr + '1;
            end: enqueue

            if (r_en && !empty)
            begin: deque
                d_out   <= buff[rd_ptr[AWIDTH-1:0]];
                rd_ptr  <= rd_ptr + '1;
            end: deque

        end: regular_op

    end: fifo_state

    // ----------
    //  CL
    // ----------
    logic same_addr = ( wr_ptr[AWIDTH-1:0] == rd_ptr[AWIDTH-1:0] );
    logic same_msb  = ( wr_ptr[AWIDTH] == rd_ptr[AWIDTH] );

    always_comb
    begin: detect_full_empty
        full    = '0;
        empty   = '0;
        if (same_addr) begin
            if (same_msb)   empty = '1;
            else            full  = '1;
        end
    end: detect_full_empty

endmodule: fifo_ext_hshake
