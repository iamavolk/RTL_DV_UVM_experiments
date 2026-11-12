module tb_random_sequences;
    initial begin
        //      randsequence uses a BNF-like (Backus-Naur Form) syntax
        //      it may be somewhat hard to understand initially:
        //
        //      a) as usual, we define relative weights
        //          cfg_read : io_read : mem_read = 1 : 3 : 5
        //
        //      b) 'stream' is the so-called production name, and
        //          it generates the new production
        //
        //      c) 'cfg_read: { cfg_read_task(); } | { cfg_read_task(); } cfg_read;'
        //          says the following:
        //              either give cfg_read_task() and be done
        //              or give cfg_read_task() and try cfg_read yet again
        //
        //              conditional probability is 50%, but
        //              total probabitiy is 50%*50%*... so roughly 2 sequences
        //              are generated
        //
        for (int i=0; i<15; ++i) begin
            randsequence (stream)
                stream:
                      cfg_read := 1
                    | io_read  := 2
                    | mem_read := 5;

                cfg_read: { cfg_read_task(); } | { cfg_read_task(); } cfg_read;
                io_read:  { io_read_task(); }  | { io_read_task(); }  io_read;
                mem_read: { mem_read_task(); } | { mem_read_task(); } mem_read;
            endsequence
        end
    end

    task cfg_read_task();
        $display("CFG");
    endtask
    task io_read_task();
        $display("IO");
    endtask
    task mem_read_task();
        $display("MEM");
    endtask
endmodule: tb_random_sequences
