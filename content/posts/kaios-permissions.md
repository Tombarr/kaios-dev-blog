+++
title = "Complete KaiOS Permission Guide"
description = "Complete Guide to App Permissions on KaiOS"
date = 2023-03-20T00:00:00+08:00
lastmod = 2024-02-01T00:00:00+08:00
toc = true
draft = false
header_img = "img/home-alt.png"
tags = ["KaiOS", "Permissions", "Apps", "Security"]
categories = []
series = ["Advanced Development"]
+++

# Complete Guide to App Permissions on KaiOS

There are **more than 100 permissions available on KaiOS**! Below is the _complete list of permissions_ on KaiOS 2.5 and KaiOS 3.0 defined in [PermissionsTable.jsm](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/apps/PermissionsTable.jsm#L299) to help with developing your next application.

# Hosted & Privileged Apps

## Geolocation

```js
geolocation: {
    app: PROMPT_ACTION,
    privileged: PROMPT_ACTION,
    certified: PROMPT_ACTION
},
"geolocation-noprompt": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION,
    substitute: ["geolocation"]
}
```

Similar to web apps, KaiOS apps can request access to the user's Global Positioning System (GPS) coordinates using the [Geolocation API](https://developer.mozilla.org/en-US/docs/Web/API/Geolocation_API). However, this API is not available unless your app requests the `geolocation` permission. Calling `navigator.geolocation.getCurrentPosition` at runtime will trigger a permission request dialog that the user can then accept or reject. For Certified apps there is also a substitute permission, `geolocation-noprompt`, which as the name implies does not trigger a permission request dialog.

## Camera & Video

```js
camera: {
    app: DENY_ACTION,
    privileged: PROMPT_ACTION,
    certified: ALLOW_ACTION
},
"video-capture": {
    app: PROMPT_ACTION,
    privileged: PROMPT_ACTION,
    certified: ALLOW_ACTION
},
```

Access to the device's cameras requires the `camera` permission, which will prompt the user except in Certified apps. Similarly for video recording, the `video-capture` is required.

## Alarms

```js
alarms: {
    app: ALLOW_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
}
```

Access to the [Alarms API](https://developer.kaiostech.com/docs/api/web-apis/alarm/alarm/) requires the `alarms` permission.

## Sockets

```js
"tcp-socket": {
    app: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
},
"udp-socket": {
    app: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
}
```

Access to the TCP or UDP Socket API requires the `tcp-socket` or `udp-socket` permission, respectively.
For more on the [Socket API]({{< ref "./ssl-certificate.md#tcpsocket-api" >}} "Socket API"), see the blog post.

## Contacts

```js
contacts: {
    app: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION,
    access: ["read", "write", "create"]
}
```

Access to the contact's list requires the `contacts` permission.

## DeviceStorage

```js
"device-storage:apps": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION,
    access: ["read"]
},
"device-storage:apps-storage": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION,
    access: ["read"]
},
"device-storage:crashes": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION,
    access: ["read"]
},
"device-storage:pictures": {
    app: DENY_ACTION,
    privileged: PROMPT_ACTION,
    certified: ALLOW_ACTION,
    access: ["read", "write", "create"]
},
"device-storage:videos": {
    app: DENY_ACTION,
    privileged: PROMPT_ACTION,
    certified: ALLOW_ACTION,
    access: ["read", "write", "create"]
},
"device-storage:music": {
    app: DENY_ACTION,
    privileged: PROMPT_ACTION,
    certified: ALLOW_ACTION,
    access: ["read", "write", "create"]
},
"device-storage:sdcard": {
    app: DENY_ACTION,
    privileged: PROMPT_ACTION,
    certified: ALLOW_ACTION,
    access: ["read", "write", "create"]
}
```

Access to the [DeviceStorage API](https://developer.kaiostech.com/docs/api/web-apis/deviceStorage/device-storage/) requires a `device-storage:*` permission corresponding to the requested storage type like `sdcard`, `music`, `pictures`, and `videos`. Special storage types including `apps`, `apps-storage`, and `crashes` are limited to Certified apps only.

## Speech Recognition

```js
"speech-recognition": {
    app: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
}
```

Access to the [Web Speech API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Speech_API) requires the `speech-recognition` permission.

## Browser

```js
browser: {
    app: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
},
"browser:universalxss": {
    app: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
},
"browser:embedded-system-app": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
}
```

Using the `browser` permission, it's possible to embed an external website within your app.

## Bluetooth

```js
bluetooth: {
    app: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
}
```

The `bluetooth` permission provides access to the [Bluetooth API](https://developer.kaiostech.com/docs/api/web-apis/bluetooth/bluetooth/), as well as the System Messages below. It's used to discover and connect to nearby devices over Bluetooth.

* `bluetooth-pbap-request`
* `bluetooth-map-request`
* `bluetooth-cancel`
* `bluetooth-hid-status-changed`
* `bluetooth-pairing-request`
* `bluetooth-opp-transfer-complete`
* `bluetooth-opp-update-progress`
* `bluetooth-opp-receiving-file-confirmation`
* `bluetooth-opp-transfer-start`

## Mobile Network

```js
mobilenetwork: {
    app: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
}
```

Access to specific properties (`lastKnownNetwork` and `lastKnownHomeNetwork`) within the Mobile Network API requires the `mobilenetwork` permission, accessible via `navigator.mozMobileConnections`.

## Push Notifications & ServiceWorker

```js
push: {
    app: ALLOW_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
},
serviceworker: {
    app: ALLOW_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
},
"desktop-notification": {
    app: PROMPT_ACTION,
    privileged: PROMPT_ACTION,
    certified: PROMPT_ACTION,
    defaultPromptAction: ALLOW_ACTION
},
```

Unlike on modern web browsers, on KaiOS the [ServiceWorker API](https://developer.mozilla.org/en-US/docs/Web/API/ServiceWorker) isn't available without requesting the `serviceworker` permission. Similarly, the [Push API](https://developer.mozilla.org/en-US/docs/Web/API/Push_API) isn't available without the `push` permission. Finally, actually displaying notifications using the `Notification` constructor or a ServiceWorker requires the `desktop-notification` permission.

## FM Radio

```js
fmradio: {
    app: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
}
```

Access to the [FM Radio API](https://developer.kaiostech.com/docs/sfp-3.0/migration-from-2.5/next-new-apis/b2g/fmRadio/navigator-b2g-fmRadio/) using `navigator.mozFMRadio` (`navigator.b2g.fmRadio` on KaiOS 3.0) requires the `fmradio` permission.

## Window Types

```js
attention: {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"global-clickthrough-overlay": {
    app: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
},
"moz-attention": {
    app: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION,
    substitute: ["attention"]
},
```

When calling `window.open`, it's possible to specify optional features. KaiOS supports a few special features including:

* `dialog` creates launches a Web Activity using the `view` name, or launches a popup window
* `attention` creates an attention window
* `global-clickthrough-overlay` creates a global clickthrough overlay
* `mozhaidasheet` creates an in-app sheet with a special animation

## App Management

```js
"webapps-manage": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"homescreen-webapps-manage": {
    app: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
}
```

In order to get the list of installed apps along with their names & icons, the `homescreen-webapps-manage` permission is required. This provides limited access to `navigator.mozApps.mgmt` to retrieve the app list and uninstall apps. For full access, including the ability to install apps, the `webapps-manage` is needed.

<u>Note</u>: the `homescreen-webapps-manage` permission is only available to a Privileged application that is set as the current homescreen.

## SystemXHR

```js
"systemXHR": {
    app: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
}
```

The `systemXHR` permission allows apps to make cross-origin resource (CORS) requests using the `mozSystem` flag without the same-origin policy. Check out [XMLHttpRequest without CORS]({{< ref "./ssl-certificate.md#xmlhttprequest-without-cors" >}} "XMLHttpRequest without CORS") for more details and examples.

```js
let xhr = new XMLHttpRequests({ mozSystem: true });
```

## Embedding

```js
"embed-widgets": {
    app: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
},
"embed-apps": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
}
```

<u>Note</u>: the following permissions do not work because the Embed API was never finished.

## Storage

```js
"storage": {
    app: ALLOW_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION,
    substitute: [
    "indexedDB-unlimited"
    ]
}
```

Apps can request unlimited IndexedDB storage using the `storage` permission.

<u>Note</u>: this is dangerous and requires properly managing storage utilization to avoid crashing the device!

## Audio Channels

```js
"audio-channel-normal": {
    app: ALLOW_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
},
"audio-channel-content": {
    app: ALLOW_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
},
"audio-channel-notification": {
    app: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
},
"audio-channel-alarm": {
    app: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
},
"audio-channel-system": {
    app: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
},
"audio-channel-telephony": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"moz-audio-channel-telephony": {
    app: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION,
    substitute: ["audio-channel-telephony"]
},
"audio-channel-ringer": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"moz-audio-channel-ringer": {
    app: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION,
    substitute: ["audio-channel-ringer"]
},
"audio-channel-publicnotification": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
}
```

KaiOS allows apps to specify what audio channel to play sounds on using the [AudioChannels API](https://developer.kaiostech.com/docs/sfp-3.0/migration-from-2.5/next-new-apis/permissionAPIs/AudioChannels/permission-table-audiochannel/). Each channel requires a corresponding `audio-channel-` permission. See the blog post on [Audio and Volume Management]({{< ref "audio-volume-management" >}} "Audio and Volume Management") for more details.

<u>Note</u>: for simplicity and forward compatibility with KaiOS 3.0, it's best to avoid the `moz-` prefixed substitute permissions.

## VolumeManager

```js
"volumemanager": {
    app: DENY_ACTION,
    trusted: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
}
```

Controlling system volume using `navigator.volumeManager` requires the `volumemanager` permission.

## Input

```js
"input": {
    app: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
}
```

The `input` permission gives access to the InputMethod API via `navigator.mozInputMethod`. The InputMethod API creates a bridge between the web content hosting an input element and the input content (i.e. input app, virtual keyboard app, or IME).

## Microphone

```js
"audio-capture": {
    app: PROMPT_ACTION,
    privileged: PROMPT_ACTION,
    certified: ALLOW_ACTION
},
"audio-capture:3gpp": {
    app: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
},
"audio-capture:3gpp2": {
    app: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
}
```

Access to the microphone for audio recording requires the `audio-capture` permission.

## Near Field Communication (NFC)

```js
"nfc": {
    app: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
},
"nfc-share": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"nfc-manager": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"nfc-hci-events": {
    app: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
}
```

For devices with supporting hardware, Near Field Communication (NFC) can be accessed using the `nfc` permission.

<u>Note</u>: as of the time of writing (March 2023), no KaiOS device has included NFC except for certain models of the JioPhone for use with JioPay only.

## Speaker Control

```js
"speaker-control": {
    app: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
}
```

The [Speaker Control API](https://wiki.mozilla.org/WebAPI/SpeakerManager) requires the corresponding `speaker-control` permission to force audio output over the device's speakers, even while headphones are connected.

## Feature Detection

```js
"feature-detection": {
    app: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
}
```

To use the Feature Detection API via `navigator.getFeature` and `navigator.hasFeature`, the `feature-detection` is needed. Useful features to detect include:

* `device.qwerty` if the device has a QWERTY keyboard like the JioPhone 2
* `hardware.memory` to distinguish 256mb and 512mb devices
* `device.storage.size` to get the total storage capacity of the device
* `dom.apps.developer_mode` to check if the user has enabled Developer Mode
* `device.key.volume`, `device.key.endcall`, and `device.key.camera` to check if hardware Volume, EndCall, and Camera shutter keys are present, respectively
* `device.parental-control` to check if parental controls are enabled
* `device.flip` to check if the device has a flip screen
* `device.bt`, `device.wifi`, and `device.gps` to check if the device supports Bluetooth, WiFi, and GPS, respectively
* `ro.product.brand` and `ro.product.name` to get product details

## Mobile ID

```js
"mobileid": {
    app: DENY_ACTION,
    privileged: PROMPT_ACTION,
    certified: PROMPT_ACTION
}
```

Privileged apps can request access to Mobile Identifiers like IMEI numbers using `navigator.getMobileIdAssertion` requires the `mobileid` permission, which always prompts the user to accept or reject.

## Settings

```js
"settings:wallpaper.image": {
    app: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION,
    access: ["read", "write"],
    additional: ["settings-api"]
},
"settings": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION,
    access: ["read", "write"],
    additional: ["indexedDB-chrome-settings", "settings-api"]
},
"settings-clear": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: DENY_ACTION,
    additional: ["indexedDB-chrome-settings", "settings-api"]
},
```

Only the special `settings:wallpaper.image` is available to Privileged apps. This permission was removed in KaiOS 3.0 and allows apps to set the `wallpaper.image` setting, changing the system-wide wallpaper image without prompting the user.

## External API

```js
"external-api": {
    app: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
}
```

Despite the generic sounding name, the External API via `navigator.externalapi` is a very limited API that only provides access to a token used by the [API Daemon](https://github.com/kaiostech/api-daemon/). It's primarily used for KaiOS 3.0 apps that need access to these APIs.

## Spatial Navigation

```js
"spatialnavigation-app-manage": {
    app: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
}
```

The `spatialnavigation-app-manage` permission provides access to the boolean property, `navigator.spatialNavigationEnabled`, which can be read or written. This toggles on or off the virtual cursor within your app.

## Sandboxed Cookies

```js
"sandboxed-cookies": {
    app: ALLOW_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
}
```

If an app specifically sets the `sandboxed-cookies` permission in its manifest, this will force reading/writing cookies of this app individually, a.k.a. no SSO service.

## Web Components

```js
"moz-extremely-unstable-and-will-change-webcomponents": {
    app: DENY_ACTION,
    trusted: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
}
```

[Web Components](https://developer.mozilla.org/en-US/docs/Web/Web_Components) are disabled by default and only available via the `moz-extremely-unstable-and-will-change-webcomponents` permission. This permission gives access to an unstable version of the Web Components APIs, allowing access to the Shadow DOM and the registration of custom elements, i.e. `<x-button>`.

## KaiOS Accounts

```js
"kaios-accounts": {
    app: DENY_ACTION,
    trusted: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"kaios-accounts:service": {
    app: DENY_ACTION,
    trusted: DENY_ACTION,
    privileged: PROMPT_ACTION,
    certified: ALLOW_ACTION,
    substitute: ["kaios-accounts"]
}
```

Used for identity management via KaiOS Accounts.

## SecureElement

```js
"secureelement-manage": {
    app: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
}
```

The Secure Element API enables access to the Secure Element (SE), a chip that is protected by design from unauthorized access. On KaiOS this is accessible via `navigator.seManager` with the `secureelement-manage` permission.

## Presentation

```js
"presentation": {
    app: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
}
```

The `presentation` permission provides access to the [Presentation API](https://wiki.mozilla.org/WebAPI/PresentationAPI) via `navigator.presentation`.

<u>Note</u>: the `dom.presentation.enabled` preference is disabled by default, and the Presentation API is not usable on KaiOS.

## Test Permission

```js
"test-permission": {
    app: PROMPT_ACTION,
    privileged: PROMPT_ACTION,
    certified: ALLOW_ACTION,
    access: ["read", "write", "create"]
}
```

Per KaiOS Documentation:

> This permission doesn't actually grant access to anything. It exists only to check the correctness of web prompt composed permissions in tests.

## [China Type Approval (CTA)](https://developer.kaiostech.com/docs/getting-started/main-concepts/manifest/#china-type-approval-cta-and-how-does-it-affect-your-apps-on-the-kaistore)

```json
"permissions": {
  "mobiledata": { },
  "wifidata": { }
}
```

Due to regional regulations, apps that need network access (i.e. KaiAds or Analytics) and intend to be published on the KaiStore in China, the `mobiledata` and `wifidata` permissions are required. Additionally, for privileged & certified apps the `calllog` permission is also required for KaiOS 2.5.2.1 and 2.5.4.1.

## Certified

The remaining permissions are only available to Certified apps.

```js
"mmi-test": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"network-events": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
sms: {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
telephony: {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
mobileconnection: {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
power: {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
softkey: {
    app: DENY_ACTION,
    trusted: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
permissions: {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
phonenumberservice: {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"backgroundservice": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"networkstats-manage": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"resourcestats-manage": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"wifi-manage": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"voicemail": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"idle": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"time": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"background-sensors": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
cellbroadcast: {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"open-remote-window": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"input-manage": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"wappush": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"downloads": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"themeable": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"engineering-mode": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"tv": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"before-after-keyboard-event": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"presentation-device-manage": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"requestsync-manager": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"inputport": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"system-update": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"open-hidden-window": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"system-app-only-audio-channels-in-app": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"killswitch": {
    app: DENY_ACTION,
    trusted: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
flip: {
    app: DENY_ACTION,
    trusted: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
flashlight: {
    app: DENY_ACTION,
    trusted: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"datacall": {
    app: DENY_ACTION,
    trusted: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"keyboard-event-generator": {
    app: DENY_ACTION,
    trusted: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"customization": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"deviceconfig": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"engmode-extension": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"cloud-authorization": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"fota": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"libsignal": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
},
"wamedia": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
}
```

Most of these permissions are not meant for third-party application use. However, a few can be useful in specific scenarios. For instance:

* `sms` to send & read SMS messages. Useful for improving user experience (UX) when sending One Time Passwords (OTPs) via SMS without the user needing to leave and re-enter your app
* `flashlight` for toggling on & off the flashlight (aka torch)
* `requestsync-manager` for triggering a background script to run on regular internals (i.e. daily) and under specification conditions (i.e. only when WiFi is available)
* `downloads` for storing and accessing system-wide downloads

## KaiOS 2.5.3+ permissions

Some of the permissions below were found on new KaiOS 2.5 devices like the [JioPhone Prima 4G (F491H)]({{< ref "whats-next-jiophone#jiophone-prima-4g" >}} "JioPhone Prima 4G (F491H)") running KaiOS 2.5.3.2.

### Sound Trigger

```js
"sound-trigger": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
}
```

Exposes the `navigator.soundTriggerManager` API based on [Android's Sound Trigger])https://source.android.com/docs/core/audio/sound-trigger. Used for AOV (Always-On local Voice) that supports wake words like "Hello Jio." Located in `libsoundtrigger.so` and `libsoundtriggerservice.so`.

```ts
interface SoundTriggerManager {
    getSupportList: Model[];
    set(model: Model): void;
    start(wakeWords: string[]): void;
    stop(): void;
    onrecognitionresult: EventHandler;
    onstatechange: EventHandler;
}
```

### Teereader

```js
"teereader-manage": {
    app: DENY_ACTION,
    privileged: DENY_ACTION,
    certified: ALLOW_ACTION
}
```

### eMBMs - Multimedia Broadcast Multicast Service (MBMS)

```js
"embms": {
    app: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
}
```

Exposes the `navigator.lteBroadcastManager` API.

```ts
interface LteBroadcastManager {
    coverage;
    setServiceClassFilter;
    getService: LteBroadcastService;
    getSAI; // Service Area Identifier
}
```

### Dongle Manager

```js
"donglemanager": {
    app: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
}
```

Exposes the `navigator.dongleManager` API for the JioPhone Media Cable.

```ts
interface DongleManager {
    dongleStatus: string;
    ondonglestatuschange: EventHandler;
    usbIpAddress: string;
}
```

### Device Financing (DFC)

```js
"dfc": {
    app: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
}
```

Exposes the `navigator.dfc` API for keeping track of device financing.

### Device Security Info

```js
"device-sec-info": {
    app: DENY_ACTION,
    privileged: ALLOW_ACTION,
    certified: ALLOW_ACTION
}
```

Exposes the `navigator.getDeviceSecInfoManager` API for checking if the device is rooted. On the JioPhone, this is used to disable JioPay on rooted devices.

```ts
interface DeviceSecInfoManager {
    isRooted: boolean;
    onrootedchange: EventHandler;
}
```

### Cross Domain Content and Unsafe Content Script

`unsafe-content-script` are `cross-domain-content` special permission not defined in PermissionsTable.jsm. `cross-domain-content`  accepts an array of URLs to authorize access to for each content script.

```js
"cross-domain-content": [ "https://api.kai.jiophone.net/" ],
```

# New to KaiOS 3.0

The following permissions are new to KaiOS 3.0 and were derived from builds extracted from the [Nokia 2780 Flip](https://wiki.bananahackers.net/en/devices/nokia-2780-flip). Note that in KaiOS 3.0, `web` apps are now `pwa`, Privileged apps are now `signed` and Certified apps are now `core`.

## Account Observer

```js
"account-manager": {
    pwa: DENY_ACTION,
    signed: DENY_ACTION,
    core: ALLOW_ACTION,
},
"account-observer-activesync": {
    pwa: DENY_ACTION,
    signed: ALLOW_ACTION,
},
"account-observer-google": {
    pwa: DENY_ACTION,
    signed: ALLOW_ACTION,
},
"account-observer-kaiaccount": {
    pwa: DENY_ACTION,
    signed: ALLOW_ACTION,
}
```

Allows an application to observe changes to Google, ActiveSync, and KaiAccounts using `new WebActivity('account-manager', data)` where `data` is an object specifying a specific `action` like `getAccounts`.

## Power Supply

```js
"powersupply": {
    pwa: DENY_ACTION,
    signed: ALLOW_ACTION,
    core: ALLOW_ACTION,
}
```

Provides access to the Power Supply API via `navigator.b2g.powerSupplyManager` with the following properties:

* `powerSupplyOnline`, a `boolean`
* `powerSupplyType`, a `string` like `'USB'` specifying the power supply type

As well as the following events:

* `chargingchange`
* `levelchange`
* `statuschange`
* `powersupplystatuschanged`

## USB Manager

```js
usb: {
    pwa: DENY_ACTION,
    signed: ALLOW_ACTION,
    core: ALLOW_ACTION,
}
```

Provides access to the USB Manager API via `navigator.b2g.usbManager` with the following properties:

* `deviceAttached`, a `boolean` property indicating if the device is attached is attached via USB
* `onusbstatuschange`, a callback triggered when the USB status has changed

## Virtual Cursor

```js
virtualcursor: {
    pwa: DENY_ACTION,
    signed: ALLOW_ACTION,
    core: ALLOW_ACTION,
}
```

This permission was renamed from `spatialnavigation-app-manage` on KaiOS 2.5, but serves the same purpose. Provides access to the Virtual Cursor API via `navigator.b2g.virtualCursor`, with the following properties:

* `enabled`, a `boolean` property indicating if the virtual cursor is enabled
* `enable` and `disable`, functions to enable and disable the virtual cursor, respectively

## Web View

```js
 "web-view": {
    pwa: DENY_ACTION,
    signed: ALLOW_ACTION,
    core: ALLOW_ACTION,
}
```

Allows apps to use the special `<web-view>` element, rendering a website within an app similar to an `iframe`. The `<web-view>` element includes special properties:

* `src`, the URL of the page to load.
* `remote`, a `boolean` to decide if that browser should load content in a content process.
* `ignorefocus`, a `boolean` that when set let the browser get pointer events without focusing it. This is useful for virtual keyboard frames.
* `transparent`, a `boolean` that, if true, the background of the browser will be transparent instead of white.

## Worker Activity

```js
"worker-activity": {
    pwa: DENY_ACTION,
    signed: ALLOW_ACTION,
    core: ALLOW_ACTION,
}
```

The `worker-activity` permission allows triggering a Web Activity from a background Worker or ServiceWorker. For instance, this could allow the user to click on a Notification and trigger a Web Activity.

## Certified

KaiOS 3.0 also introduces a number of permissions only for Certified apps, including the following.

```js
"background-window": {
    pwa: DENY_ACTION,
    signed: DENY_ACTION,
    core: ALLOW_ACTION,
},
battery: {
    pwa: DENY_ACTION,
    signed: DENY_ACTION,
    core: ALLOW_ACTION,
},
"bluetooth-privileged": {
    pwa: DENY_ACTION,
    signed: DENY_ACTION,
    core: ALLOW_ACTION,
},
engmode: {
    pwa: DENY_ACTION,
    signed: DENY_ACTION,
    core: ALLOW_ACTION,
},
"ime-connect": {
    pwa: DENY_ACTION,
    signed: DENY_ACTION,
    core: ALLOW_ACTION,
},
omacpmsg: {
        pwa: DENY_ACTION,
    signed: DENY_ACTION,
    core: ALLOW_ACTION,
},
OmaService: {
    pwa: DENY_ACTION,
    signed: DENY_ACTION,
    core: ALLOW_ACTION,
},
"process-manager": {
    pwa: DENY_ACTION,
    signed: DENY_ACTION,
    core: ALLOW_ACTION,
},
rsu: {
    pwa: DENY_ACTION,
    signed: DENY_ACTION,
    core: ALLOW_ACTION,
},
"system-time": {
    pwa: DENY_ACTION,
    signed: DENY_ACTION,
    core: ALLOW_ACTION,
    access: ["read", "write"],
},
tethering: {
    pwa: DENY_ACTION,
    signed: DENY_ACTION,
    core: ALLOW_ACTION,
}
```

## Removed in KaiOS 3.0

The following permissions were moved or removed in KaiOS 3.0:

* `geolocation-noprompt` (use `geolocation`)
* `mmi-test`
* `udp-socket` (API removed)
* `network-events`
* `speech-recognition`
* `browser`
* `browser:universalxss`
* `browser:embedded-system-app`
* `push` (no longer needed)
* `serviceworker` (no longer needed)
* `settings-clear`
* `softkey` (removed `navigator.softkeyManager`)
* `phonenumberservice` (removed `navigator.mozPhoneNumberService`)
* `global-clickthrough-overlay`
* `moz-attention`
* `homescreen-webapps-manage`
* `backgroundservice`
* `resourcestats-manage`
* `idle`
* `time` (replaced by `system-time`)
* `embed-apps`
* `embed-widgets`
* `moz-audio-channel-telephony` (use `audio-channel-telephony`)
* `moz-audio-channel-ringer` (use `audio-channel-ringer`)
* `open-remote-window`
* `input-manage`
* `audio-capture:3gpp` (use `audio-capture`)
* `audio-capture:3gpp2` (use `audio-capture`)
* `nfc`
* `nfc-share`
* `nfc-manager`
* `nfc-hci-events`
* `mobileid`
* `test-permission`
* `kaios-accounts` (replaced by `account-observer-kaiaccount`)
* `kaios-accounts:service` (replaced by `account-observer-kaiaccount`)
* `themeable`
* `settings:wallpaper.image`
* `engineering-mode` (replaced by `engmode`)
* `tv`
* `before-after-keyboard-event`
* `presentation-device-manage`
* `requestsync-manager` (API removed)
* `secureelement-manage`
* `inputport`
* `system-update`
* `presentation`
* `open-hidden-window`
* `moz-extremely-unstable-and-will-change-webcomponents` (no longer needed)
* `system-app-only-audio-channels-in-app`
* `keyboard-event-generator`
* `customization`
* `deviceconfig` (replaced by `device-configuration`)
* `external-api`
* `engmode-extension`
* `spatialnavigation-app-manage` (replaced by `virtualcursor`)
* `sandboxed-cookies` (now the default behavior on KaiOS 3.0)
* `libsignal` (now requires `systemXHR`)
* `wamedia`

# Conclusion

With over 100 permissions, and major differences between KaiOS 2.5 and 3.0, it can be difficult knowing which APIs and permissions can be used for an optimal user experience. If you need an experienced partner to guide your KaiOS development, contact the author from the [About]({{< ref "about" >}} "About") page.
