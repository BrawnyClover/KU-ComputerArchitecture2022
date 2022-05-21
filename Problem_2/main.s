; Problem 2 : Binary Search
; 2018170914 손명준

        AREA text, CODE
        
        ENTRY
                IMPORT  print
                IMPORT  scan
                IMPORT  print_char
                

start
        mov r9, #0xa            ; *10을 해주기 위해 필요함
        b get_input

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
        cmp r2, #20             ; r2 == 20? -> 9 + 1개가 입력되었는가?
                                ; 9개 : 정렬된 숫자들
                                ; 1개 : 찾고자 하는 숫자
        beq binary_search
        
        b get_input             ; 아니면 다시 입력 대기

binary_search
                                ; ===<Register Table>===
                                ; r0 : reserved
        mov r1, #0              ; r1 : st = 0
        mov r2, #8              ; r2 : ed = 16
                                ; r3 : reserved
                                ; r4 : 나누어지는 수
                                ; r5 : 나누는 수
        ldrh r6, [r10, #18]     ; r6 : target, 10번째로 입력받은 수
                                ; r7 : reserved
                                ; r8 : target과 일치한 값
                                ; r9 : 메모리 offset
                                ; r10 : 메모리 base address
                                ; r11 : mod 연산 결과, 몫
                                ; r12 : mod 연산 결과, 나머지

        b binary_search_loop    ; binary search 반복문 진입지전

        
binary_search_loop
        add r7, r1, r2          ; md = (st + ed)
        mov r4, r7              ; 나누어질 수에 r7값을 저장
        mov r5, #2              ; 나눌 수에 2를 저장
        bl mod                  ; r5 = r7 % 2
        mov r7, r11             ; md = md / 2
        mul r9, r7, r5          ; offset = md * 2

        ldrh r8, [r10, r9]      ; num[base + offset]에 접근해 가운데 위치의 값을 불러움
        cmp r6, r8              ; 불러온 값과 target 값을 비교
        BEQ finish              ; 값이 같으면 출력 후 종료
        BLT binary_search_left  ; target이 불러온 값보다 작으면 왼쪽 부분 탐색
        BGT binary_search_right ; target이 불러온 값보다 크면 오른쪽 부분 탐색

binary_search_left              ; 왼쪽 부분 탐색
        sub r7, r7, #1          ; md = md - 1
        mov r2, r7              ; 탐색 영역 : st ~ md - 1
        b binary_search_loop

binary_search_right             ; 오른쪽 부분 탐색
        add r7, r7, #1          ; md = md + 1
        mov r1, r7              ; 탐색 영역 : md + 1 ~ ed  
        b binary_search_loop
        

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

finish
        mov r11, r8         ; print_dec 분기에서 출력될 숫자로 r8 저장
        bl print_dec

        mov       r0, #0x18
        mov       r1, #0x20000        ; build the "difficult" number...
        add       r1, r1, #0x26       ; ...in two steps
        SWI       0x123456            ;; "software interrupt" = sys call




array   DCB 10

        END