// SPDX-FileCopyrightText: © 2021 Uri Shaked <uri@wokwi.com>
// SPDX-License-Identifier: MIT

`timescale 1ns / 1ps
//
`default_nettype none

module test_silife_matrix ();
  reg reset;
  reg clk;
  reg [2:0] row_select;
  reg [7:0] set_cells;
  wire [7:0] cells;

  /* Pretty output for the test bench */
  function [63:0] row_to_string(input clk, input [7:0] row);
    begin
      row_to_string = !clk ? 64'dz : {
      row[0] ? "*" : " ",
      row[1] ? "*" : " ",
      row[2] ? "*" : " ",
      row[3] ? "*" : " ",
      row[4] ? "*" : " ",
      row[5] ? "*" : " ",
      row[6] ? "*" : " ",
      row[7] ? "*" : " "
    };
    end
  endfunction

  wire [63:0] row0 = row_to_string(clk, exec.cell_values[0]);
  wire [63:0] row1 = row_to_string(clk, exec.cell_values[1]);
  wire [63:0] row2 = row_to_string(clk, exec.cell_values[2]);
  wire [63:0] row3 = row_to_string(clk, exec.cell_values[3]);
  wire [63:0] row4 = row_to_string(clk, exec.cell_values[4]);
  wire [63:0] row5 = row_to_string(clk, exec.cell_values[5]);
  wire [63:0] row6 = row_to_string(clk, exec.cell_values[6]);
  wire [63:0] row7 = row_to_string(clk, exec.cell_values[7]);

  silife_matrix exec (
      .reset(reset),
      .clk(clk),
      .enable(1'b1),
      .row_select(row_select),
      .set_cells(set_cells),
      .cells(cells)
  );

  initial begin
    clk = 0;
    forever begin
      #5 clk = ~clk;
    end
  end

  initial begin
    reset <= 1;
    #10 reset <= 0;
    row_select   <= 4;
    set_cells[4] <= 1;
    set_cells[5] <= 1;
    set_cells[6] <= 1;
    #10 set_cells <= 0;
    #50 $finish();
  end

  initial begin
    $dumpfile("matrix_tb.vcd");
    $dumpvars(0, test_silife_matrix);
  end
endmodule
