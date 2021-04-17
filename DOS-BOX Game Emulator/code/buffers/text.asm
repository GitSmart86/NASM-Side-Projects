bits 16
org 0x100

SECTION .text
main:
	mov     ax, 0xB800
	mov     es, ax                  ; moving directly into a segment register is not allowed
	mov     bx, 996                 ; offset for approximately the middle of the screen

	mov     ah, 0x0
	mov     al, 0x1
	int     0x10                    ; set video to text mode

    ; clear page
    mov     ah, 2
    mov     bh, 1
    mov     dh, 0
    mov     dl, 0
    int     0x10

    mov     ah, 9
    mov     al, 0x0
    mov     bh, 1
    mov     bl, 0x0
    mov     cx, 1000 ; 40 x 25
	int     0x10

    mov     ah, 2
    mov     bh, 1
    mov     dh, 12
    mov     dl, 17
    int     0x10

    ;mov     word [es:bx+0], 0x9F42  ; B dark blue background, white font
    mov     ah, 9
    mov     al, 0x42
    mov     bh, 1
    mov     bl, 0x9f
    mov     cx, 1
	int     0x10

    mov     ah, 2
    mov     bh, 1
    mov     dh, 12
    mov     dl, 18
    int     0x10
    ;mov     word [es:bx+2], 0x9F4A  ; J dark blue background, white font
    mov     ah, 9
    mov     al, 0x4A
    mov     bh, 1
    mov     bl, 0x9F
    mov     cx, 1
	int     0x10

    mov     ah, 2
    mov     bh, 1
    mov     dh, 12
    mov     dl, 19
    int     0x10
	;mov     word [es:bx+4], 0x9F55  ; U dark blue background, white font
    mov     ah, 9
    mov     al, 0x55
    mov     bh, 1
    mov     bl, 0x9F
    mov     cx, 1
	int     0x10

    mov     ah, 2
    mov     bh, 1
    mov     dh, 12
    mov     dl, 20
    int     0x10
	;mov     word [es:bx+6], 0x1F21  ; ! dark blue background, white font
    mov     ah, 9
    mov     al, 0x21
    mov     bh, 1
    mov     bl, 0x1F
    mov     cx, 1
	int     0x10

	mov     ah, 0x0                 ; wait for user input
	int     0x16

    mov     ah, 5
    mov     al, 1
    int     0x10

    mov     ah, 0x0                 ; wait for user input
	int     0x16

	mov     ah, 0x4c                ; exit
	mov     al, 0
	int     0x21