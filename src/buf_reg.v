module silife_buf_reg #(
    parameter BITS = 2,
    parameter DEFAULT = 1'b0
) (
    input wire reset,
    input wire clk,

    output wire in,
    output wire out
);

  reg [BITS-1:0] buffer;

  assign out = buffer[BITS-1];

  always @(posedge clk) begin
    if (reset) buffer <= {BITS{DEFAULT}};
    else buffer <= {buffer[BITS-2:0], in};
  end
endmodule
