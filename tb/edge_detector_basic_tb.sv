module edge_detector_basic_tb
(
    ed_if.TEST edif
);

    initial
        begin
            edif.rst_n = 0;
            //  clocking blocks can only be driven by NBAs
            edif.cb.d_in <= 0;

            repeat (2)
                @(edif.cb);
            edif.rst_n = 1;

            @(edif.cb);
            edif.cb.d_in <= 1;
            @(edif.cb);
            $display("detected: %p", edif.cb.detected);

            @(edif.cb);
            $display("detected: %p", edif.cb.detected);

            repeat (6)
                @(edif.cb);
            edif.cb.d_in <= 0;
            $display("detected: %p", edif.cb.detected);
            $finish();
        end

endmodule: edge_detector_basic_tb
