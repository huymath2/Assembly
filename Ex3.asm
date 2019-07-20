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
	target BYTE "abcxxxxdefghijklmop",0
	
.code
start proc
	push 4
	push 3
	push offset target
	call Str_remove
	
	push offset target
	call StdOut
	
;;Exit
Exit:
	push 0
	call ExitProcess

Str_remove proc
	push ebp
	mov ebp, esp
	mov ecx, 	[ebp + 08h]
	mov eax,	[ebp + 0Ch]
	mov ebx, 	[ebp + 10h]
	add ebx, eax
	mov [ebp + 10h], ebx
	xor esi, esi

loop_remove:
	xor edx, edx
	mov dl, byte ptr [ecx + eax]
	mov dh, byte ptr [ecx + ebx]
	mov byte ptr [ecx + eax], dh
	mov byte ptr [ecx + ebx], dl
	inc eax
	inc ebx
	cmp byte ptr [ecx + ebx], 0
	jnz loop_remove
	
	mov byte ptr [ecx + eax], 0

	pop ebp
	ret 0Ch
Str_remove endp 

start endp
End start