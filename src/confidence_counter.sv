//  a confidence counter (aka saturating confidence counter
//  accumulator, or leaky integrator, or hyseresis counter)
//  is a model that's useful wherever the persistent evidence
//  is required (rather than one sample)
//
//  typical use cases include:
//      - noisy signal qualification
//      - sensor validity detection
//      - communication/link lock detection
//      - debouncing
//      - data integrity or redundancy checks
//      - tracking whether a sampled signal is "trusted"
//      - hysteresis in control or status logic
module confidence_counter #(
    //  type params
)(
    confidence_if.DUT cif
);
    import definitions_pkg::*;

    states_enum_t state, next_state;

    always_ff @(posedge cif.clk, negedge cif.rst_n) begin
        if (!cif.rst_n) state <= COUNT0;
        else            state <= next_state;
    end

    always_ff @(posedge cif.clk, negedge cif.rst_n) begin
        if (!cif.rst_n)
            cif.data_syncd <= 0;
        else if (state == COUNT8)
            cif.data_syncd <= 1;
        else if (state == COUNT0)
            cif.data_syncd <= 0;
    end

    always_comb begin
        next_state = state;
        if (cif.cmp_en) begin
            if (cif.data_match && (state != COUNT15))
                    next_state = state.next();
        end
        else begin
            case (state)
                COUNT0: ;
                COUNT1:  next_state = state.prev(1);
                default: next_state = state.prev(2);
            endcase
        end
    end

endmodule: confidence_counter
