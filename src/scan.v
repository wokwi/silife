// SPDX-FileCopyrightText: © 2021 Uri Shaked <uri@wokwi.com>
// SPDX-License-Identifier: MIT

module silife_scan #(
    parameter WIDTH  = 8,
    parameter HEIGHT = 8
) (
    input wire reset,
    input wire clk,
    input wire invert,
    input wire [15:0] cycles,
    input wire [HEIGHT-1:0][WIDTH-1:0] cells,
    output reg [WIDTH-1:0] columns,
    output reg [HEIGHT-1:0] rows
);

  reg [15:0] counter;
  reg [7:0] row;

  integer j;
  always @(*) begin
    if (reset) begin
      rows <= {HEIGHT{1'b0}};
      columns <= {WIDTH{1'b0}};
    end else begin
      for (j = 0; j < HEIGHT; j++) begin
        rows[j] = !invert ^ (row == j);
        if (row == j) begin
          columns = cells[row] ^ {WIDTH{invert}};
        end
      end
    end
  end

  always @(posedge clk) begin
    if (reset) begin
      counter <= 0;
      row <= 0;
    end else if (cycles) begin
      if (counter >= cycles) begin
        row <= row == HEIGHT - 1 ? 0 : row + 1;
        counter <= 0;
      end else begin
        counter <= counter + 1;
      end
    end
  end
endmodule
