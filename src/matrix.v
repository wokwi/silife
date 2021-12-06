// SPDX-FileCopyrightText: © 2021 Uri Shaked <uri@wokwi.com>
// SPDX-License-Identifier: MIT

module silife_matrix #(
    parameter WIDTH  = 8,
    parameter HEIGHT = 8
) (
    input wire reset,
    input wire clk,
    input wire enable,

    /* First port: read/write */
    input wire [$clog2(HEIGHT)-1:0] row_select,
    input wire [WIDTH-1:0] clear_cells,
    input wire [WIDTH-1:0] set_cells,
    output wire [WIDTH-1:0] cells,

    /* Second port: read only */
    input wire [$clog2(HEIGHT)-1:0] row_select2,
    output wire [WIDTH-1:0] cells2
);

  localparam row_bits = $clog2(HEIGHT);
  localparam col_bits = $clog2(WIDTH);
  localparam index_bits = row_bits + col_bits;

  wire [index_bits-1:0] row_offset = {row_select, {col_bits{1'b0}}};
  assign cells = cell_values[row_offset+:WIDTH];

  wire [index_bits-1:0] row_offset2 = {row_select2, {col_bits{1'b0}}};
  assign cells2 = cell_values[row_offset2+:WIDTH];

  genvar y;
  genvar x;
  wire [(WIDTH*HEIGHT)-1:0] cell_values;
  generate
    for (y = 0; y < HEIGHT; y = y + 1) begin : gen_cellsy
      for (x = 0; x < WIDTH; x = x + 1) begin : gen_cellsx
        localparam current_row = y * WIDTH;
        localparam prev_row = current_row - WIDTH;
        localparam next_row = current_row + WIDTH;
        silife_cell cell_instance (
            .reset (reset || (row_select == y && clear_cells[x])),
            .clk   (clk),
            .enable(enable),
            .revive(row_select == y && set_cells[x]),
            .nw    (y > 0 && x > 0 ? cell_values[prev_row+x-1] : 1'b0),
            .n     (y > 0 ? cell_values[prev_row+x] : 1'b0),
            .ne    (y > 0 && x < WIDTH - 1 ? cell_values[prev_row+x+1] : 1'b0),
            .e     (x < WIDTH - 1 ? cell_values[current_row+x+1] : 1'b0),
            .se    (y < HEIGHT - 1 && x < WIDTH - 1 ? cell_values[next_row+x+1] : 1'b0),
            .s     (y < HEIGHT - 1 ? cell_values[next_row+x] : 1'b0),
            .sw    (y < HEIGHT - 1 && x > 0 ? cell_values[next_row+x-1] : 1'b0),
            .w     (x > 0 ? cell_values[current_row+x-1] : 1'b0),
            .out   (cell_values[current_row+x])
        );
      end
    end
  endgenerate

endmodule
