bits 16
org	0x100     ;   this is for .com
; org	0x0     ;   this is for .img

;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;   Table of Contents:
;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
; .TODO
; move_ball
; move_paddle_ai
; move_paddle_player
; game_active_toggle
; draw_paddle_player
; draw_paddle_ai
; draw_ball
; draw_endgame
; draw_startgame
; draw_score_player
; draw_score_ai
; draw_border_mid
; collide_paddle
; collide_border
; launch_ball



; .R_DATA      =   stores const variables, mostly being prompt strings.
;
;                main_str
;                main_a
;                main_b
;                main_c
;                main_d
;
; .DATA       =   stores dynamic variables.
;
;                game_border_right:
;                game_border_left:
;                game_border_top:
;                game_border_bot:
;                game_border_mid:
;                game_active:
;                game_diff:
;            
;                ball_vel_x:
;                ball_vel_y:
;                ball_pose_x:
;                ball_pose_y:
;            
;                paddle_ai_x:
;                paddle_ai_y:
;                paddle_ai_speed:
;                paddle_ai_range:
;                paddle_ai_score:
;            
;                paddle_player_x:
;                paddle_player_y:
;                paddle_player_speed:
;                paddle_player_score:
;
;xxxxxxxx main() xxxxxxxx
;
; .TEXT
;                main:
;               .main_loop:
;               .main_end:
;
;xxxxxxxx Tasks() xxxxxxxx
;              
;               task_a:
;                .loop_a:
;
;
;                task_b:
;                .loop_b:
;
;
;                task_c:
;                .loop_c:
;
;
;                task_d:
;                .loop_d:
;
;xxxxxxxx Utilities() xxxxxxxx
;                
;                putstring:
;               .putstring_loop:
;               .putstring_end:
;
;xxxxxxxx Yield() xxxxxxxx
;                
;                task_init:
;               .task_init_loop:
;               .task_init_continue:
;               .task_init_end:
;
;
;                yield:
;               .yield_inc_index:
;               .yield_check_index:
;               .yield_found_active_task:
;
;
; .DATA        =   stores Yield() vars
;
;                current_task_index:
;                stack_status_array:      ...
;                stack:
;                stack_pointer_array:    ...
;
;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx


;ㅡㅡㅡㅡㅡㄴ      .R_DATA     ㄱㅡㅡㅡㅡㅡ
section .rdata

    main_str: db "Hello, task main", 13, 10, 0
    main_a: db "Hello, task a", 13, 10, 0
    main_b: db "Hello, task b", 13, 10, 0
    main_c: db "Hello, task c", 13, 10, 0
    main_d: db "Hello, task d", 13, 10, 0

;ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

;ㅡㅡㅡㅡㅡㄴ      .DATA       ㄱㅡㅡㅡㅡㅡ
section .data
    game_border_right:  db 80
    game_border_mid:    db 40
    game_border_left:   db 0
    game_border_top:    db 1
    game_border_bot:    db 25
    game_active:        db 1

    ball_vel_x:         db 0
    ball_vel_y:         db 0
    ball_pose_x:        db 0
    ball_pose_y:        db 0
    ball_width:         db 0
    ball_height:        db 0
    ball_asii:          dw 0x0FFE
    ball_asii_pose:     dw 2000

    paddle_ai_x:        db 0
    paddle_ai_y:        db 12
    paddle_ai_width:    db 1
    paddle_ai_height:   db 1
    paddle_ai_speed:    db 0
    paddle_ai_range:    db 0
    paddle_ai_score:    db 0
    paddle_ai_asii:         dw 0x1CDB
    paddle_ai_asii_pose:    dw 1920

    paddle_player_x:        db 80
    paddle_player_y:        db 12
    paddle_player_width:    db 1
    paddle_player_height:   db 1
    paddle_player_speed:    db 1
    paddle_player_score:    db 0
    paddle_player_asii:         dw 0x19DB
    paddle_player_asii_pose:    dw 2078

;ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ


;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;   .TEXT
;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx


;ㅡㅡㅡㅡㅡㄴ  Main Switcher   ㄱㅡㅡㅡㅡㅡ
    
section .text
main:
	mov	ax, cs
	mov	ds, ax

    mov     si, task_a
    call    task_init

    mov     si, task_b
    call    task_init

    mov     si, task_c
    call    task_init

    mov     si, task_d
    call    task_init

.main_loop:
    mov     dx, main_str
    call    putstring
    call    yield

    ; sleep for 30 fps
	mov ah, 0x86
	mov cx, 0
	mov dx, 33333
	int 15h
    ; jmp     .main_loop

	; mov     ah, 0x0                 ; wait for user input
	; int     0x16

.main_end:
	mov	    ah, 0x4c
	mov	    al, 0
	int	    0x21	

;ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ


;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;   Tasks
;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

    
;ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ


;ㅡㅡㅡㅡㅡㄴ      Task A - Player Input      ㄱㅡㅡㅡㅡㅡ

task_a:
.loop_a:
    mov     dx, main_a
    call    putstring

    ;   code here...

    call    yield
    jmp     .loop_a
    
;ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ


;ㅡㅡㅡㅡㅡㄴ      Task B - Ball & AI Movement      ㄱㅡㅡㅡㅡㅡ

task_b:
.loop_b:
    mov     dx, main_b
    call    putstring

    ;   code here...

	; MOVE BALL
	mov ax, [ball_vel_x]
	mov bx, [ball_vel_y]
	add [ball_pose_x], ax
	add [ball_pose_y], bx
	cmp byte [ball_pose_y], AI_Y_POS + PLAYER_HEIGHT
	jb .ai_line		; Ball is above ai, do smthng!
	cmp byte [ball_pose_y], PLAYER_Y_POS - BALL_SIZE
	ja .player_line		; Ball is below player, do smthng!
	jmp .check_horizontal	; Ball is somewhere in the field, just check
				; if it hits the wall.

.ai_line:
	mov ax, [ai_x]	; Check if ai_x <= ball_pose_x <= ai_x +
	cmp [ball_pose_x], ax	; player_width
	jb .player_point	; If yes, flip the y_step of the ball.
	add ax, PLAYER_WIDTH	; Else give the player a point.
	cmp [ball_pose_x], ax
	ja .player_point
	; BALL HIT AI
	neg byte [ball_step_y]
	jmp .check_horizontal	; Just check, if the ball is in the corner.

.player_line:
	mov ax, [player_x]	; Check if player_x <= ball_pose_x <= player_x +
	cmp [ball_pose_x], ax	; player_width
	jb .ai_point		; If yes, flip the y_step of the ball.
	add ax, PLAYER_WIDTH	; Else give the ai a point.
	cmp [ball_pose_x], ax
	ja .ai_point
	; BALL HIT PLAYER
	neg byte [ball_step_y]
	jmp .check_horizontal	; Check if ball is in the corner.

.player_point:
	call ball_reset
	inc byte [score_player]
	jmp .check_horizontal

.ai_point:
	call ball_reset
	inc byte [score_ai]

.check_horizontal:
	mov ax, [ball_pose_x]
	cmp ax, 0
	jb .flip_horizontal
	cmp ax, SCREEN_WIDTH - BALL_SIZE
	jb .end_move_ball	

.flip_horizontal:
	; Ball hits the wall, change its direction.
	neg byte [ball_step_x]

.end_move_ball:

	; MOVE PLAYER AND AI
	mov ah, 01h
	int 16h			; Interrupt, get keyboardstatus
	je .move_player_done	; If no key was pressed, zero_flag=1
	mov ah, 00h		; If there was a key pressed, get that key in ax
	int 16h
	cmp ah, KEY_LEFT	; Scancode stored in ah
	je .player_left
	cmp ah, KEY_RIGHT
	je .player_right
	cmp ah, KEY_A
	je .ai_left
	cmp ah, KEY_D
	je .ai_right
	jmp .move_player_done

.player_right:
	cmp byte [player_x], SCREEN_WIDTH - (PLAYER_STEP_SIZE + PLAYER_WIDTH)
	ja .move_player_done
	add byte [player_x], PLAYER_STEP_SIZE
	jmp .move_player_done

.player_left:	
	cmp byte [player_x], PLAYER_STEP_SIZE
	jb .move_player_done
	sub byte [player_x], PLAYER_STEP_SIZE
	jmp .move_player_done

.ai_right:
	cmp byte [ai_x], SCREEN_WIDTH - (PLAYER_STEP_SIZE + PLAYER_WIDTH)
	ja .move_player_done
	add byte [ai_x], PLAYER_STEP_SIZE
	jmp .move_player_done

.ai_left:	
	cmp byte [ai_x], PLAYER_STEP_SIZE
	jb .move_player_done
	sub byte [ai_x], PLAYER_STEP_SIZE

.move_player_done:
	; Clear the screen
	;push word 0
	;push word 0
	;push word 320
	;push word 200
	;mov ah, 0
	;call draw_rect
	call set_video_mode

.ball_reset:
	mov byte [ball_x], BALL_START_X
	mov byte [ball_y], BALL_START_Y
    ret


    ;   -   -   -   -   -   -   -
    call    yield
    jmp     .loop_b
    
;ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ


;ㅡㅡㅡㅡㅡㄴ      Task C - Graphics      ㄱㅡㅡㅡㅡㅡ

task_c:
.loop_c:
    ; mov     dx, main_c
    ; call    putstring

	mov     ah, 0x0
	mov     al, 0x2
	int     0x10                    ; set video to text mode

    mov     ax, 0xB800
	mov     es, ax                  ; moving directly into a segment register is not allowed

    ;   Print Paddle_AI
    mov     bx,     [paddle_ai_asii_pose]
    mov     dx,     [paddle_ai_asii]
	mov     word [es:bx], dx
    
    ;   Print Ball
    mov     bx,     [ball_asii_pose]
    mov     dx,     [ball_asii]
	mov     word [es:bx], dx
    
    ;   Print Paddle Player
    mov     bx,     [paddle_player_asii_pose]
    mov     dx,     [paddle_player_asii]
	mov     word [es:bx], dx
    
    ;   Print Header
    ;   -    AI Score: n     > Press Enter to Launch the Ball <     Player Score: n    -
	mov     word [es:0],    0x0FDB ; ㅁ

	mov     word [es:12],   0x0F41 ; A
	mov     word [es:14],   0x0F49 ; I
	mov     word [es:18],   0x0F53 ; S
	mov     word [es:20],   0x0F63 ; c
	mov     word [es:22],   0x0F6F ; o
	mov     word [es:24],   0x0F72 ; r
	mov     word [es:26],   0x0F65 ; e
	mov     word [es:28],   0x0F3A ; :

    mov     dx,     [ball_asii]
	mov     word [es:32],   dx

	mov     word [es:126],  0x0F50 ; P
	mov     word [es:128],  0x0F6C ; l
	mov     word [es:130],  0x0F61 ; a
	mov     word [es:132],  0x0F79 ; y
	mov     word [es:134],  0x0F65 ; e
	mov     word [es:136],  0x0F72 ; r
	mov     word [es:140],  0x0F53 ; S
	mov     word [es:142],  0x0F63 ; c
	mov     word [es:144],  0x0F6F ; o
	mov     word [es:146],  0x0F72 ; r
	mov     word [es:148],  0x0F65 ; e
	mov     word [es:150],  0x0F3A ; :
    
    mov     dx,     [ball_asii]
	mov     word [es:154], dx

	mov     word [es:158],  0x0FDB ; ㅁ

    cmp     byte [game_active], 0
    je      .print_prompt

.print_end:
	mov     ah, 0x4c                ; exit
	mov     al, 0
	int     0x21

    call    yield
    jmp     .loop_c

    
.print_prompt:
	mov     word [es:42],   0x0F10 ; >>
	mov     word [es:46],   0x0F50 ; P
	mov     word [es:48],   0x0F72 ; r
	mov     word [es:50],   0x0F65 ; e
	mov     word [es:52],   0x0F73 ; s
	mov     word [es:54],   0x0F73 ; s

	mov     word [es:58],   0x0F45 ; E
	mov     word [es:60],   0x0F6E ; n
	mov     word [es:62],   0x0F74 ; t
	mov     word [es:64],   0x0F65 ; e
	mov     word [es:66],   0x0F72 ; r

	mov     word [es:70],   0x0F74 ; t
	mov     word [es:72],   0x0F6F ; o

	mov     word [es:76],   0x0F4C ; L
	mov     word [es:78],   0x0F61 ; a
	mov     word [es:80],   0x0F75 ; u
	mov     word [es:82],   0x0F6E ; n
	mov     word [es:84],   0x0F63 ; c
	mov     word [es:86],   0x0F68 ; h

	mov     word [es:90],   0x0F74 ; t
	mov     word [es:92],   0x0F68 ; h
	mov     word [es:94],   0x0F65 ; e

	mov     word [es:98],   0x0F42 ; B
	mov     word [es:100],  0x0F61 ; a
	mov     word [es:102],  0x0F6C ; l
	mov     word [es:104],  0x0F6C ; l
	mov     word [es:108],  0x0F11 ; <<
    
    jmp     .print_end
    
;ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ


;ㅡㅡㅡㅡㅡㄴ      Task D - Music      ㄱㅡㅡㅡㅡㅡ

task_d:
.loop_d:
    mov     dx, main_d
    call    putstring

    ;   code here...

    call    yield
    jmp     .loop_d

;ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ


;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;   Utility Functions
;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx


;ㅡㅡㅡㅡㅡㄴ    Move_Ball     ㄱㅡㅡㅡㅡㅡ
move_ball:
	push	ax
	push	cx
	push	si

    mov     ax,             ball_pose_y

.check_top:
    mov     bx,             game_border_top
    cmp     ax,             bx
    jl      .check_bot
    mov     si,             ball_vel_y
    neg     si
    mov     ball_pose_y,    word [si]
    jmp     .inc_y

.check_bot:
    mov     bx,             game_border_bot
    cmp     ax,             bx
    jg      .inc_y
    mov     si,             ball_vel_y
    neg     si
    mov     ball_pose_y,    si
    jmp     .inc_y

.inc_y:
    add     ax,             ball_vel_y
    mov     [ball_pose_y],  ax

;   -   -   -   -   -   -   -   -   -   -   -

    mov     ax,             ball_pose_x

.check_right:
    mov     bx,             game_border_right
    cmp     ax,             bx
    jl      .check_left
    mov     si,             ball_vel_x
    neg     si
    mov     ball_pose_x,    si
    jmp     .inc_x

.check_left:
    mov     bx,             game_border_left
    cmp     ax,             bx
    jg      .inc_x
    mov     si,             ball_vel_x
    neg     si
    mov     ball_pose_x,    si
    jmp     .inc_x

.inc_x:
    add     ax,             ball_vel_x
    mov     [ball_pose_x],  ax



.move_ball_end:
	pop	    si
	pop	    cx
	pop	    ax
	ret

;ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ


;ㅡㅡㅡㅡㅡㄴ   Print String    ㄱㅡㅡㅡㅡㅡ

;    mov     dx, <str_const>
;    call    putstring

putstring:
	push	ax
	push	cx
	push	si
	mov	    ah, 0x0e
	mov	    si, dx
.putstring_loop:	    
    mov	al, [si]
	inc	    si
	cmp	    al, 0
	jz	    .putstring_end
	int	    0x10
	jmp	    .putstring_loop
.putstring_end:
	pop	    si
	pop	    cx
	pop	    ax
	ret

;ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ


;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;   Cooperative Functions
;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx


;ㅡㅡㅡㅡㅡㄴ    Init Task     ㄱㅡㅡㅡㅡㅡ

;    mov     si, <task_function_const>
;    call    task_init

task_init:
    xor     cx,         cx                          ; cx = stack_status_index = 0
    lea     bx,         [stack_status_array]
    
.task_init_loop:
    cmp     cx,         word [net_tasks_cnt]        
    jl      .task_init_search
    ret                                             ; if(no free tasks) return

.task_init_search:
    cmp     byte [bx],  0
    je      .task_init_found                        ; if(stack_status_index == inactive)
    inc     cx                                      ; else: inc + search again   
    inc     bx
    jmp     .task_init_loop

.task_init_found:
    mov     byte [bx],  1                           ; since(stack_status_index == inactive) stack_status_addr = 1

    lea     bx,         [stack_pointer_array]
    mov     [bx],       sp                          ; save main_addr -> stack_pointer_array[ index ]
                    
    add     bx,         cx                          ; inc index
    add     bx,         cx                          ; inc twice, because index is dw, not db
    mov     sp,         [bx]                        ; sp = stack_pointer_array[ free zone ]

    push    si                                      ; save
    pusha
    pushf
    mov     [bx],       sp                          ; stack_pointer_array[ free zone ] = free_zone_addr
    
    mov     sp,         [stack_pointer_array]       ; sp = main_addr (ie: stack_pointer_array[ 0 ] )
    ret

;ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

;ㅡㅡㅡㅡㅡㄴ    Yield Task    ㄱㅡㅡㅡㅡㅡ

;   no setup needed

yield:
    pusha
    pushf
    movzx   cx,         byte [current_task_index]
    
    lea     bx,         [stack_pointer_array]       ; save current stack pointer
    add     bx,         cx
    add     bx,         cx
    mov     [bx],       sp
    
    lea     bx,         [stack_status_array]        ; loop through stack_status_array, until (status == 1)
    add     bx,         cx                          

.yield_inc_index:
    inc     bx
    inc     cx
    cmp     cx,         word [net_tasks_cnt]
    jl      .yield_check_index
    xor     cx,         cx
    lea     bx,         [stack_status_array]        ; reset index back to 0

.yield_check_index:
    cmp     byte [bx],  1                           
    jne     .yield_inc_index                        ; if(task == inactive) restart search
    mov     [current_task_index], cl                ; else: current_task_index = stack_status_array[ index ]

    lea     bx,         [stack_pointer_array]       ; setup new stack
    add     bx,         cx                          ; inc index
    add     bx,         cx                          ; inc twice, because index is dw, not db
    mov     sp,         [bx]                        
    popf
    popa
    ret

;ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

;ㅡㅡㅡㅡㅡㄴ  Init Task .DATA ㄱㅡㅡㅡㅡㅡ
section .data

    net_tasks_cnt: dw 5                 ; task_main + task_cnt = 5
    current_task_index: db 0

    stack_status_array:
    status_main: db 1
    status_A: db 0
    status_B: db 0
    status_C: db 0
    status_D: db 0

    stack: times 256 * 4 db 0           ; init stack
    stack_pointer_array:
    dw 0                                ; Main   addr
    dw stack + 256                      ; task a addr
    dw stack + 512                      ; task b addr
    dw stack + 768                      ; task c addr
    dw stack + 1024                     ; task d addr

;ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ