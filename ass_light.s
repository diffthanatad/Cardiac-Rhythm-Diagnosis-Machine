    .data
    .balign 4

Intro:      .asciz "Raspberry Pi wiringPi blink test\n" 
ErrMsg:     .asciz "Setup didn’t work... Aborting...\n"
pin:        .int 7
i:          .int 0
delayMs:    .int 250
OUTPUT  =    1

    .text
    .global main
    .extern printf
    .extern wiringPiSetup
    .extern delay
    .extern digitalWrite
    .extern pinMode

@ init the wiringPi, get it ready for blinking function
main: 
    PUSH    {ip, lr}

    LDR     R0, =Intro
    BL      printf

    BL      wiringPiSetup
    MOV     R1, #-1

    @ if librarySetUp() == Pass
    CMP     R0, R1
    BNE     init

    @ if librarySetUp() == Fail
    LDR     R0, =ErrMsg
    BL      printf
    B       done

@ set up the GPIO pin with the led
init:
    LDR     R0, =pin
    LDR     R0, [R0]
    MOV     R1, #OUTPUT
    BL      pinMode

    @ set for (int i = 0; i < 2; i++) loop
    LDR     R4, =i
    LDR     R4, [R4]
    MOV     R5, #2

@ the led will blink for 3 times
forLoop:
    CMP     R4, R5
    BGT     done

    @ turn on and off led with delay time
    LDR     R0, =pin
    LDR     R0, [R0]
    MOV     R1, #1
    BL      digitalWrite

    LDR     R0, =delayMs
    LDR     R0, [R0]
    BL      delay
    
    LDR     R0, =pin
    LDR     R0, [R0]
    MOV     R1, #0
    BL      digitalWrite

    LDR     R0, =delayMs
    LDR     R0, [R0]
    BL      delay

    ADD     R4, #1
    B       forLoop

@ finish the function and return back to the os
done:
    POP     {ip, pc}