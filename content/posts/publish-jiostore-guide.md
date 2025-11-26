+++
title = "The Definitive Guide to Publishing KaiOS Apps on the JioStore"
description = "Everything you need to know to publish KaiOS apps on the JioStore"
date = 2024-11-10T00:00:00+08:00
lastmod = 2024-11-10T00:00:00+08:00
toc = true
draft = false
header_img = "img/home-alt.png"
tags = ["JioStore", "JioPhone", "Reliance Jio", "KaiOS"]
categories = []
series = ["Getting Started"]
+++

# Publishing Apps on the JioStore

With the majority of KaiOS users located in India, publishing on the JioStore is a must to maximizing your app's reach.

### At a Glance

* KaiOS has [two app stores]({{< ref "./kaios-ecosystem#a-tale-of-two-stores" >}}): the KaiStore (Global) and JioStore (India)
* The JioStore is only available on the Reliance [JioPhone]({{< ref "./whats-next-jiophone" >}})
* ~90% of all KaiOS users are located in India
* Less than 10% of KaiOS apps are publishing on the JioStore
* Publishing on the JioStore is _much_ more difficult than the KaiStore
* Jio refers to its version of KaiOS as "JioOSLite"
* Games are not published on the JioStore but on a separate platform, JioGames
* Jio prefers apps integrated with the [JioAds](https://dashboard-jioadvt.jio.com) SDK (although payment is not supported for developers outside of India)

# The JioStore Basics

The JioStore has a [web portal](https://developer.jio.com/publisher/apps/listing) to publish apps. Like the KaiStore, the JioStore accepts two types of apps: packaged and hosted. This is a significant improvement over the previous process of submitting builds as ZIP files via WhatsApp.

## Device Categories

With more than two model models of the [JioPhone]({{< ref "./whats-next-jiophone" >}}), not every app is available on every model. Jio breaks down models into several categories:

* SPRD: older devices powered by Spreadtrum (now Unisoc) chipsets
* QCOM: modern Qualcomm-powered JioPhone models
* Landscape: the two models of the QWERTY JioPhone 2 (F20A and F300B) with its 320x240 screen in landscape orientation

Apps seeking the widest distribution must pass all testing phases across all device models. SPRD devices are particularly challenging because they have a lower acceptance threshold for memory and battery testing.

## Basic Requirements

Compared to the KaiStore, the JioStore has extensive requirements to ensure consistency and quality among published apps. Below are most of the requirements gathered from years of publishing [PodLP](https://podlp.com) on the JioStore.

### Usability

* Must display modal for exit confirmation
* App version can be seen inside app without internet connectivity
* Must be available in English
* No hang or crash observed during validation
* Taking less than 1 second per click

### Marketing

* Must include two icons: 56x56, 84x84, and 112x112 (JioPhone Value and JioPhone Prima)
* Must include a 230x130 background image (JPG only)

### Permissions

* No permission prompts at runtime
* No unnecessary permissions
* No push notifications
* No service workers
* No offline storage
* No background media playback

### Legal

> The T&C and Privacy policy must be in compliance with the Information Technology (Intermediary Guidelines & Digital Media Ethics Code) Rules, 2021. A separate Grievance Redressal Mechanism should be established for INDIA as per the Intermediary Guidelines Rules, 2021.1

* Must include a Privacy Policy and Terms of Service
* Must list a Resident Grievance Officer (in India)

### Technical

* App must be less than 1mb (5mb for games)
* App works in IPv6-only mode
* App must not store data externally (i.e. using [DeviceStorage]({{< ref "./data-storage#device-storage" >}}))
* Version numbers must include four digits in the format: #.#.#.#
* App icons must have the file name: img_Appname_##.png where ## is 56, 84, or 112

### Manifest

The following are required [manifest properties]({{< ref "./manifest-properties" >}}) for the JioStore:

* name
* description
* subtitle
* theme (CSS color in hex format)
* display (name of the app)
* version
* launch_path
* origin
* type (privileged, web (for the hosted app))
* icons (3 icons of 56×56, 84x84, 112x112)
* developer (name and url fields)
* default_locale (locales is to be defined at least for en-US)
* locales

## Quality Assurance Phases

### Sanity Test

As its name implies, sanity testing is when apps are evaluated for functionality and suitability. Sanity testing is quite expensive, often spanning ~33 test cases on 5+ device models. Sanity testing is also called "Bond testing" because it is performed by the BOND team within Reliance Jio. Some test cases to consider include:

* With the charger in/ out
* While receiving a call
* While interrupted by an alarm
* With SIM present/ removed
* With IPv6-only APN settings
* With active Bluetooth transfer
* With the screen on/ off

#### Scoring

Issues are scored as follows:

* **Blocker**: issues that _must be resolved_ before further testing can proceed
* **Critical**: issues that _must be resolved_ before the app can be published
* **Major**: significant issues that may affect publishing
* **Medium**: issues that should be resolved in subsequent updates
* **Minor**: small issues to be aware of
* **Observations/Suggestions**: small suggestions to improve user experience

### Memory Test

Apps are scored for 1 hour and 30 minutes of use across at least two device models. Each test samples PSS, CPU, NICE, USS, and Memory values taken at intervals between 2-5 seconds. Average, minimum, and maximum values are calculated in megabytes (mb). In order to pass, apps must stay below an average and maximum threshold that varies based on app category: normal, media, and games. For reference, **average PSS must remain under 40 for Media applications**.

### Battery Test

Reliance Jio has a test harness to measure battery draw from individual applications. This test is designed to prevent apps from significantly draining the user's battery. Testing is done for 30 minutes and your app must **draw
less than ~20mA** during “normal” use in the foreground. The best way to prepare for this test is to ensure your app doesn't place regular demands on the CPU or use a CPU [wake lock]({{< ref "./common-apis-and-interfaces#wake-lock" >}}).

### InfoSec Test

Jio performs an information security test on each app, primarily to ensure:

* App stores all user data on servers located within India
* App allows users ability to delete their account(s) and/ or data
* Apps cannot use private or hidden APIs
* App does not collect user data without consent

## Questions?

P.S. if you don't have a JioPhone, you can find which apps are published on the JioStore at [KaiOS.app](https://kaios.app/).

Publishing on the JioStore is far more difficult than publishing on KaiOS.  Builds can take months to QA, and it is easy to miss one of the many requirements. If you are looking for an experienced partner to help your app get publishing on the JioStore, contact the author from the [About]({{< ref "about" >}} "About") page.
