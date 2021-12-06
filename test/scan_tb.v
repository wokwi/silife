// SPDX-FileCopyrightText: © 2021 Uri Shaked <uri@wokwi.com>
// SPDX-License-Identifier: MIT

`timescale 1ns / 1ps
//
`default_nettype none

module test_silife_scan ();
  reg reset;
  reg clk;
  reg invert;
  reg [7:0][7:0] matrix_cells;
  wire [7:0] cells = matrix_cells[row_select];
  wire [7:0] columns;
  wire [7:0] rows;
  wire [2:0] row_select;

  silife_scan exec (
      .reset(reset),
      .clk(clk),
      .invert(invert),
      .cycles(16'd3),
      .cells(cells),
      .row_select(row_select),
      .rows(rows),
      .columns(columns)
  );

  initial begin
    clk = 0;
    forever begin
      #5 clk = ~clk;
    end
  end

  initial begin
    reset <= 1;
    matrix_cells <= 0;
    invert <= 0;
    #10 reset <= 0;
    matrix_cells[0] = 8'h20;
    matrix_cells[4] = 8'h24;
    matrix_cells[6] = 8'h66;
    matrix_cells[7] = 8'haa;
    #360 invert <= 1'b1;
    #360 $finish();
  end

  initial begin
    $dumpfile("scan_tb.vcd");
    $dumpvars(0, test_silife_scan);
  end
endmodule
