module test;

localparam W=8;

reg clk, rst;

reg [W-1:0] a,b;
wire done;
wire [W-1:0] quotient, remainder;

divider #(W) myDiv( a, b,clk, rst, done, quotient, remainder);

always begin
  # 2 clk = ~clk;
end

initial begin

  clk = 0; rst = 0;
  #1 rst = 1;
  #3 rst = 0;
     a = 3;
     b = 10;
end
endmodule
