# Package first
pkg/utils_pkg.sv

# RTL
src/behavioral_adder.sv
src/stupid_counter.sv
src/simple_arbiter.sv
src/edge_detector.sv
src/fifo_ext_hshake.sv

# TB
tb/chapter_3.sv
tb/tb_top.sv
tb/test_with_clocking.sv
tb/arb_if.sv
tb/edge_detector_basic_tb.sv
tb/fifo_ext_hshake_if.sv
tb/test_top.sv
tb/trial_and_error.sv
tb/verilator_issues/event_sched.sv

# vim: ft=make
