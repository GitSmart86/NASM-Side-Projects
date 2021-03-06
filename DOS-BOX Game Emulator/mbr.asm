; CpS 230 Lab 9 -- For Use With Pong
;---------------------------------------------------
; Bootloader that loads/runs a single-sector payload
; program from the boot disk.
;---------------------------------------------------
bits 16

; Our bootloader is 512 raw bytes: we treat it all as code, although
; it has data mixed into it, too.
section	.text

; The BIOS will load us into memory at 0000:7C00h; NASM needs
; to know this so it can generate correct absolute data references.
org	0x7C00

; First instruction: jump over initial data and start executing code
start:	jmp	main

; Embedded data
boot_msg	db	"CpS 230 Bootloading Pong", 13, 10
			db	"by Elisabeth Parks and Jonathan Layton", 13, 10, 0
boot_disk	db	0		; Variable to store the number of the disk we boot from
retry_msg	db	"Error reading payload from disk retrying...", 13, 10, 0

main:
	; TODO: Set DS == CS (so data addressing is normal/easy)
	mov ax, cs
    mov ds, ax
    ; TODO: Save the boot disk number (we get it in register DL
	mov [boot_disk], dl
    ; TODO: Set SS == 0x0800 (which will be the segment we load everything into later)
	mov ax, 0x800
    mov ss, ax
    ; TODO: Set SP == 0x0000 (stack pointer starts at the TOP of segment; first push decrements by 2, to 0xFFFE)
	xor sp, sp
    ; TODO: Print the boot message/banner
	lea dx, [boot_msg]
    call puts
    jmp .try
.failure:
    lea dx, [retry_msg]
    call puts
.try:
	mov ah, 0
	int 0x16
	; TODO: use BIOS raw disk I/O to load sector 2 from disk number <boot_disk> into memory at 0800:0000h (retry on failure)
	mov ax, 0x800 ; you might have to use another segment if ds doesn't contain the address you need
    mov es, ax
    mov ah, 2
    mov al, 3 ; size of your payload in bytes divided by sector size (512)
    mov ch, 0 ; floppies only have 1 track so easy to determine
    mov cl, 2 ; mbr is in sector 1 so payload starts at 2
    mov dh, 0 ; floppies only have 1 head so easy to determine
    mov dl, [boot_disk] ; this is going to vary, remember that dl is probably the current disk, check the helppc reference if you need a different disk
    mov bx, 0x0 ; whatever offset you want to load
    ; we've used literally every general purpose register for parameters!
    int 0x13
    ; the carry flag will be 0 if this worked, note disks are finicky and you may have to execute this a couple of times before it works
	jc .failure
    ; Finally, jump to address 0800h:0000h (sets CS == 0x0800 and IP == 0x0000)
	jmp	0x0800:0x0000

; print NUL-terminated string from DS:DX to screen using BIOS (INT 10h)
; takes NUL-terminated string pointed to by DS:DX
; clobbers nothing
; returns nothing
puts:
	push	ax
	push	cx
	push	si
	
	mov	ah, 0x0e
	mov	cx, 1		; no repetition of chars
	
	mov	si, dx
.loop:	mov	al, [si]
	inc	si
	cmp	al, 0
	jz	.end
	int	0x10
	jmp	.loop
.end:
	pop	si
	pop	cx
	pop	ax
	ret

; NASM mumbo-jumbo to make sure the boot sector signature starts 510 bytes from our origin
; (logic: subtract the START_ADDRESS_OF_OUR_SECTION [$$] from the CURRENT_ADDRESS [$],
;	yielding the number of bytes of code/data in the section SO FAR; then subtract
;	this size from 510 to give us BYTES_OF_PADDING_NEEDED; finally, emit
;	BYTES_OF_PADDING_NEEDED zeros to pad out the section to 510 bytes)
	times	510 - ($ - $$)	db	0

; MAGIC BOOT SECTOR SIGNATURE (*must* be the last 2 bytes of the 512 byte boot sector)
	dw	0xaa55