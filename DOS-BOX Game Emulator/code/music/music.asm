bits 16
org 0x100

SECTION .text

jmp start

; length goes in bx
; note goes in dx
play_note:
    mov     al, 182         ; Prepare the speaker for the
    out     43h, al         ;  note.
    mov     ax, dx          ; Frequency number (in decimal)
                            ;  for middle C.
    out     42h, al         ; Output low byte.
    mov     al, ah          ; Output high byte.
    out     42h, al 
    in      al, 61h         ; Turn on note (get value from
                            ;  port 61h).
    or      al, 00000011b   ; Set bits 1 and 0.
    out     61h, al         ; Send new value.
.pause1:
    mov     cx, 65535
.pause2:
    dec     cx
    jne     .pause2
    dec     bx
    jne     .pause1
    in      al, 61h         ; Turn off note (get value from
                            ;  port 61h).
    and     al, 11111100b   ; Reset bits 1 and 0.
    out     61h, al         ; Send new value.
    ret

start:
    mov     bx, 9
    mov     dx, 4560
    call    play_note

    mov     bx, 9
    mov     dx, 4063
    call    play_note

    mov     bx, 9
    mov     dx, 3619
    call    play_note

	mov     ah, 0x4c        ; exit
	mov     al, 0
	int     0x21