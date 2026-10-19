module edge_detector
(
    ed_if.DUT edif
);

    typedef enum logic [1:0] { lo, got_1, hi } state_t;
    state_t state, next_state;

    //  'unique case' has the following RUNTIME semantics:
    //  if next_state is even '11, the simulator gives a warning
    //  in this sense, unique case is a contract that's saying
    //  'next_state' can only take the given values, nothing else
    always_comb
        unique case (state)
            lo:     next_state = edif.d_in ? got_1 : lo;
            got_1:  next_state = edif.d_in ? hi : lo;
            hi:     next_state = edif.d_in ? hi : lo;
            // default:
            //     next_state = lo;
        endcase

    always_ff @(posedge edif.clk, negedge edif.rst_n)
        begin
            if ( !edif.rst_n )  state <= lo;
            else                state <= next_state;
        end
    assign edif.detected = (state == got_1);



    ///////////////////////////////////////
    //  SVA
    ///////////////////////////////////////
    // assert property (
    //     @(posedge clk) disable iff (!rst_n)
    //     detected |=> !detected
    // );
    //
    // assert property (
    //     @(posedge clk) disable iff (!rst_n)
    //     $rose(input_bit) |=> detected
    // );

endmodule: edge_detector




interface ed_if
(
    input logic clk
);
    logic rst_n, d_in, detected;

    //  d_in is driven #15 units after the clock edge
    //  detected can also admit #n, meaning 'sampled #n units before clock edge'
    clocking cb @(posedge clk);
        output #15 d_in;
        input      detected;
    endclocking: cb

    modport DUT ( input clk, rst_n, d_in,
                  output detected );

    modport TEST ( input clk, clocking cb,
                   output rst_n );

endinterface: ed_if
