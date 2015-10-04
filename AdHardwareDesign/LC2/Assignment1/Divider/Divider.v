// one input one output register
module Reg 
# (parameter  W=8)
(input [W-1:0] in, input load, input rst, input clk, output reg [W-1:0] out);

always @ (posedge clk) begin
  if(rst)
  out = 0;
  else if (load)
        out = in;
end

endmodule 

//two inout and one output register, mode =1 in, mode =0, initial value
module Reg21
# (parameter  W=8)
(input [W-1:0] in, input [W-1:0] initVal,input mode, input rst,input clk, output reg [W-1:0] out);

always @ (posedge clk) begin
  if(rst)
  out = 0;
  else if (mode) out = in; //
  else out=initVal; //initial value

end

endmodule

//return dividend-dividor
module Subtractor
# (parameter W=8)
(input [W-1:0] dividend, input[W-1:0] divider, output reg [W-1:0] out);
  always @(*) begin
    out=dividend-divider;
  end
endmodule

//comparator, if a<b , output done.
module Comparator 
# (parameter W = 8)
(input [W-1:0] a, input [W-1:0] b, output reg out);

always @ (*) begin
  out = 0;
  if ((a-b)<b) out=1;
end

endmodule

//counter, 
module Counter
# (parameter W=8)
(input  [W-1:0] in, output reg[W-1:0] out);
  always @(*) begin
    out=in+1;
  end
endmodule

/**************
FSM
*****************/
module FSM
(input done, input clk, input rst, output reg divider_load, output reg divider_rst, output reg dividend_mod, output reg dividend_rst,
output reg done_load, output reg done_rst, output reg quotient_rst, output reg quotient_load);

reg [2:0] cur_state, next_state;
localparam START=0,BUSY=1,STOP=2;

always @(posedge clk or posedge rst) begin
  if (rst) begin
    cur_state<=START;
    end
  else 
    cur_state=next_state;
end


always @(*) begin

    next_state = cur_state;
    divider_load=0; divider_rst=0;
    dividend_rst=0;dividend_mod=0; //init
    done_rst=0; done_load=0;
    quotient_rst=0; quotient_load=0;
  case (cur_state)
     
     START:  begin
     //reset
     divider_rst=1;
     //dividend_rst=1;
     quotient_rst=1;
     done_rst=1;
     if(done) next_state=STOP;
     else begin
      next_state=BUSY; 
     end 
      
     end
 
     BUSY: begin
     //load
     dividend_mod=1;
     divider_load=1;
     done_load=1;
     quotient_load=1;
     if(done) begin
     next_state=STOP; 

     end
     
     else next_state=BUSY;
     end

     STOP : begin
     dividend_mod=0;
     end
     


     default :
     begin
      
     end

  endcase
end

endmodule

/************************
Divider
************************/
module Divider
# (parameter W=8)
(input [W-1:0] dividend, input [W-1:0] divider, input rst, input clk, output [W-1:0] quotient, output [W-1:0] reminder, output  done);
//part 1
wire [W-1:0] divider_out, dividend_in, dividend_out;
wire done_in;
wire divider_load, divider_rst, dividend_rst, dividend_mod, done_rst, done_load, quotient_rst, quotient_load;
//part 2
wire [W-1:0] quotient_out, quotient_in;

assign reminder=dividend_out;
assign quotient=quotient_out;

//Reg #(W) (in, load, rst, clk, out);

Reg #(W) divider_reg (divider, divider_load, divider_rst, clk,divider_out);
Reg #(W) done_reg (done_in,done_load,done_rst,clk ,done);
//Reg #(W) quotient_reg (quotient_in, quotient_load, quotient_rst, clk, quotient_out);
Reg #(W) quotient_reg (quotient_in, (!done_in) & quotient_load, quotient_rst, clk, quotient_out);

Reg21 #(W) dividend_reg  (dividend_in,dividend, dividend_mod,dividend_rst,clk,dividend_out);
Subtractor # (W) substractor(dividend_out,divider_out, dividend_in);
Comparator # (W) comparator(dividend_out,divider_out,done_in);
Counter # (W) counter(quotient_out,quotient_in);

FSM fsm(done,clk, rst,divider_load,divider_rst,dividend_mod, dividend_rst,
 done_load, done_rst, quotient_rst, quotient_load);
endmodule