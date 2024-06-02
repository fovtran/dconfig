Now the content of the 114 bytes after the RTC is specific to the system's firmware, 
so the general method to change it is, on one machine enter the BIOS settings menu on boot, 
and set parameters as required. 
Then when the machine is fully booted, one can copy the settings with the 

dd if=/dev/nvram of=nvram.saved 
od -Ax -tx1z -v /dev/nvram

# flashrom --programmer internal -c "CHIPNAME" -r backup_CHIPNAME.bin

Write and verify the new BIOS image (proprietary or Coreboot) on the ROM chip:

# flashrom --programmer internal -c "CHIPNAME" -w newbios.bin

Or for GRUB2 in /boot/grub/grub.cfg:

/boot/grub/grub.cfg

menuentry "Flash BIOS" {
 linux16 /boot/memdisk
 initrd16 /boot/flashbios.img
}

Get the bios update iso from the vendor support site. Run the geteltorito image extraction:

$ geteltorito.pl -o <image>.img <image>.iso

Copy the image to the usb thumbdrive:

# dd if=<image>.img of=<destination> bs=512K


If your other machines have exactly the same BIOS settings then it's trivial 
to copy them to the other machines with the dd of=/dev/nvram if=nvram.saved command.

Things get a bit more involved if you want to set particular parameters independently from each other. 
In this case you must update the CRC which the firmware uses to check for corrupted settings 
(due to the battery losing charge for example). 
For my current system at least, the CRC is in the position shown above, 
and covers the white bytes in the diagram. However I have another system, 
where the CRC is 2 bytes further into the NVRAM. 
This is easy to determine by comparing hexdumps of the NVRAM before and after you change a setting. 
For example here are hexdumps (using od -Ax -tx1z -v /dev/nvram) 
before and after I set the thermal reboot limit in my BIOS settings: 


