; Hello world in ARM assembler

            AREA text, CODE
            ; This section is called "text", and contains code

            ENTRY
            
			IMPORT   print
			IMPORT   scan
			IMPORT   print_char


start
            b get_input

get_input
            mov r4, #0xa ; *10을 해주기 위해 필요함
            bl scan
			bl print_char
            cmp r0, #0x00000020 ; 스페이스가 입력되면
            beq input_cnt ; 입력 개수 추가

            sub r3, r0, #'0' ; char -> int
            mul r6, r5, r4 ; r6 = r5 * 10
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
            bl outer_loop

outer_loop
        mov r5, #2 ; j = 2
        bl inner_loop

        cmp r4, r2
        beq finish
        
        add r4, r4, #1
        b outer_loop

inner_loop
        stmfd 	sp!, {lr}

        bl modular
        cmp r8, #0
        beq is_not_prime
        
        add r5, r5, #1

        cmp r4, r5
        beq is_prime
        
        bne inner_loop
        mov pc, lr
        swi		0x123456
	    ldmfd	sp!, {pc}

modular
    stmfd 	sp!, {lr}

    mov r8, #1

    swi		0x123456
	ldmfd	sp!, {pc} 

is_prime
        stmfd 	sp!, {lr}
        mov r6, #1 ; isPrime = 1;
        add r7, r7, #1 ; cnt = cnt + 1;
        
        swi		0x123456
		ldmfd	sp!, {pc}
        mov pc, lr

is_not_prime
        stmfd 	sp!, {lr}

        mov r6, #0 ; isPrime = 0;
        swi		0x123456
		ldmfd	sp!, {pc}
        mov pc, lr


finish
            ; Standard exit code: SWI 0x123456, calling routine 0x18
            ; with argument 0x20026
            mov       r0, #0x18
            mov       r1, #0x20000        ; build the "difficult" number...
            add       r1, r1, #0x26       ; ...in two steps
            SWI       0x123456            ;; "software interrupt" = sys call

array   DCB 10

            END