interface Fact_ifc;
    method Action start( int in );
    method int result();
endinterface: Fact_ifc

module mkFact (Fact_ifc);
    Reg#(int) in_value <-mkReg(0);
    Reg#(int) out_value <-mkReg(1);
    rule cycle (in_value > 0);
        out_value <= in_value * out_value;
        in_value <= in_value - 1;
    endrule

    method Action start(in) if (in_value == 0);
    in_value <= in;
    endmethod
    
    method result() if (in_value == 0);
    return out_value;
    endmethod

endmodule : mkFact

module mkTest (Empty);

    Reg#(int) state <- mkReg(0);
    Fact_ifc m <- mkFact();

    rule go(state == 0);
        m.start(9);
        state <= 1;
    endrule

    rule finish(state == 1);
        $display("Factorial = %d", m.result());
        state  <= 2;
    endrule
    
endmodule : mkTest 