Memory Addressing Limitations

I was thinking the issue was with LBA and CHS address. However, it'sabout the memory addressing limitation in real mode.

The kernel is loaded in 0x100000, which is beyond what real mode can reach.

You can do a segment:offset attemp to reach the hih memory. However, the better solution is to load the kernel to a lower address first (below 1MB), then after entering protected/long mode, copy it to 0x100000.

The LBA extension (Int 13h/ Ah = 42h) would help if I needed to load from larger disks or handle more sectors than CHS allows but they don't solve the memory addressing limitation

