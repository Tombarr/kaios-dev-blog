+++
title = "Complete Feature Detection on KaiOS"
description = "What features can you detect with navigator.getFeature() on KaiOS?"
date = 2024-01-31T00:00:00+08:00
lastmod = 2024-02-02T00:00:00+08:00
toc = true
draft = false
header_img = "img/home-alt.png"
tags = ["KaiOS", "Feature", "API"]
categories = []
series = ["Advanced Development"]
+++

# Feature Detection

What features can you detect on KaiOS?

**Summary**. KaiOS has two APIs, `navigator.getFeature()` and `navigator.hasFeature`, for detecting device and platform features. These APIs require the <u>[`feature-detection` permission]({{< ref "./kaios-permissions/#feature-detection" >}})</u>.

Here is a simple TypeScript definition for the Feature Detection API on KaiOS 2.5:

```ts
interface Navigator {
    getFeature(name: string): Promise<any>;
    hasFeature(name: string): Promise<boolean>;
}
```

On KaiOS 3.0, the [DeviceCapabilityManager API](https://github.com/kaiostech/api-daemon/blob/main/services/devicecapability/src/devicecapability.sidl) is loaded from `http://shared.localhost/js/session/device_capability/device_capability.js` and shortens `getFeature` to just `get`. The `hasFeature` API was removed in KaiOS 3.0. Here is an example for each KaiOS version:

```js
// KaiOS 2.5
navigator.getFeature('hardware.memory')
    .then((mem) => (mem === 256) ? /* TODO */ : /* TODO */)

// KaiOS 3.0 (assumes DeviceCapabilityManager has been loaded)
DeviceCapabilityManager.get('hardware.memory')
    .then((mem) => (mem === 256) ? /* TODO */ : /* TODO */)
```

## Why use Feature Detection?

Feature Detection is a common paradigm in mobile apps to support **graceful degradation** and provide user-friendly error messages. For instance, if your application requires a certain capability like Bluetooth, you might display a fatal error message and not allow the user to proceed. Alternatively, you might adapt based on hardware limitations (i.e. device memory) and downsample images, or change how input is gathered on a T9 vs QWERTY device. Finally, you might enable advanced features to certain users if they have Developer Mode enabled.

For example, pre-installed apps use feature detection (esp. `hardware.memory`) including:

* The Music app disabled the "Share" and "Set Ringtone" on low-memory (256mb) devices, likely because passing audio blobs between apps using [Web Activities]({{< ref "./web-activities" >}}) could result in memory pressure and crashes
* The Gallery app adapts downsampling using the [`#-moz-samplesize` media fragment]({{< ref "./optimization-tips#media-fragments--moz-samplesize" >}}) based on device memory
* The Email and Calendar apps are suppressed on low-memory (256mb) devices
* Apps are instantly terminated when `EndCall` or `GoBack` is pressed on low-memory devices, unless they're playing background audio

### Background

Q: Why use `navigator.hasFeature` when you can just check if certain properties exist?

Per [Bug #1009645](https://bugzilla.mozilla.org/show_bug.cgi?id=1009645):

> The entire purpose of this API is so that we can hide properties such as `navigator.mozBluetooth` for contexts where the web page lacks the required permissions in order to be able to call into the API.

That was for Firefox OS from 10 years ago. Many (but not all) KaiOS APIs will be set to `null` or completely unavailable unless the necessary permissions and app level are met.

## Feature Table

Below is a list of features that can be detected using the Feature Detection API.

❗ <u>Important</u>: for features that return a boolean (`true` or `false`), use `navigator.hasFeature`. For all other features, use `navigator.getFeature`!

### Miscellaneous Features

| Feature name        | Example Values   | Description   |
|------------|------------|------------|
| `hardware.memory`   | `256` or `512`    | Device memory (RAM) |
| `hardware.tv`   | `true` or `false`    | TV support |
| `device.storage.size`      | `0`          | Device storage (ROM) |
| `device.parental-control`     | `true` or `false` | Parental controls enabled |
| `dom.apps.developer_mode`        | `true` or `false`         | DevMode enabled |
| `ril.support.primarysim.switch`     | `true` or `false` | Device has SIM switch |
| `web-extensions` | `true` | B2G specific |
| `late-customization` | `true` | B2G specific |
| `kaios.api_daemon.version` | `1.4.36` | KaiOS API daemon version |
| `build.type` | `user` | `ro.build.type` value |
| `capabilities.sandboxedCookies` | `true` or `false` | Sandboxed cookie support |

⚠️ <u>Warning</u>: some of the features above (i.e. `capabilities.sandboxedCookies`) are KaiOS 2.5 specific, since the corresponding APIs or permissions were removed in KaiOS 3.0.

#### Manifest Properties

| Feature name        | Example Values   | Description   |
|------------|------------|------------|
| `manifest.origin` | `true` | Origin |
| `manifest.redirects` | `true` | Redirects |
| `manifest.chrome.navigation` | `true` | Chrome Navigation |
| `manifest.precompile` | `true` | Precompile |
| `manifest.role.homescreen` | `true` | Homescreen |

ℹ️ <u>Note</u>: the above manifest features are hard-coded to return `true`.

### Device Capabilities (KaiOS 2.5)

| Feature name        | Example Values   | Description   |
|------------|------------|------------|
| `device.capability.qwerty`      | `true` or `false` | QWERTY keyboard (i.e. [JioPhone 2]({{< ref "whats-next-jiophone#jiophone-2" >}} "JioPhone 2")) |
| `device.capability.*-key` | `true` or `false`             | * is a key name (i.e. `endcall` or `volume`) |
| `device.capability.flip`     | `true` or `false` | Device has a flip screen |
| `device.capability.torch`     | `true` or `false` | Device has a torch (flashlight) |
| `device.capability.bt`     | `true` or `false` | Device has [Bluetooth]({{< ref "./bluetooth.md" >}} "Bluetooth") |
| `device.capability.wifi`     | `true` or `false` | Device has Wifi |
| `device.capability.wifi.wifi_certified` | `true` or `false` | Device has Certified WiFi |
| `device.capability.fm.recorder` | `true` or `false` | Device has FM Recorder |
| `device.capability.vilte` | `true` or `false` | Device has Video over LTE (VILTE) |
| `device.capability.volte` | `true` or `false` | Device has Voice over LTE (VOLTE) |
| `device.capability.vowifi` | `true` or `false` | Device has Voice over WiFI |
| `device.capability.gps`     | `true` or `false` | Device has a GPS |
| `device.capability.cdma_apn.feature`     | `true` or `false` | CDMA device |
| `device.capability.sim-hotswap`     | `true` or `false` | SIM hotswap |
| `device.capability.group-message`     | `true` or `false` | MMS group messaging |
| `device.capability.rtt`     | `true` or `false` | Real-time text (RTT) |
| `device.capability.dual-lte`     | `true` or `false` | Dual LTE |
| `device.capability.dfc`     | `true` or `false` | Device Financing (DFC) |
| `device.capability.readout`     | `true` or `false` | Readout (Accessibility service) |


### Device Capabilities (KaiOS 3.0)

| Feature name        | Example Values   | Description   |
|------------|------------|------------|
| `device.qwerty`      | `true` or `false` | QWERTY keyboard (i.e. [JioPhone 2]({{< ref "whats-next-jiophone#jiophone-2" >}} "JioPhone 2")) |
| `device.key.*` | `true` or `false`             | * is a key name (`camera`, `endcall`, or `volume`) |
| `device.flip`     | `true` or `false` | Device has a flip screen |
| `device.torch`     | `true` or `false` | Device has a torch (flashlight) |
| `device.bt`     | `true` or `false` | Device has [Bluetooth]({{< ref "./bluetooth.md" >}} "Bluetooth") |
| `device.wifi`     | `true` or `false` | Device has Wifi |
| `device.wifi.certified` | `true` or `false` | Device has Certified WiFi |
| `device.fm.recorder` | `true` or `false` | Device has FM Recorder |
| `device.vilte` | `true` or `false` | Device has Video over LTE (VILTE) |
| `device.volte` | `true` or `false` | Device has Voice over LTE (VOLTE) |
| `device.vowifi` | `true` or `false` | Device has Voice over WiFI |
| `device.gps`     | `true` or `false` | Device has a GPS |
| `device.cdma-apn`     | `true` or `false` | CDMA device |
| `device.sim-hotswap`     | `true` or `false` | SIM hotswap |
| `device.group-message`     | `true` or `false` | MMS group messaging |
| `device.tethering`     | `true` or `false` | Tethering |

ℹ️ <u>More Info</u>: in addition to the device capabilities above, KaiOS 3.0 exposes several more build properties. See [`devicecapability.json`](https://github.com/kaiostech/api-daemon/blob/main/services/devicecapability/devicecapability.json) included in API Daemon.

### Platform APIs

| Feature name        | Example Values   | Description   |
|------------|------------|------------|
| `api.window.XMLHttpRequest.mozSystem`     | `true` or `false` | mozSystem XHR |
| `api.window.MozMobileNetworkInfo`     | `true` or `false` | Mobile network info |
| `api.window.Navigator.mozBluetooth`     | `true` or `false` | [Bluetooth]({{< ref "./bluetooth.md" >}} "Bluetooth") API |
| `api.window.Navigator.mozContacts`     | `true` or `false` | Contacts API |
| `api.window.Navigator.getDeviceStorage`     | `true` or `false` | DeviceStorage API |
| `api.window.Navigator.addIdleObserver`     | `true` or `false` | Idle Observer |
| `api.window.Navigator.mozNetworkStats`     | `true` or `false` | Network Stats |
| `api.window.Navigator.push`     | `true` or `false` | WebPush |
| `api.window.Navigator.mozTime`     | `true` or `false` | Time API |
| `api.window.Navigator.mozFMRadio`     | `true` or `false` | FM Radio API |
| `api.window.Navigator.mozCameras`     | `true` or `false` | Camera API |
| `api.window.Navigator.mozAlarms`     | `true` or `false` | Alarm API |
| `api.window.Navigator.mozTCPSocket`     | `true` or `false` | TCP Socket API |
| `api.window.Navigator.mozInputMethod`     | `true` or `false` | Input Method API |
| `api.window.Navigator.mozMobileConnections`     | `true` or `false` | Mobile Connections API |
| `api.window.Navigator.getMobileIdAssertion`     | `true` or `false` | Mobile ID API |

In fact, you can check any [`FeatureDetectible`](https://github.com/kaiostech/gecko-b2g/commit/90781169de2de49fd7ebf97ff8165603f25a03ca) property. For instance, navigator properties like `api.window.Navigator.fota` and `api.window.Navigator.spatialNavigationEnabled`, or B2G API properties like `api.window.MozNFC.enabled` and `api.window.KeyboardEventGenerator.generate` (even if your app doesn't have permission to use these APIs).

### Behind the Scenes

The logic in [Configuration.py](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/bindings/Configuration.py#L642) shows that _any_ non-test API defined in WebIDL with the `CheckAnyPermissions`, `CheckAllPermissions`, or `AvailableIn` annotation is accessible to feature detection. In this context, **the Feature Detection API returns what the device is capable of, not  what your app is _allowed_ to do**.

## Conclusion

The KaiOS Feature Detection API is simple, but useful. Just a few lines of code can prevent user confusion, avoid errors, and tailor the user experience to different devices. However, the Feature Detection API is not a substitute for general [feature detection](https://developer.mozilla.org/en-US/docs/Learn/Tools_and_testing/Cross_browser_testing/Feature_detection). It is still important to check for the presence of certain platform-specific APIs, and to catch errors (i.e. SecurityError) in case permissions are rejected or the device does not support certain capabilities. If you would like to build a world-class KaiOS experience for your business that adapts based on device capabilities and characteristics, contact the author from the [About]({{< ref "about" >}} "About") page.
