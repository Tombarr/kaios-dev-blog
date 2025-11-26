+++
title = "KaiOS App Publishing Guide"
description = "Everything you need to publish an app on KaiOS"
date = 2024-02-19T00:00:00+08:00
lastmod = 2024-02-19T00:00:00+08:00
toc = true
draft = false
header_img = "img/home-alt.png"
tags = ["KaiOS", "App", "KaiStore", "JioStore"]
categories = []
series = ["Getting Started"]
+++

Everything you need to publish an app on KaiOS

**Why it matters**. Names, icons, and banners are how you stand out on a platform with limited discovery capabilities. Learn how to market and promote your application to grow your user base globally.

**Dive deeper**. Publishing requirements are different between the KaiStore and JioStore. This article focused on the KaiStore, but makes a few notes where design requirements differ on the JioStore.

## Design Components

### Launcher Icon

All KaiOS applications need a launcher icon. This is how user's identify your application in the launcher app drawer. Without one, your app will be given the default rocket icon:

![KaiOS Default App Icon](/img/default-app-icon.png "KaiOS Default App Icon")

KaiOS launcher icons must include the following sizes:

| Size              | Displayed In	      |
|-------------------|---------------------|
| 56 x 56           | All Apps (Grid & List)<br />KaiStore<br />Notifications |
| 84 x 84           | JioStore only |
| 112 x 112         | All Apps (Single)<br />Launcher |

It's recommended to leave about ~20% (10-12px for 56x56) of whitespace and include a drop shadow so your icon stands out against many backgrounds like the black background in the Launcher and on top of your marketing banner on the KaiStore. It will also be shown against a background of your app's focus color defined using the [`theme_color` manifest property]({{< ref "./manifest-properties#theme_color-optional" >}}), and other system focus colors.

![KaiOS Launcher Icons (Source: developer.kaiostech.com)](/img/kaios-launcher-icons.png "KaiOS Launcher Icons (Source: <a href='https://developer.kaiostech.com/docs/design-guide/launcher-icon' rel='external noopener'>developer.kaiostech.com</a>)")

**File Size<**: **icons must be at least 512 bytes**, or they'll be rejected by the KaiStore. This is only a problem for very simple, highly-compressed icons that use only a few colors. Nonetheless, it's a good idea to use [lossless compression](https://developer.mozilla.org/en-US/docs/Glossary/Lossless_compression) for icons, banners, and screenshots to reduce bandwidth and memory usage.

### Marketing Banner

The marketing banner serves as a background image to encourage views and installs. It's displayed on the KaiStore and JioStore alongside your app name, subtitle, and icon. KaiOS marketing banners are 240 x 130, JPG (non-transparent), and up to 100 KB in size. The same banner is used for both landscape and portrait orientations.

![KaiOS Marketing Banner (Source: developer.kaiostech.com)](/img/kaios-marketing-banner.png "KaiOS Marketing Banner (Source: <a href='https://developer.kaiostech.com/docs/design-guide/marketing-banner' rel='external noopener'>developer.kaiostech.com</a>)")

**Always include a marketing banner so your application stands out** on the KaiStore and JioStore. You can find great free photos on [Unsplash](https://unsplash.com/), or use Generative AI to create visuals like the background used on [KaiOS.app landing pages](https://kaios.app/apps/UxappJMyyWGDpPORzsyl).

### Screenshots

Screenshots are only available on the KaiStore, but they're an important way to show off your application before the user clicks "Install." Developers can submit **up to 5 screenshots**, all 240x320 in size. Pick good screenshots that clearly show off your application, and avoid distractions (i.e. notifications, debugger icon, etc).

![PodLP Screenshots](/img/podlp-screenshots.png "PodLP Screenshots (<a href='https://podlp.com' rel='external noopener'>PodLP.com</a>)")

## Publishing

### Submission

You can publish a KaiOS app by uploading your build (or linking your manifest) via the [KaiStore Submission Portal](https://developer.kaiostech.com/subpo/). Create an account with an email and password, then upload builds directly. Publishing on the JioStore is a manual process that involves sharing builds with the JioStore team via WhatsApp, and a more exhaustive QA process.

### Category

KaiOS has about a dozen app categories to choose from (fewer on the JioStore). **Picking the right category is critical to acquiring new users**. Categories are ordered (Education first on the KaiStore), and some categories are much more crowded than others. For instance, nearly two thirds of all apps on the KaiStore are Games. Categories include:

* Books/Reference
* Education
* Entertainment
* Games <sup>1</sup>
* Health
* Lifestyle
* News
* Shopping
* Social
* Sports
* Utilities

**Choosing Categories**. On the KaiStore you can choose your app's category, but the KaiOS team may change it if they feel another category is more appropriate. On the JioStore you can suggest a category, but the final decision is up to the Jio team.

<sup>1</sup> Games is an app category on the KaiStore, but not on the JioStore. Instead, games are available on the JioPhone via JioGames, a dedicated gaming marketplace.

### Statuses

On the KaiStore Submission Portal, you'll see your application can be in one of a number of statuses including:

* **Staging**: the initial status after uploading your application
* **Testing**: the status once you've clicked "Test Devices" and added IMEI numbers to the list
* **Failed**: status when the KaiOS team rejects your build
* **Approved**: status for builds approved by KaiOS but not yet published
* **Published**: status for one current build available for install on the KaiStore

### Testing

Test your apps via the KaiStore by selecting "Test Devices," then enter a list of IMEI numbers. After some time, your app will be available to install on these devices in the KaiStore. **KaiStore sideloading works on all devices**, even those without ADB or DevTools access. This is also **the only way to sideload KaiOS 3.0 apps**, since no commercial device supports DevTools as of the time of writing. There is no way to sideload via the JioStore, so you must have a DevTools-enabled device to test yourself.

### Google Bundle ID and Ads.txt

The KaiStore has an optional field for a Google Bundle ID. This is the [package name](https://developer.android.com/guide/app-bundle/) (i.e. `com.podlp.app`) of your Android App Bundle published on Google Play. It's useful for claiming ownership within the KaiStore and associating your Android and KaiOS applications to advertisers via [ads.txt and app-ads.txt](https://adstxt.kaiads.com/), which KaiAds provides a generator for at [adstxt.kaiads.com](https://adstxt.kaiads.com/).

## Conclusion

There are many nuances to publishing a KaiOS app, and it's important to get it right the first time because you **cannot change screenshots, icons, or banners without uploading a new build**. Moreover, you **cannot change your app name once published**. Finally, developers must accept the [submission agreement](https://www.kaiostech.com/sub-agreement/) which requires [KaiAds integration](https://www.kaiads.com/).

If you need assistance navigating the KaiStore and JioStore to ensure your app has the best chance of success, contact the author from the [About]({{< ref "about" >}} "About") page.
