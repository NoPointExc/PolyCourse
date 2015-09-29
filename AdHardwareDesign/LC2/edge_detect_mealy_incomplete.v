module edge_detect (input in, input clock, input reset, output reg out);

reg [1:0] current_state, next_state;

localparam START=0, AT_1=1, AT_0=2;

always @ (posedge clock, posedge reset)
begin
	if (reset)
		current_state <= START;
	else
		current_state <= next_state;
	end

always @ (current_state, in) begin
	out=0;
	next_state=current_state;
	case (current_state)
		START: begin
			if (in) next_state=AT_1;
			else next_state=AT_0;
		end
		AT_1: begin
			if (~in) begin
				out=1;
				next_state=AT_0;
			end
		end
		AT_0: begin
			//YOUR CODE HERE
			if(in) begin:
				out=1;
				next_state=AT_1;
			end
				
			end

		end

		default: 
			begin 
			out=1'bx;
			next_state=2'bx;
		end
	endcase
end
endmodule
