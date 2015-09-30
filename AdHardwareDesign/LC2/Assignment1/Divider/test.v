module test;

localparam W=8;

reg clk, rst;

reg [W-1:0] divider,dividend;
wire done;
wire [W-1:0] quotient, reminder;

Divider #(W) div(dividend, divider, rst, clk, quotient, reminder, done);

always begin
  # 10 clk = ~clk;
end

initial begin

  clk = 0; rst = 0;
  #10 rst = 1;
  #20 rst = 0;
     divider = 3;
     dividend = 20;
end
endmodule
