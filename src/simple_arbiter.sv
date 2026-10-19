//    Example of an arbiter that accepts an interface
//    (or, rather, its "variant", or "view", in the form of a particular modport within it)
module simple_arbiter
(
    arb_if.DUT arbif
);

    always @(posedge arbif.clk, posedge arbif.rst)
        begin: arbiter_interface_test
            if (arbif.rst)
                arbif.grant <= '0;
            else if (arbif.request[0])
                arbif.grant <= 2'b01;
            else if (arbif.request[1])
                arbif.grant <= 2'b10;
            else
                arbif.grant <= '0;
        end: arbiter_interface_test

endmodule: simple_arbiter
