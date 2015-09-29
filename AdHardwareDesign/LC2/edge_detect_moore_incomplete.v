module edge_detect (input in, input clock, input reset,output reg out);

reg [2:0] current_state, next_state;

localparam START=0, AT_1=1, AT_0=2, EDGE_10=3, EDGE_01=4;

always @ (posedge clock, posedge reset) begin
	if (reset)
		current_state <= START;
	else
		current_state <= next_state;
end

always @ (current_state, in) begin
	out=0;
	next_state=current_state;
	case(current_state)
		START: 
			if (in) next_state=AT_1;
			else next_state=AT_0;

		AT_1:  if (~in) next_state=EDGE_10;
		
		AT_0: if (in) next_state=EDGE_01;

		EDGE_10: begin
			out=1;
			if (in) next_state=EDGE_01;
			else next_state=AT_0;
		end

		EDGE_01: begin
			 //YOUR CODE HERE
			 out=1;
			 if(~in) next_state=EDGE_10;
			 else next_state=AT_1;
		end

		default: 
			begin 
			out=1'bx;
			next_state=3'bx;
		end
	endcase
end

endmodule


