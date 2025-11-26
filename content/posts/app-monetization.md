+++
title = "KaiOS App Monetization"
description = "Monetizing apps with on KaiOS with KaiAds and JioAds"
date = 2023-02-11T00:00:00+08:00
lastmod = 2023-02-16T00:00:00+08:00
toc = true
draft = false
header_img = "img/home-alt.png"
tags = ["KaiOS", "KaiAds", "JioAds", "Monetization"]
categories = []
series = ["Getting Started"]
+++

Monetizing apps with on KaiOS with KaiAds and JioAds.

## KaiAds

![KaiAd Examples](/img/kaiads-examples.png "KaiAd Examples")

By far, [KaiAds](https://kaiads.com/) are the easiest way to monetize KaiOS apps. KaiOS provides a [publisher SDK](https://kaiads.com/publishers/sdk.html) that works for both apps and websites. There are two types of KaiAds: **responsive** banners and full-page **interstitials**.

KaiAds can be preloaded in the background with a refresh rate of ~30 seconds, then displayed when the opportunity is right like during page transitions or when the user finishes a level in a game. To get started, you can register for an account at https://publishers.kaiads.com. Once complete, you'll get a Publisher ID to use with the SDK.

![Video KaiAd](/img/video-kaiad.png "Video KaiAd")

As of February 2023, KaiOS recently launched video KiaAds as well. Users are presented with a play button to watch the video and a "Go" button to open a URL in their browser. Videos are served via KaiOS' [partnership with Outbrain](https://mumbrella.com.au/outbrain-partners-with-low-spec-mobile-operating-system-kaios-675545).

<u>Note</u>: according to the [KaiStore Submission Guidelines](https://developer.kaiostech.com/docs/distribution/submission-guideline), [KaiAd integration is required]({{< ref "./history-of-kaios.md#let-there-be-kaiads" >}} "KaiAd integration is required") for apps published on the KaiStore.

> Currently, we are only accepting apps that are monetized using KaiAds SDK.

### KaiAds Implementation

KaiOS suggests adding the following dependency to your `manifest.webapp` or `manifest.webmanifest` file for privileged or certified apps. However, it's worth noting that **declaring `dependencies` in `manifest.webapp` prevents installation on devices lacking the declared dependency** with a version number _equal to or greater than_ the declared version. In this example, any device with an `ads-sdk` version _less than_ 1.5.8 would not be able to install this app.

```json
{
	"dependencies": {
		"ads-sdk": "1.5.8"
	}
}
```

[`ads-sdk.v5.min.js`](https://static.kaiads.com/ads-sdk/ads-sdk.v5.min.js) provides a single, globally-scoped function: `getKaiAd`.

```js
getKaiAd({
	publisher: 'yourPublisherID',
	app: 'yourAppName',
	slot: 'yourSlotName',
    test: 0, // test = 1 during testing
    h: 264,
	w: 240,
    container: document.getElementById('ad-container'),
	onerror: (err) => console.error('Error:', err),
	onready: (ad) => {
        // Ad Events
        ad.on('display', () => console.log('Ad displayed'));
        ad.on('close', () => console.log('Ad closed'));
        ad.on('click', () => console.log('Ad clicked'));

        // Ad is ready to be displayed
		// calling 'display' will display the ad
		ad.call('display');
	}
});
```

<br/>

* `publisher` is the Publisher ID provided during KaiAds account registration
* `app` is a unique identifier for your app. Shows in the KiaAds Publisher Portal
* `slot` is an optional unique identifier for your ad placement. Shows in the KiaAds Publisher Portal
* `test` is an integer set to 1 during testing and 0 for production
* `h` and `w` and the maximum height and width, respectively, for response ads
* `container` is the element to insert the KaiAd in to
* `onerror` and `onready` are function callbacks

Once `onready` is called, the `ad` object can be stored and `ad.call('display')` can be called when the ad should be shown on screen. KaiAds have three [Ad Events](https://kaiads.com/publishers/sdk.html#events): display, close, and click. There are also a number of errors that can occur, which KaiAds provides a list of [error codes](https://kaiads.com/publishers/sdk.html#error).

KaiAds requires that you serve and keep up-to-date an app-ads.txt file at the root domain of your app's website (e.g. yourawesomewebsite.com/app-ads.txt). app-ads.txt files can be generated at https://adstxt.kaiads.com/.

## KaiAds Publisher Portal

The [KaiAds Publisher Portal](https://publishers.kaiads.com) is where developers can see impressions, clicks, app analytics, and accumulated revenue. Under "Ad Reports," for each app and each day you can see Impressions, Clicks, Click Through Rate (CTR), Estimated Revenue, and estimated Cost per Mile (eCPM).

![KaiAds Publisher Portal - Ad Reports](/img/kaiads-reports.png "KaiAds Publisher Portal - Ad Reports")

Depending on where your app is most successful, eCPMs can vary widely. In the past month, I've seen eCPMs between $0.08 - $4.50 with an average of $0.96, rougghly 1¢ per click. With a reasonable CTR of 10%, every thousand impressions yield about $1.

KaiAds is also how KaiOS provides developers with total app installations and app installations by country under "App Reports." Here's an example from of my app, Bing Wallpaper, show 6,122 organic installs in the past month.

![KaiAds Publisher Portal - App Reports](/img/kaiads-installs.png "KaiAds Publisher Portal - App Reports")

The Publisher Portal also provides Analytics enumerating Users, New Users, Day 1 Retention, Day 7 Retention, and Day 30 Retention, although there's reason to suspect these metrics are inaccurate. Finally, there's a tab for Payment as well showing Accumulated Revenue Share, Outstanding Payment, and Payment History. This lets publishers track their accumulated revenue across all of their applications in a single place.

### Revenue & Payments

It's worth highlighting the following terms from the [KaiOS Application Submission and Distribution Agreement](https://www.kaiostech.com/sub-agreement/).

> As regards the Net Revenue generated from Advertising: 30% of Net Revenue to Developer. 70% of Net Revenue to KAI.

> KAI may hold any payment of Revenue Share until the cumulative amount owed to the Developer totals at least US $500.

This means developers receive payment after accumulating at least $500 USD, and that they receive 30% of Net Revenue from advertising.

## JioAds

![JioAds Placeholder](/img/no_internet.jpg "JioAds Placeholder")

For apps published on the JioStore, KaiAds are not available. Instead, Jio Platforms Limited offers [JioAds](https://jioads.jio.com/). JioAds uses a different SDK based on [VMAX](https://www.vmax.com/developers.html). Unlike KaiAds, JioAds supports rich media formats including video ads.

<u>Note</u>: as of the time of writing, the JioAds Dashboard at https://dashboard-jioadvt.jio.com appears to be unavailable.

## Outside Monetization

Unfortunately, KaiOS provides a lower net revenue share and lower CPMs than more popular mobile platforms like Android and iOS. Additionally, KaiAds user demographics skew towards first-time internet users in emerging markets. In order to build a sustainable business, developers are better off managing outside monetization through donations or sponsorships.

For instance, [PodLP](https://podlp.com) generates sustainable revenue by connecting podcasters with podcast listeners through sponsored listings. Doing so providers podcasters with new listeners and subscribers, and offers PodLP users engaging, regularly-updated content. Learn more about PodLP and the author on the [About]({{< ref "about" >}} "About") page.
