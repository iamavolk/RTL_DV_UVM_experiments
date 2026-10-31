module full_adder (
    input  logic a, b, cin,
    output logic result, cout
);

    //    this is to show the idea of a synthesizable function
    //    in modern systemverilog
    function automatic logic maj(input a, b, c);
        return a ^ b ^ c;
    endfunction: maj

    assign cout = maj(a, b, cin);
    assign result = a ^ b ^ cin;

endmodule: full_adder

module n_bit_adder #(
    parameter int unsigned AWIDTH = 2
)(
    input  logic [AWIDTH-1:0] a, b,
    output logic [AWIDTH:0]   sum
);

    logic [AWIDTH:0] carry;
    assign carry[0]     = 1'b0;
    assign sum[AWIDTH]  = carry[AWIDTH];

    /*

                 a[i+1]  b[i+1]           a[i]   b[i]
                     |   |                   |   |
                    .-----.                 .-----.
                    |     |                 |     |
       cout[i+2] <- | FA  | <- cout[i+1] <- | FA  | <- cin[i]
       |            |_____|                 |_____|
       |               |                       |
       v               v                       v
       sum[i+2]        sum[i+1]                sum[i]

    */

    //      IEEE-1800 LRM doesn't require 'generate .. endgenerate'
    for (genvar i = 0; i < AWIDTH; ++i)
    begin: gen_FA
        full_adder fa(
            .a      ( a[i]       ),
            .b      ( b[i]       ),
            .cin    ( carry[i]   ),
            .result ( sum[i]     ),
            .cout   ( carry[i+1] )
        );
    end: gen_FA

endmodule: n_bit_adder
