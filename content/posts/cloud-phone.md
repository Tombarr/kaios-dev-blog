+++
title = "A Developer's Introduction to CloudMosa's Cloud Phone"
description = "Everything you need to know to develop widgets for CloudModa's Cloud Phone"
date = 2024-06-16T00:00:00+08:00
lastmod = 2024-09-22T00:00:00+08:00
toc = true
draft = false
header_img = "img/nokia_110_4g_podlp.jpeg"
tags = ["Cloud Phone", "CloudMosa", "Puffin", "Remote Browser"]
categories = []
series = ["Getting Started"]
[params]
  featured_img = "img/nokia_110_4g_podlp.jpeg"
+++

# A Developer's Introduction to CloudMosa's Cloud Phone

![Cloud Phone Logo](/img/cloudphone_logo.png)

## At a Glance

[Cloud Phone](https://www.cloudfone.com/) is a Chrome-based remote browser from CloudMosa, Inc for budget feature phones to seamlessly interact with media-rich web apps (called "widgets") like YouTube Shorts and TikTok. Cloud Phone is based on [Puffin](https://www.puffin.com/), a remote browser similar to [Opera Mini](https://www.opera.com/browsers/opera-mini) that renders websites on cloud servers, sending markup language representations to draw on device.

**Quick take**. Cloud Phone performs well on budget hardware, incentivizes 4G bandwidth utilization, and requires minimal web app refactoring. It's well-positioned to expand rapidly among the [200M+ feature phones](https://www.statista.com/outlook/cmo/consumer-electronics/telephony/feature-phones/worldwide) sold annually.

### Benefits

* **Low Performance Requirements**. Parsing, rendering, painting, and compositing all happen server-side. The result is an optimized binary representation of the website that can be displayed on budget feature phones with [as little as 16MB RAM](https://www.linkedin.com/posts/cloudmosa_puffin-cloud-phone-activity-7191657064601935872-SEe8?utm_source=share&utm_medium=kaiosdev)!
* **Data Savings**. All external network requests happen server-side, and only a compressed binary representation is sent to the client. Various sources claim **_up to_ 80-90% bandwidth savings**!
* **Secure**. Because all parsing and rendering happens server-side, threats like [Opera's recent remote code execution (RCE) zero day vulnerability](https://www.darkrelay.com/post/opera-zero-day-rce-vulnerability) are mitigated. However, many class of web security concerns like cross-site scripting (XSS) or phishing are unaffected.
* **Up-to-date browser**. The majority of KaiOS devices run 2.5, based on Firefox 48 released in 2016. OEMs seldom publish over-the-air (OTA) updates, leading to compatibility issues like the [expired Let's Encrypt]({{< ref "./ssl-certificate.md#lets-encrypt-ssl-certificate-issue" >}} "expired Let's Encrypt") IdenTrust DST Root CA X3 root certificate. Cloud Phone's browser can be updated independent of individual devices, so there are no issues with expired root certificates, and no need to transpile with Babel for backwards compatibility.

### Drawbacks

* **Online-only**. Because all rendering happens server-side, Cloud Phone only works with an active internet connection. **Cloud Phone widgets cannot function offline**.
* **Blocked content**. Puffin and Cloud Phone operate as proxies that send the [`X-Forwarded-For` header](https://en.wikipedia.org/wiki/Puffin_Browser). External traffic originates from an [IPv4 address range](https://support.puffin.com/topic/110) that's sometimes categorized as bots and blocked by content delivery networks (CDNs), or flagged for CAPTCHA completion.
* **Limited access**. Cloud Phone doesn't have offer permissions. Unlike [KaiOS]({{< ref "./kaios-permissions" >}}), Cloud Phone apps cannot set alarms, access the FM radio, or read contacts.
* **Limited distribution methods**. Cloud Phone apps must be _hosted_ on a server that you control, they cannot be packaged into ZIP files.
* **Monetization**. While KaiOS has [KaiAds](https://kaiads.com/), Cloud Phone offers no first-party monetization platform. Because Cloud Phone's remote browser acts as a proxy, services like Google AdSense do not work either.

## Cloud Phone Development

Developing apps for Cloud Phone is similar to writing web apps for Chrome, with several unique considerations:

* **Small screens**. Cloud Phone runs on devices with _even smaller screens_ than KaiOS. KaiOS only supports QVGA: 240x320 (portrait) or, rarely, 320x240 (landscape). Currently Cloud Phone runs on
  * **QQVGA**: 120x160 and 128x160
  * **QVGA**: 240x320
* **Keyboard navigation**. Cloud Phone currently runs on non-touch devices that rely on arrow keys to navigate.

<u>Touchscreens</u>: CloudMosa announced that [360x480 (HVGA) touchscreen devices are coming in 2025](https://www.linkedin.com/posts/cloudmosa_puffin-cloud-phone-activity-7191657064601935872-SEe8?utm_source=share&utm_medium=kaiosdev)!

### Small Screens

The [Nokia 106 4G](https://www.mobilityindia.com/hmd-unveils-youtube-shorts-other-cloud-apps-innovation-for-nokia-106-4g-and-nokia-110-4g/) was released in 2023 in India for ₹2,199 (~$26 USD). It has a 1.8" (45mm) 120x160 QQVGA screen. For comparison, the lowest-end [1st generation Apple Watch SE](https://support.apple.com/en-us/111862) had a 1.56" (40mm) 324x394 screen. **Developing for QVGA feature phones is comparable to developing Apple Watch apps on screens with a ~2.5x lower pixel density**.

It's best to develop your app according to the [Cloud Phone UI & UX Guidelines](https://www.cloudfone.com/uiux-guidelines), with appropriate sizing and spacing for elements like the title, soft key menu, and default Roboto font.

### Keyboard Navigation

Developing Cloud Phone apps is similar to KaiOS. Both support two soft keys: Right Soft Key (RSK) and Left Soft Key (LSK).

| Key | KaiOS       | Cloud Phone   |
|-----|-------------|---------------|
| RSK | `SoftRight` | N/A           |
| LSK | `SoftLeft`  | `Escape`      |

KaiOS apps can respond to _both_ soft key events using custom key codes, while **Cloud Phone widgets can only respond to LSK via the `Escape` key**. On Cloud Phone, **RSK always acts as "go back"** (`history.back()`), and when there's no previous history entry, it functions like `window.close()` and exits your app.

#### Text Input

![Nokia 110 4G Text Input](/img/nokia_110_text_input.jpg "Nokia 110 4G Text Input")

On Cloud Phone, user text input via `<input type="text">` and `<input type="search">` triggers a full-screen input with options: "OK" or "Clear." Once complete, this triggers an `input` and `change` event, but _not_ `keydown` or `keyup`. **Cloud Phone doesn't send individual key event** during text input! Additionally, some elements like **[`<input type="range">`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/range) are not supported on Cloud Phone**.

### Caching

Cloud Phone generally caches content server-side within a browsing session, but not between sessions (or between users). Developers should still follow best practices for [cache headers](https://www.keycdn.com/blog/http-cache-headers), and consider in-memory caching to speed up page loads within a single session.

### Storage

Developers can store data using standard APIs including `localStorage`, IndexedDB, and Cookies, with a few considerations:

* **Cookies**: because Cloud Phone uses the latest Chrome build, you may run into issues with [third-party cookies](https://developers.google.com/privacy-sandbox/blog/cookie-countdown-2024jan) in the future!
* **Clear data**: users have the option to "Clear data" at any time from the main Cloud Phone menu. It's best to authenticate users using Google Sign-In where necessary to persist data to their account.
* **Limited storage**: Cloud Phones have limited on-device storage (ROM), so it's best to store the minimum data necessary.

### Volume Management

![Cloud Phone Volume Manager API](/img/cloudphone_volume.png "Cloud Phone Volume Manager API")

Not all Cloud Phones have hardware volume buttons. However, it is possible for widgets to request to raise or lower the volume using the [Volume Manager API]({{< ref "audio-volume-management#volume-manager-api" >}}). These API calls render the volume heads-up display (HUD) on screen, which is drawn as a horizontal progress bar on a solid red background at the bottom of the screen.

```js
navigator.volumeManager.requestUp();
navigator.volumeManager.requestDown();
navigator.volumeManager.requestShow();
```

### Traffic Origination

Cloud Phone originates all traffic from the [following IPv4 addresses](https://support.puffin.com/topic/110):

* 45.33.128.0/20
* 107.178.32.0/20
* 203.116.120.0/24
* 203.116.121.0/24
* 203.116.134.0/24
* 203.116.135.0/24

Geographically, **Cloud Phone production traffic comes from [servers located in](https://play.google.com/store/apps/details?id=com.cloudmosa.puffinFree&hl=en_US) in California (USA), Singapore, and recently South Africa**. Non-production traffic comes from Taiwan, where CloudMosa QA is located. Puffin and Cloud Phone are blocked in certain regions (e.g., China, Saudi Arabia, United Arab Emirates).

## Developer Mode

![Enable DevTools on Cloud Phone](/img/cloud_phone_devtools.png "Enable DevTools on Cloud Phone")

**Enable Developer Tools**. To enable Developer Tools on Cloud Phone, from the menu click "About" then **tap LSK 7 times**. This brings up a prompt asking: Are you sure to enable "Developer Mode?" Tap LSK to select "Yes," and your device will be able to load apps from the Cloud Phone [Developer Portal](https://www.cloudfone.com/auth/sign-in).

**Register Test IMEIs**. From the Developer Portal, you can register your device for testing by including it's IMEI number (type `*#06#` or look on the back of your device). Apps are called "widgets," and can be entered with a Name, Icon (PNG), and URL. For more details and to register, visit [cloudfone.com](https://www.cloudfone.com/getting-start).

### Debugging

Debugging on Cloud Phone is challenging, because all execution happens in a remote browser instance. CloudMosa is working on a remote debugger, but in the meantime your options are:

* **Chrome**. Rapidly test widgets in Chrome for style, functionality, and performance. Cloud Phone servers run Chrome, so this roughly approximates real-world experience.
* **Puffin**. At $1/m, [Puffin Secure Browser](https://www.puffin.com/secure-browser) for desktop is affordable way to validate your app via the same remote browser as Cloud Phone. However, you may not be able to size the window down to QQVGA to match the Cloud Phone viewport.
* **Cloud Phone**. There is no substitute for validating on real-world hardware. Below is a list of devices that currently run Cloud Phone. For faster feedback, you can use [RemoteJS](https://remotejs.com/) to debug and take screenshots remotely.

<u>Tip</u>: Open Developer Tools in Chrome, then from the Device Toolbar create a custom device that's 128x160 (QQVGA) like the Nokia 110 4G.

#### Devices

* [Nokia 106 4G](https://www.gadgets360.com/mobiles/news/nokia-110-106-4g-youtube-shorts-cloud-apps-google-hmd-4671224) (India)
* [Nokia 110 4G](https://www.gadgets360.com/mobiles/news/nokia-110-106-4g-youtube-shorts-cloud-apps-google-hmd-4671224) (Global)
* [Nokia 215 4G](https://www.channelnews.com.au/hmd-unveils-trio-of-4g-enabled-nokia-phones/) (Global)
* [Nokia 220 4G](https://www.hmd.com/en_in/nokia-220-4g-2024?sku=1GF026KPA2LC1) (India)
* [Nokia 225 4G](https://www.channelnews.com.au/hmd-unveils-trio-of-4g-enabled-nokia-phones/) (Global)
* [Nokia 235 4G](https://www.channelnews.com.au/hmd-unveils-trio-of-4g-enabled-nokia-phones/) (Global)
* [Nokia 3210 4G](https://timesofindia.indiatimes.com/technology/mobiles-tabs/nokia-3210-4g-launches-in-india-specifications-price-and-other-details/articleshow/110892347.cms) (India)
* [itel Super Guru 4G](https://www.fonearena.com/blog/422170/itel-super-guru-4g-price-features.html) (India)
* [Sumo V1S](https://viettel-digital.com/product/sumo-v1s) (Vietnam)
* [MTR Speed 4G](https://www.flipkart.com/mtr-speed/p/itm7da6fcb5c55d6) (India)
* [BlackZone Taurus 4G](https://www.flipkart.com/blackzone-taurus-4g/p/itm3ed334b0338fc) (India)
* [BlackZone XR 4G](https://www.flipkart.com/blackzone-xr-4g/p/itm8c70b98c8f61f) (India)
* [Snexian Guru 4G](https://www.wholemonkey.com/products/snexian-guru-4g-24-display-jio-sim-support-SKU-1381) (India)
* [Mobicell S4 Cloud](https://vodacom4u.co.za/product/mobicel-s4-cloud/) (Africa)
* [Simi G420 4G](https://www.jumia.ug/simi-g420-4g-feature-phone-inclusive-of-tiktok-youtube-facebook-fm-radio-dual-sim-card-holder-t-card-bt-2500mah-16mb16mb-memory-black-197950251.html) (Uganda)

Many more devices are expected to ship with Cloud Phone throughout 2024.

<u>Geography</u>: Cloud Phone is not available in all geographies. Currently, it's available in India, Vietnam, and Africa, but unavailable in markets like the US and Europe.

#### Screenshots

![Cloud Phone App List](/img/cloudphone_applist.png "Cloud Phone App List")

**To take screenshots on Cloud Phone, press `*` and `#`** at the same time. Screenshots are saved as bitmap (.bmp) files to the SD Card with the file format `img_YYYYMMDD_n.bmp`. Screenshots are full-screen (on the Nokia 110 4G, that's 128x160), and can be taken anywhere within Cloud Phone including on the home screen, menu, about page, or within any app. A white flash is briefly shown to indicate that a screenshot was taken.

#### User Agent

Here's a real-world user agent from my Nokia 110 4G:

```
Mozilla/5.0 (Cloud Phone; Nokia 110 4G) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.6261.111 Mobile Safari/537.36 Puffin/12.1.1.46653FP
```

You may also see requests from a user agent like this:

```
Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) HeadlessChrome/122.0.0.0 Safari/537.36
```

#### Analytics

Google Analytics works on Cloud Phone, but it does not respect the `X-Forwarded-For` header so all traffic will look as if it originates where servers are located in California (USA), Singapore, and South Africa. Tech details like Device model are also missing, and no referrer is set when your widget launches.

#### Errors

![Cloud Phone Proxy Error](/img/cloud-phone-no-internet.png "Cloud Phone Proxy Error")

Cloud Phone may temporarily be unavailable, which looks like Chrome's "No internet" error (`ERR_PROXY_CONNECTION_FAILED`). Errors within widgets on Cloud Phone are the same as on Chrome. This means developers can use `try { } catch { }` statements to catch errors, [`Promise.catch`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/catch) for Promise-based errors, as well as the global [`error`](https://developer.mozilla.org/en-US/docs/Web/API/Window/error_event) and [`unhandledrejection`](https://developer.mozilla.org/en-US/docs/Web/API/Window/unhandledrejection_event) events.

## Other Details

#### Operating System

**Cloud Phone currently runs on feature phones using the ThreadX/ [Mocor](https://lpcwiki.miraheze.org/wiki/Mocor_OS) real-time operating system (RTOS)**. Mocor is a proprietary OS for devices powered by a Unisoc (fka Spreadtrum) system-on-a-chip (SOC). On Nokia devices, Mocor is skinned and branded as S30+. On the Nokia 110 4G, the Mocor OS version is 20AMP_W22.04.6_P5 with a firmware version of UMS9117.

#### Legal

Developing apps ("widgets") for Cloud Phone is subject to the [Cloud Phone Developer Program Terms of Service](https://www.cloudfone.com/dev-terms).

## Summary

Cloud Phone is a promising platform that brings apps feature phone users around the world. As a remote browser, execution happens on cloud servers greatly reducing bandwidth usage while enabling rendering on budget hardware. It's easier than KaiOS to develop for, but is a much newer platform with a different set of technical considerations.

### Questions?

**Join the Community!**

* Reddit: [r/CloudPhone](https://www.reddit.com/r/cloudphone/)
* Discord: [r/CloudPhone](https://discord.gg/hcZPvt3D)

Cloud Phone is an emerging platform bringing rich experiences to global feature phone users. The author is among the earliest Cloud Phone developers, adapting the first podcast app, [PodLP](https://blog.podlp.com/posts/podlp-cloud-phone/), for Cloud Phone. If you are excited about the possibilities and would like **to learn how to bring your service to Cloud Phone, contact the author** from the [About]({{< ref "about" >}} "About") page.
