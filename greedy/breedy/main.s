; Hello world in ARM assembler

            AREA text, CODE
            ; This section is called "text", and contains code

            ENTRY
            
			IMPORT  print
			IMPORT  scan
			IMPORT  print_char
                        IMPORT  mod

                        EXPORT array


start
        mov r9, #0xa ; *10을 해주기 위해 필요함
        b get_input

get_input
        bl scan
        bl print_char
        cmp r0, #0x00000020 ; 스페이스가 입력되면
        beq input_cnt ; 입력 개수 추가
        bne numberlize

numberlize
        sub r3, r0, #'0' ; char -> int
        mul r6, r5, r9 ; r6 = r5 * 10
        add r5, r6, r3 ; r5 = r6 + r3
        b get_input

input_cnt
        adr r10, array
        strh r5, [r10, r2] ; save input value to memory
        add r2, r2, #2 ; add 2 byte to weight
        cmp r2, #4
        beq greedy_calc
        mov r5, #0
        b get_input

greedy_calc
        ldrh r2, [r10] ; start number
        ldrh r3, [r10, #0x02] ; dest number
        ; r4 : 나누어질 수
        ; r5 : 나눌 수
        mov r6, #0 ; cnt = 1;

        bl greedy_calc_loop

greedy_calc_loop

        add r6, r6, #1 ; cnt = cnt + 1

        cmp r2, r3
        beq finish
        BGT finish_fail
        
        mov r4, r3
        mov r5, #10
        bl mod

        cmp r12, #1
        beq remove_one

        mov r5, #2
        bl mod
        cmp r12, #0
        beq divide_by_two

        b finish_fail

remove_one
        mov r3, r11
        b greedy_calc_loop

divide_by_two
        mov r3, r11
        b greedy_calc_loop

finish_fail
        mov r0, #0x0000002D
        bl print_char
        mov r0, #1
        add r0, r0, #'0'
        bl print_char

        mov       r0, #0x18
        mov       r1, #0x20000        ; build the "difficult" number...
        add       r1, r1, #0x26       ; ...in two steps
        SWI       0x123456            ;; "software interrupt" = sys call



print_dec
    stmfd 	sp!, {lr}

    adr r10, array
    mov r2, #0
    bl push_dec
    bl pop_dec
    
    ldmfd	sp!, {pc}
    bx lr

push_dec
    
    mov r4, r11

    stmfd 	sp!, {lr}
    bl mod
    ldmfd	sp!, {lr}
    
    mov r0, r12
    add r0, r0, #'0'

    strh r0, [r10, r2]
    add r2, r2, #2
    
    cmp r11, #0
    bne push_dec
    
    bx lr

pop_dec
    stmfd 	sp!, {lr}
    
    sub r2, r2, #2
    ldrh r0, [r10, r2]
    
    bl print_char

    cmp r2, #0
    BGT pop_dec

    ldmfd	sp!, {lr}
    bx lr


finish
        ; Standard exit code: SWI 0x123456, calling routine 0x18
        ; with argument 0x20026
        ;mov r0, r7
        ;add r0, r0, #'0'
        ;bl print_char

        mov r11, r6 ; cnt
        mov r5, r9 ; 10
        bl print_dec

        mov       r0, #0x18
        mov       r1, #0x20000        ; build the "difficult" number...
        add       r1, r1, #0x26       ; ...in two steps
        SWI       0x123456            ;; "software interrupt" = sys call




array   DCB 10

            END