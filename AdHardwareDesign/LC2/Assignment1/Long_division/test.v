module test;

localparam W=8;

reg clk, rst;

reg [W-1:0] divider,dividend;
wire done;
wire [W-1:0] quotient, reminder;
wire en_dividend;
wire  en_divider;
wire en_quotient;
wire [2:0] cur_state;
wire [2:0] next_state;
Divider #(W) div(dividend, divider, clk,rst, done, reminder,  quotient,en_dividend,en_divider,en_quotient,cur_state,next_state);


always begin
  # 10 clk = ~clk;
end

initial begin

  clk = 0; rst = 0;
  //dividend=20; divider=3;
  #20 rst = 1;
  		dividend=10; divider=3;
  #60 rst = 0;
  //dividend=20; divider=3;


end
endmodule
