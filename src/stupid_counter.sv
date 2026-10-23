module stupid_counter
(
    input  logic clk,
    input  logic rst_n,

    output logic [4:0] y
);

    always_ff @(posedge clk, negedge rst_n)
    begin: add_one
        if (!rst_n) y <= '0;
        else        y <= y + 1;
    end: add_one

endmodule: stupid_counter
