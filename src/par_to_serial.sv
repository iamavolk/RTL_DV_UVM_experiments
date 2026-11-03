module par_to_serial #(
    parameter int unsigned W = 4
)(
    input logic         clk,
    input logic         rst_n,
    input logic         load,
    input logic [W-1:0] d_in,

    output logic done, occupied,
    output logic dout
);

    typedef enum logic { IDLE, BUSY } state_e;
    state_e s, ns;

    logic           [W-1:0] chain;
    logic [$clog2(W+1)-1:0] counter;

    always_ff @(posedge clk) begin
        //  reset behavior (syncronous)
        if (!rst_n) { chain, counter, done } <= '0;

        //  normal operation
        else begin: normal_op
            done <= '0;

            if (s == BUSY) begin: shifting
                if (counter == W-1) begin
                    counter <= '0;
                    done    <= 1'b1;
                end else begin
                    counter <= counter + 1'b1;
                    chain   <= chain << 1;
                end
            end: shifting

            else if (load) begin: idle_load
                chain   <= d_in;
                counter <= '0;
            end: idle_load

        end: normal_op
    end

    always_ff @(posedge clk) begin: state_transition
        if (!rst_n) s <= IDLE;
        else        s <= ns;
    end: state_transition

    always_comb begin
        dout      = chain[W-1];
        ns        = IDLE;
        occupied  = (s == BUSY);

        unique case (s)
            IDLE: ns = load ? BUSY : IDLE;
            BUSY: ns = (counter == W-1) ? IDLE : BUSY;
        endcase
    end

endmodule: par_to_serial
