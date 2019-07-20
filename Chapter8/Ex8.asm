;;Chapter7
.386
.model flat, stdcall
option casemap:none

include E:\masm32\include\windows.inc
include E:\masm32\include\user32.inc
include E:\masm32\include\kernel32.inc
include E:\masm32\include\masm32.inc
         
; *************************************************************************
; MASM32 object libraries
; *************************************************************************  
includelib E:\masm32\lib\user32.lib
includelib E:\masm32\lib\kernel32.lib
includelib E:\masm32\lib\msvcrt.lib
includelib E:\masm32\lib\masm32.lib


.data
	InputText db "Type in two number with same size: ", 0ah, 0
	number1 db 100 dup (?)
	number2 db 100 dup (?)
	sum db 101 dup(?)
	k db 1
	
.code
start proc
	push offset InputText
	call StdOut
	
	push 100
	push offset number1
	call StdIn
	
	push 100
	push offset number2
	call StdIn
	
	push offset number1
	call strlen
	
	push eax
	push offset number2
	push offset number1
	call Additon
	
	push eax
	call StdOut
	
;;Exit
Exit:
	push 0
	call ExitProcess

Additon proc
	push ebp
	mov ebp, esp
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor esi, esi
	mov eax, [ebp + 08h]
	mov ebx, [ebp + 0Ch]
	mov esi, [ebp + 10h]
	dec esi
	mov ecx, offset sum
	mov byte ptr [k], 0
	push 69
Loop_Add:
	xor edx, edx
	mov dl, byte ptr [eax + esi]
	mov dh, byte ptr [ebx + esi]
	sub dl, 30h
	sub dh, 30h
	add dl, dh
	add dl, byte ptr [k]
	cmp dl, 0ah
	jl lower_ten
	mov byte ptr [k], 1
	sub dl, 0ah
	add dl, 30h
	xor dh, dh
	push edx
	cmp esi, 0
	jz Done_Add
	dec esi
	jmp Loop_Add
	
lower_ten:
	mov byte ptr [k], 0
	add dl, 30h
	xor dh, dh
	push edx
	cmp esi, 0
	jz Done_Add
	dec esi
	jmp Loop_Add
	

Done_Add:
	cmp byte ptr [k], 1
	jnz Move_to_sum
	push 31h
	
Move_to_sum:
	xor edx, edx
	pop edx
	cmp edx, 69
	jz Out_Here
	mov byte ptr [ecx], dl
	inc ecx
	jmp Move_to_sum

Out_Here:
	xor eax, eax
	mov eax, offset sum
	pop ebp
	ret 0Ch
Additon endp

strlen proc
	push ebp
	mov ebp, esp
	mov ecx, [ebp + 08h]
	xor esi, esi
loop_strlen:
	cmp byte ptr [ecx + esi], 0
	jz Done_strlen
	inc esi
	jmp loop_strlen

Done_strlen:
	mov eax, esi
	pop ebp
	ret 4
strlen endp
	
start endp
End start
