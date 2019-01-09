// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)

// Put your code here.

// TODO: Fail early on 0 arg values for optimization

// Setup variables
@counter
M=0

@sum
M=0

// Initialize Product as 0
@R2
M=0

(LOOP)
    // Counter has reached RAM[0]
    @R0
    D=M
    @counter
    D=D-M
    @END
    D;JEQ

    // Computation - Add R1 value to sum
    @R1
    D=M
    @sum
    D=D+M
    M=D

    // Set Result to RAM[2]
    @R2
    M=D

    // Increment Counter
    @counter
    M=M+1
    @LOOP
    0;JMP

(END)
    @END
    0; JMP