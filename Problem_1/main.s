; Problem 1 : Prime number
; 2018170914 손명준

            AREA text, CODE
            ; This section is called "text", and contains code

            ENTRY
            
			IMPORT  print
			IMPORT  scan
			IMPORT  print_char
                        IMPORT  mod


start
        mov r9, #0xa            ; *10을 해주기 위해 필요함
        b get_input             ; 숫자 입력 진입 지점

get_input
        bl scan                 ; 키보드 값 입력
        bl print_char           ; 입력된 값 출력
        cmp r0, #0x00000020     ; 스페이스 값 입력이 인식되면
        beq input_cnt           ; 입력 개수 추가
        bne numberlize          ; 그렇지 않으면 16진 정수화

numberlize
        
        sub r3, r0, #'0'        ; char -> int
        mul r6, r5, r9          ; r6 = r5 * 10
        add r5, r6, r3          ; r5 = r6 + r3
        b get_input

input_cnt
        adr r10, array          ; 입력된 값이 저장될 메모리의 시작지점
        strh r5, [r10, r2]      ; save input value to memory
        add r2, r2, #2          ; add 2 byte to weight
        mov r5, #0              ; 다음 입력을 위해 r5 초기화
        cmp r2, #4              ; r2 == 4? -> 2개가 입력되었는가?
        beq calc_prime_cnt
        
        b get_input             ; 아니면 다시 입력 대기

calc_prime_cnt
                                ; ===<Register Table>===
                                ; r0 : reserved
                                ; r1 : reserved
        ldrh r2, [r10]          ; r2 : n
        ldrh r3, [r10, #0x02]   ; r3 : m, n < m
        mov r4, r2              ; r4 : i = n
                                ; r5 : j
                                ; r6 : reserved(isPrime)
        mov r7, #0              ; r7 : cnt = 0;
                                ; r8 : reserved
                                ; r9 : reserved
                                ; r10 : 1 short int값이 저장될 메모리의 시작점
                                ; r11 : mod 연산 결과, 몫
                                ; r12 : mod 연산 결과, 나머지
        cmp r4, #2
        BLE adjust_start_num

        b outer_loop


adjust_start_num
                                ; n이 2보다 작거나 같으면
                                ; 3부터 시작하도록 n값을 변경
        mov r4, #3
        add r7, r7, #1          ; cnt = 1, 2가 소수이기 때문
        b outer_loop

outer_loop
        mov r5, #2              ; j = 2
        bl inner_loop

        cmp r4, r3              ; if i == m
        beq finish              ; break
        
        add r4, r4, #1          ; i = i + 1
        b outer_loop            ; continue

inner_loop
        stmfd 	sp!, {lr}
        bl mod                  ; r12 = i % j
        ldmfd	sp!, {lr}

        cmp r12, #0             ; r12 == 0
        beq is_not_prime
        
        add r5, r5, #1          ; j = j + 1

        cmp r4, r5              ; j == i
        beq is_prime            ; i is a prime number
        bne inner_loop          ; else continue
    

is_prime
        add r7, r7, #1          ; cnt = cnt + 1;
        bx lr

is_not_prime
        bx lr


print_dec 
                                ; r8에 있는 값을 출력
    stmfd 	sp!, {lr}

    adr r10, array              ; 1 digit을 저장할 메모리 주소
    mov r2, #0                  ; offset = 0
    bl push_dec
    bl pop_dec
    
    ldmfd	sp!, {pc}
    bx lr                       ; lr로 복귀

push_dec                   
                                ; 0x00123 꼴의 형태를 1, 2, 3으로 분리해서 메모리에 저장
    mov r4, r11                 ; 분리할 대상 숫자로 r11의 값을 저장
    mov r5, #10                 ; 10진수로 분리할 것이기 때문에 나누는 수로 10을 저장

    stmfd 	sp!, {lr}       ; 현재 lr값 stack에 저장
    bl mod                      
    ldmfd	sp!, {lr}       ; lr값을 stack에서 복원
    
    mov r0, r12                 ; 나머지 값을 r0에 저장
    add r0, r0, #'0'            ; int -> char

    strh r0, [r10, r2]          ; 1 digit을 메모리에 저장
    add r2, r2, #2              ; offset 증가
    
    cmp r11, #0                 ; 몫이 0이 아니면
    bne push_dec                ; 다시 digit 분리
    
    bx lr                       ; lr로 복귀

pop_dec
                                ; 메모리에 저장된 digit값을 거꾸로 출력
    stmfd 	sp!, {lr}
    
    sub r2, r2, #2              ; offset 감소
    ldrh r0, [r10, r2]          ; 메모리에 저장된 digit 값 불러오기
    
    bl print_char               ; 1 digit 출력

    cmp r2, #0                  ; offset > 0 ?
    BGT pop_dec                 ; 다음 digit 출력

    ldmfd	sp!, {lr}
    bx lr


finish
        mov r11, r7                   ; r11에 출력될 값 r7을 저장
        bl print_dec                  ; r11에 저장된 값을 출력

        mov       r0, #0x18
        mov       r1, #0x20000        ; build the "difficult" number...
        add       r1, r1, #0x26       ; ...in two steps
        SWI       0x123456            ;; "software interrupt" = sys call




array   DCB 10

            END