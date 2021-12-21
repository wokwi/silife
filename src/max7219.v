// SPDX-FileCopyrightText: © 2021 Uri Shaked <uri@wokwi.com>
// SPDX-License-Identifier: MIT

`default_nettype none
//
`timescale 1ns / 1ps

module silife_max7219 #(
    parameter WIDTH  = 32,
    parameter HEIGHT = 32
) (
    input wire reset,
    input wire clk,

    input wire i_enable,
    input wire [WIDTH-1:0] i_cells,
    input wire [3:0] i_brightness,

    // MAX7219 SPI interface
    output reg  o_cs,
    output wire o_sck,  // 100ns
    output wire o_mosi,

    output reg [row_bits-1:0] o_row_select
);

  localparam StateInit = 2'd0;
  localparam StateStart = 2'd1;
  localparam StateData = 2'd2;
  localparam StateEnable = 2'd3;

  localparam row_bits = $clog2(HEIGHT);

  reg [1:0] state;

  reg [15:0] spi_word;
  reg spi_start;
  wire spi_busy;

  reg [1:0] init_index;
  reg [1:0] column_index;
  wire [4:0] column_offset = {column_index, 3'b000};
  reg [3:0] segment_index;
  reg max7219_enabled;
  wire [3:0] max7219_row = o_row_select[2:0] + 1;

  silife_spi_master spim (
      .reset(reset),
      .clk(clk),
      .i_word(spi_word),
      .i_start(spi_start),
      .o_sck(o_sck),
      .o_mosi(o_mosi),
      .o_busy(spi_busy)
  );

  always @(*) begin
    case (state)
      StateInit:   spi_word <= 16'b0;
      StateStart: begin
        case (init_index)
          0: spi_word <= {8'h0f, 8'h00};  // Disable test mode
          1: spi_word <= {8'h0b, 8'h07};  // Set scanlines to 8
          2: spi_word <= {8'h09, 8'h00};  // Disable decode mode
          3: spi_word <= {8'h0a, 4'b0000, i_brightness};  // Configure max brightness
        endcase
      end
      StateData:   spi_word = {4'b0, max7219_row, i_cells[column_offset+:8]};
      StateEnable: spi_word <= {8'h0c, 8'h01};  // Enable display
    endcase
  end

  always @(posedge clk) begin
    if (reset) begin
      state <= StateInit;
      init_index <= 0;
      segment_index <= 0;
      o_row_select <= 0;
      column_index <= 0;
      max7219_enabled <= 0;
      o_cs <= 1;
    end else begin
      spi_start <= 0;
      if (!i_enable) begin
        state <= StateInit;
      end else if (!spi_start && !spi_busy) begin
        case (state)
          StateInit: begin
            init_index <= 0;
            segment_index <= 4'h0;
            o_row_select <= 5'h0;
            column_index <= 2'h0;
            max7219_enabled <= 0;
            o_cs <= 1;
            if (i_enable) begin
              o_cs <= 0;
              state = StateStart;
              spi_start <= 1;
            end
          end
          StateStart: begin
            segment_index <= segment_index + 1;
            spi_start <= 1;
            if (segment_index == 4'hf) begin
              segment_index <= 4'hf;
              if (!o_cs) begin
                column_index <= 2'h0;
                o_row_select <= 5'h0;
                o_cs <= 1;
                spi_start <= 0;
              end else begin
                o_cs <= 0;
                segment_index <= 4'h0;
                if (init_index == 3) begin
                  state <= StateData;
                end
                init_index <= init_index + 1;
              end
            end
          end
          StateData: begin
            spi_start <= 1;
            column_index <= column_index + 1;
            segment_index <= segment_index + 1;
            if (column_index == 2'h3) begin
              o_row_select[4:3] <= o_row_select[4:3] + 1;
            end
            if (segment_index == 4'hf) begin
              if (!o_cs) begin
                o_cs <= 1;
                segment_index <= 4'hf;
                column_index <= column_index;
                o_row_select <= o_row_select;
                spi_start <= 0;
              end else begin
                o_cs <= 0;
                o_row_select[2:0] <= o_row_select[2:0] + 1;
                if (max7219_row == 8 && !max7219_enabled) begin
                  state <= StateEnable;
                end
              end
            end
          end
          StateEnable: begin
            if (segment_index != 4'hf) begin
              segment_index <= segment_index + 1;
              spi_start <= 1;
            end else begin
              if (!o_cs) begin
                column_index <= 2'h0;
                o_row_select <= 5'h0;
                o_cs <= 1;
              end else begin
                max7219_enabled <= 1;
                state <= StateData;
                o_cs <= 0;
                segment_index <= 0;
                spi_start <= 1;
              end
            end
          end
        endcase
      end
    end
  end
endmodule
