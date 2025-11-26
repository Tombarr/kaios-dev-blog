+++
title = "What's missing from KaiOS development?"
description = "What's missing from the KaiOS development experience in 2024?"
date = 2024-01-11T00:00:00+08:00
lastmod = 2024-01-11T00:00:00+08:00
toc = true
draft = false
header_img = "img/home-alt.png"
tags = ["KaiOS", "Developer"]
categories = []
series = ["Getting Started"]
+++

# What's Missing?

KaiOS was [founded in 2016](https://www.linkedin.com/company/kaiostechnologies/about/), but 8 years later key tools are missing from the KaiOS developer experience (DevEx).

**Why it matters?** KaiOS is available in [100+ countries](https://developer.kaiostech.com/docs/introduction/history/) with [170M+ devices shipped](https://techcrunch.com/2022/11/23/kaios-africa/) in 2022. Yet there are fewer than [1,500 KaiOS apps](https://kaios.app/), limited by DevEx.

**By the numbers** As of January 2024, the KaiStore has 1,440 KaiOS 2.5 apps but only 520 KaiOS 3.0 apps. 3 years after launching, notable 3.0 omissions include both Facebook and WhatsApp.

## KaiOS 3.0 Developer Mode

In 2023, hackers enabled [sideloading on the Nokia 2780 Flip](https://wiki.bananahackers.net/en/devices/nokia-weeknd) running KaiOS 3.1, the first time a KaiOS 3.x device was hacked. Input sanitization vulnerabilities in the Engmode API allowed attackers to dump system partitions, which can be subsequently modified (i.e. to include third-party apps) and flashed via custom recovery.

However, as of the time of writing, there are still **no KaiOS 3.x devices with DevTools enabled**. This inability for engineers to test and debug their applications on actual devices limits interest from amateur and professional developers alike.

**Recommendation**: offer developers access to DevTools, either via custom engineering models or a feature to remotely enable DevTools access.

## KaiOS 2.5 and 3.0 API Compatibility Library

KaiOS 3.0 changed [application structure](https://developer.kaiostech.com/docs/sfp-3.0/introduction/overview/), available [permissions]({{< ref "kaios-permissions#removed-in-kaios-30" >}} "permissions"), and migrated many APIs to [api-daemon](https://github.com/kaiostech/api-daemon) forcing KaiOS 2.5 developers into time-consuming refactors. Developer [Garrett Downs](https://github.com/garredow) started on a [library](https://github.com/garredow/kaios-lib) to address these inconsistencies, but it remains only partially completed.

**Recommendation**: streamline development for both major versions by providing a standard library like the [Android Support Library](https://developer.android.com/topic/libraries/support-library/) for interacting with platform-specific APIs for [Volume]({{< ref "audio-volume-management" >}} "Volume"), [Web Activities]({{< ref "web-activities" >}} "Web Activities"), and more.

## TypeScript Type Declarations for KaiOS APIs

This blog was started to fill gaps in KaiOS developer documentation. Another way to make KaiOS development more accessible is offering a standard way to interact with proprietary APIs.Many software development kits (SDKs) like the [AWS SDK](https://aws.amazon.com/blogs/developer/first-class-typescript-support-in-modular-aws-sdk-for-javascript/) provide static [type declarations](https://www.typescriptlang.org/docs/handbook/2/type-declarations.html) for their APIs.

This is a very condensed way of giving a lot of the information about APIs including function names, parameters, return types, etc. Plus modern integrated development environments (IDEs) natively support autocomplete using these definitions. What's more, KaiOS is already halfway there! Nearly all platform APIs are backed by [Web Interface Definition Language (WebIDL)](https://developer.mozilla.org/en-US/docs/Glossary/WebIDL) files, which contain all of the same information.

**Recommendation**: provide an NPM package containing TypeScript Type Declarations for KaiOS-specific APIs, i.e. `@types/kaios-apis`.

![ChatGPT Converts WebIDL to Typescript](/img/chatgpt-convert-webidl.png "ChatGPT Converts WebIDL to Typescript")

<u>Pro Tip</u>: [ChatGPT](https://chat.openai.com/) can actually convert WebIDL files to Typescript Type Declarations!

## Conclusion

KaiOS development is effectively an extensions of developing progressive web apps (PWAs). However, challenges in the developer experience affecting testing, debugging, documentation, and platform inconsistency have resulted in fewer KaiOS 3.0 applications. Navigating these obstacles can be difficult and time-consuming. If you need an experienced partner to guide your KaiOS development, contact the author from the [About]({{< ref "about" >}} "About") page.
