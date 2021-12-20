# SPDX-FileCopyrightText: © 2021 Uri Shaked <uri@wokwi.com>
# SPDX-License-Identifier: MIT

export COCOTB_REDUCED_LOG_FMT=1

GENERATED_SOURCES= src/matrix_8x8.v src/matrix_16x16_ho.v src/matrix_32x32_ho.v

all: generate test_silife

generate: $(GENERATED_SOURCES)

src/matrix_8x8.v: src/gen_matrix.py
	python $< > $@
	verible-verilog-format --inplace $@

src/matrix_16x16_ho.v: src/gen_highorder_matrix.py
	python $< --sub_size 8 > $@
	verible-verilog-format --inplace $@

src/matrix_32x32_ho.v: src/gen_highorder_matrix.py
	python $< --sub_size 16 > $@
	verible-verilog-format --inplace $@

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

test_max7219:
	iverilog -g2005 -I src -o max7219_tb.out test/max7219_tb.v src/max7219.v src/spi_master.v
	./max7219_tb.out
	python test/vcd_to_wokwi.py > max7219_tb_wokwi.vcd
	gtkwave max7219_tb.vcd test/max7219_tb.gtkw

test_silife:
	iverilog -I src -s silife -s dump -o silife_test.out test/dump_silife.v src/silife.v src/cell.v src/matrix_8x8.v src/matrix_16x16_ho.v src/matrix_32x32_ho.v src/matrix_wishbone.v src/scan.v
	MODULE=test.test_silife vvp -M $$(cocotb-config --prefix)/cocotb/libs -m libcocotbvpi_icarus ./silife_test.out
	gtkwave silife_test.vcd test/silife_test.gtkw

format:
	verible-verilog-format --inplace src/*.v test/*.v
