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
	targetStr BYTE "ABCDE",10 DUP(0)
	sourceStr BYTE "FGH",0
	
.code
start proc
	push offset sourceStr
	push offset targetStr
	call  Str_concat
	
	push offset targetStr
	call StdOut
	
	
;;Exit
Exit:
	push 0
	call ExitProcess

Str_concat proc
	push ebp
	mov ebp, esp
	mov ebx, [ebp + 08h]
	mov ecx, [ebp + 0Ch]
	xor esi, esi
	xor edi, edi
	
loop_to_index:
	cmp byte ptr [ebx + esi], 0
	jz loop_cat
	inc esi
	jmp loop_to_index

loop_cat:	
	xor edx, edx
	mov dl, byte ptr [ecx + edi]
	mov byte ptr [ebx + esi], dl
	inc edi
	inc esi
	cmp byte ptr [ecx + edi], 0
	jnz loop_cat
	
	mov byte ptr [ebx + esi], 0
	mov eax, 1
	
	pop	ebp
	ret 8
Str_concat endp

start endp
End start