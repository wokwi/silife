// SPDX-FileCopyrightText: © 2021 Uri Shaked <uri@wokwi.com>
// SPDX-License-Identifier: MIT

`timescale 1ns / 1ps
//
`default_nettype none

module test_silife_scan ();
  reg reset;
  reg clk;
  reg invert;
  reg [7:0][7:0] cells;
  wire [7:0] columns;
  wire [7:0] rows;

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

  wire [63:0] row0 = row_to_string(clk, cells[0]);
  wire [63:0] row1 = row_to_string(clk, cells[1]);
  wire [63:0] row2 = row_to_string(clk, cells[2]);
  wire [63:0] row3 = row_to_string(clk, cells[3]);
  wire [63:0] row4 = row_to_string(clk, cells[4]);
  wire [63:0] row5 = row_to_string(clk, cells[5]);
  wire [63:0] row6 = row_to_string(clk, cells[6]);
  wire [63:0] row7 = row_to_string(clk, cells[7]);

  silife_scan exec (
      .reset(reset),
      .clk(clk),
      .invert(invert),
      .cycles(16'd3),
      .cells(cells),
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
    reset  <= 1;
    cells  <= 0;
    invert <= 0;
    #10 reset <= 0;
    cells[0] = 8'h20;
    cells[4] = 8'h24;
    cells[6] = 8'h66;
    cells[7] = 8'haa;
    #360 invert <= 1'b1;
    #360 $finish();
  end

  initial begin
    $dumpfile("scan_tb.vcd");
    $dumpvars(0, test_silife_scan);
  end
endmodule
