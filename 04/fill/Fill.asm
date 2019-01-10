// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

// Put your code here.

// Setup variables
@SCREEN // Screen Base
D=A
@addr
M=D

@KBD // Print Limit
D=A
@screen_end
M=D

@i // Black Counter
M=0

@j // White Counter
M=0

(LOOP)
    @KBD
    D=M

    @WRITE_BLACK
    D;JGT

    @WRITE_WHITE
    D;JEQ

(WRITE_BLACK)
    @i
    D=M

    @addr
    D=M+D
    @temp_black_address
    M=D

    // Exit when reached screen end
    @screen_end
    D=M-D
    @LOOP
    D;JEQ

    // Print
    @temp_black_address
    A=M
    M=-1

    // Increment for next print
    @i
    M=M+1

    // Rest White Print Counter
    @j
    M=0

    @LOOP
    0;JMP

(WRITE_WHITE)
    @j
    D=M

    @addr
    D=M+D
    @temp_white_address
    M=D

    // Exit when reached screen end
    @screen_end
    D=M-D
    @LOOP
    D;JEQ

    // Print
    @temp_white_address
    A=M
    M=0

    // Increment for next print
    @j
    M=M+1
    
    // Rest Black Print Counter
    @i
    M=0

    @LOOP
    0;JMP