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
    initial
        datatypes::sv_datatypes();

endmodule: tb_sandbox

package datatypes;
    task automatic sv_datatypes;
        // select_ordinal();
        // arr_locator_methods();
        // sum_of_bits();
        // mini_scb();
        // streaming_ops();
        // enum_types();
    endtask: sv_datatypes

    typedef enum { INIT, DECODE, IDLE } fsmstate_e;
    fsmstate_e pstate, nstate;
    task automatic enum_types;
        case (pstate)
            IDLE:       nstate = INIT;
            INIT:       nstate = DECODE;
            default:    nstate = IDLE;
        endcase
        $display("next state is %s", nstate.name());
        $display("nstate last is %s", nstate.last());
        $display("nstate next(n), where n=1 is: %s", nstate.next(1).name());
    endtask: enum_types

    task automatic streaming_ops;
        int h;
        bit [7:0] b;
        bit [7:0] g[4];
        bit [7:0] j[4] = '{ 8'ha, 8'hb, 8'hc, 8'hd };
        bit [7:0] q, r, s, t;

        h = { >> {j}};
        $display("%h", h);                      //  0a0b0c0d, all packed into h
        h = { << {j}};
        $display("%h", h);                      //  b030d050, packed as reverse bits
        h = { << byte {j}};
        $display("%h", h);                      //  0d0c0b0a, packed as reverse bytes
        // { >> {g} } = { << byte {j} };
        // $display("%p", g);                   //  doesn't work in verilator, '{ 'hd, 'hc, 'hb, ha } in vcs
        b = { << {8'b0011_0101}};
        $display("%b", b);                      //  1010_1100 -- reverse bits
        b = { << 4{ 8'b0011_0101 }};
        $display("%b", b);                      //  0101_0011 -- reverse nibble
        { >> {q, r, s, t} } = j;
        $display("%h %h %h %h", q, r, s, t);    //  scatter j into bytes
        h = { >> {t, s, r, q} };
        $display("%h", h);                      //  gather bytes into h
    endtask: streaming_ops

    /*      bit-widening behavior per-simulator                                     */
    task automatic sum_of_bits;
        bit one[6];
        int total;

        foreach (one[i])
            one[i] = i;

        total = one.sum();
        $display("%d", total);              //  simulator-specific behavior
                                            //  vcs gives 1, verilator gives 3
        total = one.sum() with (int'(item));
        $display("%d", total);

    endtask: sum_of_bits

    /*  foreach loop grabs elements by keys, but we
        want ordinal positions, hence the use of 'count'                            */
    task automatic select_ordinal;
        int aa[int] = '{ 0:1, 5:2, 10:4, 50:3, 33:1 };
        int idx, elem, count;
        elem = $urandom_range(aa.size(), 0);

        foreach(aa[i])
            if (count++ == elem) begin
                idx = i;
                break;
            end

        $display("element#%0d aa[%0d] = %0d", elem, idx, aa[idx]);
    endtask: select_ordinal

    task automatic arr_locator_methods;
        int d[] = '{ 9, 1, 8, 3, 4, 4 }, tq[$];
        //      'item' is a keyword
        tq = d.find with (item > 3);
        $display("%p", tq);

        tq.delete();

        //      equivalent code
        foreach (d[i])
            if (d[i] > 3)
                tq.push_back(d[i]);

        tq = d.find_index with (item > 3);
        $display("%p", tq);                 //  {0, 2, 4, 5}
        tq = d.find_first with (item > 99);
        $display("%p", tq);                 //  {} -- none exists
        tq = d.find_first_index with (item == 8);
        $display("%p", tq);                 //  {2}
        tq = d.find_last with (item == 4);
        $display("%p", tq);                 //  {4}
        tq = d.find_last_index with (item == 4);
        $display("%p", tq);                 //  {5}, d[5] == 4
    endtask: arr_locator_methods

    typedef struct packed {
        bit [7:0]   addr;
        bit [7:0]   pr;
        bit [15:0]  data;
    } Minipacket;

    Minipacket scb[$];

    function automatic void check_addr(bit [7:0] addr);
        int intq[$];
        intq = scb.find_index() with (item.addr == addr);
        case (intq.size())
            0: $display("addr %h not found in scb", addr);
            1: scb.delete(intq[0]);
            default:
                $display("ERROR: multiple hits for addr %h", addr);
        endcase
    endfunction: check_addr

    task automatic mini_scb;
        bit [7:0] a = 'b00000011;
        //  push the same addr twice such that we hit default
        scb.push_back('{3, 6, 7});
        scb.push_back('{3, 9, 9});
        check_addr(a);
    endtask: mini_scb;
endpackage: datatypes
