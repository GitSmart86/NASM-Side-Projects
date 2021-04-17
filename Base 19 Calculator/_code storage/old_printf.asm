
.print_begin:
                call    _stack_pop              ; note: at least one <SPACE> for _stack_pop

.print_compile:
                ;mov     rcx,        19              ; rcx = divisor
                ;mov     rax,        _stack_pop ret OR line:534
                ;mov     rdx,        0
                ;div     rcx
                
                ;mov     r10,        rdx

                ;   handle rax -> char for printing
                ;mov     r8,         str_conversion  ; ['0','1','2',etc]
                ;add     r8,         rax             ; rax -> char
                ;movzx   rdx,        byte [r8]
                mov     rdx,        rax
                mov     rcx,        str_printf
                call    printf

                ;   handle rdx -> loop
                ;mov     rax,        r10             ; move remainder to div again
                ;cmp     rax,        0
                ;jg      .print_compile
                
                mov     rcx,        str_CR_LF
                call    printf
                jmp     _input_main.input_epilogue


.jmp_input_epilogue:
 jmp main.main_loop

;-------------------------------------------------------------------------------------
