_TEXT SEGMENT

_set_radio PROC; first integer param is passed on the rcx register
	mov rdi, rdx
	mov rdx, R8
	;sub rcx, 20h
	call rdi
	ret
_set_radio ENDP

_get_radio PROC; first integer param is passed on the rcx register
	;mov rdi, rdx
	mov rdi, rcx
	lea rcx, [rax-20h]
	mov rdi, rdx
		;mov rdi, rcx
		;add rdi, 0D8h
		;sub rcx, 20h
	call rdi
	ret
_get_radio ENDP

_switch_radio PROC
	mov rdi, rdx
	;sub rcx, 20h
	call rdi
	ret
_switch_radio ENDP

_TEXT ENDS

END