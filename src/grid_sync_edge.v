// SPDX-FileCopyrightText: © 2021 Uri Shaked <uri@wokwi.com>
// SPDX-License-Identifier: MIT

`default_nettype none
//
`timescale 1ns / 1ps

/* notes: 
   - i_cells is must not change while sync_active$syn is high 
   - i_corner always depends on o_cells[0] or o_last_cell$syn,
     so it should be valid by the time send_corner$syn goes high.
*/
module silife_grid_sync_edge #(
    parameter WIDTH = 32
) (
    input wire reset,
    input wire clk,

    input  wire i_sync_clk$syn,
    input  wire i_sync_active$syn,
    input  wire i_sync_in$syn,
    output reg  o_sync_out$syn,
    output reg  o_busy$syn,
    output reg  o_busy,

    input wire i_corner,
    input wire [WIDTH-1:0] i_cells,
    output reg o_corner,
    output reg [WIDTH-1:0] o_cells,
    output reg o_last_cell$syn
);

  localparam width_bits = $clog2(WIDTH);

  reg [width_bits:0] bit_index_out$syn;
  wire [width_bits-1:0] cell_index_out$syn = bit_index_out$syn[width_bits-1:0];
  wire send_corner$syn = bit_index_out$syn[width_bits];

  always @(negedge i_sync_clk$syn or negedge i_sync_active$syn) begin
    if (!i_sync_active$syn) begin
      bit_index_out$syn <= 0;
      o_sync_out$syn <= 1'b0;
      o_busy$syn <= 1'b0;
    end else begin
      bit_index_out$syn <= bit_index_out$syn + 1;
      o_sync_out$syn <= send_corner$syn ? i_corner : i_cells[cell_index_out$syn];
      o_busy$syn <= !send_corner$syn;
    end
  end

  always @(posedge i_sync_clk$syn or negedge i_sync_active$syn) begin
    if (!i_sync_active$syn) begin
      o_last_cell$syn <= 0;
    end else begin
      o_last_cell$syn <= i_sync_in$syn;
    end
  end

  reg [width_bits:0] bit_index_in;
  wire [width_bits-1:0] cell_index_in = bit_index_in[width_bits-1:0];
  wire receive_corner = bit_index_in[width_bits];

  reg [1:0] sync_active_buf;
  reg [1:0] sync_clk_buf;
  reg [1:0] sync_in_buf;

  wire sync_clk = sync_clk_buf[1];
  wire sync_active = sync_active_buf[1];
  wire sync_in = sync_in_buf[1];
  reg prev_sync_clk;

  always @(posedge clk) begin
    if (reset) begin
      o_corner <= 1'b0;
      o_cells <= {WIDTH{1'b0}};
      sync_active_buf <= 2'b00;
      sync_clk_buf <= 2'b00;
      sync_in_buf <= 2'b00;
      bit_index_in <= 0;
      prev_sync_clk <= 0;
    end else begin
      sync_active_buf <= {sync_active_buf[0], i_sync_active$syn};
      sync_clk_buf <= {sync_clk_buf[0], i_sync_clk$syn};
      sync_in_buf <= {sync_in_buf[0], i_sync_in$syn};
      prev_sync_clk <= sync_clk_buf[1];
      if (!sync_active) begin
        bit_index_in <= 0;
        o_busy <= 0;
      end else if (!prev_sync_clk && sync_clk) begin
        if (receive_corner) begin
          o_busy   <= 0;
          o_corner <= sync_in;
        end else begin
          o_busy <= 1;
          o_cells[cell_index_in] <= sync_in;
          bit_index_in <= bit_index_in + 1;
        end
      end
    end
  end

endmodule
