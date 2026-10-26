class Generator;
    event done;
    function new (input event done_ev);
        this.done = done_ev;
    endfunction

    task run (int unsigned i);
        fork
            automatic int unsigned d;
            begin
                $display("before");
                d = $urandom_range(1, 15);
                #(d);
                $display("thread[%0d] was delayed by %0d", i, d);
                -> done;
                $display("after");
            end
        join_none
    endtask
endclass: Generator

module event_sched;
    event done[4];
    Generator gen[4];

    initial begin
        foreach (gen[i]) begin
            gen[i] = new(done[i]);
            gen[i].run(i);
        end

        foreach (gen[i]) begin
            fork
                automatic int k = i;
                wait (done[k].triggered);
            join_none
        end

        wait fork;
    end
endmodule: event_sched

/*          to reproduce:

	@verilator                      \
		-j 0                        \
		-CFLAGS "-O0"               \
		-Wno-lint                   \
        -Wno-fatal                  \
		--binary                    \
		--quiet-build               \
		--prefix $(PREFIX)          \
		--top-module $(TOP)         \
		-f verilator.f


    comments:
        --trace gives conversion error:
    In file included from simulation__ALL.cpp:33:
    simulation__Trace__0__Slow.cpp: In function ‘void simulation___024root__trace_const_dtype____0(simulation___024root*, VerilatedTrace<VerilatedVcd, VerilatedVcdBuffer>::Buffer*, uint32_t, const VlUnpacked<VlAssignableEvent, 4>&)’:
    simulation__Trace__0__Slow.cpp:114:20: error: cannot convert ‘const VlAssignableEvent’ to ‘const VlEventBase*’
      114 |     bufp->fullEvent(oldp+0,(__VdtypeVar[0]));
          |     ~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~

        w/o --trace the error is nullptr deref
*/
