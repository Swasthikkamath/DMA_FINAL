#!/bin/bash
# Standalone regression for AxiInterconnect (DV/src/hdlTop/interrconnect.sv).
#
# Runs the interconnect against a lightweight slave model instead of the full
# UVM environment, so the routing behaviour can be checked in seconds.
#
#   ./run.sh                 # test the current interconnect
#   ./run.sh <other.sv>      # test a specific version of it
#
# Requires Verilator 5.x (brew install verilator).

set -e
cd "$(dirname "$0")"

DUT="${1:-../../src/hdlTop/interrconnect.sv}"

rm -rf obj_dir
verilator --binary --timing \
  -Wno-lint -Wno-LATCH -Wno-MULTIDRIVEN -Wno-WIDTH -Wno-BLKANDNBLK \
  -Wno-TIMESCALEMOD --timescale 1ns/1ps \
  --top-module tb_interconnect -o simv \
  globals_stub.sv \
  ../../src/hdlTop/axiInterface/axi4_if.sv \
  "$DUT" \
  tb_interconnect.sv

./obj_dir/simv
