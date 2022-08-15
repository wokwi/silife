// SPDX-FileCopyrightText: © 2021 Uri Shaked <uri@wokwi.com>
// SPDX-License-Identifier: MIT

`default_nettype none
//
`timescale 1ns / 1ps

module silife_vga #(
    parameter WIDTH  = 32,
    parameter HEIGHT = 32
) (
    input wire reset,
    input wire clk,

    input wire i_enable,
    input wire [WIDTH-1:0] i_cells,

    // VGA interface
    output wire o_hsync,
    output wire o_vsync,
    output wire o_data,

    output wire [row_bits-1:0] o_row_select
);

  localparam row_bits = $clog2(HEIGHT);

  parameter cell_shift = 3;  // determines the cell size (3 = 8x8 pixels)

  wire [9:0] x_px;
  wire [9:0] y_px;

  assign o_row_select = y_px >> cell_shift;
  assign o_data = i_cells[x_px>>cell_shift];

  vga_sync_gen vga_sync (
      .px_clk(clk),
      .reset (reset),
      .hsync (o_hsync),
      .vsync (o_vsync),
      .x_px  (x_px),
      .y_px  (y_px)
  );

endmodule
