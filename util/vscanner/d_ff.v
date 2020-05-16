module D_FF (CLK, D, Q); // Example flip-flop
input CLK;
input D;
output Q;
reg Q;
     always @(posedge CLK) //--> gives rising edge FF
       Q = D;               
endmodule 
