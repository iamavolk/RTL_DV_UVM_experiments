package utils_pkg;
    typedef int fixed_array5_t[5];
    // array instantiation, perhaps should be done in test, not here
    // fixed_array5_t f5;

    // comments are helpful
    task automatic monitor_time(ref bit clk);
        // using $monitor makes verilator crash
        // $monitor("@%0t: clk = %b", $time, clk);
        $display("@%0t: clk = %b", $time, clk);
        forever begin
            @(clk);
            $display("@%0t: clk = %b", $time, clk);
        end
    endtask: monitor_time

    //  comments are useful
    function automatic void print_csm_11 (const ref bit [31:0] a[]);
        bit [31:0] checksum = 0;
        for (int i=0; i < a.size(); ++i)
            checksum ^= a[i];
        $display("the array checksum is %h", checksum);
    endfunction: print_csm_11

    //  leave comments, be kind to yourself a few months on from now
    function automatic fixed_array5_t init(input int start);
        foreach (init[i]) begin
            init[i] = i + start;
        end
    endfunction: init

    //  but also be mindful and don't clutter the workspace
    function automatic void say_hi();
        $display("yo");
    endfunction: say_hi

endpackage: utils_pkg
