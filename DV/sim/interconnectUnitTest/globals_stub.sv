// Minimal stand-in for axi4_globals_pkg, carrying only what axi4_if.sv needs.
package axi4_globals_pkg;
  parameter int ADDRESS_WIDTH = 32;
  parameter int DATA_WIDTH    = 32;
  parameter int STROBE_WIDTH  = (DATA_WIDTH/8);
endpackage : axi4_globals_pkg
