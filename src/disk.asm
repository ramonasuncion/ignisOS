; dl = drive number is set as input to disk_load
; es:bx = buffer pointer is set as input as well
disk_load:
    push     dx

    mov      ah, 0x2                    ; read mode
    mov      al, dh                     ; read dh number of sectors
    mov      cl, 0x02                   ; start from sector 2 (sector 1 is our boot loader)
    mov      ch, 0x00                   ; cylinder 1
    mov      dh, 0x00                   ; head 0

    int      0x13                       ; bios interrupt
    jc       disk_error                 ; check carry bit for error

    pop      dx                         ; original number of sectors to read
    cmp      al, dh                     ; bios sets al to # of sectors read. error out if not the same.
    jne      disk_error

    ret

disk_msg:
    db       'Loaded disk...', 0

disk_error:
    mov      si, disk_error_msg
    call     print_string
    jmp      $

disk_error_msg:
    db       'Disk read error!', 0

; TODO: https://wiki.osdev.org/Disk_access_using_the_BIOS_(INT_13h)#64-bit_Addressing_Extensions

; first stage use basic INT 13h (Set AH = 02h) to load second stage
; second stage use basic INT 13h (Set AH = 0x41) Extended with LBA addressing to load in kernel.

; having problems because of real-mode segment:offset accessing higher memory address and CHS address is limited in general

; disk_load_ext:

