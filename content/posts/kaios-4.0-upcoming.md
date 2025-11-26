+++
title = "What's coming in KaiOS 4.0?"
description = "Speculation about 4.0, the new major version of KaiOS"
date = 2024-12-08T00:00:00+08:00
lastmod = 2025-05-24T00:00:00+08:00
toc = true
draft = false
tags = ["KaiOS", "4.0", "KaiOS 4.0", "5G"]
categories = []
header_img = "img/home-alt.png"
series = ["Getting Started"]
+++

**May 2025 Update**: the [TCL Flip 4 launched with KaiOS 4.0]({{< ref "./all-kaios-phones#the-first-with-kaios-40-tcl-flip-4" >}}) matching many of the predictions below. It's available in the United States and is the first KaiOS phone to support 5G.

At CES 2024, KaiOS discussed [5G smart feature phones](https://www.kaiostech.com/kaios-was-at-ces-tech-event-2024/) "slated for an early 2025 rollout" in partnership with Qualcomm.

# KaiOS 4.0

KaiOS 4.0 is the next major version of KaiOS, expected to be released in 2025. Hints have been discovered in [user agent]({{< ref "user-agents" >}} "user agent") logs and online forums. KaiOS 4.0 made it's first appearance on the KaiOS Developer Portal in [April 2024](https://www.reddit.com/r/KaiOS/comments/1ccr504/is_kaios_40_coming_soon/). Here what we know so far:

* Support for 5G
* Upgraded [Qualcomm SM4635](https://www.qualcomm.com/products/mobile/snapdragon/smartphones/snapdragon-4-series-mobile-platforms/snapdragon-4s-gen-2-mobile-platform) chipset
* Updated to Android 14 base
* Upgraded to Gecko 123 engine
* Same APIs as KaiOS 3.0
* Initial markets: India, USA (possibly as the [Go Flip 5](https://github.com/kaiostech/gecko-b2g/commit/c5915586ea04e0755eb5fb0fc632479a100f3e50))
* Improved support for eSIM (commits [`1b30c59`](https://github.com/kaiostech/gecko-b2g/commit/1b30c5931cfcfb4a939e06c3d33d83de8421fedd#diff-67eb9d4ecaf3fbe7c15482fc61a19fe13a94f8f8c7b33b21bcd0ed23ac2b5a40R103) & [`f26eddf`](https://github.com/kaiostech/gecko-b2g/commit/f26eddf1501e04531d9a555bd08d06bfc46b3b9f))

## Behind the Scenes

KaiOS 4.0 isn't expected to have many developer-facing changes. No major changes in B2G APIs, no changes to how hosted or packaged apps are served on the `http://*.localhost` origin, and no fundamental changes in the user interface. However, with all major upgrades in underlying technology, compatibility issues and breaking changes are expected.

**Total Cookie Protection**: Firefox v86 rolled out [Total Cookie Protection](https://blog.mozilla.org/en/mozilla/firefox-rolls-out-total-cookie-protection-by-default-to-all-users-worldwide/) by default to most users. In KaiOS 2.5, all cookies were globally-scoped and shared between apps and the browser unless the [`sandboxed-cookies` permission]({{< ref "./kaios-permissions#sandboxed-cookies" >}}) was used. Sandboxed cookies because the default (and only) behavior in KaiOS 3.0. KaiOS 4.0 will take this a step further by creating a separate "cookie jar," for each unique origin. This may further restrict the ability to share information using cookies between packaged apps on the origin `http://*.localhost` and their corresponding websites `https://myapp.com`.

**New Features**: Because KaiOS 4.0 will upgrade to the Gecko 123 engine (released February 20, 2024), new features are expected including support for the [declarative Shadow DOM](https://bugzilla.mozilla.org/show_bug.cgi?id=1712140), enabled by default in v122. Also expected is support for the AVIF image format (and AV1 images [with animations](https://www.mozilla.org/en-US/firefox/113.0/releasenotes/)). It's possible KaiOS 4.0 will support the [Clipboard API](https://github.com/kaiostech/gecko-b2g/commit/c987f4b7e1b02b14cb872ed5efc1cf6b0099a756), making it one of the first feature phone platforms with copy-paste functionality. Unfortunately, [zstd (zstandard compression)](https://www.mozilla.org/en-US/firefox/126.0/releasenotes/) support didn't make it until Firefox v126.

**More Privacy**: Firefox v85 introduced protections from [supercookies](https://blog.mozilla.org/security/2021/01/26/supercookie-protections/) and v87 introduced a trimmed [HTTP Referrer header](https://blog.mozilla.org/security/2021/03/22/firefox-87-trims-http-referrers-by-default-to-protect-user-privacy/), by default. v88 isolates [window.name](https://blog.mozilla.org/security/2021/04/19/firefox-88-combats-window-name-privacy-abuses/) data and v119 partitions [Blob URLs](https://developer.mozilla.org/en-US/docs/Web/API/Blob).

## Conclusion

KaiOS 4.0 is expected to be primarily a behind-the-scenes upgrade for major markets where 5G support is valuable. Although it should support most KaiOS 3.0 apps, subtle changes in the Gecko engine and privacy configurations may cause hard-to-detect bugs. If you're looking for an experienced partner to maximize reach across the feature phone market, contact the author from the [About]({{< ref "about" >}} "About") page.