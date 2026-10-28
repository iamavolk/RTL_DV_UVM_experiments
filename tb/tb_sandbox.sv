module tb_sandbox #(/* params, type params */) (
    /* io */
);
    //  Just so we have some room in the cli output
    initial $display("");
    initial #1 $display("");

    typedef int Qint[$];

    Qint dynamicQ[];        //  dynamic array of queues
    Qint quequeQ[$];        //  queue of queues
    Qint assocQ[string];    //  associative array of queues

    function automatic void do_queues();
        dynamicQ = new[2];
        dynamicQ[0] = {1, 2, 3};
        dynamicQ[1].push_back(7);
        $display("dynamicQ %p", dynamicQ);

        quequeQ.push_back('{1});
        quequeQ.push_back('{2});
        quequeQ[1].push_front(3);
        $display("quequeQ %p", quequeQ);

        assocQ["one"].push_back(5);
        assocQ["two"].push_back(7);
        $display("assocQ %p", assocQ);
    endfunction

    typedef struct packed { //  packed struct (can be signed or unsigned (default))
        byte    be;         //  contiguous mem layout is guaranteed by the LRM
        int     addr;
        int     data;
    } pStruct_s;

    typedef struct {        //  unpacked struct ('signed' isn't allowed)
        byte    be;         //  can be format-displayed with %p
        int     addr;       //  contiguous memory layout isn't guaranteed
        int     data;
    } uStruct_s;

    pStruct_s ps = '{       //  assignment by field name
        be:     'hf,
        addr:   'h2,
        data:   'h3
    };

    uStruct_s us = '{
        be:     'hf,
        addr:   'h2,
        data:   'h3
    };

    /*   A few comments on callables in SystemVerilog:
            'function static' vs 'static function'
             the idea is that the latter is your regular OOP static function
             within a class. The former, on the other hand, is a function
             whose variables/parameters are static (not automatic)              */

    function automatic void dBus (ref uStruct_s ctrl);
        int value = 0;
        /*  a slightly loaded example to showcase:
               1. passing an entity by reference (func must be automatic)
               2. passing a used-defined type object as arg
               3. 'automatic' in the module-scope means 'value' is per call    */
    endfunction: dBus


    // initial begin
    //     $display("ps=%h", ps);
    //     $display("us=%p", us);
    // end
    // initial
    //     select_ordinal();

endmodule: tb_sandbox

/*  foreach loop grabs elements by keys, but we
    want ordinal positions, hence the use of 'count'                            */
task select_ordinal;
    int aa[int] = '{ 0:1, 5:2, 10:4, 50:3, 33:1 };
    int idx, elem, count;
    elem = $urandom_range(aa.size()-1);

    foreach(aa[i])
        if (count++ == elem) begin
            idx = i;
            break;
        end

    $display("element#%0d aa[%0d] = %0d", elem, idx, aa[idx]);
endtask: select_ordinal
