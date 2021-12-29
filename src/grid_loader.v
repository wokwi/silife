// SPDX-FileCopyrightText: © 2021 Uri Shaked <uri@wokwi.com>
// SPDX-License-Identifier: MIT

`default_nettype none
//
`timescale 1ns / 1ps

module silife_grid_loader #(
    parameter WIDTH  = 32,
    parameter HEIGHT = 32
) (
    input wire reset,
    input wire clk,

    /* IO interface (SPI-like) */
    input  wire i_load_cs$load,
    input  wire i_load_clk$load,
    input  wire i_load_data$load,
    output wire o_load_data$load,

    /* Grid interface */
    output wire o_selected,
    output reg [ROW_BITS-1:0] o_row_select,
    output reg [WIDTH-1:0] o_set_cells,
    output reg [WIDTH-1:0] o_clear_cells
);

  wire load_cs;
  wire load_clk;
  wire load_data;

  localparam ROW_BITS = $clog2(HEIGHT);
  localparam COL_BITS = $clog2(WIDTH);

  /* Buffers for clock domain crossing */
  silife_buf_reg #(
      .DEFAULT(1'b1)
  ) load_cs_buf (
      .reset(reset),
      .clk(clk),
      .in(i_load_cs$load),
      .out(load_cs)
  );

  silife_buf_reg #(
      .DEFAULT(1'b0)
  ) load_clk_buf (
      .reset(reset),
      .clk(clk),
      .in(i_load_clk$load),
      .out(load_clk)
  );

  silife_buf_reg #(
      .DEFAULT(1'b0)
  ) load_data_buf (
      .reset(reset),
      .clk(clk),
      .in(i_load_data$load),
      .out(load_data)
  );

  reg first_bit_in$load;
  reg configure_mode$load;
  reg configure_mode$load_neg;
  assign o_load_data$load = configure_mode$load_neg ? 1'b1 : i_load_data$load;

  always @(negedge i_load_clk$load) begin
    configure_mode$load_neg <= configure_mode$load;
  end

  always @(posedge i_load_clk$load or posedge i_load_cs$load or posedge reset) begin
    if (reset || i_load_cs$load) begin
      first_bit_in$load <= 1'b1;
      configure_mode$load <= 1'b0;
    end else begin
      if (first_bit_in$load) begin
        configure_mode$load <= i_load_data$load;
      end else if (configure_mode$load) begin
        if (!i_load_data$load) configure_mode$load <= 1'b0;
      end
      first_bit_in$load <= 1'b0;
    end
  end

  localparam StateInit = 0;
  localparam StateConfigure = 1;
  localparam StateSegmentAddress = 2;
  localparam StateRowAddress = 3;
  localparam StateCellData = 4;

  reg [14:0] local_address;
  reg [14:0] selected_segment;
  reg [15:0] selected_row;

  wire selected = local_address == selected_segment;
  assign o_selected = selected && state == StateCellData;

  reg [2:0] state;
  reg load_clk_past;
  reg [15:0] bit_counter;
  wire [COL_BITS-1:0] cell_index = bit_counter[COL_BITS-1:0];

  always @(posedge clk) begin
    if (reset) begin
      state <= StateInit;
      local_address <= 15'b0;
      selected_segment <= 15'b0;
      selected_row <= 0;
      load_clk_past <= 1'b0;
      bit_counter <= 16'b0;
      o_set_cells <= {WIDTH{1'b0}};
      o_clear_cells <= {WIDTH{1'b0}};
    end else begin
      load_clk_past <= load_clk;
      o_set_cells   <= {WIDTH{1'b0}};
      o_clear_cells <= {WIDTH{1'b0}};
      if (load_cs) begin
        state <= StateInit;
        selected_segment <= 15'b0;
        selected_row <= 0;
        bit_counter <= 16'b0;
      end else if (load_clk && !load_clk_past) begin
        case (state)
          StateInit: begin
            if (load_data) begin
              state <= StateConfigure;
              local_address <= 15'b0;
            end else begin
              state <= StateSegmentAddress;
              selected_segment <= 15'b0;
              selected_row <= 16'b0;
              bit_counter <= 16'b0;
            end
          end
          StateConfigure: begin
            if (load_data) local_address <= local_address + 1;
          end
          StateSegmentAddress: begin
            bit_counter <= bit_counter + 1;
            selected_segment[bit_counter[3:0]] <= load_data;
            if (bit_counter == 16'd14) begin
              bit_counter <= 0;
              state <= StateRowAddress;
            end
          end
          StateRowAddress: begin
            bit_counter <= bit_counter + 1;
            selected_row[bit_counter[3:0]] <= load_data;
            if (bit_counter == 16'd15) begin
              bit_counter <= 0;
              state <= StateCellData;
            end
          end
          StateCellData: begin
            bit_counter  <= bit_counter + 1;
            o_row_select <= selected_row[ROW_BITS-1:0];
            if (selected) begin
              if (load_data) o_set_cells[cell_index] <= 1'b1;
              else o_clear_cells[cell_index] <= 1'b1;
            end
            if (bit_counter == WIDTH - 1) begin
              selected_row <= selected_row + 1;
              bit_counter  <= 0;
            end
          end
        endcase
      end
    end
  end

endmodule
