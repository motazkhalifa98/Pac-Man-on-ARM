	.data

.text
  	; in lab7.s
    .global lab_7
    .global UART0_Handler
    .global TimerPacman_Handler
    .global initial_print
    .global illuminate_RGB_LED
    .global print_update
	; in lab7_library.s
  	.global uart_init
  	.global uart_interrupt_init
  	.global timer_init
  	.global timerA_interrupt_clear
  	.global timerB_interrupt_clear
  	.global RGB_LED_init
  	.global push_button_init
  	.global output_character
  	.global output_string
  	.global output_newline
  	.global div_and_mod
  	.global convert_to_ASCII_updated


	.global TimerGhost_Handler

U0LSR:  .equ 0x18			; UART0 Line Status Register


uart_init:
    STMFD SP!, {r0-r12,lr}

    ;#0x400FE618
    MOV 	r1, #0xE618
    MOVT 	r1, #0x400F
    LDR 	r2, [r1]
    ORR 	r3, r2, #1
    STR 	r3, [r1]
    ;#0x400FE608
    MOV 	r1, #0xE608
    MOVT 	r1, #0x400F
    LDR 	r2, [r1]
    ORR 	r3, r2, #1
    STR 	r3, [r1]
    ;#0x4000C030
    MOV 	r1, #0xC030
    MOVT 	r1, #0x4000
    LDR 	r2, [r1]
    ORR 	r3, r2, #0
    STR 	r3, [r1]
    ;#0x4000C024
    MOV 	r1, #0xC024
    MOVT 	r1, #0x4000
    LDR 	r2, [r1]
    ORR 	r3, r2, #8
    STR 	r3, [r1]
    ;#0x4000C028
    MOV 	r1, #0xC028
    MOVT 	r1, #0x4000
    LDR 	r2, [r1]
    ORR 	r3, r2, #44
    STR 	r3, [r1]
    ;#0x4000CFC8
    MOV 	r1, #0xCFC8
    MOVT 	r1, #0x4000
    LDR 	r2, [r1]
    ORR 	r3, r2, #0
    STR 	r3, [r1]
    ;#0x4000C02C
    MOV 	r1, #0xC02C
    MOVT 	r1, #0x4000
    LDR 	r2, [r1]
    MOV 	r3, #0x60
    ORR 	r4, r2, r3
    STR 	r4, [r1]
    ;#0x4000C030
    MOV 	r1, #0xC030
    MOVT 	r1, #0x4000
    LDR 	r2, [r1]
    MOV 	r3, #0x301
    ORR 	r4, r2, r3
    STR 	r4, [r1]
    ;#0x4000451C
    MOV 	r1, #0x451C
    MOVT 	r1, #0x4000
    LDR 	r2, [r1]
    MOV 	r3, #0x03
    ORR 	r4, r2, r3
    STR 	r4, [r1]
    ;#0x40004420
    MOV 	r1, #0x4420
    MOVT 	r1, #0x4000
    LDR 	r2, [r1]
    MOV 	r3, #0x03
    ORR 	r4, r2, r3
    STR 	r4, [r1]
    ;#0x4000452C
    MOV 	r1, #0x452C
    MOVT 	r1, #0x4000
    LDR 	r2, [r1]
    MOV 	r3, #0x11
    ORR 	r4, r2, r3
    STR 	r4, [r1]

    LDMFD 	SP!, {r0-r12,lr}
    MOV 	pc, lr

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

uart_interrupt_init:
	STMFD SP!,{r0-r12,lr}   ; Store register lr on stack

	; UART NVIC initialization
	MOV r8, #0xE100
	MOVT r8, #0xE000
	LDR r9, [r8]
	ORR r9, r9, #0x20 ; bit 5 in the register
	STR r9, [r8]

	; Initialize UART Interrupt Mask Register
	MOV r8, #0xC038 ; UART Interrupt Mask Register
	MOVT r8, #0x4000 ; UART Interrupt Mask Register
	LDR r9, [r8]
	ORR r9, r9, #0x40 ; writes a 1 to bit 6, RTIM
	STR r9, [r8]

	LDMFD sp!, {r0-r12,lr}
	MOV pc, lr

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

timer_init:
	STMFD SP!,{r0-r12,lr}   ; Store register lr on stack

	; connect clock to timer
	; Connects T0 to clock by writing a 1 to bit 0 for TimerA
  ;                                     to bit 8 for TimerB
	MOV r8, #0xE604
	MOVT r8, #0x400F
	LDR r9, [r8]
	ORR r9, r9, #0x100
	ORR r9, r9, #0x001
	STR r9, [r8]

	; disable timer; setup/configure while timer is disabled
	; disable timer A; write a 0 to TAEN (bit 0)
  ; disable timer B; write a 0 to TBEN (bit 8)
	MOV r8, #0x000C
	MOVT r8, #0x4003
	LDR r9, [r8]
	BIC r9, r9, #0x100
	BIC r9, r9, #0x001
	STR r9, [r8]

	; set up timer for 32-bit mode
	; write a 0 to GPTMCFG (bits 2:0)
	MOV r8, #0x0000
	MOVT r8, #0x4003
	LDR r9, [r8]
	BIC r9, r9, #0x7
	STR r9, [r8]

	; put TimerA into periodic mode
	; write a 2 to GPTMTAMR (bits 1:0)
	MOV r8, #0x0004
	MOVT r8, #0x4003
	LDR r9, [r8]
	ORR r9, r9, #0x2 ; ensure bit 1 = 1
	BIC r9, r9, #0x1 ; ensure bit 0 = 0
	STR r9, [r8]

  ; put TimerB into periodic mode
	; write a 2 to GPTMTAMR (bits 1:0)
	MOV r8, #0x0008
	MOVT r8, #0x4003
	LDR r9, [r8]
	ORR r9, r9, #0x2 ; ensure bit 1 = 1
	BIC r9, r9, #0x1 ; ensure bit 0 = 0
	STR r9, [r8]

	; set up interrupt interval for timerA GPTMTAILR
	; 2 times/second = 16mil/2 = 8mil -> 0x007A 1200
	MOV r8, #0x0028
	MOVT r8, #0x4003
	MOV r9, #0x1200
	MOVT r9, #0x007A
	STR r9, [r8]

  ; set up interrupt interval for timerBB GPTMTBBILR
	; 3 times/second = 16mil/3 ~ 5,333,333 -> 0x0051 6155
	MOV r8, #0x0028
	MOVT r8, #0x4003
	MOV r9, #0x6155
	MOVT r9, #0x0051
	STR r9, [r8]

	; set timer0 to interrupt when top limit of timer is reached GPTMIMR
	; write 1 (enable) to TATOIM (bit 0) for timerA
  ; write 1 (enable) to TBTOIM (bit 8) for timerB
	MOV r8, #0x0018
	MOVT r8, #0x4003
	LDR r9, [r8]
	ORR r9, r9, #0x100
	ORR r9, r9, #0x001
	STR r9, [r8]

	; enable NVIC Interrupt timer0
	; set bit 19 of EN0
	MOV r8, #0xE100
	MOVT r8, #0xE000
	LDR r9, [r8]
	MOV r10, #0x0000
	MOVT r10, #0x0008 ; bit 19
	ORR r9, r9, r10
	STR r9, [r8]

	; enable timer A and B now since configuration is done
	; write 1 to TAEN (bit 0) for timerA
  ; write 1 to TBEN (bit 0) for timerB
	MOV r8, #0x000C
	MOVT r8, #0x4003
	LDR r9, [r8]
	ORR r9, r9, #0x100
	ORR r9, r9, #0x001

	STR r9, [r8]


	LDMFD sp!, {r0-r12,lr}
	MOV pc, lr

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; TimerA clear
timerA_interrupt_clear:
	STMFD SP!,{r0-r12,lr}

	; clear the timer interrupt
	; write 1 to Timer A Timeout Raw Interrupt (TATOCINT) bit (bit 0)
	MOV r8, #0x0024
	MOVT r8, #0x4003
	LDR r9, [r8]
	ORR r9, r9, #0x1
	STR r9, [r8]

	LDMFD sp!, {r0-r12,lr}
	MOV pc, lr
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; TimerB clear
timerB_interrupt_clear:
	STMFD SP!,{r0-r12,lr}

	; clear the timer interrupt GPTMICR
	; write 1 to Timer B Timeout Interrupt (TBTOCINT) bit (bit 8)
	MOV r8, #0x0024
	MOVT r8, #0x4003
	LDR r9, [r8]
	ORR r9, r9, #0x100
	STR r9, [r8]

	LDMFD sp!, {r0-r12,lr}
	MOV pc, lr
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RGB_LED_init:
			STMFD 	SP!, {r0-r12,lr}
			;enable only port F in clock register
			MOV 	r8, #0xE000
			MOVT 	r8, #0x400F
			LDR 	r9, [r8, #0x608]
			ORR 	r9, r9, #0x20
			STR 	r9, [r8, #0x608]
			;move address of Port F to r8
			MOV 	r8, #0x5000
			MOVT 	r8, #0x4002
			;Set direction to output
			;Digital Register, Port F, pins 3 2 1, to 1
			LDR r9, [r8, #0x400]
			ORR r9, r9, #0xE
			STR 	r9, [r8, #0x400]
			;Set type to Digital/Enable
			;Digital Register, Port F, pins 3 2 1, to 1
			LDR 	r9, [r8, #0x51C]
			ORR 	r9, r9, #0xE
			STR 	r9, [r8, #0x51C]

			LDMFD 	SP!, {r0-r12,lr}
			MOV 	pc, lr

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
push_button_init:
	STMFD SP!,{r0-r12,lr}


	; enable Port D in clock Register, write a 1 to bit 3 / 0x8
	MOV r8, #0xE000
	MOVT r8, #0x400F
	LDR r9, [r8]
	ORR r9, r9, #0x8
	STR r9, [r8]

	; base address Port D 0x40007000
	MOV r8, #0x7000
	MOVT r8, #0x4000
	; Direction register - input (0), pins 3,2,1,0 (offset 0x400)
	LDR r9, [r8, #0x400]
	BIC r9, r9, #0xF
	STR r9, [r8, #0x400]

	; Digital register - digital (1), pins 3,2,1,0 (offset 0x51C)
	LDR r9, [r8, #0x51C]
	ORR r9, r9, #0xF
	STR r9, [r8, #0x51C]


	LDMFD sp!, {r0-r12,lr}
	MOV pc, lr
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

output_character: 						;this outputs whatever is in r0
    STMFD 	SP!, {r0-r12,lr}
    MOV  	r3, #0
    MOV  	r6, #0xC000      			;store address of UARTDR
    MOVT 	r6, #0x4000     		    ;second half
CHECKOUTPUT: LDRB 	r1, [r6, #U0LSR] 			;load address from memory with added offset (UARTFR)
    AND  	r2, r1, #0x20   			;AND with 00100000
    CMP  	r2, r3 					;Compare with 0
    BNE  	CHECKOUTPUT             	;If != 0, repeat
    STRB 	r0, [r6]        		 	;store result in memory address r0
    LDMFD 	SP!, {r0-r12,lr}
    MOV 	pc, lr



    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


output_string:
    STMFD 	SP!, {r1-r12,lr}
NEXTLETTER: LDRB 	r5, [r4] 			 ;r5 holds the actual E
    CMP 	r5, #0 				 ;see if the character is null
    BEQ 	RETURNBACK 			 ;if it is null, exit this subfunction
    MOV 	r0, r5 				 ;r0 now holds the character we want to output
    BL 		output_character 	 ;this subroutine outputs r0
    ADD 	r4 ,r4, #1 			 ;increment memory
    B 		NEXTLETTER 			 ;output the next letter
RETURNBACK:	LDMFD 	SP!, {r1-r12,lr}
    MOV 	pc, lr


    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


output_newline:
    STMFD 	SP!, {r0-r12,lr}
    MOV 	r0, #10
    BL 		output_character
    MOV 	r0, #13
    BL 		output_character
    LDMFD 	SP!, {r0-r12,lr}
    MOV 	pc, lr


    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


div_and_mod:
    STMFD SP!, {r2-r12, lr}
    MOV r3, #0      		 ;zero register
    MOV r4, #0      		 ;sign indicator for dividend initialized to positive = 0
    MOV r8, #0      		 ;sign indicator for divisor initialized to positive = 0
    CMP r0, r3      		 ;checking dividend if positive
    BGT POSDIV      		 ;positive dividend, skip to line 13
    SUB r0, r3, r0  		 ;if negative flip sign
    MOV r4, #1      		 ;flip sign indicator to 1
POSDIV: 	CMP r1, r3      		 ;checking if divisor is positive
    BGT POSDIVS     		 ;positive divisor, skip to line 17
    SUB r1, r3, r1  		 ;if negative flip sign
    MOV r8, #1      		 ;flip sign indicator to 1
POSDIVS:	MOV r5, #16     		 ;counter initialized to 16
    MOV r6, #0       		 ;quotient initialized to 0
    LSL r1, r1, #16 		 ;logical shift divisor 16 places
    MOV r7, r0      		 ;initialize remainder to dividend
    B firstloop      		 ;skip the first decremental of counter (jump to line 23)
PosCounter: SUB r5, r5, #1  		 ;counter is positive, loop and decrement
firstloop:	SUB r7, r7, r1   		 ;remainder = remainder - Divisor
    CMP r7, r3      		 ;check sign of remainder
    BGE PRemainder  		 ;if remainder is positive OR = 0, branch to PRemainder
    ADD r7, r7, r1  		 ;remainder is negative, remainder = remainder + divisor
    LSL r6, r6, #1  		 ;left shift quotient
    B NRemainder    		 ;remainder is negative, so jump to NRemainder
PRemainder: LSL r6, r6, #1  		 ;remainder is positive, shift left
    ADD r6, r6, #1  		 ;add 1
NRemainder: LSR r1, r1, #1  		 ;right shift divisor
    CMP r5, r3      		 ;check sign of counter
    BGT PosCounter			 ;positive counter, repeat
    MOV r0, r6      		 ;moving quotient to r0
    MOV r1, r7      		 ;moving remainder to r1
    CMP r4, r8      		 ;checking if dividend and divisor were same sign
    BEQ PQuotient   		 ;if same sign, branch
    SUB r0, r3, r0  		 ;switching quotient back to negative
PQuotient:
    LDMFD SP!, {r2-r12, lr}
    MOV pc, lr

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

convert_to_ASCII_updated: ; this changes counter number from Integer to ASCII
    STMFD SP!, {r0-r12,lr}
    ;converts num stored in r2 to string starting from r4
    MOV r0, r2  				 ;move difference to dividend
    MOV r1, #10 				 ;divisor ,set divisor as 10
    BL div_and_mod
    ADD r1, #48 				 ;add 48 to remainder which is the last number, converting it to ASCII
    STRB r1, [r4, #2]			 ;store it at the end of differencenum
    MOV r1, #10					 ;reset r1 to 10
    ;r0 will be holding the new quotient now
    BL div_and_mod				 ;repeat process
    ADD r1, #48
    STRB r1, [r4, #1]			 ;store it at the middle of differencenum
    MOV r1, #10					 ;reset r1 to 10
    ;r0 will be the new quotient now
    BL div_and_mod
    ADD r1, #48
    STRB r1, [r4]				 ;store it as the first number in differencenum

    LDMFD SP!, {r0-r12,lr}
    MOV pc, lr
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	.end


