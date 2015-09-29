//myreg
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



// initreg, register only for initial 
module initreg
# (parameter W=8)
(input [W-1:0] xin,input [W-1:0] xit,input xload,input xinit, input xclear, input clk, output reg [W-1:0] xout);

always @ (posedge clk) begin
  if(xclear)
  xout = 0;
  else if (xload)
        xout = xin;
  else if(xinit)
        xout= xinit;
end

endmodule




//subtract
module subtract
# (parameter W=8)
(input [W-1:0] in1, input[W-1:0] in2, output reg [W-1:0] out);
	always @(*) begin
		out=in1-in2;
	end
endmodule


//counter
module counter
# (parameter W=8)
(input  [W-1:0] in1, output reg[W-1:0] out);
	always @(*) begin
		out=in1+1;
	end
endmodule


//comparator
module comparator 
# (parameter W = 8)
(input [W-1:0] dor, input [W-1:0] rem, output reg done);

always @ (*) begin
  done = 0;
  //if rem < dnd, done. 
  if (rem<dor)
    done=1;
end

endmodule


//Finiate State Machine
module myfsm (input clk, input rst, input done, 
              output reg xload, output reg lrst,
              output reg lload, output reg linit, 
              output reg irst, output reg iload);


reg [2:0] cur_state, next_state;

localparam START=0,BUSY=1,STOP=2;
always @ (posedge clk, posedge rst) begin
  if (rst) 
     cur_state <= START;
  else 
     cur_state <= next_state;
end
 

always @(*) begin
  next_state = cur_state;
  xload=0;  lrst=0; lload=0; linit=0; irst=0; iload=0;
  case (cur_state)
 
     START:  begin
     	
      lrst=1;irst=1;
      //allow to load x reg, ireg, and initial lreg
      xload=1; linit=1; iload=1; 
        if(!done) next_state=BUSY;
     end
 
     BUSY: begin
         //xload=0; yload=1;outload=1; iload=1;
         xload=0; lload=1; iload=1;
         if(done) next_state=STOP;
     end

     STOP : begin
         //xload=0;yload=0;outload=0;iload=0;

     end
     default :
     begin
     	
     end


  endcase
end
endmodule



//divider, connect modules.
module divider

# (parameter W=8)
(input [W-1:0] dor, input[W-1:0] dnd, input clk, input rst, output done, output [W-1:0] quotient, output [W-1:0] remainder);
//*******subtract
//xreg
wire [W-1:0] xout;
wire xload;
//subtract
wire [W-1:0] result;
//lreg
wire [W-1:0] lout;
wire lrst,lload, linit;
//comparator
wire cmp_out;

//*******counter
//counter
wire [W-1:0] i;
//ireg
wire irst,iload;
wire [W-1:0] iout;


assign done = cmp_out ;
assign quotient = iout;
assign remainder=lout;
//*******subtract
//xreg
myreg #(W) xreg(dor, xload, cmp_out,clk, xout);
//subtract
subtract #(W) mysub (xout,lout, result);
//outReg
initreg #(W) lreg(result, dnd,lload,linit,lrst,clk,lout);
//cmp
comparator #(W) cmp(xout, lout, cmp_out);

//*******counter
//counter
counter #(W) ct(iout, i);
//ireg
myreg #(W) ireg(i,iload,irst,clk,iout);

myfsm fsm   ( clk,rst, cmp_out, 
               xload,  lrst,
               lload,  linit, 
              irst, iload);


endmodule