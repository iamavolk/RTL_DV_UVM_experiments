typedef class confidence_test;

module tb_confidence_counter;
    logic clk;
    clock_gen clock_unit(.*);
    confidence_if cif(.*);
    confidence_counter ccounter(cif.DUT);

    confidence_test ctest;
    initial begin
        ctest = new(cif.TEST);
        ctest.run();
        $finish();
    end

    initial begin
        $dumpfile("waves/confidence_counter.fst");
        $dumpvars(0, tb_confidence_counter);
    end

endmodule: tb_confidence_counter

class confidence_test;
    virtual confidence_if.TEST vif_;

    //      ref model
    int unsigned ref_count_;

    //      DUT interaction
    logic ref_data_syncd;       //  observable / from

    function new(virtual confidence_if.TEST vif);
        vif_ = vif;
        { ref_count_, ref_data_syncd } = 0;
    endfunction

    task automatic model_predict();
        forever begin
            @(vif_.cb, negedge vif_.rst_n);
            if (vif_.rst_n == 0) begin
                ref_count_ = 0;
                ref_data_syncd = 0;
            end
            else begin

                //
                //  vif_.cb.data_syncd is a clocking-block input, and its
                //  inputs are sampled just before the clock edge by default
                //  in the so-called Postponed region of the simulation, when
                //  all design (active region), assertions (observed region),
                //  and testbench (reactive region) are completely finished.
                //
                //  As such, the INPUTS to the clocking block (as seen from
                //  the testbench) are updated as if there is a syncronizer
                //  between the DUT output and the TB input
                //
                //  Hence, if the DUT sees COUNT8, it drives DATA_SYNCD flop
                //  on cycle N. The signal shows up at cycle N+1. The TB
                //  sees it at cycle N+2 due to the clocking block
                //
                //  clocking block OUTPUTS are, on the other hand, updated
                //  without a clock-cycle delay
                //

                if (vif_.cb.data_syncd !== ref_data_syncd)
                    $error("data syncd mismatch: expected=%b, actual=%b",
                            ref_data_syncd, vif_.cb.data_syncd);

                // $display("[@%0t] expected=[%0b], actual=[%0b]", $stime,
                //         ref_data_syncd, vif_.cb.data_syncd);

                //  predict registered output from previous state
                if (ref_count_ == 8)
                    ref_data_syncd = 1;
                else if (ref_count_ == 0)
                    ref_data_syncd = 0;

                //  update to current state
                if (vif_.mon_cb.cmp_en && vif_.mon_cb.data_match) begin
                    if (ref_count_ < 15) ref_count_++;
                end

                else if (!vif_.mon_cb.cmp_en) begin
                    if (ref_count_ == 1) ref_count_ -= 1;
                    else if (ref_count_ > 1) ref_count_ -= 2;
                end
            end
        end
    endtask: model_predict

    task automatic apply_inputs(input logic cmp_en, data_match);
        @(vif_.cb) begin
            vif_.cb.cmp_en     <= cmp_en;
            vif_.cb.data_match <= data_match;
        end
    endtask: apply_inputs

    task automatic run();
        vif_.rst_n  = 0;
        fork model_predict(); join_none

        repeat (2)
            @(vif_.cb);

        vif_.rst_n = 1;

        repeat (11)
            apply_inputs(1, 1);

        repeat (2)
            @(vif_.cb);
    endtask: run

endclass: confidence_test
