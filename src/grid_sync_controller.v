// SPDX-FileCopyrightText: © 2021 Uri Shaked <uri@wokwi.com>
// SPDX-License-Identifier: MIT

`default_nettype none
//
`timescale 1ns / 1ps

module silife_grid_controller (
    input wire reset,
    input wire clk,

    input  wire i_sync_busy$syn,
    output reg  o_sync_active,
    output reg  o_sync_clk
);

  reg  i_sync_busy_buf [1:0];

  // Corner synchronization
  wire grid_n_last$syn;
  wire grid_e_last$syn;
  wire grid_s_last$syn;
  wire grid_w_last$syn;

  silife_grid_sync_edge #(
      .WIDTH(WIDTH)
  ) sync_n (
      .reset(reset),
      .clk  (clk),

      .i_sync_clk$syn(i_sync_clk$syn),
      .i_sync_active$syn(i_sync_active$syn),
      .i_sync_in$syn(i_sync_in_n$syn),
      .o_sync_out$syn(o_sync_out_n$syn),
      .o_busy(o_busy_n),

      .i_corner(o_grid_w[0]),
      .i_cells(i_grid_n),
      .o_corner(o_grid_ne),
      .o_cells(o_grid_n),
      .o_last_cell$syn(grid_n_last$syn)
  );

  silife_grid_sync_edge #(
      .WIDTH(HEIGHT)
  ) sync_e (
      .reset(reset),
      .clk  (clk),

      .i_sync_clk$syn(i_sync_clk$syn),
      .i_sync_active$syn(i_sync_active$syn),
      .i_sync_in$syn(i_sync_in_e$syn),
      .o_sync_out$syn(o_sync_out_e$syn),
      .o_busy(o_busy_e),

      .i_corner(grid_n_last$syn),
      .i_cells(i_grid_e),
      .o_corner(o_grid_se),
      .o_cells(o_grid_e),
      .o_last_cell$syn(grid_e_last$syn)
  );

  silife_grid_sync_edge #(
      .WIDTH(WIDTH)
  ) sync_s (
      .reset(reset),
      .clk  (clk),

      .i_sync_clk$syn(i_sync_clk$syn),
      .i_sync_active$syn(i_sync_active$syn),
      .i_sync_in$syn(i_sync_in_s$syn),
      .o_sync_out$syn(o_sync_out_s$syn),
      .o_busy(o_busy_s),

      .i_corner(grid_e_last$syn),
      .i_cells(i_grid_s),
      .o_corner(o_grid_sw),
      .o_cells(o_grid_s),
      .o_last_cell$syn(grid_s_last$syn)
  );

  silife_grid_sync_edge #(
      .WIDTH(HEIGHT)
  ) sync_w (
      .reset(reset),
      .clk  (clk),

      .i_sync_clk$syn(i_sync_clk$syn),
      .i_sync_active$syn(i_sync_active$syn),
      .i_sync_in$syn(i_sync_in_w$syn),
      .o_sync_out$syn(o_sync_out_w$syn),
      .o_busy(o_busy_w),

      .i_corner(o_grid_s[0]),
      .i_cells(i_grid_w),
      .o_corner(o_grid_nw),
      .o_cells(o_grid_w),
      .o_last_cell$syn(grid_w_last$syn)
  );

endmodule
