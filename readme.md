Basically, modern SV stuff with a compendium of notes (for now)

1. Verilator 5.053 devel rev v5.052-501-g770b7d009 added support for clocking block stimulus driving
    via `dut.cb.*` externally
2. Verilator uses z3 as a solver but doesn't pull it as a dependency
3. FuseSoC flow support for both Questa and Vivado is not there yet
4. Both C++ and Rust DPI-C require external-facing C ABI (obviously, duh), but it feels like
    Rust requires less effort to integrate
