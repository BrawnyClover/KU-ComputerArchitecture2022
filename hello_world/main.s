; Hello world in ARM assembler

            AREA text, CODE
            ; This section is called "text", and contains code

            ENTRY
            
			IMPORT   print
			IMPORT   scan
			IMPORT   print_char
            
            ; Print "Hello world"

start
			bl		 scan
			sub		 r3, r0, #'0'
			bl		 scan
			sub		 r4, r0, #'0'
			add		 r0, r4, r3
			add		 r0, r0, #'0'
			bl		 print_char
			


finish
            ; Standard exit code: SWI 0x123456, calling routine 0x18
            ; with argument 0x20026
            mov       r0, #0x18
            mov       r1, #0x20000        ; build the "difficult" number...
            add       r1, r1, #0x26       ; ...in two steps
            SWI       0x123456            ;; "software interrupt" = sys call



            END