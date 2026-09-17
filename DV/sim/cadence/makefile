# ================================================================
# DMA CADENCE / XCELIUM MAKEFILE
# ================================================================

# -s : silent mode
# make target -s
#
# -n / --just-print : print commands without executing
# make target -n
#
# -i / --ignore-errors : ignore errors

.IGNORE:
	compile
	simulate

.SILENT:
	compile
	simulate
	usage


# ================================================================
# USAGE
# ================================================================

usage:
	echo "";
	echo "-----------------------------------------------------------------";
	echo "------------------------- Usage ---------------------------------";
	echo "";
	echo "make target <options> <variable>=<value>";
	echo "";
	echo "To compile use:";
	echo "make compile";
	echo "";
	echo "To simulate individual test:";
	echo "make simulate test=<test_name> uvm_verbosity=<VERBOSITY_LEVEL>";
	echo "";
	echo "Example:";
	echo "make simulate test=dmaBaseTest uvm_verbosity=UVM_HIGH";
	echo "";
	echo "To run regression:";
	echo "make regression testlist_name=<regression_testlist_name.list>";
	echo "";
	echo "Example:";
	echo "make regression testlist_name=regression_testlist_name.list";
	echo "";
	echo "-----------------------------------------------------------------";
	echo "-----------------------------------------------------------------";
	echo "";


# ================================================================
# DEFAULT TARGET
# ================================================================

all:
	make clean;
	make compile;
	make simulate;


# ================================================================
# DEFAULT VARIABLES
# ================================================================

# Default test
ifndef test
override test := dmaBaseTest
endif

# Default UVM verbosity
ifndef uvm_verbosity
override uvm_verbosity := UVM_MEDIUM
endif

# Default DMA type
ifndef dmaType
override dmaType := dmaBaseTest
endif

# Default test folder
ifndef test_folder
override test_folder := $(test)
endif

# Default seed
ifndef seed
override seed := random
endif


# ================================================================
# COMPILE
# ================================================================

compile:

	make clean_compile;
	make clean_simulate;

	# Compile DMA using Xcelium
	xrun -c \
	-timescale 1ns/1ps \
	-elaborate \
	-access +rwc \
	-64bit \
	-sv \
	-uvm \
	+access+rw \
	+define+$(dmaType) \
	-f ../dmaCompile.f \
	-l dmaCompile.log \
	-coverage all \
	-sva

	# Compilation report
	make compile_war_err


# ================================================================
# SIMULATE
# ================================================================

simulate:

	mkdir -p $(test_folder)

	xrun -R \
	-64bit \
	-sv \
	-uvm \
	+sv_seed=$(seed) \
	+UVM_TESTNAME=$(test) \
	+UVM_VERBOSITY=$(uvm_verbosity) \
	+define+$(dmaType) \
	-l $(test_folder)/$(test).log \
	-coverage all \
	-covoverwrite \
	-covtest $(test_folder) \
	+plusarg_ignore

	# Simulation report
	make simulate_war_err


# ================================================================
# REGRESSION
# ================================================================

regression:

	rm -f regression_summary.log

	make clean_simulate

	make compile

	python regression_handling.py $(testlist_name)

	make merge_cov_report


# ================================================================
# MERGE COVERAGE
# ================================================================

merge_cov_report:

	rm -rf merged_cov_html_report

	imc -execcmd "merge cov_work/scope/* -out merged -initial_model union_all -overwrite; exit"

	imc -load cov_work/scope/merged

	# Generate coverage report
	imc -execcmd "report -html -out merged_cov_html_report; exit"

	echo "";
	echo "-----------------------------------------------------------------";
	echo "Coverage report generated";
	echo "-----------------------------------------------------------------";
	echo "";


# ================================================================
# CLEAN COMPILE
# ================================================================

clean_compile:

	rm -rf *_compile.log
	rm -rf *_compile.history
	rm -rf xcelium.d
	rm -rf work
	rm -rf *.shm
	rm -rf *.vcd


# ================================================================
# CLEAN SIMULATION
# ================================================================

clean_simulate:

	rm -rf dma*
	rm -rf cov_work
	rm -rf regression_summary.log
	rm -rf *.txt
	rm -rf simulation_output.vcd


# ================================================================
# CLEAN EVERYTHING
# ================================================================

clean:

	make clean_compile
	make clean_simulate


# ================================================================
# COMPILATION REPORT
# ================================================================

compile_war_err:

	echo "";
	echo "-----------------------------------------------------------------";
	echo "------------------- Compilation Report --------------------------";
	echo "";

	echo "Compilation Errors:";
	grep "Error" dmaCompile.log;

	echo "";

	echo "Compilation Warnings:";
	grep "Warning" dmaCompile.log;

	echo "";

	echo "Log file path: dmaCompile.log";

	echo "";
	echo "-----------------------------------------------------------------";
	echo "-----------------------------------------------------------------";
	echo "";


# ================================================================
# SIMULATION REPORT
# ================================================================

simulate_war_err:

	echo "";
	echo "-----------------------------------------------------------------";
	echo "-------------------- Simulation Report --------------------------";
	echo "";

	echo "Simulator Errors";
	grep "Error" $(test_folder)/$(test).log;

	echo "";

	echo "UVM Fatal";
	grep "UVM_FATAL" $(test_folder)/$(test).log;

	echo "";

	echo "UVM Errors";
	grep "UVM_ERROR" $(test_folder)/$(test).log;

	echo "";

	echo "UVM Warnings";
	grep "UVM_WARNING" $(test_folder)/$(test).log;

	echo "";

	echo "Testname: $(test)";

	echo "";

	echo "Log file path: less -R $(test_folder)/$(test).log";

	echo "";

	echo "Waveform:";
	echo "simvision $(test_folder)/waves.shm &";

	echo "";

	echo "Coverage:";
	echo "imc -load cov_work/scope/merged";

	echo "";

	echo "-----------------------------------------------------------------";
	echo "-----------------------------------------------------------------";
	echo "";
