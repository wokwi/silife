// SPDX-FileCopyrightText: © 2021 Uri Shaked <uri@wokwi.com>
// SPDX-License-Identifier: MIT

`timescale 1ns / 1ps
//
`default_nettype none

module test_silife_max7219 ();
  reg reset;
  reg clk;
  reg enable;

  reg [31:0][31:0] matrix_cells;
  wire [31:0] cells = matrix_cells[row_select];
  wire [4:0] row_select;

  wire spi_sck;
  wire spi_cs;
  wire spi_mosi;

  silife_max7219 max7219 (
      .reset(reset),
      .clk  (clk),

      .i_cells(cells),
      .i_enable(enable),
      .i_brightness(4'hf),
      .i_reverse_columns(1'b1),

      .o_cs(spi_cs),
      .o_sck(spi_sck),
      .o_mosi(spi_mosi),
      .o_row_select(row_select)
  );

  initial begin
    clk = 0;
    forever begin
      #5 clk = ~clk;
    end
  end

  initial begin
    reset <= 1;
    enable <= 0;
    matrix_cells <= 0;
    #10 reset <= 0;
    #20 enable <= 1;
    matrix_cells[0] = 8'h20;
    matrix_cells[4] = 32'h54443424;
    matrix_cells[6] = 8'h66;
    matrix_cells[7] = 8'haa;
    matrix_cells[8+4] = 32'h55453525;
    matrix_cells[16+4] = 32'h11223344;
    matrix_cells[24+4] = 32'h4faa11ff;
    #180000 $finish();
  end

  initial begin
    $dumpfile("max7219_tb.vcd");
    $dumpvars(0, test_silife_max7219);
  end
endmodule
