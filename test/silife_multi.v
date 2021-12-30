// SPDX-FileCopyrightText: © 2021 Uri Shaked <uri@wokwi.com>
// SPDX-License-Identifier: MIT

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
  wire load_data_out_0_0;

  wire busy_0_1;
  wire sync_0_1_w;
  wire load_data_out_0_1;

  assign o_busy = |{busy_0_0, busy_0_1};

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
      .i_sync_in_s$syn(1'b0),
      .i_sync_in_w$syn(1'b0),
      .o_sync_out_n$syn(),
      .o_sync_out_e$syn(sync_0_0_e),
      .o_sync_out_s$syn(),
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
      .i_sync_in_e$syn(1'b0),
      .i_sync_in_s$syn(1'b0),
      .i_sync_in_w$syn(sync_0_0_e),
      .o_sync_out_n$syn(),
      .o_sync_out_e$syn(),
      .o_sync_out_s$syn(),
      .o_sync_out_w$syn(sync_0_1_w),
      .o_busy(busy_0_1)
  );
endmodule
