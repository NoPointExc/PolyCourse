module myreg 
# (parameter  W=8)
(input [W-1:0] xin, input xload, input xclear, input clk, output reg [W-1:0] xout);


always @ (posedge clk) begin
  if(xclear)
	xout = 0;
  else if (xload)
        xout = xin;
end

endmodule


module adder 
# (parameter W = 8)
(input [W-1:0] in1, input [2*W-1:0] in2, output reg  [2*W-1:0] out);


//the first operand is 0-extended
always @ (*) begin
   out = in1 + in2;
end

endmodule

module increment 
# (parameter W = 8)
(input [W-1:0] in1, output reg [W-1:0] out);


always @ (*) begin
   out = in1 + 1;
end

endmodule

module comparator 
# (parameter W = 8)
(input [W-1:0] ival, input [W-1:0] yval, output reg done);

always @ (*) begin
  done = 0;
  // ival + 1 to correct for the fact that ival is starting from zero
  // yval-1 for "look-ahead"
  if (ival   + 1 >= yval-1)
    done=1;
end

endmodule


module myfsm (input clk, input reset, input done, 
              output reg xload, output reg xclear,
              output reg yload, output reg yclear,
	      output reg iload, output reg iclear,
	      output reg outload, output reg outclear);


reg [2:0] cs, ns;

always @ (posedge clk, posedge reset) begin
  if (reset) 
     cs <= 0;
  else 
     cs <= ns;
end

always @(*) begin
  ns = cs;
  xload = 0; yload = 0;  iload =  0;  outload = 0; 
  xclear = 0; yclear = 0; iclear = 0; outclear = 0;
  case (cs)
     //START  
     2'b00 :  begin
        
     // YOUR CODE HERE

     end
     //WORKING
     2'b01: begin
         
     //YOUR CODE HERE
    
     end

     //STOP
     2'b10 : begin
         
     // YOUR CODE HERE

     end

     default : 

  endcase
end
  

endmodule




module multiplier
# (parameter W = 8)
(input [W-1:0] x, input [W-1:0] y, input clk, input reset, output [2*W-1:0] out);


wire xload, xclear;
wire [W-1:0] xval;

wire yload, yclear;
wire [W-1:0] yval;

wire outload, outclear;
wire [2*W-1:0] outval;

wire [W-1:0] i;
wire iload, iclear;
wire [W-1:0] ival;

wire [2*W-1:0] addout;

wire done;
 
assign out = addout;

myreg #(W) xreg(x, xload, xclear, clk, xval);
myreg #(W) yreg(y, yload, yclear, clk, yval);
//Width should be 2W
myreg #(2*W) outreg(addout, outload, outclear, clk, outval); 
myreg #(W) ireg(i, iload, iclear, clk, ival);

adder #(W) add1 (xval, outval, addout);
increment inc1 (ival, i); 
comparator #(W) comp1 (ival, yval, done);

myfsm fsm1 ( clk, reset, done, xload, xclear, yload, yclear, iload, iclear, outload, outclear   ); 


endmodule
