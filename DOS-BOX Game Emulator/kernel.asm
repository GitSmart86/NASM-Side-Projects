bits 16
org	0x100       ;   this is for .com
; org	0x0     ;   this is for .img

;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;   Hex State-Logic Table:
;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
;   game_active : game_new_game : game_ai_win : game_player_win    ->    x : x : x : x   ->  numeric value
;   
;
;   menu  =  0 : 1 : x : x
;   menu  =  4      "init menu"
;   menu  =  5      "player win menu"
;   menu  =  6      "AI win menu"
;       "Enter" sets game_mode  = 8
;               - game_active       = 1 
;               - game_new_game     = 0
;               - game_ai_win       = 0
;               - game_player_win   = 0
;
;
;   in-game  =  1 : 0 : 0 : 0
;   in-game  =  8
;       "Enter" sets game_mode  = 0
;               - game_active       = 0 
;               - game_new_game     = 0
;               - game_ai_win       = 0
;               - game_player_win   = 0
;
;
;   out-game  =  0 : 0 : 0 : 0
;   out-game  =  0
;       "Enter" sets game_mode  = 8
;               - game_active       = 1 
;               - game_new_game     = 0
;               - game_ai_win       = 0
;               - game_player_win   = 0
;
;
;
;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;   Table of Contents:
;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;
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
;                game_border_mid:    
;                game_border_left: 
;                game_border_top:   
;                game_border_bot:   
;                game_mode:          
;                game_max_score:     
;
;                ;   -   -   Game Objects    -   -   ; 
;
;                ball_vel_x:        
;                ball_vel_y:       
;                ball_pose_x:     
;                ball_pose_y:     
;                ball_asii:          
;                ball_asii_pose:    
;
;                paddle_ai_x:   
;                paddle_ai_y:        
;                paddle_ai_speed:   
;                paddle_ai_range:    
;                paddle_ai_score:    
;                paddle_ai_asii:         
;                paddle_ai_asii_pose:    
;
;                paddle_player_x:      
;                paddle_player_y:    
;                paddle_player_speed:   
;                paddle_player_score:   
;                paddle_player_asii:        
;                paddle_player_asii_pose:  
;
;                ;   -   -   Menu Balls  -   -   ;
;
;                ball_1_vel_x:   
;                ball_1_vel_y:    
;                ball_1_pose_x:    
;                ball_1_pose_y:   
;                ball_1_asii:         
;                ball_1_asii_pose: 
;
;                ball_2_vel_x:    
;                ball_2_vel_y:    
;                ball_2_pose_x:      
;                ball_2_pose_y:        
;                ball_2_asii:          
;                ball_2_asii_pose:     
;
;                ball_3_vel_x:  
;                ball_3_vel_y:         
;                ball_3_pose_x:       
;                ball_3_pose_y:      
;                ball_3_asii:         
;                ball_3_asii_pose:    

;                ball_4_vel_x:     
;                ball_4_vel_y:      
;                ball_4_pose_x:     
;                ball_4_pose_y:
;                ball_4_asii:
;                ball_4_asii_pose:
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
;                       .which_key_pressed:
;                       .move_player_up:
;                       .move_player_down:
;                       .esc_pressed:
;                       .enter_pressed:
;                       .input_restart_game:
;                       .input_ingame_pause:
;                       .input_ingame_resume:
;                       .input_end:
;
;
;                task_b: 
;                .loop_b:
;                                              ;   -   -   -   -   MENU Movement    -   -   -   -   ;
;                       .menu_move_balls:
;                                              ; -   -  Move_Ball_1  Y   -   -
;                       .ball_1_inc_y:
;                       .ball_1_invert_vel_y:
;                                              ; -   -  Move_Ball_1  X   -   -
;                       .ball_1_inc_x:
;                       .ball_1_invert_vel_x:
;                                              ; -   -  Move_Ball_2  Y   -   -
;                       .ball_2_inc_y:
;                       .ball_2_invert_vel_y:
;                                              ; -   -  Move_Ball_2  X   -   -
;                       .ball_2_inc_x:    
;                       .ball_2_invert_vel_x:
;                                              ; -   -  Move_Ball_3  Y   -   -
;                       .ball_3_inc_y:
;                       .ball_3_invert_vel_y:
;                                              ; -   -  Move_Ball_3  X   -   -
;                       .ball_3_inc_x:    
;                       .ball_3_invert_vel_x:
;                                              ; -   -  Move_Ball_4  Y   -   -
;                       .ball_4_inc_y:
;                       .ball_4_invert_vel_y:
;                                              ; -   -  Move_Ball_4  X   -   -
;                       .ball_4_inc_x:    
;                       .ball_4_invert_vel_x:
;                                              ;   -   -   -   -   IN-GAME Movement    -   -   -   -   ;
;                       .ingame_move_ball:
;                                              ; -   -  Ball Y   -   -
;                       .ball_invert_vel_y:
;                                              ; -   -  AI   -   -
;                       .move_paddle_ai:
;                       .move_ai_up:
;                       .move_ai_down:
;                                              ; -   -  Ball X   -   -
;                       .ball_check_x:
;                       .check_left:
;                       .score_pt_player:
;                       .check_right:
;                       .score_pt_ai:
;                       .reset_field:
;                       .set_winner:
;                       .set_winner_ai:
;                       .set_winner_player:
;                                              ;   -   -   -   -   -   -   -
;                       .move_end:
;
;
;                task_c:
;                .loop_c:;
;                        .print_clean_screen:
;                                            ;   -   -   -   -   MENU Graphics    -   -   -   -   ;
;                        .update_menu_ascii_pose:
;                        .setup_menu_ascii_video_mode:
;                        .print_menu_ascii_art:
;                        .print_win_text:
;                        .print_win_ai_text:
;                        .print_win_player_text:
;                                            ;   -   -   -   -   IN-GAME Graphics    -   -   -   -   ;
;                        .update_ingame_ascii_pose:
;                        .setup_ingame_ascii_video_mode:
;                        .print_ingame_ascii_art:
;                        .print_prompt_resume:
;                        .print_end:
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
    main_b: dw "Hello, task b", 13, 10, 0
    main_c: db "Hello, task c", 13, 10, 0
    main_d: db "Hello, task d", 13, 10, 0

;ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

;ㅡㅡㅡㅡㅡㄴ      .DATA       ㄱㅡㅡㅡㅡㅡ
section .data
    game_border_right:  dw 79
    game_border_mid:    dw 40
    game_border_left:   dw 0
    game_border_top:    dw 1
    game_border_bot:    dw 24
    game_mode:          dw 4
    game_max_score:     dw 4

    ;   -   -   Game Objects    -   -   ; 

    ball_vel_x:         dw 1
    ball_vel_y:         dw 1
    ball_pose_x:        dw 40
    ball_pose_y:        dw 12
    ball_asii:          dw 0x0FFE
    ball_asii_pose:     dw 2000

    paddle_ai_x:        dw 0
    paddle_ai_y:        dw 12
    paddle_ai_speed:    dw 1
    paddle_ai_range:    dw 5
    paddle_ai_score:    dw 0
    paddle_ai_asii:         dw 0x1CDB
    paddle_ai_asii_pose:    dw 1920

    paddle_player_x:        dw 80
    paddle_player_y:        dw 12
    paddle_player_speed:    dw 1
    paddle_player_score:    dw 0
    paddle_player_asii:         dw 0x19DB
    paddle_player_asii_pose:    dw 2078

    ;   -   -   Menu Balls  -   -   ;

    ball_1_vel_x:         dw 1
    ball_1_vel_y:         dw 1
    ball_1_pose_x:        dw 40
    ball_1_pose_y:        dw 12
    ball_1_asii:          dw 0x0FFE
    ball_1_asii_pose:     dw 2000

    ball_2_vel_x:         dw -1
    ball_2_vel_y:         dw 1
    ball_2_pose_x:        dw 40
    ball_2_pose_y:        dw 12
    ball_2_asii:          dw 0x0FFE
    ball_2_asii_pose:     dw 2000

    ball_3_vel_x:         dw 1
    ball_3_vel_y:         dw -1
    ball_3_pose_x:        dw 40
    ball_3_pose_y:        dw 12
    ball_3_asii:          dw 0x0FFE
    ball_3_asii_pose:     dw 2000

    ball_4_vel_x:         dw -1
    ball_4_vel_y:         dw -1
    ball_4_pose_x:        dw 40
    ball_4_pose_y:        dw 12
    ball_4_asii:          dw 0x0FFE
    ball_4_asii_pose:     dw 2000

    ;   -   -   Menu Balls  -   -   ;

    int9_segment:         dw 0
    int9_isr:             dw 0
    keypress:             db 0

;ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ


;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;   .TEXT
;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx


;ㅡㅡㅡㅡㅡㄴ  Main Switcher   ㄱㅡㅡㅡㅡㅡ
    
section .text
main:
	mov	ax, cs
	mov	ds, ax

    cli                             ; turn off interrupts while we are working
	mov     ax, 0                   ; need to do work in segment 0
	mov     es, ax

	mov     dx, [es:0x9*4]          ; save the old offset
	mov     [int9_isr], dx
	mov     ax, [es:0x9*4+2]        ; save the old segment
	mov     [int9_segment], ax

	mov     dx, keyboard            ; offset is our keyboard function
	mov     [es:0x9*4], dx
	mov     ax, cs                  ; segment is our code segment
	mov     [es:0x9*4+2], ax
	sti

    mov     si, task_a
    call    task_init

    mov     si, task_b
    call    task_init

    mov     si, task_c
    call    task_init

    mov     si, task_d
    call    task_init

.main_loop:
    ; mov     dx, main_str
    ; call    putstring
    call    yield

    ; sleep for 30 fps
	mov ah, 0x86
	mov cx, 0
	mov dx, 33333
	int 15h

    jmp     .main_loop

main_end:
	mov	    ah, 0x4c
	mov	    al, 0
	int	    0x21	

;ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;   Interrupts
;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

keyboard:
	push    ax                      ; save ax since we trash it and don't want to kill math
	in      al, 0x60                ; read from the keyboard scan buffer
	mov     [keypress], al          ; store the byte read for processing
	mov     al, 0x20                ; send an acknowledgement of read
	out     0x20, al
	pop     ax                      ; restore ax
	iret

;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;   Tasks
;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

    
;ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ


;ㅡㅡㅡㅡㅡㄴ      Task A - Player Input      ㄱㅡㅡㅡㅡㅡ

task_a:
.loop_a:
    ; mov     dx, main_a
    ; call    putstring
    
    ; TODO_1: Add keyboard input sensitivity
    cmp     byte [keypress], 0
    jne     .which_key_pressed
    jmp     .input_end


.which_key_pressed:
    cmp     ax, 0x011B ;Esc
    je      .esc_pressed
    cmp     ax, 0x1C0D ;Enter
    je      .enter_pressed
    cmp     ax, 0x4800 ;Up Arrow
    je      .move_player_up
    cmp     ax, 0x5000 ;Down Arrow
    je      .move_player_down
    
    jmp .input_end

.move_player_up:
    ; if (game_mode = 8 & input = UP)
    ;   NOTE: y-axis is inverted
    dec word [paddle_player_y]
    jmp .input_end

.move_player_down:
    ; if (game_mode = 8 & input = DOWN)
    ;   NOTE: y-axis is inverted
    inc word [paddle_player_y]
    jmp .input_end

.esc_pressed:
    ; if (input = ESC)
    ;   Quit Program
    call main_end

.enter_pressed:
    ; if (game_mode = 8 & input = ENTER)
    ;   PAUSE
    cmp word [game_mode], 8
    je .input_ingame_pause

    ; if (game_mode = 0 & input = ENTER)
    ;   RESUME
    cmp word [game_mode], 0
    je .input_ingame_resume 
    
    ; if (game_mode = 4 & input = ENTER)
    ;   restart_game
    cmp word [game_mode], 4
    je .input_restart_game

    ; if (game_mode = 5 & input = ENTER)
    ;   restart_game
    cmp word [game_mode], 5
    je .input_restart_game

    ; if (game_mode = 6 & input = ENTER)
    ;   restart_game 
    cmp word [game_mode], 6
    je .input_restart_game

.input_restart_game:
    mov     word [game_mode], 8  
    mov     word [ball_vel_x], 1  
    mov     word [ball_vel_y], 1  
    mov     word [ball_pose_x], 40  
    mov     word [ball_pose_y], 12  
    mov     word [ball_asii_pose], 8  
    mov     word [paddle_ai_y], 12  
    mov     word [paddle_ai_score], 0  
    mov     word [paddle_ai_asii_pose], 1920  
    mov     word [paddle_player_y], 12  
    mov     word [paddle_player_score], 0  
    mov     word [paddle_player_asii_pose], 2078  

    jmp .input_end

.input_ingame_pause:
    mov     word [game_mode], 0
    jmp .input_end

.input_ingame_resume:
    mov     word [game_mode], 8  
    jmp .input_end

.input_end:
    mov     byte [keypress], 0
    call    yield
    jmp     .loop_a
    
;ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ


;ㅡㅡㅡㅡㅡㄴ      Task B - Ball & AI Movement      ㄱㅡㅡㅡㅡㅡ

task_b:
.loop_b:
    ; mov     dx, main_b
    ; call    putstring

    cmp word [game_mode], 8
    je  .jmp_ingame_move_ball
    
    cmp word [game_mode], 0
    je  .jmp_move_end

    jmp .menu_move_balls

.jmp_ingame_move_ball:
 jmp .ingame_move_ball
 
.jmp_move_end:
 jmp .move_end


;   -   -   -   -   MENU Movement    -   -   -   -   ;


.menu_move_balls:

    ; -   -  Move_Ball_1  Y   -   -

.ball_1_inc_y:
	mov bx, [ball_1_vel_y]
	add [ball_1_pose_y], bx

    mov cx, [game_border_top]  
    cmp word [ball_1_pose_y], cx
    jbe  .ball_1_invert_vel_y
    
    mov cx, [game_border_bot]  
    cmp word [ball_1_pose_y], cx
    jae  .ball_1_invert_vel_y

    jmp .ball_1_inc_x

.ball_1_invert_vel_y:
	neg word [ball_1_vel_y]

    ; -   -  Move_Ball_1  X   -   -

.ball_1_inc_x:
	mov ax, [ball_1_vel_x]
	add [ball_1_pose_x], ax

    mov cx, [game_border_left]  
    cmp word [ball_1_pose_x], cx
    jbe  .ball_1_invert_vel_x
    
    mov cx, [game_border_right]  
    cmp word [ball_1_pose_x], cx
    jae  .ball_1_invert_vel_x

    jmp  .ball_2_inc_y
    
.ball_1_invert_vel_x:
	neg word [ball_1_vel_x]

    ; -   -  Move_Ball_2  Y   -   -

.ball_2_inc_y:
	mov bx, [ball_2_vel_y]
	add [ball_2_pose_y], bx

    mov cx, [game_border_top]  
    cmp word [ball_2_pose_y], cx
    jbe  .ball_2_invert_vel_y
    
    mov cx, [game_border_bot]  
    cmp word [ball_2_pose_y], cx
    jae  .ball_2_invert_vel_y

    jmp .ball_2_inc_x

.ball_2_invert_vel_y:
	neg word [ball_2_vel_y]

    ; -   -  Move_Ball_2  X   -   -

.ball_2_inc_x:
	mov ax, [ball_2_vel_x]
	add [ball_2_pose_x], ax

    mov cx, [game_border_left]  
    cmp word [ball_2_pose_x], cx
    jbe  .ball_2_invert_vel_x
    
    mov cx, [game_border_right]  
    cmp word [ball_2_pose_x], cx
    jae  .ball_2_invert_vel_x

    jmp  .ball_3_inc_y
    
.ball_2_invert_vel_x:
	neg word [ball_2_vel_x]

    ; -   -  Move_Ball_3  Y   -   -

.ball_3_inc_y:
	mov bx, [ball_3_vel_y]
	add [ball_3_pose_y], bx

    mov cx, [game_border_top]  
    cmp word [ball_3_pose_y], cx
    jbe  .ball_3_invert_vel_y
    
    mov cx, [game_border_bot]  
    cmp word [ball_3_pose_y], cx
    jae  .ball_3_invert_vel_y

    jmp .ball_3_inc_x

.ball_3_invert_vel_y:
	neg word [ball_3_vel_y]

    ; -   -  Move_Ball_3  X   -   -

.ball_3_inc_x:
	mov ax, [ball_3_vel_x]
	add [ball_3_pose_x], ax

    mov cx, [game_border_left]  
    cmp word [ball_3_pose_x], cx
    jbe  .ball_3_invert_vel_x
    
    mov cx, [game_border_right]  
    cmp word [ball_3_pose_x], cx
    jae  .ball_3_invert_vel_x

    jmp  .ball_4_inc_y
    
.ball_3_invert_vel_x:
	neg word [ball_3_vel_x]

    ; -   -  Move_Ball_4  Y   -   -

.ball_4_inc_y:
	mov bx, [ball_4_vel_y]
	add [ball_4_pose_y], bx

    mov cx, [game_border_top]  
    cmp word [ball_4_pose_y], cx
    jbe  .ball_4_invert_vel_y
    
    mov cx, [game_border_bot]  
    cmp word [ball_4_pose_y], cx
    jae  .ball_4_invert_vel_y

    jmp .ball_4_inc_x

.ball_4_invert_vel_y:
	neg word [ball_4_vel_y]

    ; -   -  Move_Ball_4  X   -   -

.ball_4_inc_x:
	mov ax, [ball_4_vel_x]
	add [ball_4_pose_x], ax

    mov cx, [game_border_left]  
    cmp word [ball_4_pose_x], cx
    jbe  .ball_4_invert_vel_x
    
    mov cx, [game_border_right]  
    cmp word [ball_4_pose_x], cx
    jae  .ball_4_invert_vel_x

    jmp .move_end
    
.ball_4_invert_vel_x:
	neg word [ball_4_vel_x]

    jmp .move_end


;   -   -   -   -   IN-GAME Movement    -   -   -   -   ;


.ingame_move_ball:

    ; -   -  Ball Y   -   -

	mov ax, [ball_vel_x]
	mov bx, [ball_vel_y]
	add [ball_pose_x], ax
	add [ball_pose_y], bx

    mov cx, [game_border_top]      ; if (ball_pose_y <= game_border_top)
    cmp word [ball_pose_y], cx
    jbe  .ball_invert_vel_y
    
    mov cx, [game_border_bot]      ; if (ball_pose_y >= game_border_bot)
    cmp word [ball_pose_y], cx
    jae  .ball_invert_vel_y

    jmp .move_paddle_ai

.ball_invert_vel_y:
	neg word [ball_vel_y]

    ; -   -  AI   -   -

.move_paddle_ai:
    mov ax, [paddle_ai_range]               ; if (ball_pose_x < ai_range)
    cmp word [ball_pose_x], ax         
    jnbe  .ball_check_x
    
    mov ax, [paddle_ai_y]               ; if (ball_pose_y < ai_y)
    cmp word [ball_pose_y], ax
    jb  .move_ai_up
    
    mov ax, [paddle_ai_y]               ; if (ball_pose_y > ai_y)
    cmp word [ball_pose_y], ax
    ja  .move_ai_down

    jmp  .ball_check_x

.move_ai_up:
    dec word [paddle_ai_y]
    jmp  .ball_check_x

.move_ai_down:
    inc word [paddle_ai_y]
    jmp  .ball_check_x

    ; -   -  Ball X   -   -

.ball_check_x:
    mov ax, [game_border_left]      ; if (ball_pose_x <= game_border_left)
    cmp word [ball_pose_x], ax
    jbe  .check_left
    
    mov ax, [game_border_right]      ; if (ball_pose_x >= game_border_right)
    cmp word [ball_pose_x], ax
    jae  .check_right

    jmp  .move_end                   ; else if (left < ball_pose_x < right)


.check_left:
    mov ax, [paddle_ai_y]             ; if (ball_pose_x != paddle_ai_y)
    cmp word [ball_pose_y], ax 
    jne .score_pt_player
    
	neg word [ball_vel_x]             ; else if (ball_pose_x == paddle_ai_y)
    jmp .move_end

.score_pt_player:
    inc word [paddle_player_score]
	neg word [ball_vel_x]
    jmp .reset_field


.check_right:
    ; FAIR MODE  
    ; mov ax, [paddle_player_y]         ; if (ball_pose_x != paddle_player_y)
    ; cmp word [ball_pose_y], ax
    ; jne .score_pt_ai
    
    ; "+/- 1 Buffer for Player" MODE
    mov ax, [paddle_player_y]         ; if (ball_pose_x != paddle_player_y)
    mov cx, [ball_pose_y]         ; if (ball_pose_x != paddle_player_y)
    sub ax, cx
    cmp ax, 1
    ja .score_pt_ai
    
	neg word [ball_vel_x]             ; else if (ball_pose_x == paddle_player_y)
    jmp .move_end

.score_pt_ai:
    inc word [paddle_ai_score]
	neg word [ball_vel_x]
    jmp .reset_field


.reset_field:

    mov si, word [game_max_score]
    cmp word [paddle_player_score], si
    jae .set_winner

    mov si, word [game_max_score]
    cmp word [paddle_ai_score], si
    jae .set_winner

    mov word [game_mode], 0
    mov word [paddle_ai_y], 12
    mov word [paddle_player_y], 12
    mov word [ball_pose_y], 12
    mov word [ball_pose_x], 40

    jmp .move_end


.set_winner:

    mov word [ball_1_pose_x], 40
    mov word [ball_2_pose_x], 40
    mov word [ball_3_pose_x], 40
    mov word [ball_4_pose_x], 40

    mov word [ball_1_pose_y], 12
    mov word [ball_2_pose_y], 12
    mov word [ball_3_pose_y], 12
    mov word [ball_4_pose_y], 12

    mov word [ball_1_asii_pose], 200
    mov word [ball_2_asii_pose], 200
    mov word [ball_3_asii_pose], 200
    mov word [ball_4_asii_pose], 200

    mov word [ball_1_vel_x], 1
    mov word [ball_2_vel_x], -1
    mov word [ball_3_vel_x], 1
    mov word [ball_4_vel_x], -1

    mov word [ball_1_vel_y], 1
    mov word [ball_2_vel_y], 1
    mov word [ball_3_vel_y], -1
    mov word [ball_4_vel_y], -1

    mov si, word [game_max_score]
    cmp word [paddle_player_score], si
    jae .set_winner_player

    mov si, word [game_max_score]
    cmp word [paddle_ai_score], si
    jae .set_winner_ai

.set_winner_ai:

    mov word [game_mode], 6
    jmp .move_end

.set_winner_player:

    mov word [game_mode], 5
    jmp .move_end

;   -   -   -   -   -   -   -
.move_end:
    call    yield
    jmp     .loop_b
    
;ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ


;ㅡㅡㅡㅡㅡㄴ      Task C - Graphics      ㄱㅡㅡㅡㅡㅡ

task_c:
.loop_c:
    ; mov     dx, main_c
    ; call    putstring

.print_clean_screen:

    ;   Page change
    mov     ah, 5
    mov     al, 0
    int     0x10

    ; set video to text mode
	mov     ah, 0x0
	mov     al, 0x2
	int     0x10

    mov     ax, 0xB800
	mov     es, ax                  ; moving directly into a segment register is not allowed

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
    mov     cx, 2000 ; 80 x 25
	int     0x10

    mov     ah, 2
    mov     bh, 1
    mov     dh, 12
    mov     dl, 17
    int     0x10

    cmp word [game_mode], 8
    je  .jmp_update_ingame_ascii_pose
    
    cmp word [game_mode], 0
    je  .jmp_update_ingame_ascii_pose
    
    jmp .update_menu_ascii_pose

.jmp_update_ingame_ascii_pose:
 jmp .update_ingame_ascii_pose


;   -   -   -   -   MENU Graphics    -   -   -   -   ;


.update_menu_ascii_pose:

    ; update ASCII_Pose_Ball_1
    xor  dx,    dx
    mov  ax,    word [ball_1_pose_y]
    mov  cx,    160
    mul  cx     
    mov  word [ball_1_asii_pose],     ax  ; set ball_1_y
    
    xor  dx,    dx
    mov  ax,    word [ball_1_pose_x]
    mov  cx,    2    
    mul  cx     
    add  word [ball_1_asii_pose],     ax  ; set ball_1_x

    ; update ASCII_Pose_Ball_2
    xor  dx,    dx
    mov  ax,    word [ball_2_pose_y]
    mov  cx,    160
    mul  cx     
    mov  word [ball_2_asii_pose],     ax  ; set ball_2_y
    
    xor  dx,    dx
    mov  ax,    word [ball_2_pose_x]
    mov  cx,    2    
    mul  cx     
    add  word [ball_2_asii_pose],     ax  ; set ball_2_x

    ; update ASCII_Pose_Ball_3
    xor  dx,    dx
    mov  ax,    word [ball_3_pose_y]
    mov  cx,    160
    mul  cx     
    mov  word [ball_3_asii_pose],     ax  ; set ball_3_y
    
    xor  dx,    dx
    mov  ax,    word [ball_3_pose_x]
    mov  cx,    2    
    mul  cx     
    add  word [ball_3_asii_pose],     ax  ; set ball_3_x

    ; update ASCII_Pose_Ball_4
    xor  dx,    dx
    mov  ax,    word [ball_4_pose_y]
    mov  cx,    160
    mul  cx     
    mov  word [ball_4_asii_pose],     ax  ; set ball_4_y
    
    xor  dx,    dx
    mov  ax,    word [ball_4_pose_x]
    mov  cx,    2    
    mul  cx     
    add  word [ball_4_asii_pose],     ax  ; set ball_4_x
    

.setup_menu_ascii_video_mode:

    ;   Page change
    mov     ah, 5
    mov     al, 1
    int     0x10

    ; set video to text mode
	mov     ah, 0x0
	mov     al, 0x2
	int     0x10

    mov     ax, 0xB800
	mov     es, ax                  ; moving directly into a segment register is not allowed

.print_menu_ascii_art:
    
    ;   Print Ball_1
    mov     bx,     [ball_1_asii_pose]
    mov     dx,     [ball_1_asii]
	mov     word [es:bx], dx
    
    ;   Print Ball_2
    mov     bx,     [ball_2_asii_pose]
    mov     dx,     [ball_2_asii]
	mov     word [es:bx], dx
    
    ;   Print Ball_3
    mov     bx,     [ball_3_asii_pose]
    mov     dx,     [ball_3_asii]
	mov     word [es:bx], dx
    
    ;   Print Ball_4
    mov     bx,     [ball_4_asii_pose]
    mov     dx,     [ball_4_asii]
	mov     word [es:bx], dx
    
    ;   Print Header
	mov     word [es:0],    0x0FDB ; ㅁ
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

	mov     word [es:76],   0x0F53 ; S
	mov     word [es:78],   0x0F74 ; t
	mov     word [es:80],   0x0F61 ; a
	mov     word [es:82],   0x0F72 ; r
	mov     word [es:84],   0x0F74 ; t

	mov     word [es:88],   0x0F4E ; N
	mov     word [es:90],   0x0F65 ; e
	mov     word [es:92],   0x0F77 ; w

	mov     word [es:96],   0x0F47 ; G
	mov     word [es:98],   0x0F61 ; a
	mov     word [es:100],  0x0F6D ; m
	mov     word [es:102],  0x0F65 ; e
	mov     word [es:106],  0x0F11 ; <<
	mov     word [es:158],  0x0FDB ; ㅁ

    ;   Print Escape Information
	mov     word [es:212],   0x0F10 ; >>
	mov     word [es:216],   0x0F50 ; P
	mov     word [es:218],   0x0F72 ; r
	mov     word [es:220],   0x0F65 ; e
	mov     word [es:222],   0x0F73 ; s
	mov     word [es:224],   0x0F73 ; s

	mov     word [es:228],   0x0F45 ; E
	mov     word [es:230],   0x0F73 ; s
	mov     word [es:232],   0x0F63 ; c

	mov     word [es:236],   0x0F74 ; t
	mov     word [es:238],   0x0F6F ; o

	mov     word [es:242],   0x0F45 ; E
	mov     word [es:244],   0x0F78 ; x
    mov     word [es:246],   0x0F69 ; i
    mov     word [es:248],   0x0F74 ; t

    mov     word [es:252],   0x0F47 ; G
	mov     word [es:254],   0x0F61 ; a
	mov     word [es:256],   0x0F6D ; m
	mov     word [es:258],   0x0F65 ; e
	
	mov     word [es:262],  0x0F11 ; <<

    cmp     word [game_mode], 5
    je      .print_win_text

    cmp     word [game_mode], 6
    je      .print_win_text

    jmp     .print_end

    
.print_win_text:
	mov     word [es:224],   0x8F03 ; ㅁ
	mov     word [es:242],   0x8F57 ; W
	mov     word [es:244],   0x8F6F ; o
	mov     word [es:246],   0x8F6E ; n
	mov     word [es:248],   0x8F21 ; !
	mov     word [es:252],   0x8F03 ; ㅁ

    cmp     word [game_mode], 5
    je      .print_win_player_text
    
.print_win_ai_text:
	mov     word [es:232],   0x8F41 ; A
	mov     word [es:234],   0x8F49 ; I

    jmp     .print_end

.print_win_player_text:
	mov     word [es:228],   0x8F50 ; P
	mov     word [es:230],   0x8F6C ; l
	mov     word [es:232],   0x8F61 ; a
	mov     word [es:234],   0x8F79 ; y
	mov     word [es:236],   0x8F65 ; e
	mov     word [es:238],   0x8F72 ; r

    jmp     .print_end


;   -   -   -   -   IN-GAME Graphics    -   -   -   -   ;


.update_ingame_ascii_pose:

    ; NOTE: ; dx:ax = ax * cx
    xor  dx,    dx
    mov  ax,    word [ball_pose_y]
    mov  cx,    160
    mul  cx     
    mov  word [ball_asii_pose],     ax  ; set ball_y
    
    xor  dx,    dx
    mov  ax,    word [ball_pose_x]
    mov  cx,    2    
    mul  cx     
    add  word [ball_asii_pose],     ax  ; set ball_x
    
    ; update ASCII_Pose_Paddle_AI
    xor  dx,    dx
    mov  ax,    word [paddle_ai_y]
    mov  cx,    160
    mul  cx     
    mov  word [paddle_ai_asii_pose],     ax   ; set paddle_ai_y
    add  word [paddle_ai_asii_pose],     0    ; set paddle_ai_x
    
    ; update ASCII_Pose_Paddle_Player
    xor  dx,    dx
    mov  ax,    word [paddle_player_y]
    mov  cx,    160
    mul  cx     
    mov  word [paddle_player_asii_pose],     ax   ; set paddle_player_y
    add  word [paddle_player_asii_pose],     158  ; set paddle_player_x

.setup_ingame_ascii_video_mode:

    ;   Page change
    mov     ah, 5
    mov     al, 1
    int     0x10

    ; set video to text mode
	mov     ah, 0x0
	mov     al, 0x2
	int     0x10

    mov     ax, 0xB800
	mov     es, ax                  ; moving directly into a segment register is not allowed

.print_ingame_ascii_art:

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
	mov     word [es:0],    0x0FDB ; ㅁ

	mov     word [es:12],   0x0F41 ; A
	mov     word [es:14],   0x0F49 ; I
	mov     word [es:18],   0x0F53 ; S
	mov     word [es:20],   0x0F63 ; c
	mov     word [es:22],   0x0F6F ; o
	mov     word [es:24],   0x0F72 ; r
	mov     word [es:26],   0x0F65 ; e
	mov     word [es:28],   0x0F3A ; :

    mov     dx,     [paddle_ai_score]
    add     dx,     0x0F30         ; change int into ascii-art 
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
    
    mov     dx,     [paddle_player_score]
    add     dx,     0x0F30         ; change int into ascii-art
	mov     word [es:154], dx

	mov     word [es:158],  0x0FDB ; ㅁ

    cmp     word [game_mode], 0
    jne      .print_end
    
.print_prompt_resume:
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
    

.print_end:
    call    yield
    jmp     .loop_c
    
;ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ


;ㅡㅡㅡㅡㅡㄴ      Task D - Music      ㄱㅡㅡㅡㅡㅡ

task_d:
.loop_d:
    ; mov     dx, main_d
    ; call    putstring

    ;   code here...

    call    yield
    jmp     .loop_d

;ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ


;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
;   Utility Functions
;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx


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
    keyboard_number: db 0

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