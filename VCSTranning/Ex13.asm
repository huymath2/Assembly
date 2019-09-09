;E:\Code\VCSTranning\Assembly\Windows\Ex1.exe
.386
.model flat, stdcall
option casemap:none

include E:\masm32\include\windows.inc
include E:\masm32\include\user32.inc
include E:\masm32\include\kernel32.inc
include E:\masm32\include\masm32.inc
include E:\masm32\include\comdlg32.inc
         
; *************************************************************************
; MASM32 object libraries
; *************************************************************************  
includelib E:\masm32\lib\user32.lib
includelib E:\masm32\lib\kernel32.lib
includelib E:\masm32\lib\msvcrt.lib
includelib E:\masm32\lib\masm32.lib
includelib E:\masm32\lib\comdlg32.lib 

.data 
InputFileText db "Type in your path of PE file: ", 0
string db 20 dup (0)
newline db 0ah, 0
tabText db "	", 0
ZeroText db "0", 0
SpaceText db " 		", 0

dosHeaderText db "------------DOS HEADER--------------", 0
e_magicText db "e_magic		", 0
e_cblpText db "e_cblp		", 0
e_cpText db "e_cp		", 0
e_crlcText db "e_clrc		", 0
e_cparhdrText db "e_cparhdr	", 0
e_minallocText db "e_minalloc	", 0
e_maxallocText db "e_maxalloc	", 0
e_ssText db "e_ss		", 0
e_spText db "e_sp		", 0
e_csumText db "e_csum		", 0
e_ipText db "e_ip		", 0
e_csText db "e_cs		", 0
e_ifarlcText db "e_ifarlc	", 0
e_ovnoText db "e_ovno		", 0
e_resText db "e_res		", 0
e_oemidText db "e_oemid		", 0
e_oeminfoText db "e_oeminfo	", 0
e_res2Text db "e_res2		", 0
e_ifanewText db "e_ifanew	", 0

NtHeaderText db "-------------NT HEADER----------------", 0
SignatureText db "Signature		", 0

FileHeaderText db "-------------FILE HEADER---------------", 0 
MachineText db "Machine			", 0
NumberOfSectionsText db "NumberOfSections	", 0
TimeDateStampText db "TimeDateStamp		", 0
PointerToSymbolTableText db "PointerToSymbolTable	", 0
NumberOfSymbolText db "NumberOfSymbol		", 0
SizeOfOptionalHeaderText db "SizeOfOptionalHeader	", 0
CharacteristicsText db "Characteristics		", 0

.data? 
buffer db 512 dup(?) 
hFile dd ? 
hMapping dd ? 
pMapping dd ? 
ValidPE dd ? 

.code
start proc
;Nhap vao duong dan
	push offset InputFileText
	call StdOut
	
	push 512
	push offset buffer
	call StdIn

;Open file
	push NULL
	push FILE_ATTRIBUTE_NORMAL
	push OPEN_EXISTING
	push NULL
	push FILE_SHARE_READ
	push GENERIC_READ
	push offset buffer
	call CreateFile
	
	mov hFile, eax
	
	push 0
	push 0
	push 0
	push PAGE_READONLY
	push NULL
	push hFile
	call CreateFileMapping
	
	mov hMapping, eax
	
	push 0
	push 0
	push 0
	push FILE_MAP_READ
	push hMapping
	call MapViewOfFile
	
	mov pMapping,eax
	mov edi, pMapping 

;Dos header	
	push offset dosHeaderText
	call StdOut
	call Newline
	
    assume edi:ptr IMAGE_DOS_HEADER
	xor esi, esi
;e_magic	
	push offset e_magicText
	call StdOut
	call PrintValue
;e_cblp	
	push offset e_cblpText
	call StdOut
	call PrintValue
;e_cp	
	push offset e_cpText
	call StdOut
	call PrintValue
;e_crlc	
	push offset e_crlcText
	call StdOut
	call PrintValue
;e_cparhdr		
	push offset e_cparhdrText
	call StdOut
	call PrintValue
;e_minalloc	
	push offset e_minallocText
	call StdOut
	call PrintValue
	
	push offset e_maxallocText
	call StdOut
	call PrintValue
	
	push offset e_ssText
	call StdOut
	call PrintValue
	
	push offset e_spText
	call StdOut
	call PrintValue
	
	push offset e_csumText
	call StdOut
	call PrintValue
	
	push offset e_ipText
	call StdOut
	call PrintValue

	push offset e_csText
	call StdOut
	call PrintValue
	
	push offset e_ifarlcText
	call StdOut
	call PrintValue
;e_ovno	
	push offset e_ovnoText
	call StdOut
	call PrintValue

;e_res	
	push offset e_resText
	call StdOut
	call PrintValue
	
	push offset SpaceText
	call StdOut
	call PrintValue
	
	push offset SpaceText
	call StdOut
	call PrintValue
	
	push offset SpaceText
	call StdOut
	call PrintValue

;e_oemid
	push offset e_oemidText
	call StdOut
	call PrintValue

;e_oeminfo
	push offset e_oeminfoText
	call StdOut
	call PrintValue

;e_res2
	push offset e_res2Text
	call StdOut
	call PrintValue
	
	push offset SpaceText
	call StdOut
	call PrintValue
	
	push offset SpaceText
	call StdOut
	call PrintValue
	
	push offset SpaceText
	call StdOut
	call PrintValue
	
	push offset SpaceText
	call StdOut
	call PrintValue
	
	push offset SpaceText
	call StdOut
	call PrintValue
	
	push offset SpaceText
	call StdOut
	call PrintValue
	
	push offset SpaceText
	call StdOut
	call PrintValue
	
	push offset SpaceText
	call StdOut
	call PrintValue
	
	push offset SpaceText
	call StdOut
	call PrintValue

;e_ifanew
	push offset e_ifanewText
	call StdOut
	call PrintValue

	call Newline
;-----------------NT HEADER----------------------------
	push offset NtHeaderText
	call StdOut
	call Newline
;Signature	
	push offset SignatureText
	call StdOut
	push 0B0h
	call PrintForDword

;---------------File Header-----------------------------
	push offset FileHeaderText
	call StdOut
	call Newline
	
;Machine
	push offset MachineText
	call StdOut
	push 0B4h
	call PrintForWord
;NumberOfSections
	push offset NumberOfSectionsText
	call StdOut
	push 0B6h
	call PrintForWord
;TimeDateStamp
	push offset TimeDateStampText
	call StdOut
	push 0B8h
	call PrintForDword
;PointerToSymbolTable
	push offset PointerToSymbolTableText
	call StdOut
	push 0BCh
	call PrintForDword
;NumberOfSymbol
	push offset NumberOfSymbolText
	call StdOut
	push 0C0h
	call PrintForDword
;SizeOfOptionalHeader
	push offset SizeOfOptionalHeaderText
	call StdOut
	push 0C4h
	call PrintForWord
;Characteristics
	push offset CharacteristicsText
	call StdOut
	push 0C6h
	call PrintForWord






Exit:
	ret

PrintValue proc
	push ebp
	mov ebp, esp
	push esi
	call PrintField
	add esi, 2
	pop ebp
	ret
PrintValue endp
	
PrintField proc
	push ebp
	mov ebp, esp
	push esi
	mov esi, [ebp + 08h]
	xor ebx, ebx
	mov bx, word ptr [edi + esi]
	push ebx
	call htoa
	push eax
	call StdOut
	call Newline
	jmp done

	
done:
	pop esi
	pop ebp
	ret 4
PrintField endp	

PrintForDword proc
	push ebp
	mov ebp, esp
	mov esi, [ebp + 08h]
	mov ebx, dword ptr [edi + esi]
	push ebx
	call htoa
	push eax
	call StdOut
	call Newline
	pop ebp
	ret 4
PrintForDword endp

PrintForWord proc
	push ebp
	mov ebp, esp
	mov esi, [ebp + 08h]
	xor ebx, ebx
	mov bx, word ptr [edi + esi]
	push ebx
	call htoa
	push eax
	call StdOut
	call Newline
	pop ebp
	ret 4

	ret
PrintForWord endp

PrintForByte proc
	push ebp
	mov ebp, esp
	mov esi, [ebp + 08h]
	xor ebx, ebx
	mov bl, byte ptr [edi + esi]
	push ebx
	call htoa
	push eax
	call StdOut
	call Newline
	pop ebp
	ret 4

	ret
PrintForByte endp




;calculate fuc
htoa proc ;hex to integer
	push ebp
	mov ebp, esp
	push esi
	mov eax, [ebp + 08h]
	cmp eax, 0
	jz 	goto_zero
	mov ebx, 16
	push 80h
loop_htoa:
	xor edx, edx
	cmp eax, 0
	jz	conti 
	div ebx
	
	cmp dl, 0ah
	jge char_x
	
	add dl, 30h
	xor dh, dh
	push edx
	jmp loop_htoa
	
char_x:
	add dl, 55
	xor dh, dh
	push edx
	jmp loop_htoa

conti:
	
	xor ebx, ebx
	mov esi, offset string
loop_store:
	pop	ebx
	cmp ebx, 80h
	jz done
	mov byte ptr [esi], bl
	inc esi
	jmp loop_store

goto_zero:
	mov esi, offset string
	mov byte ptr [esi], 30h
	inc esi
done:
	mov byte ptr [esi], 0
	mov eax, offset string
	pop esi
	pop ebp
	ret 4
htoa endp

Newline proc
	push offset newline
	call StdOut
	ret
Newline endp

start endp
End start
