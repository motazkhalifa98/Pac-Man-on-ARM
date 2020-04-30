
reset_game_speed:
		STMFD SP!,{r0-r12,lr}

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


		; enable timer0 now since configuration is done
		; write 1 to TAEN (bit 0) for timer0A
		MOV r8, #0x000C
		MOVT r8, #0x4003
		LDR r9, [r8]
		ORR r9, r9, #0x1
		STR r9, [r8]

		; enable timer 1 now since configuration is done
		; write 1 to TAEN (bit 0) for timer1A
		MOV r8, #0x100C
		MOVT r8, #0x4003
		LDR r9, [r8]
		ORR r9, r9, #0x1
		STR r9, [r8]



		LDMFD sp!, {r0-r12,lr}
		MOV pc, lr
