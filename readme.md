## Modern SV and UVM compendium of notes (for now)

### Workflow, tools, etc.:
1. Verilator 5+'s support of the latest IEEE 1800.2 (**UVM 2020-3.2**) is quite decent
2. AMD/Xilinx Vivado 2026.1 (*xsim*) ships with **UVM 1.2**
3. Verilator uses **z3** as a solver but doesn't pull it as a dependency
4. FuseSoC's flow support for both Questa and Vivado is not there yet
5. Both C++ and Rust DPI-C require external-facing C ABI
6. Verilator 5.053 devel rev v5.052-501-g770b7d009 commit added support for clocking block stimulus driving
    via `dut.cb.*` externally


### IEEE 1800 LRM points of interest:

1. use clocking blocks and driving via NBAs at test site to avoid race conditions
    (cb's allow #n delays for input/output as 'after clock edge' and 'before clock edge' respectively)
