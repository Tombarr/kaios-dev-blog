+++
title = "Practical KaiOS Optimization Tips"
description = "Practical tips for meaningfully optimizing KaiOS apps"
date = 2024-01-20T00:00:00+08:00
lastmod = 2024-01-20T00:00:00+08:00
toc = true
draft = false
header_img = "img/home-alt.png"
tags = ["KaiOS", "Optimizing", "Apps", "Memory", "Tips"]
categories = []
series = ["Advanced Development"]
+++

# Practical KaiOS Optimization Tips

**Lessons**. Here are a few tips I learned first hand developing [PodLP](https://podlp.com/) for [KaiOS](https://www.kaiostech.com/) smart feature phones.

## Memoization

**What's [Memoization](https://www.freecodecamp.org/news/memoization-in-javascript-and-react/)?** It's basically a form of caching, eliminating repetitive calculation and repeated function calls by storing results in memory.

**How to memoize?** There are [many JavaScript libraries](https://stackoverflow.com/questions/61402804/what-memoization-libraries-are-available-for-javascript) like [moize](https://github.com/planttheidea/moize) that can wrap functions for automatic memoization, or you can do it yourself.

![PodLP Using Podcast Accent Color](/img/podlp-background-header.png "PodLP Using Podcast Accent Color")

<u>Image Processing</u>: in PodLP, the header background color is set to match the accent color of the podcast thumbnail. Computing this value is expensive, and it doesn't change often (only when the image itself changes), so it's faster to cache the value rather than recompute it.

```js
const colorMap = new Map();

function getAccentColor(imageBlob) {
    const imageHash = hash(imageBlob);

    // First time: compute the accent color
    if (!colorMap.has(imageHash)) {
        colorMap.set(imageHash, computeAccentColor(imageBlob));
    }

    return colorMap.get(imageHash);
}
```

In the example above, it would be better to persist the computed color in [data storage]({{< ref "./data-storage" >}}) like `localStorage` to avoid recomputing the next time the app is opened. Better still: compute values like this server-side (which is how PodLP actually does it).

**Watch out** for asynchronous functions, or functions that return a `Promise`. These need to be handled  differently, always wrapping the immediately-returned cached value with `Promise.resolve`, and keeping track of in-flight Promises.

<u>Remote Requests</u>: you might memoize the boolean return value for whether a given host is unresolvable because of the [Let's Encrypt (LE) SSL Certificate issue]({{< ref "./ssl-certificate#lets-encrypt-ssl-certificate-issue" >}}). There are easy ways to [memoize Promises](https://hackernoon.com/cache-api-calls-in-javascript-by-memoizing-promises#h-caching-api-calls-by-memoizing-promises) too.

**Keep it small**. KaiOS devices have 256-512mb of RAM, and much of that is reserved for the OS itself. Because memoized return values are stored in memory, it works especially well where the serialized input and output of computation is small (i.e. a color or boolean).

## Instant Click

**Background**. Our prior guide on KaiOS optimization covered [prefetch]({{< ref "./optimization-tips#prefetch" >}}) hints. We can extend this concept further using the [preconnect](https://developer.mozilla.org/en-US/docs/Web/HTML/Attributes/rel/preconnect) keyword, similar to [InstantClick](https://instantclick.io/).

In this overly-simplified example, the user presses the `Enter` key to select the next page in a single-page app (SPA). Subsequently, this page will make a `fetch` or `XMLHttpRequest` call to load a remote resource.

```js
function preconnect(url) {
    let link = document.createElement('link');
    link.rel = 'preconnect';
    link.href = url;
    document.head.appendChild(link);
}

window.onkeydown = (event) => {
    if (event.key === 'Enter') {
        preconnect('https://api-v1.myapp.com/'); // Instant Click

        // Loads new elements and triggered Fetch to
        // https://api-v1.myapp.com/api/v1/fetch.json
        loadNextPage();
    }
};
```

**Impact**. Preconnecting provides a hint to the browser that can noticeably reduce the time to establish a connection to an origin. This can effectively parallelize connection time with render time, decreasing effective load time by 100s of milliseconds.

**Loading Indicators**. Although it's best practice to minimize animations on KaiOS, well-optimized animations can be useful, especially as a distraction while something is loading. [Skeleton loading](https://www.letsbuildui.dev/articles/how-to-build-a-skeleton-loading-placeholder/) placeholders are a good example.

⚠️ <u>Warning</u>: only preconnect to a few critical-path origins, as preconnecting to too many can be counterproductive. Use [`dns-prefetch`](https://developer.mozilla.org/en-US/docs/Web/HTML/Attributes/rel/dns-prefetch) for less critical resources.

## Image Cache & Resize

**TLDR**. Use a free and open-source like **[images.weserv.nl](https://images.weserv.nl/)** to generate only-the-fly thumbnails for KaiOS.

**Why images.weserv.nl?**

* It's dual-stack (IPv4/IPv6), so it worked on IPv6-only networks like India's Reliance Jio
* It's hosted on Cloudflare, so you won't run into the [expired LE root certificate]({{< ref "./ssl-certificate#lets-encrypt-ssl-certificate-issue" >}}) issue
* It has parameters to control image format (`output=png`), so you can render previously-unsupported formats like AVIF and WebP (KaiOS 2.5 supports neither)
* It has parameters to control size (`w=150&h=150`), so images can be scaled down to fit KaiOS (and use less memory)
* It's free and open source

Alternatively, [Cloudflare Image Optimization](https://developers.cloudflare.com/images/) is another off-the-shelf solution, or you can always downsize and compress images ahead of time.

[**Podcast artwork**](https://podcasters.spotify.com/resources/learn/create/dos-donts-coverart) tends to be between 1400x1400 to 3000x3000 pixels in size. While this makes sense for high-resolution smartphones, it's a waste downloading all those pixels just to render on a 240x320 screen. PodLP generates thumbnails server-side, but for those that fail for a variety of reasons, the fallback is to proxy via <u>images.weserv.nl</u>.

## (Maybe) Don't Use ServiceWorkers

**Background**. [ServiceWorkers](https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API/Using_Service_Workers) are background Workers that proxy all HTTP requests via the `fetch` event, cache Request/ Response pairs, and they're required to handle [push notifications]({{< ref "./push-notifications" >}}). ServiceWorkers can enable offline experiences and reduce page load times, in conjunction with the [Caches API](https://developer.mozilla.org/en-US/docs/Web/API/Cache).

However, there is [overhead](https://chromestatus.com/feature/5136946693668864) to starting a service worker and passing all requests through even a no-op listener. In my experience, doing so can add a few hundred milliseconds round-trip to each request.

![Push Notifications on KaiOS](/img/podlp-notifications.png "Push Notifications on KaiOS")

**When to use ServiceWorkers**

* For Web [Push Notifications]({{< ref "./push-notifications" >}}) (it's required)
* Queueing requests until connection reestablishes
* Background processing computationally-expensive tasks (i.e. encryption)
* Handling [System Messages](https://developer.kaiostech.com/docs/sfp-3.0/api/next-new-apis/others/SystemMessage/other-SystemMessage/) on KaiOS 3.0

#### KaiOS Version Differences

* **Permission**: On KaiOS 2.5, the **[`serviceworker` permission]({{< ref "./kaios-permissions#push-notifications--serviceworker" >}} "serviceworker permission") is required** to expose the [`navigator.serviceWorker`](https://developer.mozilla.org/en-US/docs/Web/API/Navigator/serviceWorker) and install your worker. This permission was removed on KaiOS 3.0
* On KaiOS 2.5, you can install a ServiceWorker without a `fetch` handler. However, on KaiOS 3.0 you _must_ set a `fetch` handler in order for your worker to be installable

## Conclusion

KaiOS devices come with many technical constraints, from limited memory and persisted storage, slower network speeds (no 5G) and small screen sizes. Building performant and usable applications requires numerous changes and performance profiling on a range of commercial devices. If you need an experienced partner to build a top-notch KaiOS experience for your business, contact the author from the [About]({{< ref "about" >}} "About") page.
