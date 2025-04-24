#define VIDEO_MEMORY_LOCATION 0xB8000
#define VGA_COL 80
#define VGA_ROW 25

void kmain() {
    char *video_memory = (char *)VIDEO_MEMORY_LOCATION;

    for (int i = 0; i < VGA_COL * VGA_ROW; i++) {
        video_memory[i * 2] = ' ';
        video_memory[i * 2 + 1] = 0x07;
    }

    const char str[] = "Hello";
    int i = 0;
    while (str[i]) {
        *video_memory = str[i];
        *(video_memory + 1) = 0x07;
        i++;
        video_memory += 2;
    }

    const char *str2 = " world!";
    while (*str2) {
        *video_memory = *str2;
        *(video_memory + 1) = 0x07;
        str2++;
        video_memory += 2;
    }

    while(1) {
        asm volatile ("hlt");
    }
}
