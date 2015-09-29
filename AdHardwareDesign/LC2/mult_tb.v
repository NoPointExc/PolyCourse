module multiplier_tb;

localparam W = 8;

reg clk, reset;

reg [W-1:0] x, y; 

wire [2*W - 1:0] out;


multiplier #(W) m1  (x, y, clk, reset, out);

// posedges: 2, 6, 10, 14
// negedges: 4, 8, 12, 16
always begin
  # 2 clk = ~clk;
end


initial begin

  clk = 0; reset = 0;
  #1 reset = 1;
  #3 reset = 0;
     x = 4;
     y = 6;
end

endmodule
  