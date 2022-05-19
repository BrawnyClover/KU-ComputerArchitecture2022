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
			stmfd 	sp!, {r0, lr}
			adr		r1, char
			strb	r0, [r1]
			mov		r0, #3
			swi		0x123456
			ldmfd	sp!, {r0, pc}
			
char 		DCB		0
            
            END