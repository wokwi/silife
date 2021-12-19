# SPDX-FileCopyrightText: © 2021 Uri Shaked <uri@wokwi.com>
# SPDX-License-Identifier: MIT

export COCOTB_REDUCED_LOG_FMT=1

all: test_silife

src/matrix_8x8.v: src/matrix_gen.py
	python $< > src/matrix_8x8.v

test_cell:
	iverilog -g2005 -I src -o cell_tb.out test/cell_tb.v src/cell.v
	./cell_tb.out
	gtkwave cell_tb.vcd test/cell_tb.gtkw

test_matrix: src/matrix_8x8.v
	iverilog -g2005 -I src -o matrix_tb.out test/matrix_tb.v src/matrix_8x8.v src/cell.v
	./matrix_tb.out
	gtkwave matrix_tb.vcd test/matrix_tb.gtkw

test_scan:
	iverilog -g2005 -I src -o scan_tb.out test/scan_tb.v src/scan.v
	./scan_tb.out
	gtkwave scan_tb.vcd test/scan_tb.gtkw

test_silife:
	iverilog -I src -s silife -s dump -o silife_test.out src/silife.v src/cell.v src/matrix_8x8.v src/matrix_wishbone.v src/scan.v test/dump_silife.v
	MODULE=test.test_silife vvp -M $$(cocotb-config --prefix)/cocotb/libs -m libcocotbvpi_icarus ./silife_test.out
	gtkwave silife_test.vcd test/silife_test.gtkw

format:
	verible-verilog-format --inplace src/*.v test/*.v
