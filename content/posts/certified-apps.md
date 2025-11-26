+++
title = "Certified Apps on KaiOS"
description = "What makes KaiOS Certified Apps Special? (with sources)"
date = 2023-08-16T00:00:00+08:00
lastmod = 2023-08-16T00:00:00+08:00
toc = true
draft = false
header_img = "img/home-alt.png"
tags = ["KaiOS", "Certified", "Security"]
categories = []
series = ["Advanced Development"]
+++

What separates Certified and Privileged apps on KaiOS?

# Summary

*Privileged vs Certified*. Packaged apps on KaiOS are bundled as ZIP files, containing all the HTML, CSS, and JS needed to run locally on device. There are two types of packaged apps: Privileged and Certified. The latter is the highest security level available, granting the app access to nearly all permissions and features afforded primarily to System apps.

*Why go Certified*? The most obvious reason is if you need a permission that is marked only for Certified apps. You might also find that writing a Certified app offers access to "hidden" features for deeper system integration and a better user experience.

*Certified Games*: Perhaps surprisingly, the majority of Certified apps[KaiOS Ecosystem]({{< ref "./kaios-ecosystem" >}}) published on the KaiStore are actually games that leverage the `sms` permission to retrieve a 2-factor one time password (OTP) without needing to leave the game itself!

## Permissions

* Can access specific permissions (see [KaiOS Permissions]({{< ref "./kaios-permissions" >}}))
* Can access specific permissions without user prompts (Source: [PermissionsInstaller.jsm](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/apps/PermissionsInstaller.jsm#L144))
* Certain permission checks are skipped, i.e. AUDIO_3GPP (Source: [MediaRecorder.cpp](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/media/MediaRecorder.cpp#L727))

## Features

* Get the list of allowed audio channels via readonly properties `navigator.mozAudioChannelManager.allowedAudioChannels` with the `system-app-only-audio-channels-in-app` permission (Source: [AudioChannelManager.cpp](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/system/gonk/AudioChannelManager.cpp#190))
* Enables ECMA-402 experimental DateTimeFormat ["formatToParts" method](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/DateTimeFormat/formatToParts), later added to Firefox 51 (Source: [WorkerScope.cpp](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/workers/WorkerScope.cpp#L461))
* Can access special DOM events like `"largetextenabledchanged"` (Source: [nsGlobalWindow.cpp](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/base/nsGlobalWindow.webidl#L11363))
* Can get precise battery percentage without rounding (Source: [BatteryManager.cpp](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/battery/BatteryManager.cpp#L182))
* Certified apps can vibrate while in the background (Source: [Navigator.cpp](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/base/Navigator.cpp#L922))
* Can enumerate unfiltered activity providers from the application registry (Source: [ActivityProxy.js](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/activities/ActivityProxy.js#L58))

## System Messages and IPC

* Can respond to special system messages like `bluetooth-pairing-request` (Source: [SystemMessagePermissionsChecker.jsm](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/messages/SystemMessagePermissionsChecker.jsm))
* Can interact via Inter-App Communications (IAC) (Source: [InterAppCommService.jsm](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/apps/InterAppCommService.jsm#L402))
* Can initiate special activities like `"internal-system-engineering-mode"` (Source: [ActivitiesService.jsm](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/activities/ActivitiesService.jsm#L404))

## Behind the Scenes

* Can set sample size fragment which is disabled behind `"image.mozsamplesize.enabled"` boolean preference (Source: [ImageFactory.cpp](https://github.com/kaiostech/gecko-b2g/blob/b2g48/image/ImageFactory.cpp#L227))
* Can re-use the same process (Source: [ContentParent.cpp](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/ipc/ContentParent.cpp#L1282))

## Manifest

* Can have app `role` of `theme` or `addon` (Source: [AppsUtils.jsm](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/apps/AppsUtils.jsm#L524))
* Certified apps have a more strict [Content Security Policy]({{< ref "./security_privacy_considerations#content-security-policy-csphttpsdevelopermozillaorgen-usdocswebhttpcsp" >}}) (CSP) (Source: [b2g.js](https://github.com/kaiostech/gecko-b2g/blob/b2g48/b2g/app/b2g.jsm#L478))

## Bonus

* Exposes the boolean `scrollgrab` property on any `HTMLElement`, initially created in [Bug #912666](https://bugzilla.mozilla.org/show_bug.cgi?id=912666) for `iframe` containers to alter AsyncPanZoomController (APZC) behavior (Source: [nsGenericHTMLElement.cpp](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/html/nsGenericHTMLElement.cpp#L1762), read more in [AsyncPanZoom.md](https://github.com/kaiostech/gecko-b2g/blob/b2g48/gfx/doc/AsyncPanZoom.md)
* Can override to any `audience` via `navigator.mozId` first referenced in [Bug #947374](https://bugzilla.mozilla.org/show_bug.cgi?id=947374) (Source: [Identity.webidl](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/webidl/Identity.webidl#L26))
* Installation might be blocked during sideloading, based of certain permissions listed in the device preference `devtools.debugger.forbid-certified-apps` (Source: [debugger.js](https://github.com/kaiostech/gecko-b2g/blob/b2g48/b2g/chrome/content/devtools/debugger.js#L190))

## Publishing

The KaiStore does not provide specific guidance for publishing Certified apps. From my own experience, developers typically need to provide a justification for why their app needs to be Certified, and disclose source code for KaiOS to review to ensure the permissions are not used for malicious purposes. Remember, Certified apps have access to nearly every permission including `killswitch`, which can brick a device, so they need to be vetted more thoroughly.

Developing and publishing Certified apps can be complicated, but can also facilitate deeper integration and an improved user experience. If you are interested in developing high-quality KaiOS applications with deep system integration, learn more about the author and find contact information on the [About]({{< ref "about" >}} "About") page.
