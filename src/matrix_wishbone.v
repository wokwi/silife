module silife_matrix_wishbone #(
    parameter WIDTH  = 8,
    parameter HEIGHT = 8
) (
    input wire reset,
    input wire clk,

    input wire [WIDTH-1:0] cells,
    output wire [row_bits-1:0] row_select,
    output reg [WIDTH-1:0] clear_cells,
    output reg [WIDTH-1:0] set_cells,

    // Wishbone interface
    input  wire        i_wb_cyc,   // wishbone transaction
    input  wire        i_wb_stb,   // strobe
    input  wire        i_wb_we,    // write enable
    input  wire [31:0] i_wb_addr,  // address
    input  wire [31:0] i_wb_data,  // incoming data
    output reg         o_wb_ack,   // request is completed 
    output reg  [31:0] o_wb_data   // output data
);

  localparam cell_count = WIDTH * HEIGHT;
  localparam row_bits = $clog2(HEIGHT);
  assign row_select = i_wb_addr[2+row_bits-1:2];

  wire wb_write = i_wb_stb && i_wb_cyc && i_wb_we;

  integer j;
  always @* begin
    o_wb_data = 32'd0;
    clear_cells = 0;
    set_cells = 0;
    o_wb_data[WIDTH-1:0] = cells;
    if (wb_write) begin
      clear_cells = ~i_wb_data[WIDTH-1:0];
      set_cells   = i_wb_data[WIDTH-1:0];
    end
  end

  always @(posedge clk) begin
    if (reset) begin
      o_wb_ack <= 0;
    end else begin
      o_wb_ack <= i_wb_stb && i_wb_cyc;
    end
  end

endmodule
