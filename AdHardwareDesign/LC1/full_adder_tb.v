module test_bench;

reg a_tb, b_tb, cin_tb;

wire sum_tb, cout_tb;

full_adder fa(a_tb, b_tb, cin_tb, sum_tb, cout_tb);

initial
begin
$monitor ($time, " A=%b, B=%b, Cin=%b, Sum=%b, Cout=%b", a_tb, b_tb, cin_tb, sum_tb, cout_tb);

a_tb=0; b_tb=0; cin_tb=1; 
#1 a_tb=1;  
#2 cin_tb=0;
end

endmodule
	