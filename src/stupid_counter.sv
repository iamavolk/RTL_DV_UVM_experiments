module stupid_counter
(
    input  logic clk,
    input  logic rstN,

    input  logic [3:0] a,
    input  logic [3:0] c,

    output logic [4:0] y
);

    always_ff @(posedge clk, posedge rstN)
    begin: sa_block
        if (!rstN)  y <= '0;
        else        y <= y + 1;
    end: sa_block

endmodule: stupid_counter
