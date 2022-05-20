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
        beq calc_prime_cnt
        mov r5, #0
        b get_input

calc_prime_cnt
        ldrh r2, [r10] ; n
        ldrh r3, [r10, #0x02] ; m, n<m
        mov r4, r2 ; i = n
        mov r7, #0 ; cnt = 0;

        cmp r4, #2
        BLE adjust_start_num

        b outer_loop


adjust_start_num
        mov r4, #3
        add r7, r7, #1
        b outer_loop

; r1 
; r2 n
; r3 m
; r4 i
; r5 j
; r6 isPrime
; r7 cnt
; r8 
; r9 0xa
; r10 base register
; r11 몫
; r12 나머지

outer_loop
        mov r5, #2 ; j = 2
        bl inner_loop

        cmp r4, r3 ; if i == m
        beq finish ; break
        
        add r4, r4, #1 ; i++
        b outer_loop ; continue

inner_loop
        stmfd 	sp!, {lr}
        bl modular ; r12 = i % j
        ldmfd	sp!, {lr}

        cmp r12, #0 ; r12 == 0
        beq is_not_prime
        
        add r5, r5, #1 ; j++

        cmp r4, r5 ; j == i
        beq is_prime ; 
        bne inner_loop ; else continue
        

modular
        stmfd 	sp!, {lr}
        bl mod
        swi	0x123456
        ldmfd	sp!, {pc}
    

is_prime
        
        mov r6, #1 ; isPrime = 1;
        add r7, r7, #1 ; cnt = cnt + 1;
        
        bx lr

is_not_prime
        

        mov r6, #0 ; isPrime = 0;
        bx lr


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

        mov r11, r7 ; cnt
        mov r5, r9 ; 10
        bl print_dec

        mov       r0, #0x18
        mov       r1, #0x20000        ; build the "difficult" number...
        add       r1, r1, #0x26       ; ...in two steps
        SWI       0x123456            ;; "software interrupt" = sys call




array   DCB 10

            END