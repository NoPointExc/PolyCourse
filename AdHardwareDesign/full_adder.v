module full_adder (input a, input b, input cin, output sum, output cout);

wire w1, w2, w3, w4, w5;

and a1 (w1, a, b), a2 (w2, b, cin), a3 (w3, a, cin);

or o1 (w4, w1, w2), o2 (cout, w4, w3);

xor x1 (w5, a, b), x2 (sum, cin, w5);



endmodule