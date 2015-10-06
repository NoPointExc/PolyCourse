module Reg 
# (parameter  W=8)
(input [W-1:0] in, input en, input rst, input clk, output reg [W-1:0] out);

always @ (posedge clk) begin
  if(rst)
  out = 0;
  else if (en)
        out = in;
end
endmodule 


module Reg2 
# (parameter  W=8)
(input [W-1:0] init_in ,input [W-1:0] in, input sel,input en, input rst, input clk, output reg [W-1:0] out);

always @ (posedge clk) begin
  if(rst)
  begin
      out = 0;
      if(!sel) out=init_in;
  end

  else if (en)
    begin
      if(sel)
       out=in;
      else
       out=init_in;
    end
      
end
endmodule 



//return dividend-dividor
// module Subtractor
// # (parameter W=8)
// (input [W-1:0] dividend, input[W-1:0] divider, input en, output reg en_counter,output reg [W-1:0] out);
//   always @(*) begin
//     if(en) 
//     begin
//       out=dividend-divider;
//       en_counter=1;
//     end
//   end
// endmodule

module subtractor
# (parameter W=8)
(input [W-1:0] dividend, input[W-1:0] divider, input [W-1:0] ct_in,input en, output reg[W-1:0] ct_out,output reg [W-1:0] out);
  always @(*) begin
    if(en) 
    begin
      out=dividend-divider;
      if(dividend==out) ct_out=ct_in;
      else  ct_out=ct_in+1;
    end
  end
endmodule



//comparator, if a<b , output done.
module Comparator 
# (parameter W = 8)
(input [W-1:0] a, input [W-1:0] b, output reg out);

always @ (*) begin
  if (a<b  ) out=1;
  else out=0;
end

endmodule

//counter, 
// module Counter
// # (parameter W=8)
// (input  [W-1:0] in, input en,output reg[W-1:0] out);
//   always @(*) begin
//     if(en)
//     begin
//        out=in+1;
//     end     
// end
// endmodule



module FSM
(input done, input rst, input clk, 
  output reg en_dividend, output reg rst_dividend ,output reg sel_dividend,output reg en_divider,output reg rst_divider,
  output reg en_done, output reg rst_done,output reg en_quotient, output reg rst_quotient
  ,output reg [2:0] cur_state, output reg [2:0] next_state);

//reg [2:0] cur_state, next_state;
localparam START=0,BUSY=1,STOP=2;

always @(posedge clk or posedge rst) begin
  if (rst) begin
    cur_state<=START;
    end
  else 
    cur_state=next_state;
end

always @(*) begin
  next_state=cur_state;
  en_dividend=0;rst_dividend=0;
  en_divider=0;rst_divider=0;
  en_done=0;rst_done=0;
  en_quotient=0;rst_quotient=0;
  sel_dividend=0;
    case(cur_state)
    
    START: 
    begin
      rst_quotient=1;
      rst_dividend=1;
      rst_divider=1;
      rst_done=1;
      if(done) next_state=STOP;
      else next_state=BUSY;
    end

    BUSY:
    begin
      if(done)
       begin
          next_state=STOP;
       end 
      else
        begin
          next_state=BUSY;
          en_quotient=1;
          en_done=1;
          en_dividend=1;
          sel_dividend=1;
          en_divider=1;
        end 
        
    end

    STOP:
    begin
      // en_quotient=0;
      // en_done=0;
      // en_dividend=0;
      // en_divider=0;
    end

    default:
    begin
      
    end

    endcase

end

endmodule

module Divider
# (parameter W=8)
(input [W-1:0] dividend, input[W-1:0] divider, input clk, input rst,
  output  done,output  [W-1:0]  reminder, output  [W-1:0] quotient
,output en_dividend, output en_divider, output en_quotient
,output [2:0] cur_state,output [2:0] next_state
  );

//dividend reg
wire [W-1:0] dividend_in;
wire [W-1:0] dividend_out;
wire sel_dividend;
//wire en_dividend;
wire rst_dividend;

//divider reg
wire [W-1:0] divider_in;
wire [W-1:0] divider_out;
//wire en_divider;
wire rst_divider;

//done reg
wire done_in, done_out;
wire rst_done, en_done;

//quotient reg
wire [W-1:0] quotient_in;
wire [W-1:0] quotient_out;
wire rst_quotient;
//wire en_quotient;
wire en_counter;
//wire out/input
assign reminder=dividend_out;
//assign done=done_out;
//assign done_in=done;
//assign done=done_in;
assign quotient=quotient_out;

//reg
//Reg #(W) dividend_reg (dividend,en_dividend, rst_dividend,clk, dividend_out);
Reg2 #(W) dividend_reg (dividend,dividend_in,sel_dividend,en_dividend, rst_dividend,clk, dividend_out);
Reg #(W) divider_reg(divider, en_divider, rst_divider,clk,divider_out);
Reg #(W) quotient_reg(quotient_in,en_quotient,rst_quotient,clk,quotient_out);
//Reg #(W) done_reg(done_in,en_done,rst_done,clk,done);
//operator
Comparator #(W) cmp (dividend_out, divider_out, done);
//Subtractor #(W) sub (dividend_out, divider_out, !done,en_counter,dividend_in);
subtractor #(W) sub (dividend_out, divider_out,quotient_out,!done,quotient_in,dividend_in);
//Counter #(W) counter(quotient_out,en_counter,quotient_in);

//FSM
FSM fsm
(done, rst, clk, 
  en_dividend,  rst_dividend , sel_dividend,en_divider, rst_divider,
   en_done,  rst_done, en_quotient, rst_quotient,cur_state,next_state);
endmodule