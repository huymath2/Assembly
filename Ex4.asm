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
	target BYTE "123ABC342432", 20 dup (0)
	source BYTE "ABC",0
	notFoundText db "String is not found!", 0
	FoundText db "String was foud at position ", 0
	newline db 0ah, 0
	string db 20 dup (?)
	idx dd 1
	check BYTE 0
	
.code
start proc
	push offset target
	push offset source
	call Str_find
	
	cmp eax, -1
	jz notFound
	jmp Found
	
notFound:
	push offset notFoundText
	call StdOut
	jmp Exit
Found:
	push offset FoundText
	call StdOut
	
	
	mov eax, dword ptr [idx]
	push eax
	call itoa
	
	push eax
	call StdOut

;;Exit
Exit:
	push 0
	call ExitProcess

Str_find proc
	push ebp
	mov ebp, esp
	mov ebx, [ebp + 08h]
	mov ecx, [ebp + 0Ch]
	xor esi, esi
	xor edi, edi
	mov dword ptr [idx], edi
loop1:
	mov edi, dword ptr [idx]
	xor esi, esi
loop2:
	xor edx, edx
	mov dl, byte ptr [ecx + edi]
	mov dh, byte ptr [ebx + esi]
	cmp dh, dl
	jnz next_index
	inc esi
	cmp byte ptr [ebx + esi], 0
	jz iFound
	inc edi
	jmp loop2

next_index:
	mov edi, dword ptr [idx]
	inc edi
	cmp byte ptr [ecx + edi], 0
	jz check_find
	mov dword ptr [idx], edi
	jmp loop1

iFound:
	mov byte ptr [check], 1
	xor eax, eax
	mov eax, dword ptr [idx]
	jmp done_Find

check_find:
	cmp byte ptr [check], 1
	jz done_Find
	mov eax, -1
	
done_Find:
		
	pop ebp
	ret 8
Str_find endp

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