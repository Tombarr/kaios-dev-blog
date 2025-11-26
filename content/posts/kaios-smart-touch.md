+++
title = "An In-Depth Look At KaiOS Smart Touch"
description = "KaiOS Smart Touch: The Android Competitor Killed Before It Hit The Market"
date = 2025-01-26T00:00:00+08:00
lastmod = 2025-01-26T00:00:00+08:00
toc = true
draft = false
tags = ["KaiOS", "Smart Touch", "Android"]
categories = []
header_img = "img/kaios-smart-touch-prototype-background.jpg"
series = ["Getting Started"]
[params]
  featured_img = "img/kaios-smart-touch-prototype.jpg"
+++

![KaiOS Smart Touch Prototype](/img/kaios-smart-touch-prototype.jpg "KaiOS Smart Touch TCL Prototype")

KaiOS Smart Touch almost had a chance to compete with budget Android Go smartphones. That is, if it had not been killed before hitting the market.

# KaiOS Smart Touch

[KaiOS Smart Touch]({{< ref "./history-of-kaios.md#kaios-smart-touch-the-os-that-never-was" >}}) (ST) was a mobile operating system based on [Firefox OS](https://developer.mozilla.org/en-US/docs/Glossary/Firefox_OS) designed for budget touchscreen smartphones. ST dates back to 2020 as a fork of KaiOS with a somewhat unconventional [user interface](https://www.miketsai.com/smart-touch), a catalog of web apps from the KaiStore and JioStore, and a focus on affordability. It was initially developed for Reliance Jio following the massive success of the original JioPhone. However, Google's multi-billion dollar investment in Jio ensured the telco would pivot to Android, killing KaiOS Smart Touch before it got off the ground.

## The Device

![KaiOS Smart Touch Prototype Rear](/img/kaios-smart-touch-prototype-back.jpg)

This prototype is manufacturer by TCL with "**Powered By Jio**" etched on the removable back cover. Underneath it has a single nano SIM slot and micro SD slot. It offers 4G, WiFi, and Bluetooth connectivity. On the outside it has a micro USB and 3.5" headphone jack port. It appears to be visually similar to the model KaiOS UX Manager [Mike Tsai demonstrated](https://vimeo.com/716662394) in 2022.

![KaiOS Smart Touch Rear](/img/kaios-smart-touch-prototype-back-open.jpg)

The phone is fairly small, roughly the same size as an iPhone 13 Mini albeit with larger bezels. It seems to be based on the [Alcatel 1 5033X](https://phonedb.net/index.php?m=device&id=14615&c=alcatel_1_lte_emea_5033x__tcl_u3a) (TCL U3A) originally running Android Go 8.1. The build quality feels solid and, due in part to the plastic casing, is fairly light weight.

![KaiOS Smart Touch Prototype vs iPhone 13 Mini](/img/kaios-smart-touch-size.jpg "KaiOS Smart Touch Prototype vs. iPhone 13 Mini")

The device uses the Commercial Unit Reference (CUref) of `4044O-2BAQUS1-R`, which matches the Alcatel A405DL 4044. No other identifiers are given for this model. Performance is quite poor, but this is expected from an early prototype with low-end specifications. It has a MediaTek chip and runs KaiOS 2.5.3.1, but later versions of KaiOS Smart Touch were based on the Qualcomm 215 (used in the JioPhone Next) and ran KaiOS 3.0. The KaiOS build is from 2020 and the device is a developer unit that comes rooted with full Android Device Bridge (ADB) and Developer Tools enabled.

![KaiOS Smart Touch Device Info](/img/kaios-st-device.png "KaiOS Smart Touch Device Info")

### Specifications

| Specification |                |
|---------------|----------------|
| CPU           | Mediatek [MT6739](https://www.mediatek.jp/products/smartphones-2/mt6739)  |
| Screen        | 4.9", 480x960  |
| RAM           | 1GB            |
| Storage       | 8GB            |
| OS            | KaiOS 2.5.3.1  |
| Battery       | 2,000 mAh      |

#### Camera

The unit has both a rear and front-facing camera, but neither work due to issues in Gecko's handling of failed camera drivers. Screenshots of the blank Camera app are shown below.

```
Camera: request camera err Exception { message: "", result: 2147746065, name: "NS_ERROR_NOT_AVAILABLE", filename: "", lineNumber: 0, columnNumber: 0, data: null, stack: "" }

I Camera  : [connect] +
E CameraService: Permission Denial: can't use the camera pid=5143, uid=15643, selfpid=371
I CameraService: CameraService::connect call (PID 5143 "gonk.camera", camera ID 0) for HAL version default and Camera API version 1
E CameraService: CameraService::connect X (PID 5143) rejected (invalid camera ID 0)
W CameraService: doUserSwitch: Received notification of user switch with no updated user IDs.
W CameraBase: An error occurred while connecting to camera: 0
I Camera  : [connect] - 5 ms
```

## User Interface

KaiOS took a somewhat unconventional approach with the [Smart Touch User Interface](https://www.miketsai.com/smart-touch). It supported both light and dark themes, borrowing many elements from Microsoft's [Metro Design Language](https://en.wikipedia.org/wiki/Metro_(design_language)) popularized by Windows Phone.

### Infogation Bar

KaiOS Smart Touch combined both the status bar and software buttons in a single component dubbed the **Infogation Bar**. Integrating aspects of navigation control and system information, the Infogation Bar was designed to maximize the app display area. On some system apps like the web browser, the Infogation Bar automatically hides as the user scrolls, providing a full screen browsing experience.

### Air Deck

![KaiOS Smart Touch Air Deck](/img/kaios-st-airdeck.png "KaiOS Smart Touch Air Deck")

Although not publicly discussed, KaiOS uses a custom component called the **Air Deck** to navigate recently-opened apps similar to Android's [Recents screen](https://developer.android.com/guide/components/activities/recents). Swiping from the screen edge pulls up the Air Deck showing the names and icons of apps arranged horizontally. A single setting allows the user to swipe from the left, right, or both screen edges, and the "X" icon terminates the app process.

### Lockscreen

The lockscreen displays a single lock icon that, when swiped, expands to unlock, enable the flashlight (torch), or launch the camera.

![KaiOS Smart Touch Lockscreen](/img/kaios-st-lockscreen.png "KaiOS Smart Touch Lockscreen")

### System UI

The System UI is similar to Android phones. Below are screenshots of the software keyboard, volume panel, and permission screen.

![KaiOS Smart Touch System UI](/img/kaios-st-keyboard-volume-permission.png)

##### Wallpaper

![KaiOS Smart Touch Wallpaper](/img/kaios-st-wallpaper.jpg)

##### Boot Animation

The device boots up to the MediaTek logo, following by KaiOS' boot animation. Here is a GIF generated from the `system/media/bootanimation.zip` file.

![KaiOS Smart Touch Boot Animation](/img/kaios-st-bootanimation.gif "KaiOS Smart Touch Boot Animation")

##### Browser

This prototype suffers from the same [expired Let's Encrypt]({{< ref "./ssl-certificate.md#lets-encrypt-ssl-certificate-issue" >}} "expired Let's Encrypt") SSL root certificate that other KaiOS 2.5 devices do. Many popular websites like Wikipedia, and KaiOS' own website, www.kaiostech.com, use Let's Encrypt. Unfortunately, neither the "Visit site" nor "Add permanent exception" buttons work properly.

### Screenshots

#### Settings

The Settings app has a row of quick action icons to toggle WiFi, Data, Bluetooth, and Airplane Mode. Other settings can be accessed via dedicated pages.

![KaiOS Smart Touch Settings](/img/kaios-st-settings.png)

#### Launcher

The launcher includes a vertical row of 7 configurable apps to quickly launch, a digital clock, a search bar, and a set of information cards. Only the "Download free apps in Store" card can be hidden.

![KaiOS Smart Touch Launcher](/img/kaios-st-launcher.png)

#### Apps

Interestingly, this version of KaiOS Smart Touch comes with a native YouTube app which works despite YouTube.com displaying a message to "Please update your browser."

![KaiOS Smart Touch YouTube](/img/kaios-st-youtube.png)

Several apps are broken including the aforementioned Camera app, as well as the KaiStore. This device includes the MediaTek MTKLogger and SIM Toolkit (STK), both of which appear to work with bugs.

![KaiOS Smart Touch Misc Apps](/img/kaios-st-misc-apps2.png)

System apps like Music, Calculator, Calendar, and Contacts use a consistent design language and work as expected.

![KaiOS Smart Touch Misc Apps](/img/kaios-st-misc-apps.png)

## History

KaiOS' success started in 2017 with the [incredibly popular](https://indianexpress.com/article/technology/mobile-tabs/nearly-40-million-jiophones-have-been-sold-so-far-report-5152257/
) JioPhone, at times selling as many as 7 million units in a single month. Success was so swift that by 2018, KaiOS beat Apple iOS to become the [second most popular](https://techpp.com/2018/05/07/kaios-second-mobile-os-india/) operating system in India just months after launch. With prices as low as Rs 501 ($7 USD) and plans starting at Rs 49 ($0.68 USD), Reliance Jio's loss leader strategy saw the telco's [market share rise](https://www.newindianexpress.com/business/2024/Apr/09/jio-retains-40-market-share-in-mobile-connectivity) from 9.58% in 2017 to 40% in 2024.

No doubt envious of the success, in June 2018 Google’s Next Billion Users division invested [$22 million](https://techcrunch.com/2018/06/27/google-kaios/) in KaiOS. Around this time, leaks of a secret project dubbed **[Google Android Feature Phone (GAFP)](https://nokiapoweruser.com/full-video-of-nokia-android-feature-phone-with-google-assistant-support-emerges/)** started to emerge with leaked Nokia TA-1208 prototypes. GAFP was an undisclosed Android Open Source Project (AOSP) 8.1 fork developed by Google to run on smart feature phones.

In late 2018, Jio launched the Blackberry-esque [JioPhone 2](https://techpp.com/2018/07/05/jiophone-2-specs-price-features/) with a QWERTY keyboard for Rs 2,999 ($42 USD). A year later, [WhatsApp came to KaiOS](https://www.theverge.com/2019/7/22/20703872/whatsapp-kaios-nokia-8110-jio-phone-feature-phones), the company raised another [$50 million](https://techcrunch.com/2019/05/22/kaios-raises-50m-more-hits-100m-handsets-powered-by-its-feature-phone-os/), and [KaiOS was succeeding](https://www.androidpolice.com/2019/03/27/kaios-may-succeed-where-android-go-edition-has-failed/) where **Android Go** was faltering.

Following the splendid success of the JioPhone lineup, many speculated that Jio would continue the 2G to 4G transition with a flagship budget smartphone. However, production slowed as the company was affected by the [2020 global chip shortage](https://en.wikipedia.org/wiki/2020%E2%80%932023_global_chip_shortage). Then Google invested [$4.5 billion](https://techcrunch.com/2020/07/15/google-invests-4-5-billion-in-indias-reliance-jio-platforms/) in India's Reliance Jio in exchange for a 7.7% stake in the company. In August 2021, Google Assistant was [discontinued on KaiOS](https://9to5google.com/2021/08/30/google-assistant-kaios-text/). After more than a year of silence, the [JioPhone Next](https://www.livemint.com/technology/gadgets/jiophone-next-set-to-be-launched-on-diwali-pichai-11635361383504.html) was announced in October 2021 at the price of Rs 6,499 ($87.50 USD) sporting **Pragati OS**, a rebrand of Android Go. Despite billions in investment, [JioPhone Next sales flopped](https://the-ken.com/story/google-reliance-jio-a-smartphone-for-millions-what-went-wrong/) with only 2 million units sold due largely to the high price and competition from Chinese Android models.

### The End of KaiOS Smart Touch

Whether strategic or unintentional, Google's close partnership with Original Equipment Manufacturers (OEMs) and semiconductor companies on GAFP and Android Go/ Pragati OS was quite successful at hindering KaiOS' growth. OEMs did not want to jeopardize their relationship with Google, and without a large distribution partner like Reliance Jio, KaiOS Smart Touch never took off. Moreover, popular apps like WhatsApp would need to be adapted for larger touchscreens. Having secured the top spot among India's telco market, Jio cut subsidies and raised the price of the latest and only remaining JioPhone model, the [JioPhone Prima 2]({{< ref "whats-next-jiophone#jiophone-prima-2" >}} "JioPhone Prima 4G"), to Rs 2,899 ($33.40 USD).

In July 2024, [WhatsApp ended KaiOS support](https://www.kaiostech.com/help-center/activate-whatsapp-voip/). With inflation raising hardware costs, KaiOS phones were now priced squarely between feature phones running real-time operating systems (RTOS) and budget Android phones. However, without killer apps like WhatsApp, and with the introduction of [**Cloud Phone**](https://www.passionateinmarketing.com/hmd-brings-another-innovation-unveils-youtube-shorts-other-cloud-apps-innovation-for-nokia-106-4g-and-nokia-110-4g-even-the-existing-users-to-get-the-software-update/) to RTOS feature phones in December 2023, KaiOS' value proposition is uncertain.

## Conclusion

It's sad that KaiOS Smart Touch never got a chance to challenge the Android-iOS duopoly. As the commercial successor to Firefox OS, KaiOS Smart Touch promised to bring progressive web apps (PWAs) natively to budget smartphones. This prototype is the first to surface publicly, and holding it feels like holding a piece of digital history.

**Details**: All prices are quotes in United States Dollars (USD) at the time of launch. All sources are cited inline for reference. Device identifiers like the IMEI number and MAC address are redacted.

If you would like to learn more about platforms like KaiOS Smart Touch or about opportunities in the feature phone market, contact the author from the [About]({{< ref "about" >}} "About") page.
