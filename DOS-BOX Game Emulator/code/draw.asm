
;ㅡㅡㅡㅡㅡㄴ    Draw Object     ㄱㅡㅡㅡㅡㅡ

;    mov     al, <obj_color>
;    mov     bx, <obj_pose_x>
;    mov     cx, <obj_pose_y>
;    mov     dx, <obj_width>
;    mov     si, <obj_height>
;    call    draw_obj

;   NOTE: the object will draw down-right from origin_pose
;   bp = default_pose_x
;   si = max_x
;   di = max_y

draw_obj:
	push    bp

	mov     bp,     cx      ; default_pose_y = pose_y
	add     si,     cx      ; max_y = height + pose_y
	mov     di,     bx      ; 
	add     di,     dx      ; max_x = pose_x + width

	mov     ah,     0xc
	xor     bh,     bh

.draw_obj_row:
	cmp     bx,     di      ; if(current_x == max_x)
	ja      .draw_obj_end

.draw_obj_col:
	int     0x10
	inc     cx

	cmp     cx,     di      ; if(current_y < max_y)
	jb      .draw_obj_col

	inc     bx              ; current_x ++
	mov     cx,     bp      ; current_y = default_pose_y
	jmp     .draw_obj_row

.draw_obj_end:
	pop bp
	ret

;ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
