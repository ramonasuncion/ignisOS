print_string:
    mov ah, 0x0E                    ; bios teletype function
.loop:
    lodsb                           ; load byte from si into al
    test al, al                     ; check if end of string (0)
    jz .done                        ; if zero, we're done
    int 0x10                        ; call bios interrupt to print character
    jmp .loop
.done:
    ret

print_char:
	push ax
	mov ah, 0x0E											; bios teletype function
	int 0x10													; call bios interrupt to print character
	pop ax
	ret

print_newline:
	push ax
	mov al, 13												; carriage return
	call print_char
	mov al, 10												; line feed
	call print_char
	pop ax
	ret
