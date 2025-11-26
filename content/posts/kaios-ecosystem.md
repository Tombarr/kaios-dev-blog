+++
title = "The KaiOS Ecosystem: Apps & App Stores"
description = "The KaiOS ecosystem, packaged and hosted apps, and the KaiStore and JioStore"
date = 2023-02-04T00:00:00+08:00
toc = true
draft = false
tags = ["KaiOS", "Apps", "KaiStore", "JioStore"]
categories = []
header_img = "img/home-alt.png"
series = ["Getting Started"]
+++

The KaiOS ecosystem, packaged and hosted apps, and the KaiStore and JioStore.

# KaiOS App Basics

![KaiOS Apps](/img/2020-Top-Apps-Featured-Image.jpg "KaiOS Apps (Source: <a href='https://www.kaiostech.com/2020-most-popular-kaios-apps/' rel='external noopener'>2020’s most popular KaiOS apps</a>)")

Unlike Android and iOS, "native" KaiOS apps are just modified web apps. That means no new programming languages to learn or complicated build processes, just standard HTML, CSS, and JavaScript. That means you can also write in TypeScript or any JavaScript version or language the compiles or transpiles into ECMAScript 2015 (ES6) and runs on Firefox 48.

In 2018, the first third-party KaiOS games were published by Gameloft. Since then, as of February 2023 there were 1,350 apps available for KaiOS.

![KaiOS Apps Released Per Year](/img/KaiOS-Apps-Released-Per-Year.png "KaiOS Apps Released Per Year")

KaiOS apps are not evenly distributed by category. Games makes up the majority, with over 63% of all published apps under Games, followed distantly by Utilities and Entertainment.

![KaiOS Apps by Category](/img/KaiOS-Apps-by-Category.png "KaiOS Apps by Category")

### KaiOS App Categories

* Games
* Entertainment
* Education
* Social
* News
* Utilities
* Health
* Sports
* Books/Reference
* Lifestyle

This divide was so pronounced that Reliance Jio split their store into two: the JioStore and JioGames (more on the JioStore below).

## To Package or not to Package?

KaiOS apps come in two types: **hosted** apps and **packaged** apps, which are further broken down as **privileged** and **certified**. Hosted apps are basically progressive web apps (PWAs) that are installable via a `manifest.webapp` (KaiOS 2.5) or `manifest.webmanifest` (KaiOS 3.0) file. Hosted apps get added to the user's homescreen and if they include a caching strategy like a ServiceWorker they can work offline.

### Hosted Apps

* Easily "updated" (upload new code and clear cache)
* On-the-fly updates without store review
* Faster installation
* Ability to vary code by user (device, geography, etc)
* Native feel with d-pad navigation, fullscreen, etc.
* Availability of offline mode

Packaged apps, on the other hand, are just ZIP files containing HTML, CSS, JS, images, and a manifest file. Packaged apps are given access to additional permissions and can work completely offline.

### Packaged Apps

* Access to Privileged permissions (disable CORS, alarms, sockets, etc)
* No distribution cost (i.e. bandwidth)
* Faster start-up time
* Tighter device integration
* No server required

![KaiOS App Types](/img/KaiOS-App-Types.png "KaiOS App Types")

Most developed opt for web apps, although
For a full breakdown, see [packaged and hosted apps compared](https://developer.kaiostech.com/docs/development/packaged-or-hosted/) from the KaiOS Developer Portal.

### App Size

Compared to native Android apps, KaiOS apps are small, [averaging around 2MB](https://www.kaiostech.com/convert-android-apps-kaios/). From KaiStore analyses, apps typically range from 30KB to 3MB, not accounting for assets downloaded during runtime. It's best practice to keep app sizes small because doing so makes successful installation more likely and leads to faster startup times. Best practices include minifying code, right-sizing and compressing images, and downloading + caching non-critical assets at runtime.

![KaiOS App Size](/img/KaiOS-App-Size.png "KaiOS App Size")

## A Tale of Two Stores

Unlike Google's Android or Apple's iOS, KaiOS has two app stores: the JioStore, which serves the Indian market, and the KaiStore, which serves the rest of the world. The table below compares the two stores and is based on both personal experience and gathered data.

|          | JioStore     | KaiStore |
|--------------|-----------|------------|
| Market | India      | Global (- India)        |
| Telcos      | Reliance Jio | Many       |
| Est. Active Users      | 10 - 100M | 1 - 10M       |
| # of Apps      | 67<sup>1</sup> | 1,315+       |
| App Portal      | None | [KaiStore Submission Portal](https://developer.kaiostech.com/subpo/)       |
| Monetization      | [JioAds](https://jioads.jio.com/) | [KaiAds](https://kaiads.com/)       |
| Device Models      | [20+](https://sites.google.com/view/bananahackers/devices/jio-phone)<sup>2</sup> | [220+](https://www.kaiostech.com/explore/devices/)       |
| Testing      | N/A | By IMEI       |

<sup>1</sup> The JioStore separates apps from Games, which are installable via [JioGames](https://www.jiogames.com/).

<sup>2</sup> Although they appear similar on the surface, there are actually 20+ models of the JioPhone referred to as the JioPhone 1 (candybar) and [JioPhone 2]({{< ref "whats-next-jiophone#jiophone-2" >}} "JioPhone 2")) (Blackberry-style). The JioPhone 1 is further broken down into the JioPhone Value (lacking Wi-Fi), and models running on Qualcomm (QCOM) and Spreadtrum (SPRD) chipsets.

The two stores have different processes and requirements for publishing, with most developers opting for the KaiStore because submission is easier and more readily available. Although the JioStore is larger, with Reliance Jio's push up-market toward Pragati OS (Android Go) devices like their [JioPhone Next](https://www.jio.com/next), the JioStore user base is shrinking while the KaiStore user base is growing.

## Conclusion

KaiOS has two app stores and two primary app types. Selecting the right type and distribution strategy is important for a successful launch because attributes like app type cannot be changed once published. If you're looking for a partner to ensure the best possible launch on KaiOS, you can find the author's contact info on the [About]({{< ref "about" >}} "About") page.