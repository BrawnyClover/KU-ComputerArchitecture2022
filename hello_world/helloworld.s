

            AREA	 text, CODE
            ; This section is called "text", and contains code

            IMPORT    print
         	EXPORT	  print_helloworld
            
            ; Print "hello world"


print_helloworld
       
          ; Alternatively, use putstring to write out the
            ; whole string in one go
            stmfd     sp!, {r4-r12, lr} ; push the registers that 
                                        ; you want to save
            adr       r0, start_print
            bl        print           ;; "branch+link" = subroutine call
			ldmfd     sp!, {r4-r12, pc} ; and pop them once you're back


start_print
            DCB       "hello worlwwd!",0
            

            END