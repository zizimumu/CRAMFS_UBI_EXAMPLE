
1. execute demo_linux_nandflash.bat to write image file to SAMA5D27 xplained board,
after system boot, need to set uboot env as below:

setenv bootargs 'console=ttyS0,115200 mtdparts=atmel_nand:256k(bootstrap)ro,768k(uboot)ro,256k(env_redundant),256k(env),512k(dtb),6M(kernel)ro,100M(cramfs)ro,-(rootfs) rootfstype=cramfs root=/dev/mtdblock5 video=HDMI-A-1:1152x768-16'

setenv bootcmd 'nand read 0x21000000 0x00180000 0x8266; nand read 0x22000000 0x00200000 0x400000; bootz 0x22000000 - 0x21000000'

2. 
挂载
ubiattach /dev/ubi_ctrl -m 6 -d 0
mount -t ubifs ubi0_0 /mnt

卸载
umount /mnt/ubi
ubidetach -d 0
