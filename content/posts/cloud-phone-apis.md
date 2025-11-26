+++
title = "What APIs are supported on CloudMosa's Cloud Phone?"
description = "A look at which Web APIs are available on Cloud Phone by CloudMosa"
date = 2024-08-09T00:00:00+08:00
lastmod = 2025-05-24T00:00:00+08:00
toc = true
draft = false
header_img = "img/nokia_110_4g_podlp.jpeg"
tags = ["Cloud Phone", "CloudMosa", "API", "Developer"]
categories = []
series = ["Getting Started"]
[params]
  featured_img = "img/nokia_110_4g_podlp.jpeg"
+++

# How Cloud Phone Works

![Cloud Phone Architecture](/img/puffin-architecture.png)

Cloud Phone is a remote browser with two key components: a thin client application that renders a proprietary vector graphics language on device, and a sandboxed server running Chrome to translate websites comprised of HTML, CSS, and JavaScript into a vector graphics language. Cloud Phone is based on the Puffin web browser and uses the proprietary [Puffin Vector Graphics Language](https://medium.com/cloudmosa-en/cloudmosas-cloud-avatar-the-world-s-most-advanced-remote-browsing-platform-9ae9d23dec0e). This greatly reduces the hardware requirements and bandwidth for running the thin client, allowing it to work effectively on devices like budget feature phones.

This three-tiered architecture also means that the Cloud Phone client needs to directly integrate with device hardware running on the Mocor/ ThreadX real time operating system (RTOS), _and_ share that information with the Puffin web server, in order to read certain data like the battery level. Support for new Web APIs that need device integration requires an over-the-air (OTA) update to the Cloud Phone client in order for existing users to benefit from new features.

Here's a quick look at the Web APIs that are, and are not, supported today on Cloud Phone.

# Web API Support

[Cloud Phone for Developers](https://www.cloudphone.tech/) launch in early 2025. See the updated list of [available Web APIs](https://developer.cloudfone.com/docs/guides/get-started/#web-api-availability) to find out what's supported on recent Cloud Phone versions.

## Networking

All requests made by a website occur between the Puffin servers and web servers. As a result, **Cloud Phone has strong support for protocols**, including:

- [x] XMLHttpRequest (XHR)
- [x] Fetch, including Streams
- [x] WebSockets
- [x] Server-Sent Events
- [x] Beacon
- [ ] WebTransport (untested)
- [ ] Web Push (unsupported)

WebTransport support hasn't been confirmed, but likely aligns with the Chromium version corresponding to deployed Puffin servers. [Web Push](https://developer.mozilla.org/en-US/docs/Web/API/Push_API) is not available, but support is planned for future Cloud Phone client updates.

## Storage

Cloud Phone allows websites to use the most common storage APIs, like:

- [x] LocalStorage
- [x] SessionStorage
- [x] IndexedDB
- [x] CacheStorage
- [ ] [SharedStorage](https://developer.mozilla.org/en-US/docs/Web/API/Shared_Storage_API) (untested)
- [ ] [FileSystem](https://developer.mozilla.org/en-US/docs/Web/API/File_System_API) (unsupported)
- [ ] [Persistent Storage](https://developer.mozilla.org/en-US/docs/Web/API/Storage_API) (unsupported)
- [ ] `<a download>` (unsupported)
- [ ] [`<input type="file">`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/file) (unsupported)

Websites can persist data using LocalStorage or IndexedDB, as well as temporarily store data in memory using SessionStorage. However, there is no ability to download or access local files, or to request permission for Persistent Storage. Additionally, `CacheStorage` and other forms of persisted cache are not useful on Cloud Phone because the cache is not persisted across users, or between user sessions.

## Computation

Modern websites have access to significant resources to perform computation, and this is true for Cloud Phone as well. Cloud Phone supports:

- [x] WebWorker
- [x] WakeLock
- [x] WebAssembly
- [ ] WebGPU (not available)

## Rendering

Surprisingly, Cloud Phone supports common rendering APIs. Cloud Phone was designed to render at [15 frames per second (fps)](https://www.reddit.com/r/cloudphone/comments/1dpusuc/games_and_frame_rate/), and has been observed as high as 20 fps. However, real-world performance depends on many factors including network conditions, CPU usage, battery charge, and more.

- [x] Canvas
- [x] WebGL

## Connectivity

**Cloud Phone does not offer access to device hardware for local connectivity or positioning**. The following APIs are unsupported on Cloud Phone:

- [ ] Geolocation
- [ ] Web Bluetooth
- [ ] Near Field Communication (NFC)

Moreover, it's _not_ possible to access information about [MediaDevices](https://developer.mozilla.org/en-US/docs/Web/API/MediaDevices), device capabilities, or to use WebUSB.

## Device Information

The following APIs are available on Cloud Phone, but return values that are either fixed or correspond to the Puffin server, not the client.

- [ ] Network Information
- [ ] Battery
- [ ] Device Memory

<u>Warning</u>: these APIs are present on Cloud Phone, but return incorrect information. For instance, the Battery API always returns `level = 1` and `charging = true`, and [`navigator.deviceMemory`](https://developer.mozilla.org/en-US/docs/Web/API/Navigator/deviceMemory) always returns the maximum value of `8`. These data likely correspond to the Puffin server, and not end-user device.

<u>Note</u>: it's not possible to confirm if the Network Information API works correctly on Cloud Phone because devices running Cloud Phone only support one network type: 4G. Valid values for down/uplink speeds are not returned.

## Miscellaneous

Here's a compatibility list of other Web APIs on Cloud Phone:

- [x] Crypto
- [x] Fullscreen (not relevant)
- [ ] Vibrate
- [ ] Clipboard
- [ ] Selection
- [ ] Popover
- [ ] WebHID
- [ ] Picture-in-Picture (PiP)
- [ ] Contacts
- [ ] Badging (noop)
- [ ] Screen Orientation
- [ ] Barcode
- [ ] Media Session (available, noop)
- [ ] Encrypted Media (available, no key systems)

The [Screen Orientation API](https://developer.mozilla.org/en-US/docs/Web/API/Screen_Orientation_API) is available, but orientation is fixed in portrait-primary and attempts to set an orientation lock throw this error: `screen.orientation.lock() is not available on this device.`. [Encrypted Media](https://developer.mozilla.org/en-US/docs/Web/API/Encrypted_Media_Extensions_API) is also available, but **support for Widevine, Primetime, PlayReady is missing**. `navigator.setAppBadge` is available, but is a no operation (noop). Finally, **the Fullscreen API _is available_ but effectively useless** since all Cloud Phone widgets run in fullscreen already. Similarly, Picture-in-Picture would not make sense on devices with QQVGA and QVGA screens.

## Summary

Cloud Phone is an exciting platform that allows budget feature phone users to access many important services using standard web technology. However, Cloud Phone developers should be aware of which features are and are not supported. Moreover, developers should make use of runtime feature detection to maximize compatibility and support graceful degradation. Finally, it's always important to validate your widgets on real-world hardware.

### Questions?

**Join the Community!**

* Reddit: [r/CloudPhone](https://www.reddit.com/r/cloudphone/)
* Discord: [r/CloudPhone](https://discord.gg/hcZPvt3D)

Cloud Phone is an emerging platform bringing rich experiences to feature phone users around the world. The author is among the earliest Cloud Phone developers, adapting the first podcast app, [PodLP](https://blog.podlp.com/posts/podlp-cloud-phone/), for Cloud Phone. If you are excited about the possibilities and would like **to learn how to bring your service to Cloud Phone, contact the author** from the [About]({{< ref "about" >}} "About") page.
