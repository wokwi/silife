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
    input wire [WIDTH-1:0] cells,
    output wire [WIDTH-1:0] columns,
    output reg [HEIGHT-1:0] rows,
    output reg [row_bits-1:0] row_select
);

  localparam row_bits = $clog2(HEIGHT);
  localparam max_row_int = HEIGHT - 1;
  localparam max_row = max_row_int[row_bits-1:0];
  assign columns = invert ? ~cells : cells;

  reg [15:0] counter;

  integer j;
  always @(*) begin
    if (reset) begin
      rows = {HEIGHT{1'b0}};
    end else begin
      for (j = 0; j < HEIGHT; j++) begin
        rows[j] = !invert ^ (row_select == j[row_bits-1:0]);
      end
    end
  end

  always @(posedge clk) begin
    if (reset) begin
      counter <= 0;
      row_select <= 0;
    end else if (cycles != 16'b0) begin
      if (counter >= cycles) begin
        row_select <= (row_select == max_row) ? 0 : row_select + 1;
        counter <= 0;
      end else begin
        counter <= counter + 1;
      end
    end
  end
endmodule
