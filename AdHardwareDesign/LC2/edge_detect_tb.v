module edge_detect_tb;

reg in_tb, clock_tb, reset_tb;
wire out_tb;

edge_detect ed (in_tb, clock_tb, reset_tb, out_tb);

initial
begin
	$monitor ($time, " in=%b, clock=%b, reset=%b, out=%b", in_tb, clock_tb, reset_tb, out_tb);
	clock_tb <= 1'b0;
	reset_tb <= 1'b0;
	in_tb <= 1'b0;

	#50 reset_tb <= 1'b1;
	#70 reset_tb <= 1'b0;
	#30 in_tb <= 1'b0;
	#50 in_tb <= 1'b1;
	#100 in_tb <= 1'b0;
	#100 in_tb <= 1'b1;
end

always
	#20 clock_tb <= ~clock_tb;
endmodule
