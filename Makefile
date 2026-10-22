RTL       = src/behavioral_adder.sv         \
            src/stupid_counter.sv           \
            src/simple_arbiter.sv           \
            src/edge_detector               \
            src/fifo_ext_hshake

TB        = tb/chapter_3.sv                 \
            tb/tb_top.sv                    \
            tb/test_with_clocking.sv        \
            tb/arb_if.sv                    \
            tb/edge_detector_basic_tb.sv    \
            tb/fifo_ext_hshake_if.sv        \
            tb/test_top.sv

PKG       = pkg/utils_pkg.sv

TOP       ?= tb_top
PREFIX    ?= simulation

RUST_LIB  = src/rtl_sim/target/release/librtl_sim.a

$(RUST_LIB): src/rtl_sim/src/lib.rs src/rtl_sim/Cargo.toml
	cargo build --release --lib --manifest-path src/rtl_sim/Cargo.toml

verilator: $(RUST_LIB)
	@verilator                      \
		-j 0                        \
		-CFLAGS "-O0"               \
		-Wno-lint                   \
		--binary                    \
		--trace                     \
		--quiet-build               \
		--prefix $(PREFIX)          \
		--top-module $(TOP)         \
		--exe $(CURDIR)/$(RUST_LIB) \
		$(RTL) $(TB) $(PKG)
	@echo ""
	@./obj_dir/$(PREFIX)

# Alma Linux only
xsim:
	@mkdir -p build
	@cd build && xvlog ../src/behavioral_adder.sv ../tb/behavioral_adder_tb.sv
	@cd build && xelab behavioral_adder_tb -snapshot sim
	@cd build && xsim -R sim

clean:
	rm -rf obj_dir xsim.dir *.pb *.log *.wdb
