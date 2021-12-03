// SPDX-FileCopyrightText: © 2021 Uri Shaked <uri@wokwi.com>
// SPDX-License-Identifier: MIT

module silife_matrix #(
    parameter WIDTH  = 8,
    parameter HEIGHT = 8
) (
    input wire reset,
    input wire clk,
    input wire enable,
    input wire [(WIDTH*HEIGHT)-1:0] clear_cells,
    input wire [(WIDTH*HEIGHT)-1:0] set_cells,
    output wire [(WIDTH*HEIGHT)-1:0] cells
);

  assign cells = cell_values;

  genvar y;
  genvar x;
  wire [(WIDTH*HEIGHT)-1:0] cell_values;
  generate
    for (y = 0; y < HEIGHT; y = y + 1) begin : gen_cellsy
      for (x = 0; x < WIDTH; x = x + 1) begin : gen_cellsx
        silife_cell cell_instance (
            .reset (reset || clear_cells[y*WIDTH+x]),
            .clk   (clk),
            .enable(enable),
            .revive(set_cells[y*WIDTH+x]),
            .nw    (y > 0 && x > 0 ? cell_values[WIDTH*(y-1)+(x-1)] : 1'b0),
            .n     (y > 0 ? cell_values[WIDTH*(y-1)+x] : 1'b0),
            .ne    (y > 0 && x < WIDTH - 1 ? cell_values[WIDTH*(y-1)+x+1] : 1'b0),
            .e     (x < WIDTH - 1 ? cell_values[WIDTH*(y)+x+1] : 1'b0),
            .se    (y < HEIGHT - 1 && x < WIDTH - 1 ? cell_values[WIDTH*(y+1)+x+1] : 1'b0),
            .s     (y < HEIGHT - 1 ? cell_values[WIDTH*(y+1)+x] : 1'b0),
            .sw    (y < HEIGHT - 1 && x > 0 ? cell_values[WIDTH*(y+1)+x-1] : 1'b0),
            .w     (x > 0 ? cell_values[WIDTH*(y)+x-1] : 1'b0),
            .out   (cell_values[WIDTH*(y)+x])
        );
      end
    end
  endgenerate

endmodule
