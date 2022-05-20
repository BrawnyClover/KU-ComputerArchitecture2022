            AREA      text,CODE
                                                
            EXPORT    mod
            EXPORT	  divide_loop
            
mod ; r11 = r4 / r5, r12 = r4 % r5
    stmfd 	sp!, {r4, lr}
    
    mov r11, #0
    mov r12, #0
    bl divide_loop
    mov r8, r12
    swi	0x123456
    ldmfd	sp!, {r4, pc}

divide_loop
    cmp r4, r5 ; i, j
    BLT stop_divide

    add r11, r11, #1 ; d++
    sub r4, r4, r5 ; i = i - j
    mov r12, r4
    
    b divide_loop ; i>j:continue
    

stop_divide
    mov r12, r4
    bx lr

    END