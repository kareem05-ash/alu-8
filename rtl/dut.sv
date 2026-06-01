 `define WIDTH  8
import types_pkg::*;
module alu8 (
    input logic [`WIDTH-1 : 0]  A,
    input logic [`WIDTH-1 : 0]  B,
    input op_t                  op,
    input logic                 Cin,
    output logic [`WIDTH-1 : 0] R,
    output logic [1:0]          S       // Status Register {S[1]: CF, S[0]: ZF}
);
    logic CF, ZF;                       // Needed for status register

    assign ZF = ~|R;
    assign S = {CF, ZF};
    always_comb begin
        case (op)
            ADD :   {CF, R} = A + B + Cin;          // ADD
            SUB :   {CF, R} = A - B - Cin;          // SUB
            AND :   {CF, R} = {1'b0, A & B};        // AND
            OR  :   {CF, R} = {1'b0, A | B};        // OR
            default:{CF, R} = {(1+`WIDTH){1'b0}};   // Default Case
        endcase 
    end
endmodule