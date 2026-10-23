CWD                         =$(shell pwd)
COCOTB_REDUCED_LOG_FMT      = True
SIM                         ?= verilator
VERILOG_SOURCES             =$(CWD)/clocker.sv
COCOTB_TEST_MODULES         := tb
COCOTB_TOPLEVEL             := clocker
TOPLEVEL_LANG               = verilog
COCOTB_HDL_TIMEUNIT         = 1ps
COCOTB_HDL_TIMEPRECISION    = 1ps
COMPILE_ARGS                += --quiet-build
COMPILE_ARGS                += --timing
COMPILE_ARGS                += --timescale 1ns/1ps

include $(shell cocotb-config --makefiles)/Makefile.sim
# include ../cleanall.mk
