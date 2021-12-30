// SPDX-FileCopyrightText: © 2021 Uri Shaked <uri@wokwi.com>
// SPDX-License-Identifier: MIT

`default_nettype none
//
`timescale 1ns / 1ps

module silife_grid_sync #(
    parameter WIDTH  = 32,
    parameter HEIGHT = 32
) (
    input wire reset,
    input wire clk,

    input  wire i_sync_clk$syn,
    input  wire i_sync_active$syn,
    input  wire i_sync_in_n$syn,
    input  wire i_sync_in_e$syn,
    input  wire i_sync_in_s$syn,
    input  wire i_sync_in_w$syn,
    output wire o_sync_out_n$syn,
    output wire o_sync_out_e$syn,
    output wire o_sync_out_s$syn,
    output wire o_sync_out_w$syn,
    output wire o_busy$syn,
    output wire o_busy,

    input wire [ WIDTH-1:0] i_grid_n,
    input wire [HEIGHT-1:0] i_grid_e,
    input wire [ WIDTH-1:0] i_grid_s,
    input wire [HEIGHT-1:0] i_grid_w,

    output wire [WIDTH-1:0] o_grid_n,
    output wire o_grid_ne,
    output wire [HEIGHT-1:0] o_grid_e,
    output wire o_grid_se,
    output wire [WIDTH-1:0] o_grid_s,
    output wire o_grid_sw,
    output wire [HEIGHT-1:0] o_grid_w,
    output wire o_grid_nw
);

  wire o_busy_n;
  wire o_busy_e;
  wire o_busy_s;
  wire o_busy_w;
  assign o_busy = |{o_busy_n, o_busy_e, o_busy_s, o_busy_w};

  wire o_busy_n$syn;
  wire o_busy_e$syn;
  wire o_busy_s$syn;
  wire o_busy_w$syn;
  assign o_busy$syn = |{o_busy_n$syn, o_busy_e$syn, o_busy_s$syn, o_busy_w$syn};

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
      .o_busy$syn(o_busy_n$syn),
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
      .o_busy$syn(o_busy_e$syn),
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
      .o_busy$syn(o_busy_s$syn),
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
      .o_busy$syn(o_busy_w$syn),
      .o_busy(o_busy_w),

      .i_corner(o_grid_s[0]),
      .i_cells(i_grid_w),
      .o_corner(o_grid_nw),
      .o_cells(o_grid_w),
      .o_last_cell$syn(grid_w_last$syn)
  );

endmodule
