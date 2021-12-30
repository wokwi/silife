`define SILIFE_TEST

module dump ();
  initial begin
    $dumpfile("silife_test_multi.vcd");
    $dumpvars(0, silife_multi);
    #1;
  end
endmodule
