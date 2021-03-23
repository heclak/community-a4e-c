_TEXT SEGMENT

;This is just to bypass the annoying as fuck
;C++ compiler.
_find_vfptr_fnc PROC
	mov rax, QWORD PTR [rcx] ; get table
	add rax, rdx ; add table offset
	mov rax, QWORD PTR [rax]
	ret
_find_vfptr_fnc ENDP

_set_radio PROC; first integer param is passed on the rcx register
	mov rdi, QWORD PTR [rcx]
	add rdi, 58h ;function offset; 58h is elec Mac power.
	call QWORD PTR [rdi]
	ret
_set_radio ENDP

_get_radio PROC; first integer param is passed on the rcx register
	mov rdi, QWORD PTR [rcx]
	add rdi, 0d8h ;function offset
	call QWORD PTR [rdi]
	ret
_get_radio ENDP

_ext_is_on PROC
	mov rdi, rdx
	mov rdx, R8
	call rdi
	ret

_ext_is_on ENDP

_is_on_intercom PROC
	call rdx
	ret

_is_on_intercom ENDP


_get_intercom PROC
	mov rdi, QWORD PTR [rcx]
	add rdi, 0h; function offset
	;call QWORD PTR [rdi]
	ret
_get_intercom ENDP

_switch_radio PROC
	mov rdi, rdx
	;sub rcx, 20h
	call rdi
	ret
_switch_radio ENDP

_TEXT ENDS

END