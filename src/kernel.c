// kprint

// idt -  Having a working and reliable interrupt/exception handling system that can dump the contents of the registers (and perhaps the address of the fault) will be very useful.
// https://wiki.osdev.org/Interrupt_Descriptor_Table#:~:text=The%20Interrupt%20Descriptor%20Table%20(IDT,(one%20per%20interrupt%20vector).
// https://wiki.osdev.org/Interrupts
// https://forum.osdev.org/download/file.php?id=3406

// Outputting to a serial port will save you a lot of debugging time. You don't have to fear losing information due to scrolling. You will be able to test your OS from a console, filter interesting debug messages, and automatize some tests.

//  Plan your memory map (virtual, and physical) : decide where you want the data to be -  https://forum.osdev.org/viewtopic.php?t=57323 I want identity mapping but is that the best?
// https://wiki.osdev.org/Memory_management

//  The heap: allocating memory at runtime (malloc and free) is almost impossible to go without. It should be implemented as soon as possible.

//  Once those steps are completed, whether you'll try to have a working GUI before you have a filesystem, multitasking or module-loading is completely up to you. Try to sketch out what is likely to depend on what, and do things in 'least dependent first' order.

//  For instance, the GUI could depend on the filesystem to load bitmaps or resources, but you don't necessarily need bitmaps in your very first GUI. Good advice in such a case is to design the interface of the filesystem first (be it open/close/read/write or something else), and then go on with whatever you prefer, respecting the interface on both sides.


void kmain()
{
  while (1) { }
}
