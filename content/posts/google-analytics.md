+++
title = "Google Analytics and Alternatives for KaiOS Apps"
description = "Setup Google Analytics (GAv4) or alternative web traffic analytics for KaiOS apps"
date = 2024-01-05T00:00:00+08:00
lastmod = 2024-01-05T00:00:00+08:00
toc = true
draft = false
header_img = "img/home-alt.png"
tags = ["KaiOS", "Google", "Analytics", "GA4"]
categories = []
series = ["Getting Started"]
+++

Setup Google Analytics (GAv4) or alternative web traffic analytics for KaiOS apps.

## Google Analytics

![Google Analytics Demographics - KaiOS App](/img/google-analytics-demographic-countries-kaios.png "Google Analytics Demographics - KaiOS App")

[Google Analytics](https://analytics.withgoogle.com/) is by far the most popular web and mobile traffic and events analytics platform. It's free, easy to use, and customizable to accurately measure user behavior, demographics, technical performance and errors, and more. However, **Google Analytics does not work out of the box with KaiOS**.

<u>Note</u>: on July 1st, 2023, [Universal Analytics stopped processing new data](https://support.google.com/analytics/answer/10089681?hl=en). All users must migrate to Google Analytics 4 (GA4).

Google Analytics does not work on KaiOS for a few reasons, namely:

1. Both inline and external (i.e. from `www.googletagmanager.com`) scripts are blocked in privileged (packaged) apps, per the default CSP
2. KaiOS 2.5 apps use the origin protocol of `app:`, which Google doesn't recognize
3. `gtag.js` uses ECMAScript language features and APIs that are unsupported on KaiOS

Moreover, the GA4 library has a [script size](https://blog.analytics-toolkit.com/2023/a-lightweight-google-analytics-4-integration/) of ~371kb and a compressed transfer size of ~134kb, making it a fairly large dependency for KaiOS.

So in order to use Google Analytics on KaiOS, you'll need to **use a third-party library like [minimal-analytics (GA4)](https://github.com/Tombarr/minimal-analytics/tree/main/packages/ga4#readme)** (my fork includes necessary features for KaiOS). This library is only a few kb, while still supporting page views, custom events, clicks, downloads, and more. As noted above, you'll need to replace the `dl` (Document Location) parameter value of your app's origin protocol with `https:`. For KaiOS 3.0, app origins follow the pattern `https://*.localhost/`, so the document location will need to match the website you configured.

```js
track(MEASUREMENT_ID, {
	type: 'click',
	event: {
		// KaiOS 2.5
		'dl': location.origin.toString().replace('app:', 'https:') + location.pathname + location.search,
		// KaiOS 3.0
		'dl': location.origin.toString().replace('myapp.localhost:', 'myapp.com') + location.pathname + location.search,
	},
});
```

That's it! Once you're set up, you can validate test events under Admin > Data Display > DebugView and watch as events come in live. Now your app is integrate with Google Analytics!

<u>Tip</u>: wait ~24 hours to confirm that events show up in both in realtime and report snapshots to ensure proper setup.

## Alternatives

Although Google Analytics is the most popular analytics platform, there are no shortage of alternatives. Here are just a few:

### KaiAds Publisher Portal

![KaiAds Publisher Portal - App Reports](/img/kaiads-installs.png "KaiAds Publisher Portal - App Reports")

The [KaiAds Publisher Portal](https://publishers.kaiads.com) provides analytics including Users, New Users, Day 1 Retention, Day 7 Retention, and Day 30 Retention for all apps integrated with KaiAds (which is required to publish on the KaiStore). However, I suspect these metrics are inaccurate as they never correlate well with server logs or Google Analytics. Although not a major concern, they also won't count users who have an ad blocker set up (i.e. host file or DNS block).

<u>Note</u>: KaiAds are not available to apps published on the JioStore.

### Cloudflare Web Analytics

Similar to Google Analytics, [Cloudflare Web Analytics](https://www.cloudflare.com/web-analytics/) JavaScript beacon does not work out of the box on KaiOS. However, it's server-side metrics for websites hosted or proxied using the Cloudflare CDN works well. Cloudflare provides fewer metrics–page views, country, host, path, referer, and status codes–but it's free, lightweight, and is more privacy-centric (e.g. does not fingerprint users or use any client-side state, such as cookies or localStorage).

<u>Note</u>: like GA4, Cloudflare's [`beacon.min.js`](https://static.cloudflareinsights.com/beacon.min.js) does not work on KaiOS. However, it may be possible if modified, or by making direct calls to `https://cloudflareinsights.com/cdn-cgi/rum`.

### Custom Analytics

Of course, if you'd prefer to control your data there are many self-hosted solutions. One easy and affordable solution is to use [Cloudfront Functions](https://aws.amazon.com/blogs/aws/introducing-cloudfront-functions-run-your-code-at-the-edge-with-low-latency-at-any-scale/) on AWS. With 2 million monthly invocations in the Free Tier and $0.10 per 1 million invocations after, and $0.01 for every 1 million CloudWatch log line, it's an affordable way to gather custom data. Payloads can be logged to CloudWatch and batch processed after the fact, or visualized directly in a CloudWatch Dashboard.

When sending data from the client, use [`navigator.sendBeacon`](https://developer.mozilla.org/en-US/docs/Web/API/Navigator/sendBeacon) which KaiOS 2.5 and 3.0 support. Otherwise, you can use a synchronous [`XMLHttpRequest`](https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest) or `fetch` with the [`keepalive`](https://developer.mozilla.org/en-US/docs/Web/API/Fetch#keepalive) property as a fallback, or from a Worker or ServiceWorker context.

Other self-hosted options include [umami.js](https://umami.is/), [Matomo](https://github.com/matomo-org/matomo), [Open Web Analytics](https://github.com/Open-Web-Analytics/), [Countly](https://github.com/Countly), [Plausible](https://github.com/plausible/analytics), and more.

## Conclusion

Most web analytics platforms, including Google Analytics, don't work out of the box on KaiOS. However, it's not difficult to configure them to work. Tracking engagement, retention, and user behavior is an important way to understand what's working, and what's not, in your app. If you need help properly configuring analytics for your KaiOS app, contact the author from the [About]({{< ref "about" >}} "About") page.
