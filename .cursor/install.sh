#!/usr/bin/env bash
# Idempotent Cloud Agent bootstrap for the DMA_FINAL repository.
#
# Installs a license-free open-source EDA toolchain (Icarus Verilog, Verilator,
# GTKWave) so the Verilog RTL can be elaborated and simulated without any
# commercial simulator. The primary UVM regression under DV/sim/questaSim still
# requires QuestaSim (a licensed Siemens tool) and is not installable here.
set -euo pipefail

SUDO=""
if [ "$(id -u)" -ne 0 ]; then
  if command -v sudo >/dev/null 2>&1; then
    SUDO="sudo"
  fi
fi

export DEBIAN_FRONTEND=noninteractive

$SUDO apt-get update -qq
$SUDO apt-get install -y --no-install-recommends \
  iverilog \
  verilator \
  gtkwave \
  make \
  build-essential

echo "----------------------------------------------------------------"
echo "EDA toolchain:"
iverilog -V | head -1
verilator --version | head -1
echo "----------------------------------------------------------------"

# Fail fast if the RTL no longer elaborates with the open-source toolchain.
make -C "$(dirname "$0")/../DV/sim/openSource" elaborate

echo "Cloud Agent environment ready. Run the RTL smoke test with:"
echo "  make -C DV/sim/openSource smoke"
