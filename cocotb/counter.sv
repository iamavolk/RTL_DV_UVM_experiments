module counter
(
    input   bit             clk, rst_n,
    output  byte unsigned   count
);

    always_ff @(posedge clk)
    begin: add_one
        count <= rst_n ? count + 1 : '0;
    end: add_one

endmodule: counter
