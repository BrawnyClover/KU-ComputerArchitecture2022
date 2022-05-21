; Problem 3 : Greedy
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
        beq greedy_calc
        
        b get_input             ; 아니면 다시 입력 대기

greedy_calc
                                ; ===<Register Table>===
                                ; r0 : reserved
                                ; r1 : reserved
        ldrh r2, [r10]          ; r2 : n, start number
        ldrh r3, [r10, #0x02]   ; r3 : m, destination number
                                ; r4 : 나누어질 수
                                ; r5 : 나눌 수
        mov r6, #0              ; r6 : cnt
                                ; r7 ~ r8 : reserved
                                ; r9 : reserved
                                ; r10 : 1 short int값이 저장될 메모리의 시작점
                                ; r11 : mod 연산 결과, 몫
                                ; r12 : mod 연산 결과, 나머지

        bl greedy_calc_loop     ; greedy 반복문 진입지점

greedy_calc_loop

        add r6, r6, #1 ; cnt = cnt + 1

        cmp r2, r3      ; n == m ?
        beq finish      ; dest에 도착했으므로 cnt 출력 후 종료
        BGT finish_fail ; n > m ? 더 이상 연산이 불가하므로 -1 출력 후 종료
        
        mov r4, r3      ; 나누어질 수로 m을 저장
        
        mov r5, #10     ; 나눌 수로 10을 저장
        bl mod          ; r12 = m % 10
        cmp r12, #1     ; r12 == 1 ?
        beq renew_dest  ; m의 끝에서 1 제거

        mov r5, #2      ; 나눌 수로 2를 저장
        bl mod          ; r12 = m % 2
        cmp r12, #0     ; r12 == 0 ?
        beq renew_dest  ; m = m / 2

        b finish_fail   ; 더 이상 연산이 불가하므로 -1 출력 후 종료

renew_dest
        mov r3, r11     ; m = m % r5
        b greedy_calc_loop ; 루프로 복귀

finish_fail
        mov r0, #0x0000002D     ; '-' 출력
        bl print_char           ;
        mov r0, #1              ; 1 출력
        add r0, r0, #'0'        ;
        bl print_char           ;

        mov       r0, #0x18
        mov       r1, #0x20000        ; build the "difficult" number...
        add       r1, r1, #0x26       ; ...in two steps
        SWI       0x123456            ;; "software interrupt" = sys call



print_dec 
                                ; r11에 있는 값을 출력
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
        mov r11, r6 ; print_dec 분기에서 출력될 숫자로 cnt 저장
        bl print_dec

        mov       r0, #0x18
        mov       r1, #0x20000        ; build the "difficult" number...
        add       r1, r1, #0x26       ; ...in two steps
        SWI       0x123456            ;; "software interrupt" = sys call


array   DCB 10
            END