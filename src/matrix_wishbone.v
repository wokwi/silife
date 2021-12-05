module silife_matrix_wishbone #(
    parameter WIDTH  = 8,
    parameter HEIGHT = 8
) (
    input wire reset,
    input wire clk,

    input  wire [HEIGHT*WIDTH-1:0] cells,
    output reg  [HEIGHT*WIDTH-1:0] clear_cells,
    output reg  [HEIGHT*WIDTH-1:0] set_cells,

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
  localparam word_count = cell_count / 32;
  localparam word_bits = $clog2(word_count);
  wire [word_bits-1:0] word_index = i_wb_addr[2+word_bits-1:2];

  wire wb_write = i_wb_stb && i_wb_cyc && i_wb_we;

  integer j;
  always @* begin
    o_wb_data   = 32'd0;
    clear_cells = 0;
    set_cells   = 0;
    for (j = 0; j < cell_count; j += 32) begin : read_cells
      if ({word_index, 5'b00000} == j[5+word_bits-1:0]) begin
        o_wb_data = cells[j+:32];
        if (wb_write) begin
          clear_cells[j+:32] = ~i_wb_data;
          set_cells[j+:32]   = i_wb_data;
        end
      end
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
