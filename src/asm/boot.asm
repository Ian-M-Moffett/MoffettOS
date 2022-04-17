global start
extern kmain


section .text
bits 32
start:
    mov eax, p3_table
    or eax, 0b11                    ; Present, RW
    mov dword [p4_table], eax       ; Set first entry to p3_table.

    mov eax, p2_table               
    or eax, 0b11                    ; Present RW.
    mov dword [p3_table], eax       ; Set first entry to p2_table

    xor ecx, ecx                    ; Zero ECX.

    .map_p2_table:
        mov eax, 0x200000                   ; 2 MiB
        mul ecx
        or eax, 0b10000011                  ; Huge page.
        mov [p2_table + ecx * 8], eax       ; Times 8 because each entry is 8 bytes.
        inc ecx
        cmp ecx, 512
        jne .map_p2_table

    mov eax, p4_table
    mov cr3, eax

    ; Enable PAE.
    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    ; Set long mode bit.
    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8
    wrmsr

    ; Enable paging.
    mov eax, cr0
    or eax, 1 << 31
    or eax, 1 << 16
    mov cr0, eax

    ; Tell CPU about GDT.
    lgdt [gdt64.pointer]

    ; Set segment registers.
    mov ax, gdt64.data
    mov ss, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax


    ; Far jump.
    jmp gdt64.code:lm_start    


section .rodata
gdt64:
    dq 0
.code: equ $ - gdt64
    dq (1<<44) | (1<<47) | (1<<41) | (1<<43) | (1<<53)
.data: equ $ - gdt64
    dq (1<<44) | (1<<47) | (1<<41)
.pointer:
    dw .pointer - gdt64 - 1
    dq gdt64

section .text
bits 64
lm_start:
    call kmain
    cli
    hlt

section .bss
align 4096
p4_table: resb 4096
p3_table: resb 4096
p2_table: resb 4096
