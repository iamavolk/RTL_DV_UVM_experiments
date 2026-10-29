module tb_sandbox_tasks;

    logic [3:0] bus_addr;
    logic [1:0] bus_data;
    /*
            input args are sticky with respect to both the direction
            and object type

            NOTES on the arg behavior:
                (this is especially relevant due to SystemVerilog HVL being an explicitly
                    concurrent language)

                - input:    copied into the task when called
                            (ordinary call-stack behavior)

                - output:   local variable inside the task;
                            COPIED back to the external type's storage
                            when the task returns

                            with that said, the VALUE of the output argument
                            within the task ISN'T GUARANTEED to match the
                            one at call site, but if the former is assigned to,
                            the change WILL reflect it, but ONLY when
                            the task returns

                - inout:    copied in, copied out (combines both above)

                - ref:      true alias
                            think reference in c++: can't be reseated, but
                            can alter the object in a way that will be
                            reflected at tha call site immediately

    */
    task automatic wait_for_bus(input logic [3:0] addr, [1:0] expect_data,
                                output logic success_out);
        while (bus_addr != addr)
            @(bus_addr);
        success_out = (bus_data == expect_data);
        $display("\taddr match happened at time @%t!", $stime);
    endtask

    task automatic generate_addrs(input int unsigned count);
        $timeformat(-9, 2, " ns", 0);
        while (count-- > 0) begin
            //      pretend the transaction comes from DUT or another agent/VIP
            bus_addr = 4'( $urandom_range(15) );            //  static cast to [3:0]
            bus_data = 2'( $urandom_range(4) );             //  same, but to [1:0]
            // $display("@%0t: \t%d", $stime, bus_addr);
            #1;
        end
    endtask

    logic success;
    initial begin
        $display("====== success (init value) %d", success);
        /*
                a side note on the behavior:

                    if addr match never happens inside 'wait_for_bus',
                    the latter never finishes, and thus, 'wait fork' isn't
                    taking place. Can make it more robust by explicitly spawn
                    a thread that times out after a period of time and
                    disabling the 'labeled' upon the join_any

                    e.g.
                        begin
                            fork: handle_timeout
                                wait_for_bus(_, _, success);
                                begin
                                    #(100);
                                    $display("timeout reached");
                                end
                            join_any

                            disable handle_timeout;
                        end

        */
        fork
            generate_addrs(32);
            wait_for_bus(8, 2, success);
        join_none
        $display("\t\t\tmain thread says: i didn't wait because i don't have to!");

        wait fork;      //  make it wait
        $display("====== success (expected data match): %d", success);
    end

endmodule: tb_sandbox_tasks
