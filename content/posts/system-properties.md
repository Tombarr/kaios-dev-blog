+++
title = "KaiOS System Properties"
description = "Reading and writing system properties on KaiOS"
date = 2024-03-28T00:00:00+08:00
lastmod = 2024-03-28T00:00:00+08:00
toc = true
draft = false
header_img = "img/home-alt.png"
tags = ["KaiOS", "System", "Security"]
categories = []
series = ["Advanced Development"]
+++

![KaiOS Architecture](/img/kaios-flows.jpg "KaiOS Architecture (Source: <a href='https://scottiestech.info/2019/09/24/dumbphone-with-kaios-hang-on-isnt-that-a-smartphone/flows/' rel='external noopener'>scottiestech.info</a>)")

# Reading and writing system properties on KaiOS

KaiOS is a partially open source mobile Linux distribution that, under the hood, makes significant use of Android components like the Hardware Abstraction Layer (HAL). Gonk is KaiOS' platform denomination for a combination of the Linux kernel and Android HAL, borrowed from it's predecessor Firefox OS.

Like Android, KaiOS has system properties that provide a convenient way to share information like configurations, system-wide. These are stored in read-only property files (`.prop` extension) like `bootimg/ramdisk/default.prop` and `system/build.prop`. System properties are then managed by `property_service` to populate its internal in-memory database at start-up.

System properties are stored in a key-value format and include useful information like the device model name (`ro.product.model`), whether debug mode is enabled (`ro.debuggable`), and the timestamp when the OS build was generated (`ro.bootimage.build.date.utc`).

### Android Device Bridge (ADB)

Like Android, system properties are accessible using the `getprop` and `setprop` shell commands via the Android Device Bridge (ADB). Not all commercial KaiOS devices will be equip with ADB vendor keys, in which case you'll get an `unauthorized` error message.

```bash
adb shell getprop ro.build.version.sdk
adb shell setprop ctl.stop wpa_supplicant
```

### Low-level Access

Static libraries like `libcutils` (`system/lib/libcutils.so`) contain wrappers to access system properties via native contexts in C/C++. In KaiOS, this is abstracted via [SystemProperty.cpp](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/system/gonk/SystemProperty.cpp) which lazy-loads `libcutils` used throughout Gonk.

```cpp
// Get system property, null default value
Property::Get("ro.build.version.sdk", value, nullptr);

// Set system property to "radvd"
Property::Set("ctl.start", "radvd");
```

The second example uses another special property that communicates with [init.rc]. Control messages–`ctl.start`, `ctl.stop`, and `ctl.restart`–do as their name suggests: identify a service by name and start, stop, or restart it.

`libcutils` is also exponsed via XPCOM components from a Javascript context within the Gecko system context.

```js
// Get system property, with "1" as the default value
let numClients = libcutils.property_get("ro.moz.ril.numclients", "1");

// Set system property value to "1"
libcutils.property_set("sys.boot_completed", "1");
```

### EngMode API

System properties are also accessible to [certified]({{< ref "certified-apps" >}} "certified") KaiOS apps using the [Engmode API ]({{< ref "./kaios-permissions" >}}). Behind the scenes, the Engmode API uses the same `libcutils` component packaged with the [`omni.ja`](https://udn.realityripple.com/docs/Mozilla/About_omni.ja_(formerly_omni.jar)) file.

#### KaiOS 2.5

```js
// Get system property
let buildType = navigator.engmodeExtension.getPropertyValue("ro.build.type");

// Set system property value to "b2g"
navigator.engmodeExtension.setPropertyValue("ctl.stop", "b2g");
```

#### KaiOS 3.0

```js
// Get system property, returns Promise<string>
navigator.b2g.engmodeManager.getPropertyValue("ro.operator.name")
    .then((operator) => console.log(operator));

// Set system property value to "1"
navigator.b2g.engmodeManager.setPropertyValue("persist.service.adb.enable", "1");
```

<u>Over-permissioning</u>: In 2020, information security firm [NCC Group](https://research.nccgroup.com/wp-content/uploads/2020/08/KaiOS-Whitepaper_1.3.pdf) noted that the system Browser is over-permissioned with the `jrdextension` and `engmode` permissions. These are used to determine the carrier, but inadvertently grants access the Engmode API from Javascript executed on websites. This remains true across all tested version of KaiOS 2.5.

### TCT Web Server

Using the same methodology identified in [CVE-2023-33294]({{< ref "./CVE-2023-33294" >}}), it's possible to access and modify system properties from any Javascript context using `XMLHttpRequest`. A local HTTP server is exposed at `http://127.0.0.1:2929` on KaiOS 3.0 (`http://127.0.0.1:1380/engmode/` on the [JioPhone Prima 4G]({{< ref "whats-next-jiophone#jiophone-prima-4g" >}} "JioPhone Prima 4G") running KaiOS 2.5.4), that accepts arbitrary commands to run as root.

```js
let xhr = new XMLHttpRequest();
xhr.open("POST", "http://127.0.0.1:2929", true);
xhr.send('cmd=shell&shellcommand=getprop ro.build.type');
```

However, this method isn't recommended because it exploits a known vulnerability that doesn't work across all KaiOS versions. Moreover, the port, path, and command syntax vary across devices.

### Modifying Properties

Property namespaces (prefixes) are important, namely `ro` (for properties set only once), and `persist` (for properties that persist across reboots). Moreover, on KaiOS 2.5.4+ and KaiOS 3.0+, Security-Enhanced Linux (SELinux) [property contexts](https://source.android.com/docs/core/architecture/configuration/add-system-properties) apply, which may prevent certain properties from being modified even with `engmode` access.

## Example Property Files

The following property files are from the recent JioPhone Prima 4G.

#### `default.prop`

```
#
# ADDITIONAL_DEFAULT_PROPERTIES
#
persist.log.tag=I
ro.secure=1
ro.allow.mock.location=0
ro.debuggable=0
ro.zygote=zygote32
dalvik.vm.image-dex2oat-Xms=64m
dalvik.vm.image-dex2oat-Xmx=64m
dalvik.vm.dex2oat-Xms=64m
dalvik.vm.dex2oat-Xmx=512m
ro.dalvik.vm.native.bridge=0
debug.atrace.tags.enableflags=0
camera.disable_zsl_mode=1
ro.gpu.boost=0
persist.sys.usb.config=cdrom
sys.usb.controller=musb-hdrc.0.auto
ro.support.auto.roam=disabled
#
# BOOTIMAGE_BUILD_PROPERTIES
#
ro.bootimage.build.date=2023年 09月 01日 星期五 15:45:31 CST
ro.bootimage.build.date.utc=1693554331
ro.bootimage.build.fingerprint=Jio/F491H/F491H:6.0/MRA58K/Jio-F491H-F001-04-13-310823:user/release-keys
```

#### `build.prop`

```

# begin build properties
# autogenerated by buildinfo.sh
ro.build.id=MRA58K
ro.build.display.id=MRA58K release-keys
ro.build.version.incremental=Jio-F491H-F001-04-13-310823
ro.build.version.sdk=23
ro.build.version.preview_sdk=0
ro.build.version.codename=REL
ro.build.version.all_codenames=REL
ro.build.version.release=6.0
ro.build.version.security_patch=2016-07-01
ro.build.version.base_os=
ro.build.date=2023年 09月 01日 星期五 15:42:27 CST
ro.build.date.utc=1693554147
ro.build.type=user
ro.build.user=serveradmin
ro.product.version_tag=kaios_jp4_pier_odm_20230829_10
ro.fota.sw_ver=F.001.04.13
ro.fota.cu_ref=F491H-PBJIINB
ro.product.base_version=SPRDROID6.0_KAIOS_17D_RLS3_W20.52.2_P1
ro.product.sar_value=Head SAR: 0.89 W/kg Body SAR: 1.37
ro.build.host=bjfih007
ro.build.tags=release-keys
ro.build.flavor=MAD-user
ro.product.model=F491H
ro.product.brand=JIO
ro.product.name=MAD
ro.product.device=F491H
ro.product.board=sp9820e_1h10
# ro.product.cpu.abi and ro.product.cpu.abi2 are obsolete,
# use ro.product.cpu.abilist instead.
ro.product.cpu.abi=armeabi-v7a
ro.product.cpu.abi2=armeabi
ro.product.cpu.abilist=armeabi-v7a,armeabi
ro.product.cpu.abilist32=armeabi-v7a,armeabi
ro.product.cpu.abilist64=
ro.product.manufacturer=LYF-JP4
ro.product.locale=en-US
ro.wifi.channels=
ro.board.platform=sp9820e
# ro.build.product is obsolete; use ro.product.device
ro.build.product=MAD
# Do not try to parse description, fingerprint, or thumbprint
ro.build.description=MAD-user 6.0 MRA58K Jio-F491H-F001-04-13-310823 release-keys
ro.build.fingerprint=Jio/F491H/F491H:6.0/MRA58K/Jio-F491H-F001-04-13-310823:user/release-keys
ro.build.characteristics=default
# end build properties
#
# from device/sprd/sharkle/sp9820e_1h10/system.prop
#
# Default density config
ro.sf.lcd_density=120
ro.sf.lcd_width=24
ro.sf.lcd_height=32
ro.product.hardware=sp9820e_1h10
# Set Opengl ES Version
ro.opengles.version=196609

# ro.fm.chip.port.UART.androidm=true

# FRP property for pst device
ro.frp.pst=/dev/block/platform/soc/soc:ap-ahb/20600000.sdio/by-name/persist

#disable zsl function until zsl capture is ready
persist.sys.cam.zsl=false

#add for torch node
ro.kaios.torch_node=/sys/devices/virtual/misc/sprd_flash/test
ro.kaios.torch_enable_value=10
ro.kaios.torch_disable_value=11
persist.sys.aov.support=false
persist.sys.mmi2.support=false
ro.product.brand=LYF

#enable audio nr tuning
ro.audio_tunning.nr=1

ro.build.cver=UN_9820_4_4_83_SEC_1

#
# ADDITIONAL_BUILD_PROPERTIES
#
ro.config.ringtone=Ring_Synth_04.ogg
ro.config.notification_sound=pixiedust.ogg
ro.carrier=unknown
ro.config.alarm_alert=Alarm_Classic.ogg
persist.sys.engpc.disable=1
persist.sys.sprd.modemreset=1
ro.product.partitionpath=/dev/block/platform/soc/soc:ap-ahb/20600000.sdio/by-name/
ro.modem.l.dev=/proc/cptl/
ro.modem.l.tty=/dev/stty_lte
ro.modem.l.eth=seth_lte
ro.modem.l.snd=1
ro.modem.l.diag=/dev/sdiag_lte
ro.modem.l.log=/dev/slog_lte
ro.modem.l.loop=/dev/spipe_lte0
ro.modem.l.nv=/dev/spipe_lte1
ro.modem.l.assert=/dev/spipe_lte2
ro.modem.l.vbc=/dev/spipe_lte6
ro.modem.l.id=0
ro.modem.l.fixnv_size=0xc8000
ro.modem.l.runnv_size=0xe8000
persist.modem.l.nvp=l_
persist.modem.l.enable=1
ro.radio.modemtype=l
ro.telephony.default_network=11
ro.modem.l.count=1
persist.msms.phone_count=1
persist.radio.multisim.config=ssss
keyguard.no_require_sim=true
ro.com.android.dataroaming=false
ro.simlock.unlock.autoshow=1
ro.simlock.unlock.bynv=0
ro.simlock.onekey.lock=0
ro.storage.flash_type=2
sys.internal.emulated=1
persist.storage.type=2
ro.storage.install2internal=0
drm.service.enabled=false
ro.treble.enabled=true
ro.product.first_api_level=26
ro.vendor.vndk.version=1
persist.sys.sprd.wcnreset=1
persist.sys.apr.enabled=0
persist.sys.start_udpdatastall=0
persist.sys.apr.intervaltime=1
persist.sys.apr.testgroup=CSSLAB
persist.sys.apr.autoupload=1
persist.sys.heartbeat.enable=1
persist.sys.power.touch=1
persist.recents.sprd=1
ro.kaios.use_timerfd=true
ro.kaios.usb.functions_node=/config/usb_gadget/g1/configs/b.1/strings/0x409/configuration
ro.kaios.ums.directory_node=/config/usb_gadget/g1/functions/mass_storage.gs6
ro.kaios.mtp.directory_node=/config/usb_gadget/g1/functions/mtp.gs0
ro.kaios.usb.state_node=/sys/class/android_usb/android0/state
ro.wcn.hardware.product=sharkle
ro.wcn.hardware.etcpath=/system/etc
ro.bt.bdaddr_path=/data/misc/bluedroid/btmac.txt
ro.hotspot.enabled=1
reset_default_http_response=true
ro.void_charge_tip=true
ro.softaplte.coexist=true
ro.vowifi.softap.ee_warning=false
persist.sys.wifi.pocketmode=true
ro.wcn=enabled
ro.softap.whitelist=true
ro.btwifisoftap.coexist=true
persist.wifi.func.hidessid=true
ro.wifi.softap.maxstanum=10
ro.wifi.signal.optimized=true
ro.support.auto.roam=disabled
ro.wifip2p.coexist=true
ro.modem.wcn.enable=1
ro.modem.wcn.diag=/dev/slog_wcn
ro.modem.wcn.id=1
ro.modem.wcn.count=1
ro.modem.gnss.diag=/dev/slog_gnss
persist.sys.support.vt=false
persist.sys.csvt=false
persist.radio.modem.workmode=3,10
persist.radio.modem.config=TL_LF_W_G,G
persist.radio.ssda.mode=csfb
persist.radio.ssda.testmode=3
persist.radio.ssda.testmode1=10
ro.wcn.gpschip=ge2
persist.dbg.wfc_avail_ovr=1
persist.sys.vowifi.voice=cp
persist.sys.cam.refocus.enable=false
ro.lockscreen.disable.default=true
ro.moz.ril.numclients=1
ro.moz.ril.query_icc_count=true
ro.moz.ril.radio_off_wo_card=true
ro.moz.ril.data_reg_on_demand=true
ro.moz.ril.ipv6=true
ro.moz.ril.0.network_types=lte
ril.ecclist=112,911,122
persist.user.agent=default
persist.data.collector.enable=true
persist.device.vowifi.supported=true
persist.sys.volte.enable=true
ro.product.fota=redbend
ro.moz.nfc.enabled=false
ro.build.cver=UN_9820_4_4_83_SEC_1
ro.embms.enable=1
persist.sys.dalvik.vm.lib.2=libart
dalvik.vm.isa.arm.variant=generic
dalvik.vm.isa.arm.features=default
net.bt.name=Android
dalvik.vm.stack-trace-file=/data/anr/traces.txt
ro.expect.recovery_id=0xd65615fd4cbd808139fbedcc46c59e4481a764c4000000000000000000000000
```

## Conclusion

KaiOS' kernel-level component, Gonk, is built on top of Android's board support package (BSP) and hardware abstraction layer (HAL). As a result, it retains many features like system properties. Most app developers do not need low-level access, but in rare cases, it can be useful because the necessary data isn't exposed via other APIs. If you need an expert-level KaiOS partner, contact the author from the [About]({{< ref "about" >}} "About") page.
