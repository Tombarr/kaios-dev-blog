+++
title = "[Guest Post] Building a Crypto Wallet on KaiOS"
description = "Navigating the Challenges of Building a Crypto Wallet on KaiOS"
date = 2023-11-02T00:00:00+08:00
lastmod = 2023-11-09T00:00:00+08:00
author = "Shishir Gupta"
toc = true
draft = false
header_img = "img/home-alt.png"
tags = ["KaiOS", "Sorted Wallet", "Crypto", "Bitcoin"]
categories = []
series = ["Case Study"]
+++

# [Guest Post] Building a Crypto Wallet on KaiOS

[Sorted Wallet](https://sortedwallet.com/?utm_source=kaios.dev&utm_medium=article) is the first cryptocurrency wallet created for KaiOS feature phone devices and published on the [KaiStore](https://www.kaiostech.com/store/apps/?bundle_id=kaios.app.sortedwallet).

**Why it matters?** Sorted Wallet provides the basic functionality for crypto assets holders and enables non-smartphone owners to step into the world of cryptocurrency. It tackles the increasing wealth gap in emerging markets and provides support to underserved populations in their fight for financial inclusion.

## By The Numbers

![Sorted Wallet Installs](/img/sorted-wallet-install-trend.png "Sorted Wallet Installs")

* Sorted Wallet received [**50,000+ downloads**](https://www.linkedin.com/posts/sortedwallet_crypto-financialinclusion-africa-ugcPost-7128326909276389377-awAX) in ~6 months across 64 countries (March 2023) on the KaiStore.
* More than 50% downloads come from African countries with Nigeria, Pakistan, and Tanzania as the top three countries
* **19% users registered** for the wallet, totalling **8,000 registered users**.
* ~37% of registered users use the wallet 3 to 4 times per month, primarily for receiving funds from other wallets, suggesting a practical application in remittance payments.

This adoption underscores the critical need for this product in these regions. The app is on a mission to become the go-to crypto super app for all things related to digital assets in Africa and other emerging markets have opened up new possibilities for KaiOS users.

## How it works

![Screenshots of Sorted Wallet on KaiOS](/img/sorted-wallet-kaios-screenshots.png "Screenshots of Sorted Wallet on KaiOS")

* Login or Register via Email & Password or Phone Number
* Receive an SMS-based One Time Password (OTP) from 22395 (Twilio)
* My Wallet shows MATIC, Polygon, and BTC
* Options to view transaction records or share wallet address
* Options to scan or show wallet address QR Codes
* Settings to change Language
* Frequently Asked Questions (FAQ)

## Key Benefits of Building on KaiOS

Building for underprivileged communities on KaiOS helped Sorted Wallet reach its target customers quickly and in the most user-friendly way. Without significant marketing expenses, the wallet app climbed to the top of the KaiStore ranking, attracting users who eagerly embraced cryptocurrency usage.

The Sorted Wallet team also found building on KaiOS to be inherently more secure than any other operating system. Moreover, the application is lightweight<sup>1</sup> and optimized to operate within the hardware constraints of KaiOS feature phones.

<sup>1</sup> Version 2.3.88 is the latest as of the time of writing. It was published on 9/13 and is 3.1 MB zipped, 10.1 MB expanded. The [KaiOS average app size was ~2 MB]({{< relref path="kaios-ecosystem.md#app-size" >}} "KaiOS average app size was ~2 MB") earlier this year.

## Difficulties of Building on KaiOS

There were challenges involved in developing for KaiOS. Notably, **KaiOS lacks an extensive developer community** compared to iOS and Android. Also, **debugging tools and interactive studios for coding are less prevalent**, making troubleshooting more challenging. Additionally, the app's performance is limited by the capabilities of KaiOS devices, and there were inconsistencies between the app's behavior in the simulator and on real devices.

## Why Continue Building on KaiOS

**Sorted Wallet selected Vue.js** to leverage the right technology to perform seamlessly within the constraints of KaiOS feature phones. Vue.js was the ideal choice due to its efficient use of resources and its suitability for the hardware found in KaiOS devices. It's a framework known for its flexibility, scalability, and exceptional performance, making it the perfect fit.

To provide a smooth user experience, we needed to ensure Sorted Wallet was memory-efficient. Vue.js allowed us to create an app that operates smoothly even on devices with limited RAM (512 MB). We meticulously profiled the app to measure its RAM usage, ensuring that it ran optimally and didn't strain the hardware.

The Sorted Wallet back-end at <a href="https://api.sorted.finance" rel="external noopener">api.sorted.finance</a> hosts a REST API on [ngrok](https://ngrok.com/) (nginx/ Ubuntu reverse-proxy that provides JSON responses), while the client was built using the following notable frameworks and libraries:

* Vue.js
* core-js
* Webpack
* Babel
* [Vue KaiOS](https://github.com/sebastianbaar/vue-kaiui)
* [vue-cookies](https://github.com/cmp-cc/vue-cookies)
* [vue-i18n](https://kazupon.github.io/vue-i18n/)
* [qrcode.js](https://davidshimjs.github.io/qrcodejs/)
* [Axios](https://axios-http.com/docs/intro)

Additionally, the Sorted Wallet app requests the following [permissions]({{< relref path="kaios-permissions.md" >}} "permissions"):

* `camera` - for scanning QR codes
* `device-storage:videos`
* `device-storage:pictures`
* `device-storage:apps`
* `device-storage:sdcard`
* `systemXHR`

## Conclusion

With KaiOS, we take pride in providing crypto education and support to communities in need. [Sorted Wallet](https://kaios.app/apps/Flot-N4KUGgUtkVMC3Jw) continues to be a driving force in the journey towards financial inclusion, delivering seamless cryptocurrency access to millions of feature phone users in emerging markets.

ℹ️ <u>Note</u>: this guest article was provided by [Shishir Gupta](https://www.linkedin.com/in/shishrgupta/) of [Sorted Wallet](https://sortedwallet.com). It was published without compensation. All opinions and data are those of Sorted Wallet.
