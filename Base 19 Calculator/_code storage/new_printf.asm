
.print_begin:
                mov     r12,    9
                call    _stack_pop              ;   note: at least one <SPACE> for _stack_pop

                cmp     rax,    0
                jne     .print_compile
                jmp     _input_main.input_epilogue


.print_compile:
               ;mov     rax,        _stack_pop ret OR line:621
                mov     rdx,        0
                mov     rcx,        19              ; rcx = divisor
                div     rcx
                 
                ; preserve rax
                mov     rdi,            rax

                ;       get char from rdx
                mov     r13,            str_conversion  ; ['0','...','J']
                mov     r15b,           [r13 + rdx]
                
                ;       store char in str_printf
                lea     rbx,            str_printf_result
                mov     [rbx + r12],    r15b

                ;       debugging printf
                movzx     rdx,            r15b
                mov     rcx,            str_printf
                call    printf
                
                ; restore rax
                mov     rax,   rdi

                ;       if(rdx == 0) -> loop
                dec     r12
                cmp     r12,            0
                jge     .print_compile

                
                mov     rcx,    str_CR_LF
                call    printf
                
                call    _printf_result
                jmp     _input_main.input_epilogue

.jmp_input_epilogue:
 jmp main.main_loop

;-------------------------------------------------------------------------------------

_printf_result:
                ; local prologue
                push    rbp
                mov     rbp,    rsp
                sub     rsp,    32

                mov     r12,    0           ;   sigfig zero bool
                mov     r13,    0           ;   count to 9

.printf_result_loop:
                cmp     r13,    11
                je     .printf_result_end

                lea     rbx,    str_printf_result
                movzx   rdx,    byte [rbx + r13]
               ;inc     rbx
                inc     r13

                ;cmp     rdx,   48
                ;je     .printf_result_check_0

                ;mov     r12,   1

.printf_result_check_0:
                ;cmp     r12,   0
                ;je      .printf_result_loop

.printf_result_print:
                ;mov     rdx,    r13
                mov     rcx,    str_printf
                call    printf
                jmp     .printf_result_loop

.printf_result_end:
                mov     rcx,    str_CR_LF
                call    printf

                ; local epilogue
                mov     rsp,    rbp
                pop     rbp
                ret


    str_printf      db      " %2d",0