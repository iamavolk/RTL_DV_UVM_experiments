module fifo_ext_hshake
#(
    parameter int DWIDTH = 8,
    parameter int AWIDTH = 4
)(
    fifo_ext_hshake_if.DUT fifo_if
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

    logic same_addr, same_msb;

    // ----------
    //  SEQ
    // ----------
    always_ff @(posedge fifo_if.clk, negedge fifo_if.rst_n)
    begin: fifo_state

        if (!fifo_if.rst_n)
        begin: reset_active_low
            wr_ptr          <= '0;
            rd_ptr          <= '0;
            fifo_if.d_out   <= '0;
        end: reset_active_low

        else
        begin: regular_op

            if (fifo_if.w_en && !fifo_if.full)
            begin: enqueue
                buff[wr_ptr[AWIDTH-1:0]]    <= fifo_if.d_in;
                wr_ptr                      <= wr_ptr + '1;
            end: enqueue

            if (fifo_if.r_en && !fifo_if.empty)
            begin: deque
                fifo_if.d_out   <= buff[rd_ptr[AWIDTH-1:0]];
                rd_ptr          <= rd_ptr + '1;
            end: deque

        end: regular_op

    end: fifo_state

    // ----------
    //  CL
    // ----------
    assign same_addr = ( wr_ptr[AWIDTH-1:0] == rd_ptr[AWIDTH-1:0] );
    assign same_msb  = ( wr_ptr[AWIDTH] == rd_ptr[AWIDTH] );

    always_comb
    begin: detect_full_empty
        fifo_if.full    = '0;
        fifo_if.empty   = '0;

        if (same_addr) begin
            if (same_msb)   fifo_if.empty = '1;
            else            fifo_if.full  = '1;
        end
    end: detect_full_empty

endmodule: fifo_ext_hshake
