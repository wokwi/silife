// SPDX-FileCopyrightText: © 2021 Uri Shaked <uri@wokwi.com>
// SPDX-License-Identifier: MIT

`default_nettype none
//
`timescale 1ns / 1ps

module silife #(
    parameter WIDTH  = 8,
    parameter HEIGHT = 8
) (
    input wire reset,
    input wire clk,

    // GPIO
    output wire [WIDTH+HEIGHT-1:0] io_out,
    output wire [WIDTH+HEIGHT-1:0] io_oeb,

    // Logic anaylzer
    output wire [31:0] la_data_out,

    // Wishbone interface
    input  wire        i_wb_cyc,   // wishbone transaction
    input  wire        i_wb_stb,   // strobe
    input  wire        i_wb_we,    // write enable
    input  wire [31:0] i_wb_addr,  // address
    input  wire [31:0] i_wb_data,  // incoming data
    output wire        o_wb_ack,   // request is completed 
    output reg  [31:0] o_wb_data   // output data
);

  reg enable;
  reg invert;
  reg clk_pulse;
  reg [15:0] scan_cycles;

  localparam REG_CTRL = 24'h000;
  localparam io_pins = WIDTH + HEIGHT;

  assign io_oeb = {io_pins{1'b0}};

  reg wb_read_ack;
  reg wb_write_ack;
  wire wb_matrix_ack;
  wire [31:0] wb_matrix_data;

  assign o_wb_ack = wb_read_ack | wb_write_ack | (wb_matrix_select && wb_matrix_ack);
  wire wb_read = i_wb_stb && i_wb_cyc && !i_wb_we;
  wire wb_write = i_wb_stb && i_wb_cyc && i_wb_we;
  wire [23:0] wb_addr = i_wb_addr[23:0];
  wire wb_matrix_select = i_wb_addr[23:12] == 12'h001;

  wire [WIDTH-1:0] clear_cells;
  wire [WIDTH-1:0] set_cells;
  wire [WIDTH-1:0] cells;
  wire [WIDTH-1:0] cells_scan;
  wire [$clog2(HEIGHT)-1:0] row_select;
  wire [$clog2(HEIGHT)-1:0] row_select_scan;

`ifdef SILIFE_TEST
  /* Pretty output for the test bench */
  localparam string_bits = WIDTH * 8;
  integer i;
  function [string_bits-1:0] row_to_string(input clk, input [WIDTH-1:0] row);
    begin
      for (i = 0; i < WIDTH; i = i + 1) begin
        row_to_string[i*8+:8] = clk ? (row[WIDTH-1-i] ? "*" : " ") : 8'bz;
      end
    end
  endfunction

  wire [string_bits-1:0] row00 = row_to_string(clk, matrix.cell_values['d00*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row01 = row_to_string(clk, matrix.cell_values['d01*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row02 = row_to_string(clk, matrix.cell_values['d02*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row03 = row_to_string(clk, matrix.cell_values['d03*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row04 = row_to_string(clk, matrix.cell_values['d04*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row05 = row_to_string(clk, matrix.cell_values['d05*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row06 = row_to_string(clk, matrix.cell_values['d06*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row07 = row_to_string(clk, matrix.cell_values['d07*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row08 = row_to_string(clk, matrix.cell_values['d08*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row09 = row_to_string(clk, matrix.cell_values['d09*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row10 = row_to_string(clk, matrix.cell_values['d10*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row11 = row_to_string(clk, matrix.cell_values['d11*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row12 = row_to_string(clk, matrix.cell_values['d12*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row13 = row_to_string(clk, matrix.cell_values['d13*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row14 = row_to_string(clk, matrix.cell_values['d14*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row15 = row_to_string(clk, matrix.cell_values['d15*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row16 = row_to_string(clk, matrix.cell_values['d16*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row17 = row_to_string(clk, matrix.cell_values['d17*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row18 = row_to_string(clk, matrix.cell_values['d18*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row19 = row_to_string(clk, matrix.cell_values['d19*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row20 = row_to_string(clk, matrix.cell_values['d20*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row21 = row_to_string(clk, matrix.cell_values['d21*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row22 = row_to_string(clk, matrix.cell_values['d22*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row23 = row_to_string(clk, matrix.cell_values['d23*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row24 = row_to_string(clk, matrix.cell_values['d24*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row25 = row_to_string(clk, matrix.cell_values['d25*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row26 = row_to_string(clk, matrix.cell_values['d26*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row27 = row_to_string(clk, matrix.cell_values['d27*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row28 = row_to_string(clk, matrix.cell_values['d28*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row29 = row_to_string(clk, matrix.cell_values['d29*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row30 = row_to_string(clk, matrix.cell_values['d30*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row31 = row_to_string(clk, matrix.cell_values['d31*WIDTH+:WIDTH]);
`endif

  silife_scan #(
      .WIDTH (WIDTH),
      .HEIGHT(HEIGHT)
  ) scan (
      .reset(reset),
      .clk(clk),
      .cells(cells),
      .invert(invert),
      .cycles(scan_cycles),
      .row_select(row_select_scan),
      .columns(io_out[WIDTH-1:0]),
      .rows(io_out[HEIGHT+WIDTH-1:WIDTH])
  );

  silife_matrix_8x8 matrix (
      .reset(reset),
      .clk(clk),
      .enable(enable || clk_pulse),
      .row_select(row_select),
      .row_select2(row_select_scan),
      .clear_cells(clear_cells),
      .set_cells(set_cells),
      .cells(cells),
      .cells2(cells_scan),
      .i_nw(1'b0),
      .i_ne(1'b0),
      .i_sw(1'b0),
      .i_se(1'b0),
      .i_n({WIDTH{1'b0}}),
      .i_s({WIDTH{1'b0}}),
      .i_e({HEIGHT{1'b0}}),
      .i_w({HEIGHT{1'b0}})
  );

  silife_matrix_wishbone #(
      .WIDTH (WIDTH),
      .HEIGHT(HEIGHT)
  ) matrix_wishbone (
      .reset(reset),
      .clk  (clk),

      .clear_cells(clear_cells),
      .set_cells(set_cells),
      .cells(cells),
      .row_select(row_select),

      .i_wb_cyc (i_wb_cyc),
      .i_wb_stb (i_wb_stb && wb_matrix_select),
      .i_wb_we  (i_wb_we),
      .i_wb_addr(i_wb_addr),
      .i_wb_data(i_wb_data),
      .o_wb_ack (wb_matrix_ack),
      .o_wb_data(wb_matrix_data)
  );

  // Wishbone reads
  always @(posedge clk) begin
    if (reset) begin
      o_wb_data   <= 0;
      wb_read_ack <= 0;
    end else if (wb_read) begin
      case (wb_addr)
        REG_CTRL: o_wb_data <= {30'b0, invert, enable};
        default: begin
          o_wb_data <= wb_matrix_data;
        end
      endcase
      wb_read_ack <= 1;
    end else begin
      wb_read_ack <= 0;
    end
  end

  always @(posedge clk) begin
    if (reset) begin
      enable <= 0;
      invert <= 0;
      clk_pulse <= 0;
      scan_cycles <= 16'd3;
    end else begin
      if (wb_write) begin
        case (wb_addr)
          REG_CTRL: begin
            enable <= i_wb_data[0];
            invert <= i_wb_data[1];
            clk_pulse <= i_wb_data[2];
          end
        endcase
        wb_write_ack <= 1;
      end else begin
        wb_write_ack <= 0;
      end
      if (clk_pulse) clk_pulse <= 0;
    end
  end

endmodule
