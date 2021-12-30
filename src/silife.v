// SPDX-FileCopyrightText: © 2021 Uri Shaked <uri@wokwi.com>
// SPDX-License-Identifier: MIT

`default_nettype none
//
`timescale 1ns / 1ps

module silife #(
    parameter WIDTH  = 32,
    parameter HEIGHT = 32
) (
    input wire reset,
    input wire clk,

    // MAX7219 SPI
    output wire spi_cs,
    output wire spi_mosi,
    output wire spi_sck,

    // Inter-grid synchronization
    input  wire i_sync_clk$syn,
    input  wire i_sync_active$syn,
    input  wire i_sync_in_n$syn,
    input  wire i_sync_in_e$syn,
    input  wire i_sync_in_s$syn,
    input  wire i_sync_in_w$syn,
    output wire o_sync_out_n$syn,
    output wire o_sync_out_e$syn,
    output wire o_sync_out_s$syn,
    output wire o_sync_out_w$syn,
    output wire o_busy,

    output wire o_sync_active,
    output wire o_sync_clk,
    input  wire i_sync_busy$syn,

    // Serial load interface
    input  wire i_load_cs$load,
    input  wire i_load_clk$load,
    input  wire i_load_data$load,
    output wire o_load_data$load,

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
  reg clk_pulse;
  reg grid_wrap;

  localparam REG_CTRL = 24'h000;
  localparam REG_CONFIG = 24'h004;
  localparam REG_MAX7219_CTRL = 24'h010;
  localparam REG_MAX7219_CONFIG = 24'h014;
  localparam REG_MAX7219_BRIGHTNESS = 24'h018;
  localparam REG_DBG_LOCAL_ADDRESS = 24'h020;

  localparam ROW_BITS = $clog2(HEIGHT);

  /* SPI Loader */
  wire spi_loader_selected;
  wire [ROW_BITS-1:0] spi_loader_row_select;
  wire [WIDTH-1:0] spi_loader_set_cells;
  wire [WIDTH-1:0] spi_loader_clear_cells;
  wire [14:0] dbg_local_address;

  wire spi_loader_control_write;
  wire [23:0] spi_loader_control_addr;
  wire [31:0] spi_loader_control_data;

  /* MAX7219 interface */
  reg max7219_enable;
  reg max7219_pause;
  reg max7219_frame;
  wire max7219_busy;
  reg [3:0] max7219_brightness;
  reg max7219_reverse_columns;
  reg max7219_serpentine;

  /* Syncronization interface */
  wire [WIDTH-1:0] grid_n;
  wire [HEIGHT-1:0] grid_e;
  wire [WIDTH-1:0] grid_s;
  wire [HEIGHT-1:0] grid_w;
  wire [WIDTH-1:0] grid_in_n;
  wire grid_in_ne;
  wire [HEIGHT-1:0] grid_in_e;
  wire grid_in_se;
  wire [WIDTH-1:0] grid_in_s;
  wire grid_in_sw;
  wire [HEIGHT-1:0] grid_in_w;
  wire grid_in_nw;

  reg sync_en_n;
  reg sync_en_e;
  reg sync_en_s;
  reg sync_en_w;
  wire [WIDTH-1:0] sync_fallback_n = grid_wrap ? grid_s : {WIDTH{1'b0}};
  wire sync_fallback_ne = grid_wrap ? grid_s[0] : 1'b0;
  wire [HEIGHT-1:0] sync_fallback_e = grid_wrap ? grid_w : {HEIGHT{1'b0}};
  wire sync_fallback_se = grid_wrap ? grid_n[0] : 1'b0;
  wire [WIDTH-1:0] sync_fallback_s = grid_wrap ? grid_n : {WIDTH{1'b0}};
  wire sync_fallback_sw = grid_wrap ? grid_n[WIDTH-1] : 1'b0;
  wire [HEIGHT-1:0] sync_fallback_w = grid_wrap ? grid_e : {HEIGHT{1'b0}};
  wire sync_fallback_nw = grid_wrap ? grid_s[WIDTH-1] : 1'b0;

  reg sync_generation;
  wire sync_busy$syn;
  reg sync_busy_past;
  wire sync_busy;

  assign o_busy = |{sync_busy$syn | sync_busy | sync_busy_past | sync_generation};

  /* Wishbone interface */
  reg wb_read_ack;
  reg wb_write_ack;
  wire wb_grid_ack;
  wire [31:0] wb_grid_data;

  assign o_wb_ack = wb_read_ack | wb_write_ack | (wb_grid_select && wb_grid_ack);
  wire wb_read = i_wb_stb && i_wb_cyc && !i_wb_we;
  wire wb_write = i_wb_stb && i_wb_cyc && i_wb_we;
  wire [23:0] wb_addr = i_wb_addr[23:0];
  wire wb_grid_select = i_wb_addr[23:12] == 12'h001;

  wire [WIDTH-1:0] wb_clear_cells;
  wire [WIDTH-1:0] wb_set_cells;
  wire [WIDTH-1:0] cells;
  wire [WIDTH-1:0] cells_scan;
  wire [ROW_BITS-1:0] wb_row_select;
  wire [ROW_BITS-1:0] row_select_scan;

  /* Unified control interface */
  wire control_reg_write = wb_write | spi_loader_control_write;
  wire [23:0] control_reg_addr = spi_loader_control_write ? spi_loader_control_addr : wb_addr;
  wire [31:0] control_reg_data = spi_loader_control_write ? spi_loader_control_data : i_wb_data;

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

  wire [string_bits-1:0] row00 = row_to_string(clk, grid.cell_values['d00*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row01 = row_to_string(clk, grid.cell_values['d01*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row02 = row_to_string(clk, grid.cell_values['d02*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row03 = row_to_string(clk, grid.cell_values['d03*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row04 = row_to_string(clk, grid.cell_values['d04*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row05 = row_to_string(clk, grid.cell_values['d05*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row06 = row_to_string(clk, grid.cell_values['d06*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row07 = row_to_string(clk, grid.cell_values['d07*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row08 = row_to_string(clk, grid.cell_values['d08*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row09 = row_to_string(clk, grid.cell_values['d09*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row10 = row_to_string(clk, grid.cell_values['d10*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row11 = row_to_string(clk, grid.cell_values['d11*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row12 = row_to_string(clk, grid.cell_values['d12*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row13 = row_to_string(clk, grid.cell_values['d13*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row14 = row_to_string(clk, grid.cell_values['d14*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row15 = row_to_string(clk, grid.cell_values['d15*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row16 = row_to_string(clk, grid.cell_values['d16*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row17 = row_to_string(clk, grid.cell_values['d17*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row18 = row_to_string(clk, grid.cell_values['d18*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row19 = row_to_string(clk, grid.cell_values['d19*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row20 = row_to_string(clk, grid.cell_values['d20*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row21 = row_to_string(clk, grid.cell_values['d21*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row22 = row_to_string(clk, grid.cell_values['d22*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row23 = row_to_string(clk, grid.cell_values['d23*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row24 = row_to_string(clk, grid.cell_values['d24*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row25 = row_to_string(clk, grid.cell_values['d25*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row26 = row_to_string(clk, grid.cell_values['d26*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row27 = row_to_string(clk, grid.cell_values['d27*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row28 = row_to_string(clk, grid.cell_values['d28*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row29 = row_to_string(clk, grid.cell_values['d29*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row30 = row_to_string(clk, grid.cell_values['d30*WIDTH+:WIDTH]);
  wire [string_bits-1:0] row31 = row_to_string(clk, grid.cell_values['d31*WIDTH+:WIDTH]);
`endif

  silife_max7219 #(
      .WIDTH (WIDTH),
      .HEIGHT(HEIGHT)
  ) max7219 (
      .reset(reset),
      .clk(clk),
      .i_frame(!max7219_pause | max7219_frame),
      .i_enable(max7219_enable),
      .i_brightness(max7219_brightness),
      .i_reverse_columns(max7219_reverse_columns),
      .i_serpentine(max7219_serpentine),
      .i_cells(cells_scan),
      .o_cs(spi_cs),
      .o_sck(spi_sck),
      .o_mosi(spi_mosi),
      .o_busy(max7219_busy),
      .o_row_select(row_select_scan)
  );

  silife_grid_32x32 grid (
      .reset(reset),
      .clk(clk),
      .enable(enable || clk_pulse || sync_generation),
      .row_select(spi_loader_selected ? spi_loader_row_select : wb_row_select),
      .row_select2(row_select_scan),
      .clear_cells(spi_loader_selected ? spi_loader_clear_cells : wb_clear_cells),
      .set_cells(spi_loader_selected ? spi_loader_set_cells : wb_set_cells),
      .cells(cells),
      .cells2(cells_scan),
      .i_ne(sync_en_n ? grid_in_ne : sync_fallback_ne),
      .i_se(sync_en_e ? grid_in_se : sync_fallback_se),
      .i_sw(sync_en_s ? grid_in_sw : sync_fallback_sw),
      .i_nw(sync_en_w ? grid_in_nw : sync_fallback_nw),
      .i_n(sync_en_n ? grid_in_n : sync_fallback_n),
      .i_e(sync_en_e ? grid_in_e : sync_fallback_e),
      .i_s(sync_en_s ? grid_in_s : sync_fallback_s),
      .i_w(sync_en_w ? grid_in_w : sync_fallback_w),
      .o_n(grid_n),
      .o_e(grid_e),
      .o_s(grid_s),
      .o_w(grid_w)
  );

  silife_grid_loader #(
      .WIDTH (WIDTH),
      .HEIGHT(HEIGHT)

  ) grid_spi_loader (
      .reset(reset),
      .clk  (clk),

      .i_load_cs$load  (i_load_cs$load),
      .i_load_clk$load (i_load_clk$load),
      .i_load_data$load(i_load_data$load),
      .o_load_data$load(o_load_data$load),

      .o_selected(spi_loader_selected),
      .o_row_select(spi_loader_row_select),
      .o_set_cells(spi_loader_set_cells),
      .o_clear_cells(spi_loader_clear_cells),

      .o_control_write(spi_loader_control_write),
      .o_control_addr (spi_loader_control_addr),
      .o_control_data (spi_loader_control_data),

      .o_dbg_local_address(dbg_local_address)
  );

  silife_grid_sync #(
      .WIDTH (WIDTH),
      .HEIGHT(HEIGHT)
  ) grid_sync (
      .reset(reset),
      .clk  (clk),

      .i_sync_clk$syn(i_sync_clk$syn),
      .i_sync_active$syn(i_sync_active$syn),
      .i_sync_in_n$syn(i_sync_in_n$syn),
      .i_sync_in_e$syn(i_sync_in_e$syn),
      .i_sync_in_s$syn(i_sync_in_s$syn),
      .i_sync_in_w$syn(i_sync_in_w$syn),
      .o_sync_out_n$syn(o_sync_out_n$syn),
      .o_sync_out_e$syn(o_sync_out_e$syn),
      .o_sync_out_s$syn(o_sync_out_s$syn),
      .o_sync_out_w$syn(o_sync_out_w$syn),
      .o_busy$syn(sync_busy$syn),
      .o_busy(sync_busy),

      .i_grid_n (grid_n),
      .i_grid_e (grid_e),
      .i_grid_s (grid_s),
      .i_grid_w (grid_w),
      .o_grid_n (grid_in_n),
      .o_grid_ne(grid_in_ne),
      .o_grid_e (grid_in_e),
      .o_grid_se(grid_in_se),
      .o_grid_s (grid_in_s),
      .o_grid_sw(grid_in_sw),
      .o_grid_w (grid_in_w),
      .o_grid_nw(grid_in_nw)
  );

  silife_grid_wishbone #(
      .WIDTH (WIDTH),
      .HEIGHT(HEIGHT)
  ) grid_wishbone (
      .reset(reset),
      .clk  (clk),

      .clear_cells(wb_clear_cells),
      .set_cells(wb_set_cells),
      .cells(cells),
      .row_select(wb_row_select),

      .i_wb_cyc (i_wb_cyc),
      .i_wb_stb (i_wb_stb && wb_grid_select),
      .i_wb_we  (i_wb_we),
      .i_wb_addr(i_wb_addr),
      .i_wb_data(i_wb_data),
      .o_wb_ack (wb_grid_ack),
      .o_wb_data(wb_grid_data)
  );

  // Wishbone reads
  always @(posedge clk) begin
    if (reset) begin
      o_wb_data   <= 0;
      wb_read_ack <= 0;
    end else if (wb_read) begin
      case (wb_addr)
        REG_CTRL: o_wb_data <= {30'b0, 1'b0, enable};
        REG_CONFIG: begin
          o_wb_data <= {24'b0, sync_en_w, sync_en_s, sync_en_e, sync_en_n, 3'b0, grid_wrap};
        end
        REG_MAX7219_CTRL: o_wb_data <= {28'b0, max7219_busy, 1'b0, max7219_pause, max7219_enable};
        REG_MAX7219_CONFIG: o_wb_data <= {30'b0, max7219_serpentine, max7219_reverse_columns};
        REG_MAX7219_BRIGHTNESS: o_wb_data <= {28'b0, max7219_brightness};
        REG_DBG_LOCAL_ADDRESS: o_wb_data <= {17'b0, dbg_local_address};
        default: begin
          o_wb_data <= wb_grid_data;
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
      clk_pulse <= 0;
      max7219_enable <= 1'b0;
      max7219_pause <= 1'b0;
      max7219_frame <= 1'b1;
      max7219_reverse_columns <= 1'b1;
      max7219_serpentine <= 1'b1;
      max7219_brightness <= 4'hf;
      grid_wrap <= 1'b0;
      sync_en_n <= 1'b0;
      sync_en_e <= 1'b0;
      sync_en_s <= 1'b0;
      sync_en_w <= 1'b0;
      sync_busy_past <= 1'b0;
      sync_generation <= 1'b0;
    end else begin
      sync_generation <= sync_busy_past && !sync_busy;
      sync_busy_past  <= sync_busy;
      if (control_reg_write) begin
        case (control_reg_addr)
          REG_CTRL: begin
            enable <= control_reg_data[0];
            clk_pulse <= control_reg_data[1];
          end
          REG_CONFIG: begin
            grid_wrap <= control_reg_data[0];
            sync_en_n = control_reg_data[3];
            sync_en_e = control_reg_data[4];
            sync_en_s = control_reg_data[5];
            sync_en_w = control_reg_data[6];
          end
          REG_MAX7219_CTRL: begin
            max7219_enable <= control_reg_data[0];
            max7219_pause  <= control_reg_data[1];
            max7219_frame  <= control_reg_data[2];
          end
          REG_MAX7219_CONFIG: begin
            max7219_reverse_columns <= control_reg_data[0];
            max7219_serpentine <= control_reg_data[1];
          end
          REG_MAX7219_BRIGHTNESS: begin
            max7219_brightness <= control_reg_data[3:0];
          end
        endcase
        if (wb_write) wb_write_ack <= 1;
      end else begin
        wb_write_ack <= 0;
        if (max7219_busy) max7219_frame <= 0;
      end
      if (clk_pulse) clk_pulse <= 0;
    end
  end

endmodule
