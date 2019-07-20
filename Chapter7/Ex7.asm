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
	x dword 25
	y dword 25
	string db 20 dup(0)
	
.code
start proc
	mov ebx, dword ptr [x]
	mov eax, dword ptr [y]
	push eax
	push ebx
	call MulByShift
	
	push eax
	call itoa
	
	push eax
	call StdOut
	
;;Exit
Exit:
	push 0
	call ExitProcess


MulByShift proc 
	push ebp
	mov ebp, esp
	xor ecx, ecx
	xor eax, eax
	xor ebx, ebx
	mov ebx, [ebp + 08h]
	mov eax, [ebp + 0Ch]
	xor edi, edi

Loop_Shift:
	test eax, 01h
	jnz  Odd_Num
	
Even_Num:
	shl ebx, 1
	shr eax, 1
	cmp eax, 01h
	jz Done_Shift
	jmp Loop_Shift
		
Odd_Num:
	add edi, ebx
	dec eax
	jmp Loop_Shift

Done_Shift:
	mov eax, ebx
	add eax, edi
	pop ebp
	ret 8
MulByShift endp

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
