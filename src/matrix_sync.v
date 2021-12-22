// SPDX-FileCopyrightText: © 2021 Uri Shaked <uri@wokwi.com>
// SPDX-License-Identifier: MIT

`default_nettype none
//
`timescale 1ns / 1ps

/* notes: 
   - i_cells is must not change while sync_active$syn is high 
   - i_edge always depends on o_cells[0], so it should be stable 3 clk cycles
     after the first rising edge of i_sync_clk$syn.
*/
module matrix_sync #(
    parameter WIDTH = 32
) (
    input wire reset,
    input wire clk,

    input  wire i_sync_clk$syn,
    input  wire i_sync_active$syn,
    input  wire i_sync_in$syn,
    output reg  o_sync_out$syn,
    output reg  o_busy,

    input wire i_edge,
    input wire [WIDTH-1:0] i_cells,
    output reg o_edge,
    output reg [WIDTH-1:0] o_cells
);

  localparam width_bits = $clog2(WIDTH);

  reg [width_bits:0] bit_index_out$syn;
  wire [width_bits-1:0] cell_index_out$syn = bit_index_out$syn[width_bits-1:0];
  wire send_edge$syn = bit_index_out$syn[width_bits];

  always @(negedge i_sync_clk$syn or negedge i_sync_active$syn) begin
    if (!i_sync_active$syn) begin
      o_sync_out$syn <= 1'b0;
      bit_index_out$syn <= 0;
    end else begin
      o_sync_out$syn <= send_edge$syn ? i_edge : i_cells[cell_index_out$syn];
    end
  end

  reg [width_bits:0] bit_index_in;
  wire [width_bits-1:0] cell_index_in = bit_index_in[width_bits-1:0];
  wire recieve_edge = bit_index_in[width_bits];

  reg [1:0] sync_active_buf;
  reg [1:0] sync_clk_buf;
  reg [1:0] sync_in_buf;

  wire sync_clk = sync_clk_buf[1];
  wire sync_active = sync_active_buf[1];
  wire sync_in = sync_in_buf[1];
  reg prev_sync_clk;

  always @(posedge clk) begin
    if (reset) begin
      o_edge <= 1'b0;
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
        if (recieve_edge) begin
          o_busy <= 0;
          o_edge <= sync_in;
        end else begin
          o_busy <= 1;
          o_cells[cell_index_in] <= sync_in;
          bit_index_in <= bit_index_in + 1;
        end
      end
    end
  end

endmodule
