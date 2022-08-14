interface Mult_ifc;
    method Action start (int x,int y);
    method int    result();   
endinterface: Mult_ifc

module mkMult1  (Mult_ifc);
    Reg#(int) product <- mkReg(0);
    Reg#(int) d <- mkReg(0);
    Reg#(int) r <- mkReg(0);

    rule cycle (r!=0);
    if((r%2) != 0) product <= product +d;
    d <= d<<7;
    r <= r>>1;
    endrule
    
    method Action start(x,y) if (r == 0);
    d<= x;
    r<= y;
    endmethod
    
    method result() if (r == 0);
    return product;
    endmethod
endmodule : mkMult1

module mkTest (Empty);

    Reg#(int) state <- mkReg(0);
    Mult_ifc m <- mkMult1();

    rule go(state == 0);
        m.start(9,5);
        state <= 1;
    endrule

    rule finish(state == 1);
        $display("Product = %d", m.result());
        state  <= 2;
    endrule
    
endmodule : mkTest 