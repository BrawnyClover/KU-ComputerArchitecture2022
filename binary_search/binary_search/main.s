; Hello world in ARM assembler

        AREA text, CODE
        ; This section is called "text", and contains code

        ENTRY

        IMPORT  print
        IMPORT  scan
        IMPORT  print_char

start
        mov r9, #0xa ; *10을 해주기 위해 필요함
        adr r10, array
        mov r11, #0
        mov r12, #0
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
        strh r5, [r10, r2] ; save input value to memory
        add r2, r2, #2 ; add 2 byte to weight
        cmp r2, #20
        beq binary_search
        mov r5, #0
        b get_input

binary_search
        mov r1, #0 ; st = 0
        mov r2, #16 ; ed = 16
        ; r4 : 나누어지는 수
        ; r5 : 나누는 수
        ldrh r6, [r10, #18] ; target, 10번째로 입력받은 수

        b binary_search_loop

        
binary_search_loop
        add r7, r1, r2 ; md = (st + ed)
        mov r4, r7
        mov r5, #2
        bl mod
        mov r7, r11 ; md = md / 2

        ldrh r8, [r10, r7] ; num[md]
        cmp r6, r8
        BEQ finish
        BLT binary_search_left
        BGT binary_search_right

binary_search_left
        sub r7, r7, #2
        mov r2, r7 ; st ~ md-1
        b binary_search_loop

binary_search_right
        add r7, r7, #2
        mov r1, r7 ; md+1 ~ ed
        b binary_search_loop
        

print_dec ; r11에 있는 값을 출력
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


mod 
    stmfd 	sp!, {r4, lr}
    ; r11 = r4 / r5, r12 = r4 % r5
    mov r11, #0
    mov r12, #0

    bl divide_loop
    
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
    mov r12, r4 ; remain
    bx lr

finish
        mov r11, r8
        bl print_dec

        mov       r0, #0x18
        mov       r1, #0x20000        ; build the "difficult" number...
        add       r1, r1, #0x26       ; ...in two steps
        SWI       0x123456            ;; "software interrupt" = sys call




array   DCB 10

        END