bits 16

org 0x100


; prints al as a hex char
%macro printHexChar 0
    cmp     al, 10                  
	jl      %%digit                 ; check if al is < 10
	add     al, 55                  ; get al into the ascii lowercase letter range
	jmp     %%print
%%digit:
	add     al, '0'                 ; get al into the ascii digit range
%%print:
	mov     ah, 0xE                 ; actually print
	int     0x10
%endmacro

section .text
main:
	cli                             ; turn off interrupts while we are working
	mov     ax, 0                   ; need to do work in segment 0
	mov     es, ax

	mov     dx, [es:0x9*4]          ; save the old offset
	mov     [previous9offset], dx
	mov     ax, [es:0x9*4+2]        ; save the old segment
	mov     [previous9segment], ax

	mov     dx, keyboard            ; offset is our keyboard function
	mov     [es:0x9*4], dx
	mov     ax, cs                  ; segment is our code segment
	mov     [es:0x9*4+2], ax
	sti


loop_until_q:
	cmp     byte [number], 0        ; have we got a keypress yet?
	je      loop_until_q            ; no so we wait in a loop

	cmp     byte [number], 0x10     ; yes, but was it a q?
	jne     print_scan_code         ; no it was not
	jmp     finish                  ; yes it was
print_scan_code:
	; print top hex digit
	mov     al, [number]            ; get the scan code
	call    printByteAsHex          ; print it

	mov     ah, 0xE                 ; also print a newline
	mov     al, 13
	int     0x10

	mov     ah, 0xE                 ; newlines are two characters now, remember?
	mov     al, 10
	int     0x10

	mov     byte [number], 0        ; reset keyboard printer
	jmp     loop_until_q 

finish:
	mov     dx, [previous9offset]   ; restore the old offset
	mov     [es:0x9*4], dx
	mov     ax, [previous9segment]  ; restore the old segment
	mov     [es:0x9*4+2], ax

	mov     ah, 0x4c                ; standard exit code
	mov     al, 0
	int     0x21

; print the character given in al
printByteAsHex:
    push    ax                      ; save al temporarily
    shr     al, 4                   ; print top 4 bits of al
    and     al, 0xF
	printHexChar
    pop     ax                      ; restore al
    and     al, 0xF                 ; print bottom 4 bits of al
    printHexChar
	ret

; our new keyboard handler
keyboard:
	push    ax                      ; save ax since we trash it and don't want to kill math
	in      al, 0x60                ; read from the keyboard scan buffer
	mov     [number], al            ; store the byte read for processing
	mov     al, 0x20                ; send an acknowledgement of read
	out     0x20, al
	pop     ax                      ; restore ax
	iret

section .data
	number: db 0
	previous9offset: dw 0
    previous9segment: dw 0

    ;   -   -   Setup Tasks Space   -   -   ;

    task_index: dw 0                ; must always be a multiple of 2
    stacks: times (256 * 2) db 0    ; 31 fake stacks of size 256 bytes
    task_status: times 2 dw 0       ; 0 means inactive, 1 means active
    stack_pointers: dw 0            ; the first pointer needs to be to the real stack !

    %assign i 1

    %rep    31
        dw stacks + (256 * i)
        %assign i i+1
    %endrep

    ;   -   -   -   -   -   -   -   -   -   ;
    
yield:
    call pusha
    call pushf

.task_check:
    cmp     task_index,     1
    jg      .task_reset

    cmp     task_index,     1
    add     task_index,     2
    
    je      .task_active
    jmp     .task_check

.task_reset:
    mov     task_index,     0
    jmp     .task_check

.task_active:
    lea     ri,     [task_status]
    mov     si,     task_index

    mov     sp,     [ri + si*2]
    ;   do something with the index stuff

    call popf
    call popa 
    iret 
