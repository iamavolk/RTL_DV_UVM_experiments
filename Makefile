TOP         ?= tb_top
PREFIX      ?= sim_tb

SEED        ?= $(shell date +%s)
OBJ_DIR     ?= obj_dir
COV_DIR     ?= coverage
COV_NAME    ?= coverage

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

verilate_clean:
	@verilator                      \
		-j 0                        \
		-CFLAGS "-O0"               \
		-Wno-lint                   \
		-Wno-fatal                  \
		--binary                    \
		--coverage                  \
		--coverage-user             \
		--build-jobs 8              \
		--timing                    \
		--no-sched-zero-delay       \
		--timescale  1ns/1ps        \
		--trace-fst                 \
		--quiet-build               \
		--quiet-stats               \
		--prefix $(PREFIX)          \
		--top-module $(TOP)         \
		-f $(FILES)

run_test: FILES := _isolated.f
run_test: verilate_clean

run_coverage:
	@verilator_coverage             \
		--annotate coverage_report  \
		$(COV_DIR)/$(COV_NAME).dat  \

run run_test:
	@./$(OBJ_DIR)/$(PREFIX)         \
		+verilator+seed+$(SEED) +verilator+quiet +verilator+coverage+file+$(COV_DIR)/$(COV_NAME).dat

run: verilate

run_rand:
	@./$(OBJ_DIR)/$(PREFIX) +verilator+seed+$(date +%s)

#############################################
#   RHEL / Alma / Rocky with Vivado >= 25.02
#############################################
xsim:
	@mkdir -p build
	@cd build && xvlog ../src/behavioral_adder.sv ../tb/behavioral_adder_tb.sv
	@cd build && xelab behavioral_adder_tb -snapshot sim
	@cd build && xsim -R sim

clean:
	rm -rf obj_dir xsim.dir *.pb *.log *.wdb

.PHONY: verilate verilate_clean run run_rand run_test run_coverage xsim clean
