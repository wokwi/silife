// SPDX-FileCopyrightText: © 2021 Uri Shaked <uri@wokwi.com>
// SPDX-License-Identifier: MIT

`timescale 1ns / 1ps
//
`default_nettype none

module test_silife_cell ();
  reg  reset;
  reg  clk;
  reg  nw = 0;
  reg  n = 0;
  reg  ne = 0;
  reg  e = 0;
  reg  se = 0;
  reg  s = 0;
  reg  sw = 0;
  reg  w = 0;
  wire out;

  silife_cell exec (
      .reset(reset),
      .clk(clk),
      .nw(nw),
      .n(n),
      .ne(ne),
      .e(e),
      .se(se),
      .s(s),
      .sw(sw),
      .w(w),
      .out(out)
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
    nw <= 1;
    #10 n <= 1;
    #10 s <= 1;
    #10 s <= 0;
    #10 e <= 1;
    #10 s <= 1;
    #10 n <= 0;
    #10 s <= 0;
    #10 e <= 0;
    #20 $finish();
  end

  initial begin
    $dumpfile("cell_tb.vcd");
    $dumpvars(0, test_silife_cell);
  end
endmodule
