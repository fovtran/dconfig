./scripts/diffconfig .config ~/config-slub-nodebug-modules-5.4.188|grep n|awk '{print $1;}'|sed -e 's/+//'

/usr/src/linux-5.4.188/scripts/config -e BCACHE
/usr/src/linux-5.4.188/scripts/config -e DM_CACHE
/usr/src/linux-5.4.188/scripts/config -e DM_DELAY
/usr/src/linux-5.4.188/scripts/config -e DRM_BOCHS
/usr/src/linux-5.4.188/scripts/config -e FB_NVIDIA
/usr/src/linux-5.4.188/scripts/config -e FB_VESA
/usr/src/linux-5.4.188/scripts/config -e COUNTER
/usr/src/linux-5.4.188/scripts/config -e ATH9K_DYNACK
/usr/src/linux-5.4.188/scripts/config -e ATH9K_CHANNEL_CONTEXT
/usr/src/linux-5.4.188/scripts/config -e ATH9K_COMMON_SPECTRAL
/usr/src/linux-5.4.188/scripts/config -e I3C
/usr/src/linux-5.4.188/scripts/config -e POWERCAP
/usr/src/linux-5.4.188/scripts/config -e PCI_STUB
/usr/src/linux-5.4.188/scripts/config -e PCIE_DPC
/usr/src/linux-5.4.188/scripts/config -e DMA_VIRTUAL_CHANNELS
/usr/src/linux-5.4.188/scripts/config -e FB_BOOT_VESA_SUPPORT
/usr/src/linux-5.4.188/scripts/config -e FB_DDC
/usr/src/linux-5.4.188/scripts/config -e FB_NVIDIA_BACKLIGHT
/usr/src/linux-5.4.188/scripts/config -e FB_NVIDIA_I2C
/usr/src/linux-5.4.188/scripts/config -e TIMER_OF
/usr/src/linux-5.4.188/scripts/config -e TIMER_PROBE
/usr/src/linux-5.4.188/scripts/config -e VGASTATE
/usr/src/linux-5.4.188/scripts/config -d COMPILE_TEST
/usr/src/linux-5.4.188/scripts/config -d INTEGRITY_AUDIT
/usr/src/linux-5.4.188/scripts/config -d GENERIC_IRQ_DEBUGFS
/usr/src/linux-5.4.188/scripts/config -e PCIEASPM_DEBUG
/usr/src/linux-5.4.188/scripts/config -d PCI_SW_SWITCHTEC
/usr/src/linux-5.4.188/scripts/config -d SCSI_ISCI
/usr/src/linux-5.4.188/scripts/config -d SW_SYNC
/usr/src/linux-5.4.188/scripts/config -d VIRT_DRIVERS
/usr/src/linux-5.4.188/scripts/config -e VIRTIO_PCI_LEGACY
/usr/src/linux-5.4.188/scripts/config -e VGA_ARB
/usr/src/linux-5.4.188/scripts/config -m ZRAM
/usr/src/linux-5.4.188/scripts/config -e VXLAN

/usr/src/linux-5.4.188/scripts/config -d DEBUG_INFO 
/usr/src/linux-5.4.188/scripts/config -e LOCALVERSION_AUTO
/usr/src/linux-5.4.188/scripts/config -d X86_DECODER_SELFTEST
/usr/src/linux-5.4.188/scripts/config -e ATH9K_HWRNG
/usr/src/linux-5.4.188/scripts/config -d ATH_REG_DYNAMIC_USER_REG_HINTS
/usr/src/linux-5.4.188/scripts/config -m BLK_DEV_DRBD
/usr/src/linux-5.4.188/scripts/config -d BPF_STREAM_PARSER
/usr/src/linux-5.4.188/scripts/config -m COMMON_CLK_CDCE706
/usr/src/linux-5.4.188/scripts/config -m COMMON_CLK_CDCE925
/usr/src/linux-5.4.188/scripts/config -m COMMON_CLK_CS2000_CP
/usr/src/linux-5.4.188/scripts/config -m COMMON_CLK_MAX9485
/usr/src/linux-5.4.188/scripts/config -m COMMON_CLK_PALMAS
/usr/src/linux-5.4.188/scripts/config -m COMMON_CLK_SI514
/usr/src/linux-5.4.188/scripts/config -m COMMON_CLK_SI5341
/usr/src/linux-5.4.188/scripts/config -m COMMON_CLK_SI5351
/usr/src/linux-5.4.188/scripts/config -m COMMON_CLK_SI544
/usr/src/linux-5.4.188/scripts/config -m COMMON_CLK_SI570
/usr/src/linux-5.4.188/scripts/config -m COMMON_CLK_VC5
/usr/src/linux-5.4.188/scripts/config -d DM_WRITECACHE
/usr/src/linux-5.4.188/scripts/config -d GENERIC_IRQ_DEBUGFS
/usr/src/linux-5.4.188/scripts/config -e GLOB_SELFTEST
/usr/src/linux-5.4.188/scripts/config -m HP_WIRELESS
/usr/src/linux-5.4.188/scripts/config -m HP_WMI
/usr/src/linux-5.4.188/scripts/config -m I2C_ALGOPCA
/usr/src/linux-5.4.188/scripts/config -m I2C_AMD756_S4882
/usr/src/linux-5.4.188/scripts/config -m I2C_PARPORT
/usr/src/linux-5.4.188/scripts/config -m I2C_PARPORT_LIGHT
/usr/src/linux-5.4.188/scripts/config -m I2C_PCA_PLATFORM
/usr/src/linux-5.4.188/scripts/config -m I2C_TINY_USB
/usr/src/linux-5.4.188/scripts/config -d I2C_VIA
/usr/src/linux-5.4.188/scripts/config -d I2C_VIAPRO
/usr/src/linux-5.4.188/scripts/config -e IDLE_INJECT
/usr/src/linux-5.4.188/scripts/config -d LOCK_EVENT_COUNTS
/usr/src/linux-5.4.188/scripts/config -m MAC80211_HWSIM
/usr/src/linux-5.4.188/scripts/config -m MISC_RTSX
/usr/src/linux-5.4.188/scripts/config -m MISC_RTSX_USB
/usr/src/linux-5.4.188/scripts/config -m MSI_LAPTOP
/usr/src/linux-5.4.188/scripts/config -e NTB_IDT
/usr/src/linux-5.4.188/scripts/config -m NTB_TRANSPORT
/usr/src/linux-5.4.188/scripts/config -m PARPORT_PC
/usr/src/linux-5.4.188/scripts/config -m PLATFORM_MHU
/usr/src/linux-5.4.188/scripts/config -m PWM_LP3943
/usr/src/linux-5.4.188/scripts/config -m PWM_LPSS
/usr/src/linux-5.4.188/scripts/config -m PWM_LPSS_PCI
/usr/src/linux-5.4.188/scripts/config -m PWM_LPSS_PLATFORM
/usr/src/linux-5.4.188/scripts/config -d RAS_CEC_DEBUG
/usr/src/linux-5.4.188/scripts/config -d RCU_EQS_DEBUG
/usr/src/linux-5.4.188/scripts/config -m RPMSG
/usr/src/linux-5.4.188/scripts/config -m RPMSG_CHAR
/usr/src/linux-5.4.188/scripts/config -m RPMSG_VIRTIO
/usr/src/linux-5.4.188/scripts/config -d SECURITY_DMESG_RESTRICT
/usr/src/linux-5.4.188/scripts/config -e SLAB_FREELIST_HARDENED
/usr/src/linux-5.4.188/scripts/config -d SLAB_FREELIST_RANDOM
/usr/src/linux-5.4.188/scripts/config -m STRING_SELFTEST
/usr/src/linux-5.4.188/scripts/config -m SURFACE_3_BUTTON
/usr/src/linux-5.4.188/scripts/config -m SURFACE_PRO3_BUTTON
/usr/src/linux-5.4.188/scripts/config -m TUN
/usr/src/linux-5.4.188/scripts/config -m VETH
/usr/src/linux-5.4.188/scripts/config -m VIRTIO_BALLOON
/usr/src/linux-5.4.188/scripts/config -m VIRTIO_BLK
/usr/src/linux-5.4.188/scripts/config -m VIRTIO_INPUT
/usr/src/linux-5.4.188/scripts/config -m VIRTIO_MMIO
/usr/src/linux-5.4.188/scripts/config -m VIRTIO_PCI
/usr/src/linux-5.4.188/scripts/config -m VIRTIO_PMEM
/usr/src/linux-5.4.188/scripts/config -m VMD
/usr/src/linux-5.4.188/scripts/config -m VSOCKMON
/usr/src/linux-5.4.188/scripts/config -e ZRAM_MEMORY_TRACKING
/usr/src/linux-5.4.188/scripts/config -e ZRAM_WRITEBACK

./scripts/config --set-val CONFIG_DRM_FBDEV_OVERALLOC 300
./scripts/config -d CONFIG_DEBUG_TLBFLUSH


for a in $(./scripts/diffconfig .config ~/config-slub-nodebug-modules-5.4.188|grep n| grep RTC |awk '{print $1;}'|sed -e 's/+//'); do echo $a; done
for a in $(./scripts/diffconfig .config ~/config-slub-nodebug-modules-5.4.188|grep n| grep RESET |awk '{print $1;}'|sed -e 's/+//'); do ./scripts/config -d $a; done
for a in $(./scripts/diffconfig .config ~/config-slub-nodebug-modules-5.4.188|grep n| grep 'REGULATOR' |awk '{print $1;}'|sed -e 's/+//'); do ./scripts/config -d $a; done
for a in $(./scripts/diffconfig .config ~/config-slub-nodebug-modules-5.4.188|grep n| grep 'UNIPHIER' |awk '{print $1;}'|sed -e 's/+//'); do ./scripts/config -d $a; done
for a in $(./scripts/diffconfig .config ~/config-slub-nodebug-modules-5.4.188|grep n| grep 'USB' |awk '{print $1;}'|sed -e 's/+//'); do ./scripts/config -d $a; done
for a in $(./scripts/diffconfig .config ~/config-slub-nodebug-modules-5.4.188|grep n| grep 'TEGRA' |awk '{print $1;}'|sed -e 's/+//'); do ./scripts/config -d $a; done
for a in $(./scripts/diffconfig .config ~/config-slub-nodebug-modules-5.4.188|grep n| grep 'SUNXI' |awk '{print $1;}'|sed -e 's/+//'); do ./scripts/config -d $a; done
for a in $(./scripts/diffconfig .config ~/config-slub-nodebug-modules-5.4.188|grep n| grep 'STM32' |awk '{print $1;}'|sed -e 's/+//'); do ./scripts/config -d $a; done
for a in $(./scripts/diffconfig .config ~/config-slub-nodebug-modules-5.4.188|grep n| grep 'SPI' |awk '{print $1;}'|sed -e 's/+//'); do ./scripts/config -d $a; done
for a in $(./scripts/diffconfig .config ~/config-slub-nodebug-modules-5.4.188|grep n| grep 'SND' |awk '{print $1;}'|sed -e 's/+//'); do ./scripts/config -d $a; done
for a in $(./scripts/diffconfig .config ~/config-slub-nodebug-modules-5.4.188|grep n| grep 'SERIAL' |awk '{print $1;}'|sed -e 's/+//'); do ./scripts/config -d $a; done
for a in $(./scripts/diffconfig .config ~/config-slub-nodebug-modules-5.4.188|grep n| grep 'TI_' |awk '{print $1;}'|sed -e 's/+//'); do ./scripts/config -d $a; done
for a in $(./scripts/diffconfig .config ~/config-slub-nodebug-modules-5.4.188|grep n| grep 'SOC_' |awk '{print $1;}'|sed -e 's/+//'); do ./scripts/config -d $a; done
for a in $(./scripts/diffconfig .config ~/config-slub-nodebug-modules-5.4.188|grep n| grep 'ROCKCHIP' |awk '{print $1;}'|sed -e 's/+//'); do ./scripts/config -d $a; done
for a in $(./scripts/diffconfig .config ~/config-slub-nodebug-modules-5.4.188|grep n| grep 'SPRD' |awk '{print $1;}'|sed -e 's/+//'); do ./scripts/config -d $a; done
for a in $(./scripts/diffconfig .config ~/config-slub-nodebug-modules-5.4.188|grep n| grep 'RENESAS' |awk '{print $1;}'|sed -e 's/+//'); do ./scripts/config -d $a; done
for a in $(./scripts/diffconfig .config ~/config-slub-nodebug-modules-5.4.188|grep n| grep 'QCOM_' |awk '{print $1;}'|sed -e 's/+//'); do ./scripts/config -d $a; done
for a in $(./scripts/diffconfig .config ~/config-slub-nodebug-modules-5.4.188|grep n| grep 'PHY_' |awk '{print $1;}'|sed -e 's/+//'); do ./scripts/config -d $a; done
for a in $(./scripts/diffconfig .config ~/config-slub-nodebug-modules-5.4.188|grep n| grep 'PINCTRL_' |awk '{print $1;}'|sed -e 's/+//'); do ./scripts/config -d $a; done
for a in $(./scripts/diffconfig .config ~/config-slub-nodebug-modules-5.4.188|grep n| grep 'PCI_' |awk '{print $1;}'|sed -e 's/+//'); do ./scripts/config -d $a; done
for a in $(./scripts/diffconfig .config ~/config-slub-nodebug-modules-5.4.188|grep n| grep 'PWM_' |awk '{print $1;}'|sed -e 's/+//'); do ./scripts/config -d $a; done
for a in $(./scripts/diffconfig .config ~/config-slub-nodebug-modules-5.4.188|grep n| grep 'PCIE_' |awk '{print $1;}'|sed -e 's/+//'); do ./scripts/config -d $a; done
for a in $(./scripts/diffconfig .config ~/config-slub-nodebug-modules-5.4.188|grep n| grep 'SATA_' |awk '{print $1;}'|sed -e 's/+//'); do ./scripts/config -d $a; done
for a in $(./scripts/diffconfig .config ~/config-slub-nodebug-modules-5.4.188|grep n| grep 'OMAP' |awk '{print $1;}'|sed -e 's/+//'); do ./scripts/config -d $a; done
for a in $(./scripts/diffconfig .config ~/config-slub-nodebug-modules-5.4.188|grep n| grep 'NET_' |awk '{print $1;}'|sed -e 's/+//'); do ./scripts/config -d $a; done
for a in $(./scripts/diffconfig .config ~/config-slub-nodebug-modules-5.4.188|grep n| grep 'MESON_' |awk '{print $1;}'|sed -e 's/+//'); do ./scripts/config -d $a; done
