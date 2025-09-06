; ------------------------------------------------------------------
; disk_load
; ------------------------------------------------------------------
; caller:
;   DL = drive
;   DH = head
;   CH = cylinder
;   CL = starting sector
;   AL = number of sectors
;   ES:BX = buffer
; ------------------------------------------------------------------

%macro multipop 1-*
    %rep %0
        %rotate -1
        pop %1
    %endrep
%endmacro

%macro multipush 1-*
    %rep %0
        %rotate -1
        push %1
    %endrep
%endmacro

disk_load:
    multipush bx, es

    mov    ah, 0x02
    int    0x13
    jc     .disk_error

    multipop es, bx
    ret

.disk_error:
    multipop es, bx
    mov    si, disk_error_msg
    call   print_string
    jmp    $

disk_msg:
    db 'Loaded disk...', 0

disk_error_msg:
    db 'Disk read error!', 0

