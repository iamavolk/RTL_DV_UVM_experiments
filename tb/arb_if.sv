//    Example of an interface with modports
//    the interface encapsulates and bundles connections
//    modports inside the interface provide permitted views (access restriction)
//    and define directionality
interface arb_if
(
    input bit clk
);
    logic [1:0] grant, request;
    bit rst;

    // input and output as seen from the test's perspective
    // e.g.: TEST owns the cb (see below)
    //        therefore, TEST outputs request (into the dut, in our case)
    //        and accepts grant (from the dut)
    clocking cb @(posedge clk);
        output request;
        input grant;
    endclocking: cb

    // output -- from test into the dut
    // test owns the clocking block
    modport TEST (clocking cb,
                  output rst);

    //  input -- into the dut: request from clocking block, rst from the test,
    //    clk from top
    //  output -- from the dut into the clocking block
    modport DUT (input request, rst, clk,
                 output grant);

endinterface: arb_if
