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
  reg [15:0] scan_cycles;

  localparam REG_CTRL = 24'h000;
  localparam io_pins = WIDTH + HEIGHT;

  assign io_oeb = {io_pins{1'b0}};

  reg wb_read_ack;
  reg wb_write_ack;
  assign o_wb_ack = wb_read_ack | wb_write_ack;
  wire wb_read = i_wb_stb && i_wb_cyc && !i_wb_we;
  wire wb_write = i_wb_stb && i_wb_cyc && i_wb_we;
  wire [23:0] wb_addr = i_wb_addr[23:0];

  reg [HEIGHT*WIDTH-1:0] clear_cells;
  reg [HEIGHT*WIDTH-1:0] set_cells;
  wire [HEIGHT-1:0][WIDTH-1:0] cells;

  silife_scan #(
      .WIDTH (WIDTH),
      .HEIGHT(HEIGHT)
  ) scan (
      .reset(reset),
      .clk(clk),
      .cells(cells),
      .invert(invert),
      .cycles(scan_cycles),
      .columns(io_out[WIDTH-1:0]),
      .rows(io_out[HEIGHT+WIDTH-1:WIDTH])
  );

  silife_matrix matrix (
      .reset(reset),
      .clk(clk),
      .enable(1'b1),
      .clear_cells(clear_cells),
      .set_cells(set_cells),
      .cells(cells)
  );

  // Wishbone reads
  always @(posedge clk) begin
    if (reset) begin
      o_wb_data   <= 0;
      wb_read_ack <= 0;
    end else if (wb_read) begin
      case (wb_addr)
        REG_CTRL: o_wb_data <= {31'b0, invert, enable};
        default: begin
          // TODO return cells data
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
      scan_cycles <= 16'd3;
    end else begin
      if (wb_write) begin
        case (wb_addr)
          REG_CTRL: begin
            enable <= i_wb_data[0];
            invert <= i_wb_data[0];
          end
        endcase
        wb_write_ack <= 1;
      end else begin
        wb_write_ack <= 0;
      end
    end
  end

endmodule
