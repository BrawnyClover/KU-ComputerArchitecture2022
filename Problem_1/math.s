            AREA      text,CODE
                                                
            EXPORT    mod
            EXPORT	  divide_loop
            
mod 
    ; r11 = r4 / r5
    ; r12 = r4 % r5
    stmfd 	sp!, {r4, lr}   ; 복귀 지점, r4 레지스터를 stack에 저장
    
    mov r11, #0             ; 몫이 저장될 레지스터 초기화
    mov r12, #0             ; 나머지가 저장될 레지스터 초기화
    bl divide_loop          ; 나머지 연산 진입 지점

    swi	0x123456
    ldmfd	sp!, {r4, pc}

divide_loop
    cmp r4, r5              ; i == j ?
    BLT stop_divide         ; i < j 면 나눗셈 종료

    add r11, r11, #1        ; 몫 +1
    sub r4, r4, r5          ; i = i - j
    
    b divide_loop           ; loop continue
    

stop_divide
    mov r12, r4             ; r12에 나머지 저장
    bx lr

    END