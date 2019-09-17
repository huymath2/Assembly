GLOBAL _start

section .data
	newline 		db 0ah,0
	lmsg			db "Enter the path of file : ",0
	space			db " ", 0
;------------- lable header ----------------
	lHeader 		db "ELF Header:	",0ah,0
	lMagic 			db "  Magic : ",0
	lClass 			db "  Class : ",0
	lData  			db "  Data : ",0
	lVersion 		db "  Version : ",0
	lOSABI 			db "  OS/ABI : ",0
	lABIVersion		db "  ABI Version : ",0
	lType 			db "  Type : ",0
	lMachine 		db "  Machine : ",0
	lEPaddress 		db "  Entry point address : ",0
	lSop_header		db "  Start of program headers : ",0
	lSos_header 	db "  Start of section headers : ",0
	lFlags 			db "  Flags : ",0
	lSot_header		db "  Size of this headers : ",0
	lSizeop_header 	db "  Size of program headers : ",0
	lNop_header 	db "  Number of program headers : ",0
	lSizeos_header 	db "  Size of section headers : ",0
	lNos_header 	db "  Number of section headers : ",0
	lShsti 			db "  Section header string table index : ",0

;------------- data header ----------------
	;---------- Class ------------------
	cClass1			db "ELF32",0
	cClass2			db "ELF64",0
	;---------- Data ------------------
	cData1			db	"little endian",0 
	cData2			db	"big endian",0 
	EI_DATA			dd cData1,cData2
	;---------- Version ------------------
	cVer			db "1 (current)",0 
	EI_VERSION 		dd cVer
	
	;---------- OSABI ------------------
	cOSABI00		db "System V",0
	cOSABI01		db "Hewlett-Packard HP-UX",0
	cOSABI02		db "NetBSD",0
	cOSABI03		db "Linux",0
	cOSABI04		db "GNU Hurd",0
	cOSABI05		db "",0
	cOSABI06		db "Sun Solaris",0
	cOSABI07		db "AIX",0
	cOSABI08		db "IRIX",0
	cOSABI09		db "FreeBSD",0
	cOSABI0A		db "Compaq TRU64 UNIX",0
	cOSABI0B		db "Novell Modesto",0
	cOSABI0C		db "OpenBSD",0
	cOSABI0D		db "OpenVMS",0
	cOSABI0E		db "NonStop Kernel",0
	cOSABI0F		db "AROS",0
	cOSABI10		db "Fenix OS",0
	cOSABI11		db "CloudABI",0
	EI_OSABI		dd cOSABI00,cOSABI01,cOSABI02,cOSABI03,cOSABI04,cOSABI05,cOSABI06,cOSABI07,cOSABI08,cOSABI09,cOSABI0A,cOSABI0B,cOSABI0C,cOSABI0D,cOSABI0E,cOSABI0F,cOSABI10,cOSABI11

	;---------- Type ------------------
	cType00			db "ET_NONE",0
	cType01			db "ET_REL",0
	cType02			db "ET_EXEC",0
	cType03			db "ET_DYN",0
	cType04			db "ET_CORE",0
	cTypefe00		db "ET_LOOS",0
	cTypefeff		db "ET_HIOS",0
	cTypeff00		db "ET_LOPROC",0
	cTypeffff		db "ET_HIPROC",0
	;---------- Machine ------------------
	cMachine02 		db "SPARC",0
	cMachine03 		db "x86",0
	cMachine08 		db "MIPS",0
	cMachine14 		db "PowerPC",0
	cMachine16 		db "S390",0
	cMachine28 		db "ARM",0
	cMachine2A 		db "SuperH",0
	cMachine32 		db "IA-64",0
	cMachine3E 		db "x86-64",0
	cMachineB7 		db "AArch64",0
	cMachineF3 		db "RISC-V",0

section .bss
	buffer resb 100
	fileHandle resd 1
	fileContents resb 150
	string resb 20

section .text

_start:
	push lmsg
	call Printf

;;open file
	push 100
	push buffer
	call Scanf
	push buffer
	call Strlen
	mov byte [buffer + eax - 1], 0

.openfile:
	mov ecx, 0
	mov ebx, buffer
	mov eax, 5
	int 80h
	mov [fileHandle], eax
;Magic
	call WriteMagic

exit:
	mov eax, 1
	xor ebx, ebx
	int 80h

WriteMagic:
	pushad
		
.readfile:
	mov edx,16				; read 16 byte
	mov ecx,fileContents	
	mov ebx,[fileHandle]
	mov eax,3 
	int 80h
	

	push lHeader
	call Printf
	push lMagic
	call Printf
	mov ecx,16
	mov esi,0
.L1:
	push ecx
	movsx eax,byte [fileContents+esi]
	push eax
	call htoa
	push eax
	call Printf
	push space 
	call Printf
	inc esi
	pop ecx
	loop .L1

	push newline
	call Printf
	
	popad
	ret 


htoa: ;hex to integer
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
	mov esi, string
loop_store:
	pop	ebx
	cmp ebx, 80h
	jz done
	mov byte [esi], bl
	inc esi
	jmp loop_store

goto_zero:
	mov esi, string
	mov byte [esi], 30h
	inc esi
done:
	mov byte [esi], 0
	mov eax, string
	pop esi
	pop ebp
	ret 4


Printf:
	push ebp ; save ebp value
	mov ebp, esp ; take ebp point to current pos in stack
	mov ecx, [ebp + 08h] ; string offset
	push ecx
	call Strlen
	mov edx, eax
	mov eax, 4 ; StdOut
	mov ebx, 1
	int 80h
	pop ebp ; return value of ebp
	ret 4h ; return position of stack before call Printf
	
Scanf:
	push ebp ; save ebp value
	mov ebp, esp ; take ebp point to current pos in stack
	mov ecx, [ebp + 08h] ; string offset
	mov edx, [ebp + 0Ch] ; length of string
	mov eax, 3 ; StdIn
	mov ebx, 2
	int 80h
	pop ebp
	ret 8h


Strlen:
	push ebp
	mov ebp, esp
	push ecx
	mov ecx, [ebp + 08h]
	xor eax, eax
loop_Strlen:
	inc eax
	cmp byte[ecx + eax], 0
	jnz loop_Strlen
	pop ecx
	pop ebp
	ret 4h

Newline:
	push newline
	call Printf
	ret
