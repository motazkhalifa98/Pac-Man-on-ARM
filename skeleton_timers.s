
TimerPacman_Handler:
    STMFD sp!,{r0-r12,lr}

    BL timerA_interrupt_clear


    LDMFD sp!,{r0-r12,lr}
    BX lr


TimerGhost_Handler:
    STMFD sp!,{r0-r12,lr}

    BL timerB_interrupt_clear


    LDMFD sp!,{r0-r12,lr}
    BX lr
