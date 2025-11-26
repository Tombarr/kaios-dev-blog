+++
title = "KaiOS App Ideas"
description = "Ideas for KaiOS apps still unavailable on the KaiStore in 2024"
date = 2024-01-24T00:00:00+08:00
lastmod = 2024-01-28T00:00:00+08:00
toc = true
draft = false
header_img = "img/home-alt.png"
tags = ["KaiOS", "Apps", "KaiStore"]
categories = []
series = ["Getting Started"]
+++

# KaiOS App Ideas

**Apps**. There are just under [1,500 KaiOS apps](https://kaios.app/) as of January 2024. Here are some ideas for apps that aren't yet available on the KaiStore.

## Utilities

### Smart TV Remote

What is a T9 feature phone with Bluetooth and Wi-Fi, if not a smart TV remote to control your Android TV or Roku? Numerous remote apps make the Top 100 list in the Utilities category for smartphones. KaiOS provides access to raw TCP/ UDP sockets, as well as [low-level Bluetooth APIs]({{< ref "./bluetooth" >}} "low-level Bluetooth APIs"), so this should be possible.

### Robocall Blocker

KaiOS users are no less likely to receive spam calls, yet despite numerous robocall blockers making the Top 100 list on the App Store, none exist on the KaiStore. This should be feasible since KaiOS exposes telephony APIs to Certified apps. The app would screen calls against a block list and auto-reject them if a match is found.

### File Sync (FTP, LDAP, etc)

Getting data onto, and off of, KaiOS devices can be painful. Some (but not all) phones have micro SD card slots, yet many of these require battery removal to access.

The ability to access, backup, and sync remote files could augment limited storage while removing the need for USB cables or swapping SD cards. The app could offer free storage in a UX-friendly way, or allow the user to manually enter their own server.

### Clipboard Stash

KaiOS does not support copy and paste, and while this might be a system limitation, in different contexts it's possible to "Share" text or images via [Web Activities]({{< ref "./web-activities" >}}). Perhaps copy-paste could be partially replicating through an app that can store and re-share such content.

### Virtual Phone Number

KaiOS doesn't have Google Voice, or _any_ virtual phone number app. While some KaiOS devices are dual-SIM, many are not, and it's clear from the Android charts that virtual phone number services are quite popular. This is especially true among a global user base where SMS charges can be quite significant.

### Bookmarks

On newer KaiOS 2.5.4+ devices, the system browser allows you to "pin" up to six websites on the default page. Users might find it helpful if they can save more websites for easier access, with features to sort by dates added or accessed, or to search by title or URL. There are plenty of iOS and Android bookmark apps to draw inspiration from.

### Predictive Keyboard (Typeahead)

Most Android and iOS phones come with native typeahead support that learns and predicts your next few words or sentence as you type. Typing on T9 keyboards is notoriously slow and challenging, yet KaiOS' most advanced predictive features are static (non-learning) using tries and pre-installed dictionaries.

Using the [`input-manage` and `input` permissions]({{< ref "./kaios-permissions#input" >}}), the `inputs` manifest property, and the `spell-dialog` and `keyevent` inter-app communication ports, it might be possible to create a third-party, [certified]({{< ref "./certified-apps" >}}), installable keyboard. Such a keyboard could be extended further to include a password manager and clipboard functionality to reduce repeat typing of usernames, passwords, and URLs.

## Lifestyle

### Stocks

Technically KaiOS published [AlphaStock](https://kaios.app/apps/TvUwcddBSplM87Qnls0g), but there's significant room for improvement searching and saving relevant symbols to track prices. A full-feature Stocks app could offer Web Push notifications when prices cross a threshold or move by a pre-defined percentage within a given time window.

### Flight Tracker

Even though KaiOS users may not fly as often as their Android or iOS counterparts, an app providing this information could keep users apprised of their friend's and family member's travels.

### DuckDuckGo

Many KaiOS devices come pre-installed with the "Google" app, which is effectively just a bookmark to Google.com. DuckDuckGo doesn't provide an API, but its possible to circumvent CORS with the [`systemXHR` permission]({{< ref "./kaios-permissions#systemxhr" >}}) and parse the returned HTML to render in a "native" UI.

### Coupons

Many smartphone apps help users search for and "clip" virtual coupons, rendered via bar codes. There's no reason this couldn't be replicated on feature phones, and given KaiOS demographics skew lower income, users might find this especially useful.

### Weather Radar

Weather is a crowded category, yet despite this, there are no live weather radars showing precipitation, air quality, or temperature on KaiOS. It would be easy to auto-center the radar using GPS or GeoIP to lookup the user's location, and fairly intuitive to zoom/ pan around to scrub forwards and backwards in time using the arrow keys.

<u>Note</u>: the open source [o.map](https://github.com/strukturart/o.map) openstreetmap app does offer a radar layer, but there's still space for a dedicated weather radar with layers over time including precipitation, air quality, and temperature.

## Health & Fitness

### Heart Rate Monitor

Hundreds of smartphone apps use the camera and flashlight (torch) to approximate your heart rate. While not every KaiOS device places the torch next to the camera, many do, and for these devices it might be possible to estimate changes in heart rate in beats per minute (BPM) using basic algorithms. The fancy word for this is Photoplethysmography.

## Social

### Tinder

Instead of swiping, you could use `ArrowLeft` and `ArrowRight` to navigate the list of nearby eligible singles. Tinder's API has been [reverse engineered](https://github.com/tiagovla/tinder.py), so it should be possible to make a KaiOS client (of course, YMMV as this may be against their Terms of Service).

### Texting

Yes, KaiOS devices support SMS and WhatsApp (on KaiOS 2.5 only), but not much beyond that. The list of what's missing is long, but some notable omissions include RCS, Telegram, Signal, Discord, Slack, GroupMe, Skype, WeChat, and many more.

## Conclusion

Unlike Android or iOS, the KaiStore has very few apps. As a result, it's easy to publish in an area with little to no competition. If you need an experienced developer to help build a world-class KaiOS app for your business, contact the author from the [About]({{< ref "about" >}} "About") page.
