 `define WIDTH  8
import types_pkg::*;
module tb_top;
// Ports (Input / Ouptut)
    logic [`WIDTH-1 : 0] A_tb, B_tb, R_dut;     // In1, In2, Result
    logic [1 : 0]       S_dut;                  // Status Register
    logic               Cin_tb;                 // Input Carry
    op_t                op_tb;                  // Opcode {ADD, SUB, AND, OR}

// Needed Internal Signals
    int unsigned error_count = 0;
    logic [`WIDTH-1 : 0] R_gm;                  // Golden Model Result Register
    logic [1 : 0]        S_gm;                  // Golden Model Status Register

// DUT Instantiation
    alu8 DUT (
        // Inputs
            .A(A_tb),
            .B(B_tb),
            .Cin(Cin_tb),
            .op(op_tb),
        // Ouptuts
            .R(R_dut),
            .S(S_dut)
    );

// TASKs
    // Golden Model
        task GM; /* Role: Computes the values of R_gm & S_gm */
            begin
                // Result & CF
                case (op_tb)
                    ADD: {S_gm[1], R_gm} = A_tb + B_tb + Cin_tb;
                    SUB: {S_gm[1], R_gm} = A_tb - B_tb - Cin_tb;
                    AND: {S_gm[1], R_gm} = A_tb & B_tb;
                    OR : {S_gm[1], R_gm} = A_tb | B_tb;
                    default: {S_gm[1], R_gm} = {(`WIDTH+1){1'b0}}; 
                endcase
                // ZF
                S_gm[0] = ~|R_gm;       // Reduciton Nor for Result register
            end
        endtask

    // Scoreboard
        task SB; /* Role: Compare DUT & GM outputs {R_dut vs. R_gm && S_dut vs. S_gm} */
            begin
                if (R_dut !== R_gm || S_dut !== S_gm) begin
                    error_count++;
                    $error("FAIL: A=%h B=%h Cin=%0b op=%0s | R_dut=%h expected=%h | S_dut=%b expected=%b",
                            A_tb, B_tb, Cin_tb, op_tb.name(), R_dut, R_gm, S_dut, S_gm);
                end else begin
                    $display("PASS: A=%h B=%h Cin=%0b op=%0s | R_dut=%h expected=%h | S_dut=%b expected=%b",
                                A_tb, B_tb, Cin_tb, op_tb.name(), R_dut, R_gm, S_dut, S_gm);
                end
            end
        endtask

    // Driver
        task driver_check(
            logic [`WIDTH-1 : 0]    A,
                                    B,
            logic                   Cin,
            op_t                    op
        );
            begin
                {A_tb, B_tb, Cin_tb, op_tb} = {A, B, Cin, op};
                #1;
                GM();
                SB();
            end
        endtask

// Stimuli
    initial begin
        // Reset
            driver_check(0, 0, 0, ADD);

        // ADD
            driver_check(
                .A($urandom_range(0, 2**(`WIDTH) - 1)), 
                .B($urandom_range(0, 2**(`WIDTH) - 1)),
                .Cin($urandom_range(0, 1)), 
                .op(ADD)
            );
            driver_check(20, 10, 1, ADD);

        // SUB
            driver_check(
                .A($urandom_range(0, 2**(`WIDTH) - 1)), 
                .B($urandom_range(0, 2**(`WIDTH) - 1)),
                .Cin($urandom_range(0, 1)), 
                .op(SUB)
            );
            driver_check(20, 10, 1, SUB);

        // AND
            driver_check(
                .A($urandom_range(0, 2**(`WIDTH) - 1)), 
                .B($urandom_range(0, 2**(`WIDTH) - 1)),
                .Cin($urandom_range(0, 1)), 
                .op(AND)
            );
            driver_check(20, 10, 1, AND);

        // OR
            driver_check(
                .A($urandom_range(0, 2**(`WIDTH) - 1)), 
                .B($urandom_range(0, 2**(`WIDTH) - 1)),
                .Cin($urandom_range(0, 1)), 
                .op(OR)
            );
            driver_check(20, 10, 1, OR);

        // END Simulation
            if (error_count != 0)
                $fatal(1, "TEST FAILed: error count = %0d", error_count);
            else
                $display("TEST PASSed:  error count = %0d", error_count);
            $finish;
    end

endmodule