`define SILIFE_TEST 

module dump ();
  initial begin
    $dumpfile("silife_test.vcd");
    $dumpvars(0, silife);
    #1;
  end
endmodule
