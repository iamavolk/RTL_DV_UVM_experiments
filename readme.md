## Compendium of notes for modern SystemVerilog and UVM

### Workflow, tools, etc.:
1. Verilator 5.x supports **UVM 3.2**
    > [verilator-uvm](https://github.com/chipsalliance/uvm-verilator) Accelera UVM implementaton (1800.2 2020 3.2) with adjustments
2. **Vivado** 2026.1 ships with **UVM 1.2** (_xsim_ handles it well so far)
3. Verilator uses **z3** as a solver
    > verilator's integration of z3 demonstrates some unexpected behavior with coverage api (WIP)
4. FuseSoC's flow support for both Questa and Vivado is not there yet
5. Both C++ and Rust DPI-C require external-facing C ABI
6. Verilator 5.053 devel rev v5.052-501-g770b7d009 commit added support for clocking block stimulus driving
    via `dut.cb.*` externally

### IEEE-1800 LRM points of interest:

1. Clocking blocks are a way to mitigate race conditions between the DUT and the TB
    (CBs can also make use of #n step delays at i/o). Default behavior:
   > a clocking-block input is sampled just before the clock edge (by default)
   > in the so-called **postponed** region of the simulation. This takes place when
   > all of the design (**active** region), assertion (**observed** region),
   > and the testbench (**reactive** region) activities are completely done.
   > As such, the _INPUTS_ to the CB (as seen from
   > the testbench) are updated _as if_ there is a syncronizer
   > between DUT outputs and TB inputs routed through the cb.
   > cb _OUTPUTS_, on the other hand, experience no delays.
