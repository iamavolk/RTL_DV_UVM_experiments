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

    typedef struct packed {        //  packed struct,
        byte    be;         //  contiguous mem layout is guaranteed by the LRM
        int     addr;
        int     data;
    } pStruct_s;

    typedef struct {        //  unpacked struct
        byte    be;         //  can be format-displayed with %p
        int     addr;       //  contiguous memory layout isn't guaranteed
        int     data;
    } uStruct_s;

    pStruct_s ps = '{
        be: 'h7,
        addr: 'h2,
        data: 'h3
    };

    uStruct_s us = '{
        be: 'h7,
        addr: 'h2,
        data: 'h3
    };


    initial begin
        $display("ps=%h", ps);
        $display("us=%p", us);
    end

endmodule: tb_sandbox
