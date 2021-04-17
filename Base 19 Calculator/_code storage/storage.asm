
.push_var:
                cmp     rdi,    1
                je      .set_var

                ;   switch(rax) for .push_var
                cmp     rax,    'a'
                je      .jmp_push_a
                cmp     rax,    'b'
                je      .jmp_push_b
                cmp     rax,    'c'
                je      .jmp_push_c
                cmp     rax,    'd'
                je      .jmp_push_d
                cmp     rax,    'e'
                je      .jmp_push_e
                cmp     rax,    'f'
                je      .jmp_push_f
                cmp     rax,    'g'
                je      .jmp_push_g
                cmp     rax,    'h'
                je      .jmp_push_h
                cmp     rax,    'i'
                je      .jmp_push_i
                cmp     rax,    'j'
                je      .jmp_push_j
                cmp     rax,    'k'
                je      .jmp_push_k
                cmp     rax,    'l'
                je      .jmp_push_l
                cmp     rax,    'm'
                je      .jmp_push_m
                cmp     rax,    'n'
                je      .jmp_push_n
                cmp     rax,    'o'
                je      .jmp_push_o
                cmp     rax,    'p'
                je      .jmp_push_p
                cmp     rax,    'q'
                je      .jmp_push_q
                cmp     rax,    'r'
                je      .jmp_push_r
                cmp     rax,    's'
                je      .jmp_push_s
                cmp     rax,    't'
                je      .jmp_push_t
                cmp     rax,    'u'
                je      .jmp_push_u
                cmp     rax,    'v'
                je      .jmp_push_v
                cmp     rax,    'w'
                je      .jmp_push_w
                cmp     rax,    'x'
                je      .jmp_push_x
                cmp     rax,    'y'
                je      .jmp_push_y
                cmp     rax,    'z'
                je      .jmp_push_z

;--------------------------------------------------------------------
.jmp_push_a:
 jmp .push_a
.jmp_push_b:
 jmp .push_b
.jmp_push_c:
 jmp .push_c
.jmp_push_d:
 jmp .push_d
.jmp_push_e:
 jmp .push_e
.jmp_push_f:
 jmp .push_f
.jmp_push_g:
 jmp .push_g
.jmp_push_h:
 jmp .push_h
.jmp_push_i:
 jmp .push_i
.jmp_push_j:
 jmp .push_j
.jmp_push_k:
 jmp .push_k
.jmp_push_l:
 jmp .push_l
.jmp_push_m:
 jmp .push_m
.jmp_push_n:
 jmp .push_n
.jmp_push_o:
 jmp .push_o
.jmp_push_p:
 jmp .push_p
.jmp_push_q:
 jmp .push_q
.jmp_push_r:
 jmp .push_r
.jmp_push_s:
 jmp .push_s
.jmp_push_t:
 jmp .push_t
.jmp_push_u:
 jmp .push_u
.jmp_push_v:
 jmp .push_v
.jmp_push_w:
 jmp .push_w
.jmp_push_x:
 jmp .push_x
.jmp_push_y:
 jmp .push_y
.jmp_push_z:
 jmp .push_z
;--------------------------------------------------------------------

.set_var:
                mov     rdi,    0       ;   reset equal_flag

                ;   switch(rax) for .set_var
                cmp     rax,    'a'
                je      .jmp_set_a
                cmp     rax,    'b'
                je      .jmp_set_b
                cmp     rax,    'c'
                je      .jmp_set_c
                cmp     rax,    'd'
                je      .jmp_set_d
                cmp     rax,    'e'
                je      .jmp_set_e
                cmp     rax,    'f'
                je      .jmp_set_f
                cmp     rax,    'g'
                je      .jmp_set_g
                cmp     rax,    'h'
                je      .jmp_set_h
                cmp     rax,    'i'
                je      .jmp_set_i
                cmp     rax,    'j'
                je      .jmp_set_j
                cmp     rax,    'k'
                je      .jmp_set_k
                cmp     rax,    'l'
                je      .jmp_set_l
                cmp     rax,    'm'
                je      .jmp_set_m
                cmp     rax,    'n'
                je      .jmp_set_n
                cmp     rax,    'o'
                je      .jmp_set_o
                cmp     rax,    'p'
                je      .jmp_set_p
                cmp     rax,    'q'
                je      .jmp_set_q
                cmp     rax,    'r'
                je      .jmp_set_r
                cmp     rax,    's'
                je      .jmp_set_s
                cmp     rax,    't'
                je      .jmp_set_t
                cmp     rax,    'u'
                je      .jmp_set_u
                cmp     rax,    'v'
                je      .jmp_set_v
                cmp     rax,    'w'
                je      .jmp_set_w
                cmp     rax,    'x'
                je      .jmp_set_x
                cmp     rax,    'y'
                je      .jmp_set_y
                cmp     rax,    'z'
                je      .jmp_set_z

;--------------------------------------------------------------------
.jmp_set_a:
 jmp .set_a
.jmp_set_b:
 jmp .set_b
.jmp_set_c:
 jmp .set_c
.jmp_set_d:
 jmp .set_d
.jmp_set_e:
 jmp .set_e
.jmp_set_f:
 jmp .set_f
.jmp_set_g:
 jmp .set_g
.jmp_set_h:
 jmp .set_h
.jmp_set_i:
 jmp .set_i
.jmp_set_j:
 jmp .set_j
.jmp_set_k:
 jmp .set_k
.jmp_set_l:
 jmp .set_l
.jmp_set_m:
 jmp .set_m
.jmp_set_n:
 jmp .set_n
.jmp_set_o:
 jmp .set_o
.jmp_set_p:
 jmp .set_p
.jmp_set_q:
 jmp .set_q
.jmp_set_r:
 jmp .set_r
.jmp_set_s:
 jmp .set_s
.jmp_set_t:
 jmp .set_t
.jmp_set_u:
 jmp .set_u
.jmp_set_v:
 jmp .set_v
.jmp_set_w:
 jmp .set_w
.jmp_set_x:
 jmp .set_x
.jmp_set_y:
 jmp .set_y
.jmp_set_z:
 jmp .set_z
    
