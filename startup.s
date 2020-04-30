state_info: .string 27,"[31;1mLevel: ",0
state_score: .string 27,"[34;1mScore: ",0
instructions: .string 27,"[37;0m Pac-Man",13,10,27,"[37;0mControl Pac-Man using the w,a,s, and d keys to move up, left, down, and right",13,10
	.string "[37;0mrespectively. Collect all four power pellets in each corner to reach the next level. ",13,10
	.string "[37;0mPress p to pause the game. Press w to start.",0


; UART0 Initialization
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


; UART0 Interrupt Initialization
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

; Timer Initialization A and B
timer_init:
	STMFD SP!,{r0-r12,lr}   ; Store register lr on stack

	; connect clock to timer
	; Connects T0 to clock by writing a 1 to bit 0
	MOV r8, #0xE604
	MOVT r8, #0x400F
	LDR r9, [r8]
	ORR r9, r9, #0x1
	STR r9, [r8]

	; disable timer; setup/configure while timer is disabled
	; disable timer A; write a 0 to TAEN (bit 0)
  ; disable timer B; write a 0 to TBEN (bit 8)
	MOV r8, #0x000C
	MOVT r8, #0x4003
	LDR r9, [r8]
	MOV r10, #0x101
	BIC r9, r9, r10
	STR r9, [r8]

	; set up timer for 32-bit mode
	; write a 0 to GPTMCFG (bits 2:0)
	MOV r8, #0x0000
	MOVT r8, #0x4003
	LDR r9, [r8]
	BIC r9, r9, #0x7
	STR r9, [r8]

	; put TimerA into periodic mode
	; write a 2 to GPTM Timer A Mode GPTMTAMR (bits 1:0)
	MOV r8, #0x0004
	MOVT r8, #0x4003
	LDR r9, [r8]
	ORR r9, r9, #0x2 ; ensure bit 1 = 1
	BIC r9, r9, #0x1 ; ensure bit 0 = 0
	STR r9, [r8]

  ; put TimerB into periodic mode
	; write a 2 to GPTM Timer B Mode GPTMTBMR (bits 1:0)
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
	MOV r10, #0x101
	ORR r9, r9, r10
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
	MOV r10, #0x101
	ORR r9, r9, r10
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

; Intiate RGB LEDs
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



; for the RGB LEDs, let's have a counter that keeps track of the lives and power pellet
; the purpose of this subroutine is to light up the RGB accordingly to current status
; 4 - power pellet: blue
; 3 - 3 lives: green
; 2 - 2 lives: yellow
; 1 - 1 life: red
illuminate_RGB_LED:
  STMFD 	SP!, {r0-r12,lr}

  ; GPIO Port F's data register: 0x400253FC
  MOV r8, #0x53FC
  MOVT r8, #0x4002

  LDR r9, [r8]

  LDR r4 ptr_to_led_status
  CMP r4, 4; check if status is power pellet
  BEQ powerpellet

  CMP r4, 3; check if status is 3 lives
  BEQ threelives

  CMP r4, 2; check if status is 2 lives
  BEQ twolives

  CMP r4, 1; check if status is 1 life
  BEQ onelife

  ; GPIO colors
  ; pins 3, 2, 1
  ; green, blue, red

  powerpellet: ; turn to blue
    ORR r9, r9, #0x4 ; turns blue on
    BIC r9, r9, #0xA ; turns green and red off
  B continue

  threelives: ; turn to green
    ORR r9, r9, #0x8 ; turns green on
    BIC r9, r9, #0x6 ; turns blue and red off
  B continue

  twolives: ; turn to yellow
    ORR r9, r9, #0xA ; turns red and green on
    BIC r9, r9, #0x4 ; turns blue off
  B continue

  onelife: ; turn to red
    ORR r9, r9, #0x2 ; turns red on
    BIC r9, r9, #0xC ; turns blue and green off
  B continue

  continue:

    STR r9, [r8]

  LDMFD sp!, {r0-r12,lr}
  MOV pc, lr

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
