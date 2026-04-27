`timescale 1ns/1ps

module alu_tb;

    reg  [3:0] a, b;
    reg  [2:0] op;
    wire [3:0] result;
    wire       zero;

    // instantiate the ALU
    alu uut (
        .a(a), .b(b), .op(op),
        .result(result), .zero(zero)
    );

    // dump waveforms
    initial begin
        $dumpfile("sim/alu_tb.vcd");
        $dumpvars(0, alu_tb);
    end

    // self-checking task
    task check;
        input [3:0] exp;
        input [31:0] test_num;
        begin
            #10;
            if (result === exp)
                $display("PASS test %0d | a=%b b=%b op=%b | result=%b", test_num, a, b, op, result);
            else
                $display("FAIL test %0d | a=%b b=%b op=%b | expected=%b got=%b", test_num, a, b, op, exp, result);
        end
    endtask

    initial begin
        // ADD
        a=4'b0011; b=4'b0001; op=3'b000; check(4'b0100, 1);
        // SUB
        a=4'b0101; b=4'b0011; op=3'b001; check(4'b0010, 2);
        // AND
        a=4'b1100; b=4'b1010; op=3'b010; check(4'b1000, 3);
        // OR
        a=4'b1100; b=4'b1010; op=3'b011; check(4'b1110, 4);
        // XOR
        a=4'b1100; b=4'b1010; op=3'b100; check(4'b0110, 5);
        // NOT
        a=4'b1010; b=4'b0000; op=3'b101; check(4'b0101, 6);
        // SHL
        a=4'b0001; b=4'b0000; op=3'b110; check(4'b0010, 7);
        // SHR
        a=4'b1000; b=4'b0000; op=3'b111; check(4'b0100, 8);
        // zero flag test
        a=4'b0000; b=4'b0000; op=3'b000;
        #10;
        if (zero === 1'b1) $display("PASS zero flag test");
        else               $display("FAIL zero flag test");

        $finish;
    end

endmodule
