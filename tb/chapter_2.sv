program chapter_2;
    import "DPI-C" function int c_add(input int a, input int b);
    import "DPI-C" function int rust_add(input int a, input int b);

    initial
    begin: rust_ffi
        int result = rust_add(20, 40);
        disable rust_ffi;
        $display("%0d", result);
    end: rust_ffi

    byte b[$] = { 2, 3, 4, 5 };   // a queue (perhaps, a deque would be better name for this DS)
    int w;                        // 'int' is a 2-state type

    initial
    begin: array_methods
        disable array_methods;

        w = b.sum();
        $display("sum: %0d", w);
        w = b.product();
        $display("product: %0d", w);
        w = b.and();
        $displayb("and: %0b", w);

        $display("random elem: %0d", b[$urandom_range(b.size()-1)]);
    end: array_methods

    //  a rule of thumb: use packed struct if accessing the struct itself
    //  (but not individual elements) often
    //  otherwise use regular ('unpacked') struct
    typedef struct packed { bit [7:0] r, g, b; } pixel_t;
    pixel_t my_pixel;

    // logic clk = 0;
    // always #5 clk = ~clk;

    logic [3:0] a = 3;
    logic [3:0] c = 4;
    logic [4:0] y;
    logic rst;

    stupid_counter sa(.a, .c, .y, .clk, .rst);

    initial
    begin: testadder
        rst = '1;
        repeat(4) @(posedge clk);
        rst = '0;
        @(posedge clk);
        $display("%0d", y);
        repeat(4) @(posedge clk);
        $display("%0d", y);
        $finish();
    end: testadder

endprogram: chapter_2
