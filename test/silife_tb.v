// SPDX-FileCopyrightText: © 2021 Uri Shaked <uri@wokwi.com>
// SPDX-License-Identifier: MIT

`timescale 1ns / 1ps
//
`default_nettype none

module test_silife ();
  reg reset;
  reg clk;
  wire [15:0] io_out;
  wire [15:0] io_oeb;

  silife exec (
      .reset(reset),
      .clk(clk),
      .io_out(io_out),
      .io_oeb(io_oeb)
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
    #360 $finish();
  end

  initial begin
    $dumpfile("silife_tb.vcd");
    $dumpvars(0, test_silife);
  end
endmodule
