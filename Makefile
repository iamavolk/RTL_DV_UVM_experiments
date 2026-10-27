TOP         ?= tb_top
PREFIX      ?= simulation

SEED        ?= $(shell date +%s)
RUST_LIB    = src/rtl_sim/target/release/librtl_sim.a

$(RUST_LIB): src/rtl_sim/src/lib.rs src/rtl_sim/Cargo.toml
	cargo build --release --lib --manifest-path src/rtl_sim/Cargo.toml

verilate: $(RUST_LIB)
	@verilator                      \
		-j 0                        \
		-CFLAGS "-O0"               \
		-Wno-lint                   \
		-Wno-fatal                  \
		--binary                    \
		--timing                    \
		--trace                     \
		--quiet-build               \
		--prefix $(PREFIX)          \
		--top-module $(TOP)         \
		--exe $(CURDIR)/$(RUST_LIB) \
		-f verilator.f

verilator_clean:
	@verilator                      \
		-j 0                        \
		-CFLAGS "-O0"               \
		-Wno-lint                   \
		-Wno-fatal                  \
		--binary                    \
		--build-jobs 8              \
		--timing                    \
		--no-sched-zero-delay       \
		--timescale  1ns/1ps        \
		--trace                     \
		--quiet-build               \
		--prefix $(PREFIX)          \
		--top-module $(TOP)         \
		-f $(FILES)

run_isolated: FILES := _isolated.f --quiet-stats
run_isolated: verilator_clean

run run_isolated:
	@./obj_dir/$(PREFIX) +verilator+seed+$(SEED) +verilator+quiet

run: verilate

run_rand:
	@./obj_dir/$(PREFIX) +verilator+seed+$(date +%s)

#-------------------------------------------
#-- RHEL / Alma / Rocky with Vivado >= 25.02
#-------------------------------------------
xsim:
	@mkdir -p build
	@cd build && xvlog ../src/behavioral_adder.sv ../tb/behavioral_adder_tb.sv
	@cd build && xelab behavioral_adder_tb -snapshot sim
	@cd build && xsim -R sim

clean:
	rm -rf obj_dir xsim.dir *.pb *.log *.wdb

.PHONY: verilate run run_rand
