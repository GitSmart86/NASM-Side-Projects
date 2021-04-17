; CpS 230 Prog. 2: Jonathan Layton (jlayt118)
;
;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;   Table of Contents:
;
;   r8  =   last_char_was_number
;   r9  =   temp. index for cal_fmt_in_len()
;   r10 =   placeholder for div's rdx value
;   r11 =   r12_'s conversion f(x) index        =   tainted
;   r12 =   temp. value_'s power index
;   r13 =   temp. value
;   r14 =   fake STACK index
;   r15 =   EQUAL flag
;
;
;
; 1st Tier    =   handles user input
;-----------------
;       _main:
;       .main_loop:
;       .main_end:
;
;
;
; 2nd Tier    =   cycles through user input char[]
;----------------------------------
;       _input_main:
;       .input_loop:
;       .input_epilogue:
;           -> conditional_jmp -> abs_jmp table       
;                   ( reduces mental_code_load, AKA bugs ) 
;
;
;
; 3rd Tier    =   cmp valid input chars
;---------------------------------------------------
;       .input_PLUS:
;       .input_MINUS:
;       .input_MULTI:
;       .input_DIVIDE:
;       .input_TILDE:
;       .input_EQUAL:
;       .input_SPACE:
;       .input_check_0_9:
;       .input_check_A_Z:
;       .input_check_a_z:
;
;
;
; 4th Tier    =   stack operations
;--------------------------------------------------------------------
;       _cal_fmt_in_len:
;       .cal_fmt_in_len_loop:
;       .cal_fmt_in_len_end:
;
;       _stack_push:
;       _stack_pop:
;       _stack_peek:
;
;       _convert_fmt_in:
;       .convert_fmt_in_loop:
;       .convert_fmt_in_end:
;
;
;
; 5th Tier    =   utility
;-------------------------------------------------------------------------------------
;       _utility:
;       .handle_num:
;       .handle_alph:
  
;       .handle_var:
;       .set_var:
;       .get_var:

;       .error_underflow:
;       .error_overflow:

;       .print_begin:
;       .print_compile:
;       .print_add_char:
;
;
;
;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;---------------------------------------------------------------------------------------------------------------------------------------------------------
;   BUGS:
;
;   printf conversion to B19 crashes
;   vars taint +/-4 slots around themselves
;   
;---------------------------------------------------------------------------------------------------------------------------------------------------------


;xxxxxxxxxxxxxxx   
;     TEXT
;xxxxxxxxxxxxxxx   
default rel
extern  printf
extern  gets_s
section .text
global  main


;-----------------
;    1st Tier 
;-----------------
main:   
    ; Prologue
    push    rbp
    mov     rbp, rsp
    sub     rsp, 32
    
	push	rsi					    ;   No locals needed, but we need to save ESI	

    ; print greeting, then loop
    mov     rcx, str_start
    call    printf
    jmp     .main_loop
    

.main_loop:
    ; Read input     
    mov     rdx,    80
    lea     rcx,    [BUFFER]
    call    gets_s

    ; if input = NULL
    cmp     byte [rax],     0
    je      .main_end
    
    mov     dl,         byte [EQUAL]
    cmp     byte [rax],    dl
    je      .jmp_utility.check_equal_var

    ; else
    call    _cal_fmt_in_len
	mov		rsi,    rax			    ;   %rsi = fmt
    mov     r9,     0               ;   set set_var_single_run = 0

    call    _input_main             ;   handle prompted fmt_text
    jmp     .main_loop


.main_end:
    mov     rcx, str_end
    call    printf
      
    ; Epilogue
    mov     rax, 0  
    mov     rsp, rbp
    pop     rbp
    ret
    

.jmp_utility.check_equal_var:
 jmp _utility.check_equal_var

;----------------------------------
;            2nd Tier 
;----------------------------------
_input_main:
        ; local prologue
        push    rbp
        mov     rbp,    rsp
        sub     rsp,    32


        mov     qword [A_temp_val],     0
        mov     qword[last_char_numeric],   0
        mov     r8,     0
        mov     r9,     0
        mov     r10,    0
        mov     r11,    0           ;   power index f(x) = 0
        mov     r12,    0           ;   temp. value power index = 0
        mov     r13,    0           ;   temp. value = 0
        mov     r14,    0           ;   fake STACK = 0 
        mov     qword [Set_Var_Flag],    0           ;   set equal_flag to F
        jmp     .input_loop


.input_loop:
        ; load next char, then inc index
        movzx	rax,    byte [rsi]
        dec		rsi

        ; . . . . . . . . .
        ; Handle next char
        ; . . . . . . . . .

        ; <line_end>
        cmp     rax,    0
        je     .jmp_print_result

        ;    +
        cmp     rax,    [PLUS]
        je      .jmp_input_PLUS

        ;    -
        cmp     rax,    [MINUS]
        je      .jmp_input_MINUS

        ;    *
        cmp     rax,    [MULTI]
        je      .jmp_input_MULTI

        ;    /
        cmp     rax,    [DIVIDE]
        je      .jmp_input_DIVIDE

        ;    ~
        cmp     rax,    [TILDE]
        je      .jmp_input_TILDE

        ;    =
        cmp     rax,    [EQUAL]
        je      .jmp_input_EQUAL
    
        ; <space>
        cmp     rax,    [SPACE]
        je      .jmp_input_SPACE
        
        ; <numeric> | <variable>
        cmp     rax,    '0'
        jge     .jmp_input_check_0_9

        ; else   
        jmp     .input_loop


.input_epilogue:
        mov     rax,    0 
        mov     rsp,    rbp
        pop     rbp
        ret

;----------------------------------

.jmp_print_result:
 jmp _utility.print_begin
.jmp_input_PLUS:
 jmp .input_PLUS
.jmp_input_MINUS:
 jmp .input_MINUS
.jmp_input_MULTI:
 jmp .input_MULTI
.jmp_input_DIVIDE:
 jmp .input_DIVIDE
.jmp_input_TILDE:
 jmp .input_TILDE
.jmp_input_EQUAL:
 jmp .input_EQUAL
.jmp_input_SPACE:
 jmp .input_SPACE
.jmp_input_check_0_9:
 jmp .input_check_0_9
 

;---------------------------------------------------
;                  3rd Tier 
;---------------------------------------------------

.input_PLUS:
            call    _check_push_A_temp_val

            call    _stack_pop
            mov     rcx,    rax
            
            call    _stack_pop
            mov     rdx,    rax

            add     rcx,    rdx
            mov     qword [A_temp_val],    rcx
            call    _stack_push
            jmp     .input_loop

.input_MINUS:
            call    _check_push_A_temp_val
            
            call    _stack_pop
            mov     rcx,    rax
            
            call    _stack_pop
            mov     rdx,    rax

            sub     rcx,    rdx
            mov     qword [A_temp_val],    rcx
            call    _stack_push
            jmp     .input_loop

.input_MULTI:
            call    _check_push_A_temp_val
            
            call    _stack_pop
            mov     rcx,    rax
            
            call    _stack_pop
            mov     rax,    rax

            mul     rcx
            mov     qword [A_temp_val],    rax
            call    _stack_push
            jmp     .input_loop

.input_DIVIDE:
            call    _check_push_A_temp_val
            
            call    _stack_pop
            mov     rcx,    rax     ; rcx = divisor
            
            call    _stack_pop      ; rax = quotient
            mov     rdx,    0

            div     rcx
            mov     qword [A_temp_val],    rax
            call    _stack_push
            jmp     .input_loop

.input_TILDE:
            call    _check_push_A_temp_val
            
            call    _stack_pop
            neg     rax
            mov     qword [A_temp_val],    rax
            call    _stack_push
            jmp     .input_loop

.input_EQUAL:
            mov     qword [Set_Var_Flag],   1
            jmp     .input_loop

.input_SPACE:
            cmp     qword[last_char_numeric],      1   ; cmp if last char was numeric
            jne      .input_SPACE_end
            mov     qword[last_char_numeric],     0

            call    _stack_push
            mov     r12,    0
            mov     qword [A_temp_val],    0

.input_SPACE_end:
            jmp     .input_loop

.input_check_0_9:

            cmp     rax,    '9'
            jle     .jmp_handle_num

            cmp     rax,    'A'
            jge     .input_check_A_Z
            
            ; '0' < char < 'A'
            ; must be an irrelevent char...
            jmp     .input_loop

.input_check_A_Z:
            cmp     rax,    'Z'
            jle     .jmp_handle_alph

            cmp     rax,    'a'
            jge     .input_check_a_z
            
            ; 'Z' < char < 'a'
            ; must be an irrelevent char...
            jmp     .input_loop

.input_check_a_z:
            cmp     rax,    'z'
            jle     .jmp_handle_var
            
            ; 'z' < char
            ; and we already checked for ~
            ; so must be an invalid char...
            jmp     .input_loop


;----------------------------------

.jmp_handle_num:
 jmp _utility.handle_num
.jmp_handle_alph:
 jmp _utility.handle_alph
.jmp_handle_var:
 jmp _utility.handle_var

;--------------------------------------------------------------------
;                             4th Tier 
;--------------------------------------------------------------------
_cal_fmt_in_len:                
                ; local prologue
                push    rbp
                mov     rbp,    rsp
                sub     rsp,    32

                mov     r9,     rax

.cal_fmt_in_len_loop:
                movzx   r8,     byte [r9]
                cmp     r8,     0
                je      .cal_fmt_in_len_end

                inc     r9
                jmp     .cal_fmt_in_len_loop
                
.cal_fmt_in_len_end:
                mov     rax,    r9
                dec     rax

                ; local epilogue
                mov     rsp,    rbp
                pop     rbp
                ret
_stack_push:
                ; check for overflow error
                cmp     r14,    100
                jge     _utility.error_overflow
                
                ; local prologue
                push    rbp
                mov     rbp,    rsp
                sub     rsp,    32

                ; push
                lea     rbx,    [STACK]
                mov     r13, qword [A_temp_val]
                mov     [rbx + r14 * 4], r13
                inc     r14  
                mov     qword [A_temp_val],    0 
                
                ; local epilogue
                mov     rsp,    rbp
                pop     rbp
                ret
_stack_pop:
                ; check for underflow error
                cmp     r14,    0
                jle     _utility.error_underflow
                
                ; local prologue
                push    rbp
                mov     rbp,    rsp
                sub     rsp,    32

                ; pop
                dec     r14  
                lea     rbx,    [STACK]
                mov     rax,    [rbx + r14 * 4] 
                
                ; local epilogue
                mov     rsp,    rbp
                pop     rbp
                ret
_stack_peek:
                ; local prologue
                push    rbp
                mov     rbp,    rsp
                sub     rsp,    32

                ; peek
                lea     rbx,    [STACK]
                mov     rax,    [rbx + r14 * 4] 
                
                ; local epilogue
                mov     rsp,    rbp
                pop     rbp
                ret
_convert_fmt_in:
                ; local prologue
                push    rbp
                mov     rbp,    rsp
                sub     rsp,    32

                mov     r11,    0           ;   reset f(x) power index

.convert_fmt_in_loop:
                cmp     r11,    r12         ;   cmp char power index to word power index 
                jge     .convert_fmt_in_end

                mov     rcx,    10  ;  19
                mul     rcx
                inc     r11                 ;   char power index++

                jmp     .convert_fmt_in_loop

.convert_fmt_in_end:
                inc     r12                 ;   word power index++
                add     qword [A_temp_val],    rax         ;   add incoming converted value to temp. value

                ; local epilogue
                mov     rsp,    rbp
                pop     rbp
                ret

_check_push_A_temp_val:
                ; local prologue
                push    rbp
                mov     rbp,    rsp
                sub     rsp,    32

                ;cmp     r13,    0
                ;je      .check_push_A_temp_val_end

                cmp     qword[last_char_numeric],      1   ; cmp if last char was numeric
                jne      .check_push_A_temp_val_end
                mov     qword[last_char_numeric],     0

                call    _stack_push

.check_push_A_temp_val_end:
                ; local epilogue
                mov     rsp,    rbp
                pop     rbp
                ret

;-------------------------------------------------------------------------------------
;                                   5th Tier 
;-------------------------------------------------------------------------------------
_utility:

.check_equal_var:
            	mov		rsi,    rax			    ;   %rsi = fmt

                movzx	rax,    byte [rsi]
                inc		rsi
                movzx	rax,    byte [rsi]   

                mov     r9,     1               ;   set var_equal_single_run = 1
                jmp     .set_var

.handle_num:
                sub     rax,            '0'
                call    _convert_fmt_in
                mov     qword [last_char_numeric],     1
                jmp     _input_main.input_loop

.handle_alph:
                sub     rax,            'A'
                call    _convert_fmt_in
                mov     qword [last_char_numeric],     1
                jmp     _input_main.input_loop
                
.handle_var:
                cmp     qword [Set_Var_Flag],   1   ;   if(EQUAL_flag == True)
                je      .set_var
                jmp     .get_var

.set_var:
                ; push A_temp_val to VARS[index]
                sub     rax,    'a' ;   convert var to VARS[] index
                mov     rcx,    rax ;   rax_index -> rcx
                call    _stack_peek ;   peek_val -> rax

                lea     rbx,    VARS
                mov     [rbx + rcx],    rax 
                mov     qword[A_temp_val],    rax
                call    _stack_push

                cmp     r9,     1
                je      .jmp_input_epilogue

                jmp     _input_main.input_loop

.get_var:
                sub     rax,    'a' ;   convert var to VARS[] index
                lea     rbx,    VARS
                mov     r13,    qword [A_temp_val]
                mov     r13,    [rbx + rax]
                mov     qword [A_temp_val], r13
                call    _stack_push
                jmp     _input_main.input_loop

.error_underflow:
                mov     rcx,    str_error_underflow
                call    printf
                jmp     _input_main.input_epilogue

.error_overflow:
                mov     rcx,    str_error_overflow
                call    printf
                jmp     _input_main.input_epilogue

.print_begin:
                ;mov     r12,    9
                call    _stack_pop              ;   note: at least one <SPACE> for _stack_pop

                ;cmp     rax,    0
                ;jne     .print_compile

                ;mov     rdx,    '0'
                ;mov     rcx,    str_printf
                ;call    printf
                ;mov     rcx,        str_CR_LF
                ;call    printf
                ;jmp     _input_main.input_epilogue


.print_compile:
               ;mov     rax,        _stack_pop ret OR line:534
                mov     rdx,        0
                mov     rcx,        19              ; rcx = divisor
                div     rcx
                 

                ;   handle rax -> char for printing
                mov     r10,        str_conversion  ; ['0','...','J']
                add     r10,        rdx             ;   rax -> char
                movzx   r8,         byte [r10]

                ;   handle rdx -> char for printing
                ;sub     r10,        rdx
                ;add     r10,        rax
                ;movzx   rdx,        byte[r10]

                ; preserve rax
                mov          rbx,   rax

                mov     rcx,        str_printf_old
                call    printf
                
                ; restore rax
                mov          rax,   rbx

                ;   handle rdx -> loop
                cmp     rax,        0
                jg      .print_compile
            
                mov     rcx,        str_CR_LF
                call    printf
                jmp     _input_main.input_epilogue



.jmp_input_epilogue:
 jmp main.main_loop

;-------------------------------------------------------------------------------------



;xxxxxxxxxxxxxxx   
;     DATA
;xxxxxxxxxxxxxxx  
section .data
    CR EQU $0D    
    LF EQU $0A
    


    Set_Var_Flag                dq    	0		;   r15 =   EQUAL flag
    Fake_stack_Index            dq    	0		;   r14 =   fake STACK index
    A_temp_val                  dq    	0		;   r13 =   temp. value
    A_power_index               dq    	0		;   r12 =   temp. value_'s power index
    A_conversion_power_index    dq    	0		;   r11 =   r12_'s conversion f(x) index
    Div_temp_rdx_val            dq    	0		;   r10 =   placeholder for div's rdx value
    cal_fmt_index               dq    	0		;   r9  =   temp. index for cal_fmt_in_len()
    last_char_numeric           dq    	0		;   r8  =   last_char_was_number
    ;SPACE       dq    	32		; <space>
    ;SPACE       dq    	32		; <space>
    ;SPACE       dq    	32		; <space>
    ;SPACE       dq    	32		; <space>
    ;SPACE       dq    	32		; <space>

    SPACE       dq    	32		; <space>
    PLUS        dq    	43		; +
    MINUS       dq    	45		; -
    MULTI       dq    	42		; *
    DIVIDE      dq    	47		; /
    TILDE       dq    	126		; ~
    EQUAL       dq    	61		; =
    
    VARS        dq      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

    str_start       db      "The Great Grokian Math Guru beckons you to feed him some math to grind...",CR,LF, 0
    str_end         db      "Thank you for visiting Earth. We hope you make it home safely.",CR,LF, 0

    str_error_underflow   db      "Underflow Error... (-_-)",CR,LF, 0
    str_error_overflow    db      "Overflow Error... (-_-)",CR,LF, 0
    
    str_test        db      " | ",0
    str_conversion  db      "0123456789ABCDEFGHIJK",0
    str_CR_LF       db      CR,LF,0
    str_printf_old      db      "%%c : %c . %c r",CR,LF,0
    str_printf      db      "%c",CR,LF,0
    str_printf_debug      db      "%%d : %d",CR,LF, 0
    str_printf_result     db  32,32,32,32,32,32,32,32,32,32, 43, 0


section .bss

    BUFFER:     resb    80
    STACK:      resq    100





;   REFERENCE CODE SNIPPETS


;mov  ax, 5     ; ax = 5
;mov  cx, 10    ; cx = 10
;mul  cx        ; ax = ax * cx   ; actually dx:ax = ax * cx

;mov    rdx,    val ;   rdx = quotient byte_H
;mov    rax,    val ;   rax = quotient byte_L
;div    rcx,    val ;   divisor
;rdx    =   remainder
;rax    =   result

;    b[3] ->
; mov     rcx,     3
; lea     rbx,    [b]
; mov     rax,    [rbx + rcx * 4]           where 4 = quad-byte
; OR
; movzx   rax,    byte[rbx + rcx * 1]       where 1 = single-byte

;    b[3] ->
; r14 = fake STACK rsp
; lea     rbx,    [b]
; mov     rax,    [rbx + r14 * 4]           where 4 = quad-byte
; OR
; movzx   rax,    byte[rbx + rcx * 1]       where 1 = single-byte




      ;          add     rax,    '0'     ; int -> char_int
     ;           cmp     rax,    '9'     ; if('0' <= char <= '9')
    ;            jle     .print_add_char

   ;             sub     rax,    '0'     ; oops, revert to int
  ;              add     rax,    'A'     ; int -> int_alph
 ;               jmp     .print_add_char

;.print_add_char: