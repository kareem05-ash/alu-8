# =============================================================================
# Makefile  —  local convenience wrapper (mirrors CI exactly)
#
# Usage:
#   make sim      — compile + run
#   make clean    — remove work library and transcripts
# =============================================================================

VSIM      ?= vsim
SIM_SCRIPT = sim/run.do

.PHONY: sim clean

sim:
	$(VSIM) -c -do $(SIM_SCRIPT)

clean:
	@if [ -d sim/work ]; then vdel -lib sim/work -all; fi
	@rm -f transcript