# Memory Map

| Region    | Addr       | Size | Desc                 |
| --------- | ---------- | ---- | -------------------- |
| Real mode | 0x7C00     | 512B | Bootloader           |
| Kernel    | 0x0x100000 | ?    | Kernel loaded (1MB+) |

The stack grow downwards.

x86 stack
- bp (base pointer)
- sp (stack pointer)
