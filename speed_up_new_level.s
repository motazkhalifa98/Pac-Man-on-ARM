
speed_up_new_level:
  STMFD SP!,{r0-r12,lr}

  ; Step 1a: disable timer A; write a 0 to TAEN (bit 0)
  MOV r0, #0x000C
	MOVT r0, #0x4003
	LDR r9, [r0]
	BIC r9, r9, #0x1
	STR r9, [r0]

  ; Step 2a: Read value in current interval register
  MOV r0, #0x0028
	MOVT r0, #0x4003
  LDR r9, [r0] ; r9 holds the value of the interval register; initially, it is
    ; 8 million, or 2 times per second

  ; Step 3a: Perform algorithm
  MOV r5, #5
  ; Algorithm step 1 of 2 : divide by 5, store result in different register r10
  UDIV r10, r9, r5
  ; Algorithm step 2 of 2 : original value - result from last step
  SUB r10, r9, r10
  ; r10 now has the faster speed

  ; Step 4a: Store result back to interval register
  STR r10, [r0]

  ; Step 5a: Enable Timer A; write 1 to TAEN (bit 0) for timerA
  MOV r0, #0x000C
  MOVT r0, #0x4003
  LDR r9, [r0]
  ORR r9, r9, #0x1
  STR r9, [r0]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; Step 1b: disable timer B; write a 0 to TBEN (bit 8)
  MOV r0, #0x000C
  MOVT r0, #0x4003
  LDR r9, [r0]
  BIC r9, r9, #0x100
  STR r9, [r0]

  ; Step 2b: Read value in current interval register
  MOV r0, #0x0028
	MOVT r0, #0x4003
  LDR r9, [r0] ; r9 holds the value of the interval register; initially, it is
    ; 8 million, or 2 times per second

  ; Step 3b: Perform algorithm
  MOV r5, #5
  ; Algorithm step 1 of 2 : divide by 5, store result in different register r10
  UDIV r10, r9, r5
  ; Algorithm step 2 of 2 : original value - result from last step
  SUB r10, r9, r10
  ; r10 now has the faster speed

  ; Step 4b: Store result back to interval register
  STR r10, [r0]

  ; Step 5bb: Enable Timer B; write 1 to TBEN (bit 8) for timerB
  MOV r0, #0x000C
  MOVT r0, #0x4003
  LDR r9, [r0]
  ORR r9, r9, #0x100
  STR r9, [r0]

  LDMFD sp!, {r0-r12,lr}
	MOV pc, lr
