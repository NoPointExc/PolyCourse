module test_FSM;



reg done, rst, clk;
wire  en_dividend,  rst_dividend , en_divider, rst_divider,
   en_done,  rst_done, en_quotient, rst_quotient;
wire[2:0] cur_state, next_state;


//Divider #(W) div(dividend, divider, clk,rst, done, reminder,  quotient);
FSM fsm
(done, rst, clk, 
  en_dividend,  rst_dividend , en_divider, rst_divider,
   en_done,  rst_done, en_quotient, rst_quotient,cur_state,next_state);

always begin
  # 20 clk = ~clk;
end

initial begin
  done=0; rst=0;clk=0;
  // clk = 0; rst = 0;
  #20 rst = 1;
  #20 rst = 0;
  #80 done=1;
  #80 done=0;
end
endmodule
