module test;

localparam W=8;

reg clk, rst;

reg [W-1:0] divider,dividend;
wire done;
wire [W-1:0] quotient, reminder;
Divider #(W) div(dividend, divider, clk,rst, done, reminder,  quotient);


always begin
  # 10 clk = ~clk;
end

initial begin

  clk = 0; rst = 0;
  //10/3
  #20 rst = 1;
  		dividend=10; divider=3;
  #60 rst = 0;
  //dividend=10; divider=3;
  // 20/3
  #400 rst = 1;
  		dividend=20; divider=3;
  #60 rst = 0;
  //dividend=20; divider=3;  
  // 0/3
  #400 rst = 1;
  		dividend=0; divider=3;
  #60 rst = 0;   
  // 1/3
  #400 rst = 1;
  		dividend=1; divider=3;
  #60 rst = 0;  
  // 1/0
  #400 rst = 1;
  		dividend=1; divider=0;
  #60 rst = 0;
  // 0/0  
  #400 rst = 1;
  		dividend=0; divider=0;
  #60 rst = 0;      		
end
endmodule
