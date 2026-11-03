module clock_gen #(
    parameter time PERIOD = 10ns
)(
    output logic clk
);
    initial begin
        clk = 0;
        forever #(PERIOD/2) clk = ~clk;
    end
endmodule: clock_gen
