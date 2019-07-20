;;Chapter8
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
	copiedByte db "Number of copied Bytes : ", 0
	root db "The fucking noob!!!!!", 0
	stringcpy db 2000 dup (?)
	newline db 0ah, 0
	lengthCopy dd 1
	string db 20 dup (?)
	
.code
start proc
	push offset stringcpy
	push offset root
	call 	Str_copyN
	
	mov dword ptr [lengthCopy], eax
	
	push offset root
	call	StdOut
	
	push offset newline
	call StdOut
	
	push offset stringcpy
	call StdOut
	
	push offset newline
	call StdOut
	
	push offset copiedByte
	call StdOut
	
	push dword ptr [lengthCopy]
	call itoa
	
	push eax
	call StdOut
	
	
;;Exit
Exit:
	push 0
	call ExitProcess

Str_copyN proc
	push ebp
	mov ebp, esp
	mov ebx, [ebp + 08h]
	mov ecx, [ebp + 0Ch]
	xor esi, esi
loop_cpy:
	xor edx, edx
	mov dl, byte ptr [ebx + esi]
	mov byte ptr [ecx + esi], dl
	inc esi
	cmp byte ptr [ebx  + esi], 0
	jnz loop_cpy
	
	xor eax, eax
	mov eax, esi
	pop ebp
	ret 8
Str_copyN endp
	
itoa proc
	push ebp
	mov ebp, esp
	xor eax, eax
	mov eax, [ebp + 08h]
	mov ecx, offset string
	push 69h
	mov ebx, 10
	
		
loop_itoa:
	xor edx, edx
	div ebx
	add dl, 30h
	xor dh, dh
	push edx
	cmp eax, 0
	jnz loop_itoa
	

done_itoa:
	xor ebx, ebx
	pop ebx
	cmp ebx, 69h
	jz 	OutHere
	mov byte ptr [ecx], bl
	inc ecx
	jmp done_itoa

OutHere:	
	mov eax, offset string
	pop ebp
	ret
itoa endp

start endp
End start