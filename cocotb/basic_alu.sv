module basic_alu
(
    input   logic [7:0] a, b,
    input   logic [2:0] op,
    input   logic rst_n, start,

    output  logic done,
    output  logic [15:0] res
);

    logic           start_fast;
    logic           clk;

    initial clk = 0;
    always #5 clk = ~clk;

    assign start_fast = start & ~op[2];
    single_cycle fast_op (
        .a    ( a ),
        .b    ( b ),
        .op   ( op ),
        .clk  ( clk ),
        .rst_n( rst_n ),
        .start( start_fast ),
        .done ( done ),
        .res  ( res )
    );


endmodule: basic_alu

module single_cycle
(
    input   logic [7:0] a, b,
    input   logic [2:0] op,
    input   logic clk, rst_n, start,

    output  logic done,
    output  logic [15:0] res
);

    always_ff @(posedge clk)
    begin: alu_result
        if (!rst_n) res <= '0;
        else
            case(op)
                3'b001:     res <= a + b;
                3'b010:     res <= a & b;
                3'b011:     res <= a ^ b;
                default:    res <= '0;
            endcase
    end: alu_result

    always_ff @(posedge clk)
    begin: done_flop
        if (!rst_n) done <= '0;
        else        done <= (start && (op != 3'b000));
    end: done_flop

endmodule: single_cycle

module three_cycle
(
    // WIP
);

endmodule: three_cycle
