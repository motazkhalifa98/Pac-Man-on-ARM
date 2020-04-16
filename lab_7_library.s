	.data

	.text
	.global UART0_Handler
	.global Timer0_Handler
	.global lab_7
	.global uart_init
	.global output_character
	.global output_string
	.global output_newline
	.global div_and_mod
	.global timer_init
	.global uart_interrupt_init
	.global convert_to_ASCII_updated
	.global print_update
	.global initial_print


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
