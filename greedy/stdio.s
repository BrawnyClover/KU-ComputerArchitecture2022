; print

            AREA      text,CODE
                                                
            EXPORT    scan
            EXPORT	  print
            EXPORT    print_char


print
    ; Entry: Takes char in r0.
    ; Conforms to APCS
    ; Call SYS_WRITEC, with r1 containing a POINTER TO a character.

    ; SYS_WRITEC = 3, SYS_WRITE0 = 4, SYS_READC = 7

    stmfd     sp!, {r4-r12, lr}


    mov       r1, r0
    mov       r0, #4
    swi       0x123456

    ldmfd     sp!, {r4-r12, pc} ; and pop them once you're back


scan
    stmfd 	sp!, {lr}
    mov	  	r0, #7
    swi		0x123456
    ldmfd	sp!, {pc}
			
print_char
    stmfd 	sp!, {r0, lr} ;스택에 r0와 lr 레지스터를 저장하고 sp를 그만큼 감소시킨다.
    adr		r1, char ; char의 주소 값을 r1에 저장
    strb	r0, [r1] ; r1이 가리키는 곳에 r0값을 저장
    mov		r0, #3 ; SYS_WRITEC
    swi		0x123456
    ldmfd	sp!, {r0, pc} ;스택에서 r0와 pc를 복원하고 sp를 그만큼 증가시킨다.
			
char 	DCB	0
stack   DCB 10

    END