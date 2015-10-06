module decoder(input in, input clk, input rst, output reg out_a, output reg out_b, output reg out_c, output reg out_d);


reg [1:0] current_state; 
reg [1:0] next_state;

localparam START=0,S1=1,S2=2;

//reset
always @(posedge clk ,posedge rst) 
begin
	if (rst) 
		next_state <= START;		
	else 
		current_state<= next_state;		
end

//states trans
always @(current_state,in) begin
	out_a=0;out_b=0;out_c=0;out_d=0;
	//default, no trans
	next_state=current_state;
	case (current_state)
		START:
			begin
				if(in==0) out_a=1;
				else next_state=S1;
			end
		S1:
			begin
				if(in==0) begin
					out_b=1;
					next_state=START;
				end
				else next_state=S2;
			end
		S2:
			begin
				next_state=START;
				if(in==0) out_c=1;
				else out_d=1;
				
			end
		default:
			next_state=START;
	endcase
end


endmodule
