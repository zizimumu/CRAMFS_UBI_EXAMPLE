#!/bin/bash

ROOTFS_DIR=./build_root
PAGE_SIZE=4096
SUB_PAGE_SIZE=4096
# free physic block = all block - used block - bad block = 2048 - 32
PHYSIC_BLK_NUM=2048
#already used blocks, e.g. uboot, kenerl,
USED_PHYSIC_BLKS=432 
LOGIC_ERASE_BLK_SZ=253952
# unit is KB
PHYSIC_ERASE_BLK_SZ=256



let B=PHYSIC_BLK_NUM*20/1024
echo "reserver ${B} blocks for bad block"

let o=(PHYSIC_ERASE_BLK_SZ*1024-LOGIC_ERASE_BLK_SZ)
#echo o=${o}
let "reserv=((B+4+USED_PHYSIC_BLKS)*PHYSIC_ERASE_BLK_SZ+(o/1024)*(PHYSIC_BLK_NUM-B-4-USED_PHYSIC_BLKS))"
echo "reserve ${reserv}KB"

let "valide=(PHYSIC_BLK_NUM*PHYSIC_ERASE_BLK_SZ - reserv )"
echo "valide ${valide}KB for free UBI"

#let "logic_blk_num=((valide*1024/PHYSIC_BLK_NUM)-1)"
let "logic_blk_num=((valide*1024/LOGIC_ERASE_BLK_SZ))"
echo "free logic_blk_num=${logic_blk_num}"

let "vol_size=logic_blk_num*LOGIC_ERASE_BLK_SZ/1024/1024"

echo "UBI vol size ${vol_size}MB"

# let "vol_size=valide/1024"


rm -rf ubi.cfg ubi_yocto.ubi

echo [ubifs] >> ubi.cfg
echo mode=ubi >> ubi.cfg
echo image=yocto_ubi.bin >> ubi.cfg
echo vol_id=0 >> ubi.cfg
echo vol_size=${vol_size}MiB >> ubi.cfg
echo vol_type=dynamic >> ubi.cfg
echo vol_name=rootfs >> ubi.cfg
echo vol_flags=autoresize >> ubi.cfg


mkfs.ubifs -r ${ROOTFS_DIR} -m ${PAGE_SIZE} -e ${LOGIC_ERASE_BLK_SZ} -c ${logic_blk_num} -o yocto_ubi.bin

ubinize -o ubi_yocto.ubi -m ${PAGE_SIZE} -p ${PHYSIC_ERASE_BLK_SZ}KiB -s ${SUB_PAGE_SIZE} ubi.cfg

rm -rf yocto_ubi.bin
echo "ubi image done success"
