; E:\Code\VisualStdio2015\RE01\RE01\Release\RE01.exe
; E:\Code\VisualStdio2015\RE01\RE01\x64\Release\RE01.exe
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
SpaceText db " 				", 0
SignatureVal dw 0
PE32Text db "PE32", 0
PE64Text db "PE64", 0
PE db 32

dosHeaderText db "------------DOS HEADER--------------", 0
e_magicText db "e_magic				", 0
e_cblpText db "e_cblp				", 0
e_cpText db "e_cp				", 0
e_crlcText db "e_clrc				", 0
e_cparhdrText db "e_cparhdr			", 0
e_minallocText db "e_minalloc			", 0
e_maxallocText db "e_maxalloc			", 0
e_ssText db "e_ss				", 0
e_spText db "e_sp				", 0
e_csumText db "e_csum				", 0
e_ipText db "e_ip				", 0
e_csText db "e_cs				", 0
e_ifarlcText db "e_ifarlc			", 0
e_ovnoText db "e_ovno				", 0
e_resText db "e_res				", 0
e_oemidText db "e_oemid				", 0
e_oeminfoText db "e_oeminfo			", 0
e_res2Text db "e_res2				", 0
e_ifanewText db "e_ifanew			", 0

NtHeaderText db "-------------NT HEADER----------------", 0
SignatureText db "Signature		", 0

FileHeaderText db "-------------FILE HEADER---------------", 0 
MachineText db "Machine				", 0
NumberOfSectionsText db "NumberOfSections		", 0
TimeDateStampText db "TimeDateStamp			", 0
PointerToSymbolTableText db "PointerToSymbolTable		", 0
NumberOfSymbolText db "NumberOfSymbol			", 0
SizeOfOptionalHeaderText db "SizeOfOptionalHeader		", 0
CharacteristicsText db "Characteristics			", 0

OptionalHeaderText db "--------------OPTIONAL HEADER----------------", 0
MagicText db "Magic				", 0
MajorLinkerVersionText db "MajorLinkerVersion		", 0
MinorLinkerVersionText db "MinorLinkerVersion		", 0
SizeOfCodeText db "SizeOfCode			", 0
SizeOfInitializedDataText db "SizeOfInitializedData		", 0
SizeOfUninitializedDataText db "SizeOfUninitializedData		", 0
AddressOfEntryPointText db "AddressOfEntryPoint		", 0
BaseOfCodeText db "BaseOfCode			", 0
BaseOfDataText	db "BaseOfData			", 0
ImageBaseText db "ImageBase			", 0
SectionAlignmentText db "SectionAlignment		", 0
FileAlignmentText db "FileAlignment			", 0
MajorOperatingSystemVersionText db "MajorOperatingSystemVersion	", 0
MinorOperatingSystemVersionText db "MinorOperatingSystemVersion	", 0
MajorImageVersionText db "MajorImageVersion		", 0
MinorImageVersionText db "MinorImageVersion		", 0
MajorSubsystemVersionText db "MajorSubsystemVersion		", 0
MinorSubsystemVersionText db "MinorSubsystemVersion		", 0
Win32VersionValueText db "Win32VersionValue		", 0
SizeOfImageText db "SizeOfImage			", 0
SizeOfHeadersText db "SizeOfHeaders			", 0
CheckSumText db "CheckSum			", 0
SubSystemText db "SubSystem			", 0
DllCharacteristicsText db "DllCharacteristics		", 0
SizeOfStackReserveText db "SizeOfStackReserve		", 0
SizeOfStackCommitText db "SizeOfStackCommit		", 0
SizeOfHeapReserveText db "SizeOfHeapReserve		", 0
SizeOfHeapCommitText db "SizeOfHeapCommit		", 0
LoaderFlagsText db "LoaderFlags			", 0
NumberOfRvaAndSizesText db "NumberOfRvaAndSizes		", 0

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
	mov  ax, word ptr [edi + esi]
	mov SignatureVal, ax
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
	xor eax, eax
	mov ax, SignatureVal
	mov esi, eax
	push eax
	call PrintForDword

;---------------File Header-----------------------------
	push offset FileHeaderText
	call StdOut
	call Newline
	
;Machine
	push offset MachineText
	call StdOut
	push esi
	call PrintForWord
;NumberOfSections
	push offset NumberOfSectionsText
	call StdOut
	push esi
	call PrintForWord
;TimeDateStamp
	push offset TimeDateStampText
	call StdOut
	push esi
	call PrintForDword
;PointerToSymbolTable
	push offset PointerToSymbolTableText
	call StdOut
	push esi
	call PrintForDword
;NumberOfSymbol
	push offset NumberOfSymbolText
	call StdOut
	push esi
	call PrintForDword
;SizeOfOptionalHeader
	push offset SizeOfOptionalHeaderText
	call StdOut
	push esi
	call PrintForWord
;Characteristics
	push offset CharacteristicsText
	call StdOut
	push esi
	call PrintForWord

;----------------OPTIONAL HEADER----------------
	push offset OptionalHeaderText
	call StdOut
	call Newline
;Magic
	cmp word ptr [edi + esi], 10Bh
	jz	Continue_1
	mov al, 64
	mov PE, al
Continue_1:
	push offset MagicText
	call StdOut
	push esi
	call PrintForWord
;MajorLinkerVersion
	push offset MajorLinkerVersionText
	call StdOut
	push esi
	call PrintForByte
;MinorLinkerVersion
	push offset MinorLinkerVersionText
	call StdOut
	push esi
	call PrintForByte
;SizeOfCode
	push offset SizeOfCodeText
	call StdOut
	push esi
	call PrintForDword
;SizeOfInitializedData
	push offset SizeOfInitializedDataText
	call StdOut
	push esi
	call PrintForDword
;SizeOfUninitializedData
	push offset SizeOfUninitializedDataText
	call StdOut
	push esi
	call PrintForDword
;AddressOfEntryPoint
	push offset AddressOfEntryPointText
	call StdOut
	push esi
	call PrintForDword
;BaseOfCode
	push offset BaseOfCodeText
	call StdOut
	push esi
	call PrintForDword
	
	cmp PE, 32
	jnz Continue_2
;BaseOfData (only exist in PE32)
	push offset BaseOfDataText
	call StdOut
	push esi
	call PrintForDword
;ImageBase
	push offset ImageBaseText
	call StdOut
	push esi
	call PrintForDword
	jmp Continue_3
Continue_2:
	push offset ImageBaseText
	call StdOut
	push esi
	call PrintForQword
	
Continue_3:
;SectionAlignment
	push offset SectionAlignmentText
	call StdOut
	push esi
	call PrintForDword
;FileAlignment
	push offset FileAlignmentText
	call StdOut
	push esi
	call PrintForDword
;MajorOperatingSystemVersion
	push offset MajorOperatingSystemVersionText
	call StdOut
	push esi
	call PrintForWord
;MinorOperatingSystemVersion
	push offset MinorOperatingSystemVersionText
	call StdOut
	push esi
	call PrintForWord
;MajorImageVersion
	push offset MajorImageVersionText
	call StdOut
	push esi
	call PrintForWord
;MinorImageVersion
	push offset MinorImageVersionText
	call StdOut
	push esi
	call PrintForWord
;MajorSubsystemVersion
	push offset MajorSubsystemVersionText
	call StdOut
	push esi
	call PrintForWord
;MinorSubsystemVersion
	push offset MinorSubsystemVersionText
	call StdOut
	push esi
	call PrintForWord
;Win32VersionValue
	push offset Win32VersionValueText
	call StdOut
	push esi
	call PrintForDword
;SizeOfImage
	push offset SizeOfImageText
	call StdOut
	push esi
	call PrintForDword
;SizeOfHeaders
	push offset SizeOfHeadersText
	call StdOut
	push esi
	call PrintForDword
;CheckSum
	push offset CheckSumText
	call StdOut
	push esi
	call PrintForDword
;SubSystem
	push offset SubSystemText
	call StdOut
	push esi
	call PrintForWord
;DllCharacteristics
	push offset DllCharacteristicsText
	call StdOut
	push esi
	call PrintForWord
;SizeOfStackReserve
	cmp  PE, 32
	jnz  Continue_4
	push offset SizeOfStackReserveText
	call StdOut
	push esi
	call PrintForDword
	jmp Continue_5
Continue_4:
	push offset SizeOfStackReserveText
	call StdOut
	push esi
	call PrintForQword
Continue_5:
;SizeOfStackCommit
	cmp  PE, 32
	jnz  Continue_6
	push offset SizeOfStackCommitText
	call StdOut
	push esi
	call PrintForDword
	jmp  Continue_7
Continue_6:
	push offset SizeOfStackCommitText
	call StdOut
	push esi
	call PrintForQword
Continue_7:
;SizeOfHeapReserve
	cmp  PE, 32
	jnz  Continue_8
	push offset SizeOfHeapReserveText
	call StdOut
	push esi
	call PrintForDword
	jmp Continue_9
Continue_8:
	push offset SizeOfHeapReserveText
	call StdOut
	push esi
	call PrintForQword
	
Continue_9:
;SizeOfHeapCommit
	cmp  PE, 32
	jnz  Continue_10
	push offset SizeOfHeapCommitText
	call StdOut
	push esi
	call PrintForDword
	jmp Continue_11
Continue_10:
	push offset SizeOfHeapCommitText
	call StdOut
	push esi
	call PrintForQword
Continue_11:
;LoaderFlags
	push offset LoaderFlagsText
	call StdOut
	push esi
	call PrintForDword
;NumberOfRvaAndSizes
	push offset NumberOfRvaAndSizesText
	call StdOut
	push esi
	call PrintForDword
	
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

PrintForQword proc
	push ebp
	mov ebp, esp
	mov esi, [ebp + 08h]
	add esi, 4
	mov ebx, dword ptr [edi + esi]
	push ebx
	call htoa
	push eax
	call StdOut
	sub esi, 4
	mov ebx, dword ptr [edi + esi]
	push ebx
	call htoa
	push eax
	call StdOut
	call Newline
	add esi, 8
	pop ebp
	ret 4
PrintForQword endp

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
	add esi, 4
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
	add esi, 2
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
	add esi, 1
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
