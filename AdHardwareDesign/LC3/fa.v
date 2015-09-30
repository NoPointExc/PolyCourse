module fulladder (input a, input b, input cin, output sum, output cout);
//simple full adder module
assign {cout, sum} = a + b + cin; 

endmodule
