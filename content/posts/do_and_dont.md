+++
title = "Dos and Don'ts for KaiOS"
description = "Recommendations for developing KaiOS apps"
date = 2023-02-18T00:00:00+08:00
toc = true
draft = false
header_img = "img/home-alt.png"
tags = ["KaiOS", "Developer", "Tips"]
categories = []
series = ["Getting Started"]
+++

# Dos and dont's of developing KaiOS apps

## ☑️ Dos

* Develop small applications
	* Minify all resources (JS, CSS, HTML)
	* Right-size and compress multimedia assets
* Have a caching strategy
* Test on an actual device
* Support offline usage (when possible)
* Use global CDNs for edge caching
* Only access secure resources (i.e. HTTPS)

### Develop small applications

The maximum package size that the KaiStore accepts is 20MB, with an average of 2-4MB. Compare that to iOS, where [iOS apps average 110 - 427MB](https://www.statista.com/statistics/1295962/size-top-ios-apps/). Smaller applications use less memory and this will perform better on KaiOS devices which only have 256MB or 512MB of RAM.

The easiest way to reduce package size is to [minify all resources](https://kinsta.com/blog/minify-javascript/) (JavaScript, CSS, and HTML). Minification can save 40% or more on the total build size and can be automatically integrated as part of a build & transpilation process.

The next way to reduce package size is to right-size and compress all images, audio, and videos. All KaiOS devices have 240x320 screens, so there is no need for assets larger than this size. Downscaling larger images will result in unnecessary memory usage and hurt performance. Free apps like [ImageOptim](https://imageoptim.com/mac) for Mac can also loselessly compress common image formats including JPG and PNG.

### Have a caching strategy

There are many ways to cache remote assets on KaiOS, including [HTTP cache headers](https://www.keycdn.com/blog/http-cache-headers), [ApplicationCache](https://webplatform.github.io/docs/apis/appcache/ApplicationCache/), and ServiceWorkers using the [`Cache` interface](https://developer.mozilla.org/en-US/docs/Web/API/Cache). Additionally, smaller resources can be cached in the application context using `localStorage` or `IndexedDB`.

<u>Tip</u>: [`sessionStorage`](https://developer.mozilla.org/en-US/docs/Web/API/Window/sessionStorage) can be a great solution on KaiOS because it's disk-backed, not memory-backed, and automatically clears when the application is terminated.

### Test on an actual device

KaiOS has many quirks, and not all devices or OS sub-versions behave the same. Where possible, it's important to test on a range of low-end (i.e. 256MB RAM) and high-end (i.e. 512MB RAM) hardware to see how your app performs in a real world context. It can also be helpful to test under poor network conditions and with background audio playback from another app.

### Support offline usage (when possible)

Unless your app requires a constant connection, it's important to test and support offline usage. This ensures your app remains useable during intermittent connections.

<u>UX Tip</u>: indicate to the user when they are online or offline, and use Web Activities to more easily launch the Connections page within the Settings app.

### Use global CDNs for edge caching

If you are hosting remote resources, it can greatly reduce round trip request time to use a globally-distributed content delivery network (CDN) like Amazon CloudFront or Cloudflare. Doing so allows origin resources to be cached at points of presence (POPs) and edge locations so subsequent requests are resolved more quickly.

### Only access secure resources (i.e. HTTPS)

Progressive Web Apps (PWAs) and most KaiOS app formats only allow connections to secure (i.e. HTTPS) resources using `XMLHttpRequest` or `fetch`.

## ❌ Dont's

* Overuse offline storage
* Render complex animations
* Rely on emulated cursor navigation
* Rely on APIs backed by Let's Encrypt SSL Certificates
* Avoid large, complex frameworks
* Include unnecessary dependencies

### Don't overuse offline storage

The default storage quota for [KaiOS is 5MB](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/storage/DOMStorageManager.cpp#L27). It's also never overridden on stock devices via the `"dom.storage.default_quota"` preference. This means if the device has sufficient storage, you can store **up to 5MB** in `localStorage` before receiving `QuotaExceededError`.

It's also possible that the OS might purge storage to reclaim space. Worse yet, there is no enforced quota for `indexedDB`. If your app fills up all available storage using IndexedDB, the device might start misbehaving and throwing errors.

<u>Tip</u>: It's best to store the minimum required information in `localStorage` or `indexedDB`, and rely on self-purging storage interfaces like `sessionStorage` and `Caches` for non-critical resources.

### Render complex animations

![KaiOS Memory Low Warning](/img/memory-low.png "KaiOS Memory Low Warning")

KaiOS has partial support for WebGL as well as CSS animations, transitions, and transforms. However, these APIs use significant memory and CPU. It's best to avoid unnecessary animations. Otherwise, using `transform` instead of modifying position properties, as well as `requestAnimationFrame` instead of `setInterval`, can result in smoother, more efficient animations. See [Performance Fundamentals](https://developer.mozilla.org/en-US/docs/Web/Performance/Fundamentals) for general guidelines on implementing, profiling, and optimizing animations and transitions.

<u>Note</u>: KaiOS may provide user warning when memory is low, or it may terminate your app without notice.

### Rely on emulated cursor navigation

![KaiOS Emulated Cursor](/img/kaios-cursor.png "KaiOS Emulated Cursor")

KaiOS has a `"cursor"` property in `manifest.webapp` (or `manifest.webmanifest` on KaiOS 3.0), that lets developers enable or disable an [emulator cursor](https://developer.kaiostech.com/docs/getting-started/main-concepts/emulated-cursor/). However, navigation is slow and cumbersome using the emulatored cursor. Instead, developers can disable the cursor and rely on KeyEvents for d-pad navigation (`ArrowUp`, `ArrowDown`, `ArrowLeft`, `ArrowRight`) to control app navigation.

```json
{
  "name": "My App",
  "description": "Awesome App",
  "cursor": false
}
```

### Rely on APIs backed by Let's Encrypt SSL Certificates

![Untrusted Connection Warning on KaiOS](/img/ssl-error.png "KaiOS screenshot of anchor.fm with expired LE root certificate")

In September 2021, the IdenTrust DST Root CA X3 root certificate used by Let's Encrypt expired. Since KaiOS devices do not receive regular over-the-air (OTA) updates, this means that as of the time of writing, most **phones running KaiOS 2.5 will flag Let's Encrypt SSL certificates as insecure**. To avoid this, it's best to use another Certificate Authority like Amazon Certificate Manager (ACM), Cloudflare, or Google Trust Services.

### Avoid large, complex frameworks

Popular web frameworks like React, Angular, and Ember can range from a [base size of 133KB - 566KB](https://gist.github.com/Restuta/cda69e50a853aa64912d). In order to keep application sizes small and performance smooth, it's best to use lighter-weight frameworks like Preact or [SvelteJS](https://svelte.dev/), which have much smaller base bundle sizes.

### Include unnecessary dependencies

Another way to reduce bundle size is to avoid unnecessary dependencies. Popular libraries like [Moment.js](https://blog.bitsrc.io/date-fns-vs-momentjs-9833f7463751?gi=8ec08a2b38bf) have large bundle sizes of more than 200KB. An easy way to keep package size small is to remove replace dependencies with lighter-weight versions or remove them altogether.

<u>Tip</u>: Check out [Bundlephobia](https://bundlephobia.com/) to learn more about the cost of adding an `npm` package to your application.
