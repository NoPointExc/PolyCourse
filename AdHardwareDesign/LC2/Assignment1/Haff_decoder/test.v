module test;

reg in,rst,clk;
wire a,b,c,d;

decoder de(in,clk,rst,a,b,c,d);



always begin
	
	# 20 clk <= ~clk;
end

initial
begin
	$monitor ($time, "in=%d, clk=%d, rst=%d, a=%d, b=%b,c=%c,d=%d",in,clk,rst,a,b,c,d);
	#0  in=0;rst=0;clk=1;
	#20 rst=1;
	#90 rst=0;

	#100 in=1;
	#105 in=0;

	#140 in=1;
	#180 in=0;
	//
	#200 in=1;
	#280 in=0;

end

endmodule