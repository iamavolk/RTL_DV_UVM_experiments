## Compendium of notes for modern SystemVerilog and UVM

### Workflow, tools, etc.:
1. Verilator 5.x supports **UVM 3.1**
    > [uvm-verilator](https://github.com/chipsalliance/uvm-verilator) Accelera UVM implementaton (1800.2 2020 3.1) with adjustments
2. **Vivado** 2026.1 ships with **UVM 1.2** (_xsim_ handles it well so far)
3. Verilator uses **z3** for solver
    > verilator's integration of z3 demonstrates some unexpected behavior with coverage API
    > (WIP, some bins aren't getting hits if using particular syntax that shouldn't affect the behavior)
4. _xsim_ provides WebUI **functional coverage**, _verilator_ is only able to do **code coverage** UI with LCOV
5. Both C++ and Rust DPI-C require external-facing C ABI
6. Verilator 5.053 devel rev v5.052-501-g770b7d009 commit added support for clocking block stimulus driving
    via `dut.cb.*` externally

### IEEE-1800 LRM points of interest:

1. Clocking blocks are a way to mitigate race conditions between the DUT and the TB
    (CBs can also make use of #n step delays at i/o). Default behavior:
   > a clocking block input is sampled just before the clock edge (by default)
   > in the so-called **postponed** region of the simulation. This takes place when
   > all of the design (**active** region), assertion (**observed** region),
   > and the testbench (**reactive** region) activities are completely done (N-1 cycle)
   > As such, **raw** (non-clocking block) _INPUTS_ are updated _as if_ there is a syncronizer
   > between DUT outputs and TB inputs routed through the cb.
   > **raw**_OUTPUTS_, on the other hand, experience no delay by default
   > (that is, raw and clocking block outputs are identical with respect to simulation time)
