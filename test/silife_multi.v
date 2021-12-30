// SPDX-FileCopyrightText: © 2021 Uri Shaked <uri@wokwi.com>
// SPDX-License-Identifier: MIT

`default_nettype none
//
`timescale 1ns / 1ps

module silife_multi (
    input wire clk,
    input wire reset,

    input  wire i_sync_active,
    input  wire i_sync_clk,
    output wire o_busy,

    input wire i_load_cs$load,
    input wire i_load_clk$load,
    input wire i_load_data$load
);

  wire busy_0_0;
  wire sync_0_0_e;
  wire sync_0_0_s;
  wire load_data_out_0_0;

  wire busy_0_1;
  wire sync_0_1_e;
  wire sync_0_1_s;
  wire sync_0_1_w;
  wire load_data_out_0_1;

  wire busy_0_2;
  wire sync_0_2_s;
  wire sync_0_2_w;
  wire load_data_out_0_2;

  wire busy_1_0;
  wire sync_1_0_n;
  wire sync_1_0_e;
  wire sync_1_0_s;
  wire load_data_out_1_0;

  wire busy_1_1;
  wire sync_1_1_n;
  wire sync_1_1_e;
  wire sync_1_1_s;
  wire sync_1_1_w;
  wire load_data_out_1_1;

  wire busy_1_2;
  wire sync_1_2_n;
  wire sync_1_2_s;
  wire sync_1_2_w;
  wire load_data_out_1_2;

  wire busy_2_0;
  wire sync_2_0_n;
  wire sync_2_0_e;
  wire load_data_out_2_0;

  wire busy_2_1;
  wire sync_2_1_n;
  wire sync_2_1_e;
  wire sync_2_1_w;
  wire load_data_out_2_1;

  wire busy_2_2;
  wire sync_2_2_n;
  wire sync_2_2_w;
  wire load_data_out_2_2;

  assign o_busy = |{busy_0_0, busy_0_1, busy_0_2, busy_1_0, busy_1_1, busy_1_2, busy_2_0, busy_2_1, busy_2_2};

  silife silife0_0 (
      .reset(reset),
      .clk(clk),
      .i_load_cs$load(i_load_cs$load),
      .i_load_clk$load(i_load_clk$load),
      .i_load_data$load(i_load_data$load),
      .o_load_data$load(load_data_out_0_0),

      .i_sync_active$syn(i_sync_active),
      .i_sync_clk$syn(i_sync_clk),
      .i_sync_in_n$syn(1'b0),
      .i_sync_in_e$syn(sync_0_1_w),
      .i_sync_in_s$syn(sync_1_0_n),
      .i_sync_in_w$syn(1'b0),
      .o_sync_out_n$syn(),
      .o_sync_out_e$syn(sync_0_0_e),
      .o_sync_out_s$syn(sync_0_0_s),
      .o_sync_out_w$syn(),
      .o_busy(busy_0_0)
  );

  silife silife0_1 (
      .reset(reset),
      .clk(clk),
      .i_load_cs$load(i_load_cs$load),
      .i_load_clk$load(i_load_clk$load),
      .i_load_data$load(load_data_out_0_0),
      .o_load_data$load(load_data_out_0_1),

      .i_sync_active$syn(i_sync_active),
      .i_sync_clk$syn(i_sync_clk),
      .i_sync_in_n$syn(1'b0),
      .i_sync_in_e$syn(sync_0_2_w),
      .i_sync_in_s$syn(sync_1_1_n),
      .i_sync_in_w$syn(sync_0_0_e),
      .o_sync_out_n$syn(),
      .o_sync_out_e$syn(sync_0_1_e),
      .o_sync_out_s$syn(sync_0_1_s),
      .o_sync_out_w$syn(sync_0_1_w),
      .o_busy(busy_0_1)
  );

  silife silife0_2 (
      .reset(reset),
      .clk(clk),
      .i_load_cs$load(i_load_cs$load),
      .i_load_clk$load(i_load_clk$load),
      .i_load_data$load(load_data_out_0_1),
      .o_load_data$load(load_data_out_0_2),

      .i_sync_active$syn(i_sync_active),
      .i_sync_clk$syn(i_sync_clk),
      .i_sync_in_n$syn(1'b0),
      .i_sync_in_e$syn(1'b0),
      .i_sync_in_s$syn(sync_1_2_n),
      .i_sync_in_w$syn(sync_0_1_e),
      .o_sync_out_n$syn(),
      .o_sync_out_e$syn(),
      .o_sync_out_s$syn(sync_0_2_s),
      .o_sync_out_w$syn(sync_0_2_w),
      .o_busy(busy_0_2)
  );

  silife silife1_0 (
      .reset(reset),
      .clk(clk),
      .i_load_cs$load(i_load_cs$load),
      .i_load_clk$load(i_load_clk$load),
      .i_load_data$load(load_data_out_0_2),
      .o_load_data$load(load_data_out_1_0),

      .i_sync_active$syn(i_sync_active),
      .i_sync_clk$syn(i_sync_clk),
      .i_sync_in_n$syn(sync_0_0_s),
      .i_sync_in_e$syn(sync_1_1_w),
      .i_sync_in_s$syn(sync_2_0_n),
      .i_sync_in_w$syn(1'b0),
      .o_sync_out_n$syn(sync_1_0_n),
      .o_sync_out_e$syn(sync_1_0_e),
      .o_sync_out_s$syn(sync_1_0_s),
      .o_sync_out_w$syn(),
      .o_busy(busy_1_0)
  );

  silife silife1_1 (
      .reset(reset),
      .clk(clk),
      .i_load_cs$load(i_load_cs$load),
      .i_load_clk$load(i_load_clk$load),
      .i_load_data$load(load_data_out_1_0),
      .o_load_data$load(load_data_out_1_1),

      .i_sync_active$syn(i_sync_active),
      .i_sync_clk$syn(i_sync_clk),
      .i_sync_in_n$syn(sync_0_1_s),
      .i_sync_in_e$syn(sync_1_2_w),
      .i_sync_in_s$syn(sync_2_1_n),
      .i_sync_in_w$syn(sync_1_0_e),
      .o_sync_out_n$syn(sync_1_1_n),
      .o_sync_out_e$syn(sync_1_1_e),
      .o_sync_out_s$syn(sync_1_1_s),
      .o_sync_out_w$syn(sync_1_1_w),
      .o_busy(busy_1_1)
  );

  silife silife1_2 (
      .reset(reset),
      .clk(clk),
      .i_load_cs$load(i_load_cs$load),
      .i_load_clk$load(i_load_clk$load),
      .i_load_data$load(load_data_out_1_1),
      .o_load_data$load(load_data_out_1_2),

      .i_sync_active$syn(i_sync_active),
      .i_sync_clk$syn(i_sync_clk),
      .i_sync_in_n$syn(sync_0_2_s),
      .i_sync_in_e$syn(1'b0),
      .i_sync_in_s$syn(sync_2_2_n),
      .i_sync_in_w$syn(sync_1_1_e),
      .o_sync_out_n$syn(sync_1_2_n),
      .o_sync_out_e$syn(),
      .o_sync_out_s$syn(sync_1_2_s),
      .o_sync_out_w$syn(sync_1_2_w),
      .o_busy(busy_1_2)
  );

  silife silife2_0 (
      .reset(reset),
      .clk(clk),
      .i_load_cs$load(i_load_cs$load),
      .i_load_clk$load(i_load_clk$load),
      .i_load_data$load(load_data_out_1_2),
      .o_load_data$load(load_data_out_2_0),

      .i_sync_active$syn(i_sync_active),
      .i_sync_clk$syn(i_sync_clk),
      .i_sync_in_n$syn(sync_1_0_s),
      .i_sync_in_e$syn(sync_2_1_w),
      .i_sync_in_s$syn(1'b0),
      .i_sync_in_w$syn(1'b0),
      .o_sync_out_n$syn(sync_2_0_n),
      .o_sync_out_e$syn(sync_2_0_e),
      .o_sync_out_s$syn(),
      .o_sync_out_w$syn(),
      .o_busy(busy_1_0)
  );

  silife silife2_1 (
      .reset(reset),
      .clk(clk),
      .i_load_cs$load(i_load_cs$load),
      .i_load_clk$load(i_load_clk$load),
      .i_load_data$load(load_data_out_2_0),
      .o_load_data$load(load_data_out_2_1),

      .i_sync_active$syn(i_sync_active),
      .i_sync_clk$syn(i_sync_clk),
      .i_sync_in_n$syn(sync_1_1_s),
      .i_sync_in_e$syn(sync_2_2_w),
      .i_sync_in_s$syn(1'b0),
      .i_sync_in_w$syn(sync_2_0_e),
      .o_sync_out_n$syn(sync_2_1_n),
      .o_sync_out_e$syn(sync_2_1_e),
      .o_sync_out_s$syn(),
      .o_sync_out_w$syn(sync_2_1_w),
      .o_busy(busy_1_1)
  );

  silife silife2_2 (
      .reset(reset),
      .clk(clk),
      .i_load_cs$load(i_load_cs$load),
      .i_load_clk$load(i_load_clk$load),
      .i_load_data$load(load_data_out_2_1),
      .o_load_data$load(load_data_out_2_2),

      .i_sync_active$syn(i_sync_active),
      .i_sync_clk$syn(i_sync_clk),
      .i_sync_in_n$syn(sync_1_2_s),
      .i_sync_in_e$syn(1'b0),
      .i_sync_in_s$syn(1'b0),
      .i_sync_in_w$syn(sync_2_1_e),
      .o_sync_out_n$syn(sync_2_2_n),
      .o_sync_out_e$syn(),
      .o_sync_out_s$syn(),
      .o_sync_out_w$syn(sync_2_2_w),
      .o_busy(busy_2_2)
  );
endmodule
