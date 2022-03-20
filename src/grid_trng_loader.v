// SPDX-FileCopyrightText: © 2022 Uri Shaked <uri@wokwi.com>
// SPDX-License-Identifier: MIT

`default_nettype none
//
`timescale 1ns / 1ps

module silife_grid_trng_loader #(
    parameter WIDTH  = 32,
    parameter HEIGHT = 32
) (
    input wire reset,
    input wire clk,

    /* Grid interface */
    output reg [ROW_BITS-1:0] o_row_select,
    output reg [WIDTH-1:0] o_set_cells,
    output reg [WIDTH-1:0] o_clear_cells,

    /* Control interface */
    input  wire i_start,
    output reg  o_busy
);

  localparam ROW_BITS = $clog2(HEIGHT);
  localparam COL_BITS = $clog2(WIDTH);
  localparam MAX_COL = WIDTH - 1;
  localparam MAX_ROW = HEIGHT - 1;

  wire trng_output;
  reg prev_start;
  reg [COL_BITS-1:0] col_counter;

  trng trng1 (
      .clk(clk),
      .rst(reset),
      .stop(1'b0),
      .random(trng_output)
  );

  always @(posedge clk) begin
    if (reset) begin
      prev_start <= 1'b0;
      o_row_select <= 0;
      col_counter <= 0;
      o_busy <= 0;
      o_clear_cells <= 0;
      o_set_cells <= 0;
    end else begin
      if (i_start && !prev_start) begin
        o_row_select <= 0;
        col_counter <= 0;
        o_clear_cells <= 0;
        o_set_cells <= 0;
        o_busy <= 1'b1;
        o_clear_cells[0] <= ~trng_output;
        o_set_cells[0] <= trng_output;
      end
      if (o_busy) begin
        o_clear_cells[col_counter+1] <= ~trng_output;
        o_set_cells[col_counter+1] <= trng_output;
        col_counter <= col_counter + 1;
        if (col_counter == MAX_COL[COL_BITS-1:0]) begin
          col_counter  <= 0;
          o_row_select <= o_row_select + 1;
          if (o_row_select == MAX_ROW[ROW_BITS-1:0]) begin
            o_busy <= 1'b0;
          end
        end
      end
      prev_start <= i_start;
    end
  end

endmodule
