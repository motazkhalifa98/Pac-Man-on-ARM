

	.data
aprompt: .string "A",0
bprompt: .string "B",0

	.text

	.global mult_test
	.global timer_init
	.global timerA_interrupt_clear
	.global timerB_interrupt_clear
	.global timerAhandler
	.global timerBhandler
	.global output_characterA
	.global output_characterC
	.global output_string
ptr_to_aprompt: .word aprompt
ptr_to_bprompt: .word bprompt

U0LSR:  .equ 0x18			; UART0 Line Status Register

mult_test:
	STMFD SP!,{r0-r12,lr}

	BL uart_init
	BL timer_init


	BL output_characterA
	BL output_characterA
	BL output_characterA

handstart:
	B handend

handend:


	B handstart

	LDMFD sp!, {r0-r12,lr}
	MOV pc, lr



timerBhandler:
		STMFD SP!,{r0-r12,lr}

		BL timerB_interrupt_clear
		BL output_characterA


		LDMFD sp!, {r0-r12,lr}
		BX lr
timerAhandler:
		STMFD SP!,{r0-r12,lr}

		BL timerA_interrupt_clear
		BL output_characterC

		LDMFD sp!, {r0-r12,lr}
		BX lr

timer_init:
		STMFD SP!,{r0-r12,lr}   ; Store register lr on stack

		; connect clock to timer
		; Connects T0 and T1 to clock by writing a 1 to bit 0 and 1
		MOV r8, #0xE604
		MOVT r8, #0x400F
		LDR r9, [r8]
		ORR r9, r9, #0x3
		STR r9, [r8]

		MOV r10, #0xFFFF
delay: SUB r10, r10, #1
		CMP r10, #0
		BNE delay


		; disable timer; setup/configure while timer is disabled
		; disable timer 0; write a 0 to TAEN (bit 0)
		MOV r8, #0x000C
		MOVT r8, #0x4003
		LDR r9, [r8]
		BIC r9, r9, #0x1
		STR r9, [r8]

		; disable timer; setup/configure while timer is disabled
		; disable timer 1; write a 0 to TAEN (bit 0)
		MOV r8, #0x100C
		MOVT r8, #0x4003
		LDR r9, [r8]
		BIC r9, r9, #0x1
		STR r9, [r8]

		; set up timer 0 for 32-bit mode
		; write a 0 to (bits 2:0)
		MOV r8, #0x0000
		MOVT r8, #0x4003
		LDR r9, [r8]
		; write a 0x4
		;BIC r9, r9, #0x3
		;ORR r9, r9, #0x4
		BIC r9, r9, #0x7
		STR r9, [r8]

		; set up timer 1 for 32-bit mode
		; write a 0 to (bits 2:0)
		MOV r8, #0x1000
		MOVT r8, #0x4003
		LDR r9, [r8]
		; write a 0x4
		;BIC r9, r9, #0x3
		;ORR r9, r9, #0x4
		BIC r9, r9, #0x7
		STR r9, [r8]


		; put Timer0 into periodic mode
		; write a 2 to GPTM Timer A Mode GPTMTAMR (bits 1:0)
		MOV r8, #0x0004
		MOVT r8, #0x4003
		LDR r9, [r8]
		ORR r9, r9, #0x2 ; ensure bit 1 = 1
		;BIC r9, r9, #0x1 ; ensure bit 0 = 0
		STR r9, [r8]

	  ; put Timer1 into periodic mode
		; write a 2 to GPTM Timer A Mode GPTMTAMR (bits 1:0)
		MOV r8, #0x1004
		MOVT r8, #0x4003
		LDR r9, [r8]
		ORR r9, r9, #0x2 ; ensure bit 1 = 1
		;BIC r9, r9, #0x1 ; ensure bit 0 = 0
		STR r9, [r8]

		; set up interrupt interval for timer0 GPTMTAILR
		; 2 times/second = 16mil/2 = 8mil -> 0x007A 1200
		MOV r8, #0x0028
		MOVT r8, #0x4003
		LDR r10, [r8]
		MOV r9, #0x1200
		MOVT r9, #0x007A
		AND r10, r10, r9
		STR r10, [r8]

	  ; set up interrupt interval for timer1 GPTMTAILR
		; 3 times/second = 16mil/3 ~ 5,333,333 -> 0x0051 6155
		MOV r8, #0x1028
		MOVT r8, #0x4003
		LDR r10, [r8]
		MOV r9, #0x6155
		MOVT r9, #0x0051
		AND r10, r10, r9
		STR r10, [r8]

		; set timer0 to interrupt when top limit of timer is reached GPTMIMR
		; write 1 (enable) to TATOIM (bit 0) for timerA
		MOV r8, #0x0018
		MOVT r8, #0x4003
		LDR r9, [r8]
		ORR r9, r9, #0x1
		STR r9, [r8]

		; set timer1 to interrupt when top limit of timer is reached GPTMIMR
		; write 1 (enable) to TATOIM (bit 0) for timerA
		MOV r8, #0x1018
		MOVT r8, #0x4003
		LDR r9, [r8]
		ORR r9, r9, #0x1
		STR r9, [r8]


		; enable NVIC Interrupt timer0
		; set bit 19 of EN0
		; set bit 21 of EN1
		MOV r8, #0xE100
		MOVT r8, #0xE000
		LDR r9, [r8]
		MOV r10, #0x0000
		MOVT r10, #0x0028 ; bit 19
		ORR r9, r9, r10
		STR r9, [r8]

		; enable timer0 now since configuration is done
		; write 1 to TAEN (bit 0) for timerA
		MOV r8, #0x000C
		MOVT r8, #0x4003
		LDR r9, [r8]
		ORR r9, r9, #0x1
		STR r9, [r8]

		; enable timer 1 now since configuration is done
		; write 1 to TAEN (bit 0) for timerA
		MOV r8, #0x100C
		MOVT r8, #0x4003
		LDR r9, [r8]
		ORR r9, r9, #0x1
		STR r9, [r8]


		LDMFD sp!, {r0-r12,lr}
		MOV pc, lr



; TimerB clear
timerB_interrupt_clear:
	STMFD SP!,{r0-r12,lr}

	; clear the timer interrupt GPTMICR
	; write 1 to Timer B Timeout Interrupt (TBTOCINT) bit (bit 8)
	MOV r8, #0x1024
	MOVT r8, #0x4003
	LDR r9, [r8]
	ORR r9, r9, #0x1
	STR r9, [r8]

	LDMFD sp!, {r0-r12,lr}
	MOV pc, lr
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

output_characterA: 						;this outputs whatever is in r0
			STMFD 	SP!, {r0-r12,lr}
			MOV  	r3, #0
			MOV  	r6, #0xC000      			;store address of UARTDR
			MOVT 	r6, #0x4000     		    ;second half
CHECKOUTPUT: LDRB 	r1, [r6, #0x18] 			;load address from memory with added offset (UARTFR)
			AND  	r2, r1, #0x20   			;AND with 00100000
			CMP  	r2, r3 					;Compare with 0
			BNE  	CHECKOUTPUT             	;If != 0, repeat
			MOV 	r0, #65
			STRB 	r0, [r6]        		 	;store result in memory address r0
			LDMFD 	SP!, {r0-r12,lr}
			MOV 	pc, lr
output_characterC: 						;this outputs whatever is in r0
			STMFD 	SP!, {r0-r12,lr}
			MOV  	r3, #0
			MOV  	r6, #0xC000      			;store address of UARTDR
			MOVT 	r6, #0x4000     		    ;second half
CHECKOUTPUT2: LDRB 	r1, [r6, #0x18] 			;load address from memory with added offset (UARTFR)
			AND  	r2, r1, #0x20   			;AND with 00100000
			CMP  	r2, r3 					;Compare with 0
			BNE  	CHECKOUTPUT2           	;If != 0, repeat
			MOV 	r0, #67
			STRB 	r0, [r6]        		 	;store result in memory address r0
			LDMFD 	SP!, {r0-r12,lr}
			MOV 	pc, lr

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
	.end
