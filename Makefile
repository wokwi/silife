
# SPDX-FileCopyrightText: © 2021 Uri Shaked <uri@wokwi.com>
# SPDX-License-Identifier: MIT

all: test_matrix

test_cell:
	iverilog -g2012 -I src -o cell_tb.out test/cell_tb.v src/cell.v
	./cell_tb.out
	gtkwave cell_tb.vcd test/cell_tb.gtkw

test_matrix:
	iverilog -g2012 -I src -o matrix_tb.out test/matrix_tb.v src/matrix.v src/cell.v
	./matrix_tb.out
	gtkwave matrix_tb.vcd test/matrix_tb.gtkw

format:
	verible-verilog-format --inplace src/*.v test/*.v
