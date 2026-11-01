module edge_detector #(
)(
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

    always_ff @(posedge edif.clk, negedge edif.rst_n) begin
            if ( !edif.rst_n )  state <= lo;
            else                state <= next_state;
        end

    assign edif.detected = (state == got_1);



    ///////////////////////////////////////
    //  SVA
    ///////////////////////////////////////
    assert property (
        @(posedge edif.clk) disable iff (!edif.rst_n)
        edif.detected |=> !edif.detected
    );

    assert property (
        @(posedge edif.clk) disable iff (!edif.rst_n)
        $rose(edif.d_in) |=> edif.detected
    );

endmodule: edge_detector

module simple_detector #(
)(
    ed_if.DUT edif
);

    logic prev;
    always_ff @(posedge edif.clk, negedge edif.rst_n) begin
        if (!edif.rst_n)    prev <= '0;
        else                prev <= edif.d_in;
    end

    //      the so-called continuous assignment works just as well
    //      'assign = edif.detected = ( <...> );
    always_comb
        edif.detected = (edif.d_in == 1'b1 && prev == 1'b0);

endmodule: simple_detector


//      What's an interface in SystemVerilog? The answer is quite simple:
//      it serves the purpose of keeping ports and signals together;
//      it is an aggregate of a whole bunch of 'wires' that enhances
//      maintainability, reuse, and organization of the codebase
//
//      an interface may contain several subcomponents. Namely,
//      clocking blocks, and modports.
//
//      Clocking blocks are there
//      to mitigate race conditions inherent to the simulation
//      environment (the idea is that the evaluation of the stimulus values
//      of the signals defined within the clocking block is well defined, and
//      follows the model of evaluating regions in the very specific manner,
//      as defined by the LRM)
//
//      Modports are constructs that provide the notion of directionality
//      and 'belonging.' The gist of it is that modports represent subsets
//      of the interface signals and busses for each counterpart that is
//      connected via a particular modport
interface ed_if
(
    input logic clk
);
    logic rst_n, d_in, detected;

    //  d_in is driven #15 units after the clock edge
    //  detected can also admit #n; the semantics is: 'sampled #n units before clock edge'
    clocking cb @(posedge clk);
        output #15 d_in;
        input      detected;
    endclocking: cb

    modport DUT (
            input   clk,
            input   rst_n,
            input   d_in,
            output  detected
    );

    modport TEST(
            input    clk,
            output   rst_n,
            clocking cb
    );

endinterface: ed_if
