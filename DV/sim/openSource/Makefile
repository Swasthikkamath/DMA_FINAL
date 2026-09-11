# -----------------------------------------------------------------------------
# License-free RTL flow using Icarus Verilog (open source).
#
# The primary DV flow (../questaSim/makefile) drives the full UVM regression on
# QuestaSim, which needs a commercial license. This flow needs no license and
# lets a developer elaborate the RTL and run a self-checking APB smoke test in
# any Cloud Agent / CI environment.
#
# Targets:
#   make elaborate  - compile + elaborate the whole RTL (catches syntax/elab bugs)
#   make smoke       - run the APB write/read-back smoke test (default)
#   make waves       - open the generated VCD in GTKWave
#   make clean
# -----------------------------------------------------------------------------

RTL_DIR   := ../../../RTL
IVERILOG  := iverilog
VVP       := vvp
GTKWAVE   := gtkwave

RTL_SRCS  := $(wildcard $(RTL_DIR)/*.v)
TB        := tb_dma_smoke.v

BUILD_DIR := build
ELAB_OUT  := $(BUILD_DIR)/dma_rtl.vvp
SMOKE_OUT := $(BUILD_DIR)/dma_smoke.vvp
VCD       := dma_smoke.vcd

.PHONY: all smoke elaborate waves clean

all: smoke

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Elaborate the full RTL with top_mod as the root, proving the design builds.
elaborate: | $(BUILD_DIR)
	$(IVERILOG) -g2012 -Wall -s top_mod -o $(ELAB_OUT) $(RTL_SRCS)
	@echo "RTL elaboration OK -> $(ELAB_OUT)"

# Compile the smoke testbench together with the RTL and run it.
smoke: | $(BUILD_DIR)
	$(IVERILOG) -g2012 -s tb_dma_smoke -o $(SMOKE_OUT) $(TB) $(RTL_SRCS)
	$(VVP) $(SMOKE_OUT)

waves: $(VCD)
	$(GTKWAVE) $(VCD) &

clean:
	rm -rf $(BUILD_DIR) $(VCD)
