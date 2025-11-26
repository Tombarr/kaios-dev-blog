+++
title = "FAQ"
description = "KaiOS FAQs"
date = 2023-02-17T00:00:00+08:00
toc = true
draft = false
unlisted = true
header_img = "img/home-alt.png"
+++

# KaiOS FAQs

## Basics

### What hardware specifications do KaiOS phones have?

* 240x320 ~2.4-3" displays
* 256mb or 512mb RAM
* 3G or 4G
* ARM CPUs
  * Qualcomm, Spreadtrum & Mediatek
  * ~1GHz - 1.3GHz
  * Dual or Quad Core
* T9 or QWERTY keyboards
* D-Pad & Soft-Key (LSK & RSK) navigation
* WiFI & Bluetooth (optional)

### Is Instagram, Tik-Tok, Spotify, Uber, [insert app] available on KaiOS?

No. KaiOS has a number of popular apps, including:

* Facebook
* WhatsApp
* YouTube
* Google Assistant
* Google Search
* Google Maps
* Microsoft Outlook

As of February 2023, most other popular social network, music streaming, chat, or shopping apps are not available. The following are **not officially available on KaiOS**:

* Gmail (use default Email app)
* Discord
* Amazon
* Reddit (see [Zap Reddit](https://www.kaiostech.com/store/apps/?bundle_id=am.ambigr.zapredditclient))
* Telegram (see [Telekram](https://github.com/arma7x/svelte-telekram), an open-source client)
* SnapChat
* Zoom
* Signal

### Does KaiOS have group messaging?

No, KaiOS does not support group text messages (SMS or MMS). Also KaiOS does not support Rich Communication Services (RCS) used by modern Android phones as a substitute for Apple's iMessage.

### Is KaiOS open source?

KaiOS is a proprietary operating system based on Firefox OS, which was released under the "file-level" Mozilla Public License (MPL) 2.0. Parts of KaiOS source is available on [KaiOS Tech's GitHub](https://github.com/kaiostech/gecko-b2g).

### What's the difference between KaiOS 2.5 and 3.0?

Thanks to a combination of hardware and software upgrades, newer KaiOS 3.0 devices are noticeably smoother than older models running KaiOS 2.5. From a user perspective, there's little discernible difference. Most of the changes are under the hood. Here's a summary of key differences.

|          | KaiOS 2.5     | KaiOS 3.0 |
|--------------|-----------|------------|
| Availability      | Global | US-only       |
| Apps | 1300+      | 420        |
| Gecko Engine | v48      | v84        |
| ECMAScript      | ES2015 | ES2021       |
| PWAs      | No | Yes       |
| WebP      | No | Yes       |
| App Origin      | `app://app_name.com` | `http://app_name.localhost`       |
| Manifest      | `manifest.webapp` | `manifest.webmanifest`       |
| WASM      | [asm.js](https://developer.mozilla.org/en-US/docs/Games/Tools/asm.js) | Yes       |
| Debug Enabled      | Select Models | No       |

<u>Note</u>: Many popular apps like Facebook and WhatsApp are not available on KaiOS 3.0. Additionally, you **cannot sideload apps on KaiOS 3.0** so it's not possible to debug apps on KaiOS 3.0 devices.

### Can KaiOS 2.5 devices update to KaiOS 3.0?

No KaiOS 2.5 device has received an over-the-air (OTA) update with KaiOS 3.0, nor has KaiOS 3.0 been ported to older devices.

### Can KaiOS devices run Android?

No. It might be possible to port older versions of Android or MocorDroid to KaiOS phones, but not without great effort.

### Is there a BlackBerry-like KaiOS phone with a QWERTY keyboard?

There are two, the [JioPhone 2]({{< ref "whats-next-jiophone#jiophone-2" >}} "JioPhone 2")) (India-only), and the [Xandos X5](https://www.imei.info/phonedatabase/xandos-x5/) (3G only).

### Can KaiOS run Android apps?

No, Android apps are distributed as Android Packages (.apk) that require the Android Runtime (ART).

### Can KaiOS run Java/ J2ME games?

No, KaiOS does not include the Java 2 Mobile Edition (J2ME) runtime. It is possible to emulate J2ME on KaiOS with emulators like [Project Kava](https://gitlab.com/suborg/project-kava) but compabilitiy and usability will likely be poor.

### Can KaiOS play NES games?

Yes, there is an [NES Emulator](https://www.reddit.com/r/KaiOS/comments/y9olbz/ive_created_nes_emulator_for_kaios_3_its/) for KaiOS 3.0. Similar projects might work on KaiOS 2.5, but with poor performance.

## Development

Coming Soon

## Publishing

Coming Soon

## Monetizing

Coming Soon