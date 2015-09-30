module counter (input clk, input reset, 
                input [31:0] step, output reg [31:0] count);


always @ (posedge clk, posedge reset) begin

	if (reset)
		count <= 0;
	else
		count <= count + step;
end

endmodule


