+++
title = "KaiOS App Optimization Tips"
description = "Optimizing apps for KaiOS smart feature phones"
date = 2023-04-02T00:00:00+08:00
toc = true
draft = false
header_img = "img/home-alt.png"
tags = ["KaiOS", "Optimizing", "Apps", "Memory", "Tips"]
categories = []
series = ["Advanced Development"]
+++

# Optimizing apps for KaiOS smart feature phones

Modern app developers have become accustomed to iOS and Android smartphones with specifications comparable to laptop or desktop computers: multi-touch high-resolution displays, gigabytes of memory, hundreds of gigabytes of storage, and cutting-edge 5G and WiFi 6 networking. In contrast, KaiOS smart feature phones have either 256mb or 512mb of RAM, storage between 256mb - 8gb, small ~2" 240x320 screens, and 3G, 4G and Wi-Fi ABG. These hardware restrictions make it crucial to optimize and measure KaiOS web app performance to run well on low-end hardware.

Since KaiOS is based on Firefox OS (and thus the Firefox web browser), most optimizations for standard web apps apply to KaiOS. Additionally, KaiOS provides APIs to enable smooth performance for multimedia, messaging, and web browsing.

## Top Tips

It's difficult to know exactly what to optimize without measuring, and premature optimization is the root of all evil (that and `eval`). That said, here are some common tips when refactoring your web app for KaiOS.

* Avoid "large" frameworks like React or AngularJS
* Scale and compress images for 240x320 screens
* Avoid redundant network requests with caching
* Offload resource-intensive processing server-side or to a background Worker
* Remove unnecessary animations and transitions
* Reduce bundle size through minification and dependency selection

### Framework Selection

This is perhaps the most impactful (and subjective) of the KaiOS optimization tips, but it's important to consider hardware restrictions when selecting a JavaScript framework for KaiOS. When possible, the best advice is often to **avoid a framework altogether**! However, that's often not possible either because you're refactoring an existing code base or developing a complex single-page app (SPA) that needs some degree of routing, caching, authentication, and componentization. These are my recommendations for framework selection on KaiOS:

* Avoid React, prefer Preact if refactoring
* Avoid AngularJS altogether
* Prefer compile-time frameworks like Svelte

### Virtualized Components

![Virtualized List Component, Source: web.dev](/img/virtualized.png "Virtualized List Component, Source: web.dev")

As a general tip, it's best to prefer **virtualized components** when dealing with off-screen content in the form of infinitely scrollable lists, grids, and tabs. Virtualized components only render the on-screen elements (plus a few buffer elements just off-screen) to the Document Object Model (DOM). Doing so significantly reduces DOM size and thus memory usage.

![PodLP Episode Page](/img/nov28-podlp-podcast.png "PodLP Episode Page")

Consider the PodLP Podcast Details page, which renders a list of podcast episodes. During early prototyping, these were rendered on screen using list elements directly. However, some podcasts like [Krista Tippett's On Being](https://onbeing.org/series/podcast/) have over ~500 episodes! This regularly triggered an Out of Memory (OOM) error, causing PodLP to crash.

The code has since been refactored to use a virtualized list view that only renders the on-screen episodes. Then, as the user scrolls down, top elements that go offscreen are "recycled," repositioned to the bottom and with new content. This technique is made easy by the fact that KaiOS devices use D-Pad navigation (up, down, left, right) instead of touch screens, so you don't need to make complex multi-touch calculations factoring in things like angle or momentum.

<u>Note</u>: this concept is similar to the [RecyclerView](https://developer.android.com/develop/ui/views/layout/recyclerview) component on Android.

### WebWorkers

KaiOS devices run on ARM chipsets from OEMs like MediaTek, Qualcomm, and Spreadtrum that range from Mali-400 on the lower end to the QCOM 215 on the upper-end. To put this into perspective, the quad-core QCOM 215 can also be found on budget Android Go devices like the JioPhone Next.

That means computational efficiency is important, and developers will find it's best to offload intense computation like image compression or pattern recognition to a web server. This is incredibly easy with the rise of Edge Function as a Service (FaaS) infrastructure like Lambda@Edge on AWS Cloudfront or Cloudflare Workers. However, when it's not feasible to offload computation server-side, the next best solution is to move computationally intensive operations to a background thread using WebWorkers.

Consider this example of a WebWorker creating using the `new Worker` constructor. It is wrapped in a `Promise` to simplify usage. If the functions within the Worker script were to be used regularly, the worker could be kept alive to process multiple messages. In this example, the Worker is spun up ad-hoc and terminated upon completed processing to free up resources on the main thread.

```js
const workerPromise = new Promise(function toWorkerPromise(resolve, reject) {
    const worker = new Worker('compress.js');

    worker.addEventListener('message', function onWorkerMessage(e) {
        if (e.data.responseType === 'success') {
            resolve(true);
        } else {
            reject(e.data.error);
        }

        // Terminate worker to free up resources
        if ('terminate' in worker) {
            worker.terminate();
        }
    }, false);

    worker.postMessage({
        requestType: 'compress',
        imageBlob: blob,
    });
});
```

This example shows how a Worker script could be used to compress an image Blob in the background. Although Workers do not have access to the DOM and the WorkerScope has limited access to common APIs, Workers can be useful for many asynchronous use cases such as:

* Downloading data using `XMLHttpRequest`, processing, and storing data using `IndexedDB` for use on the main thread
* Computationally-intensive tasks such as compression or pattern recognition algorithms
* In the case of `ServerWorkers`, as middleware for caching & routing network requests
* For processing local data sets in chunks, then combining the output (i.e. MapReduce)
* Client-side processing of timeseries multimedia like audio or video

<u>Note</u>: this concept is similar to [Background Services](https://developer.android.com/training/run-background-service/create-service) on Android.

### Media Fragments `-moz-samplesize`

Given memory restrictions and slower network backwidth, it's best to right-size local and remote assets like images for KaiOS devices. Since all KaiOS devices have 240x320 screens,  images should be sized and compressed in advance to avoid OOM errors.

When right-sizing isn't possible, it's best to use the `#-moz-samplesize` Media Fragment which downsamples large JPEG images while decoding them when necessary. You can specify a maximum image decode size (in megapixels) and KaiOS checks at runtime for the amount of RAM available on the device that may limit the image decode size on low-memory devices. For large JPEGs, this can save megabytes of memory.

```html
<img src="image.jpeg#-moz-samplesize=8" />
```

<u>Note</u>: The value of `-moz-samplesize` can be: 1, 2, 4, or 8. In additional to local and remote images, `-moz-samplesize` can be used for Object and Blob URLs as well! See [Bug #854795](https://bugzilla.mozilla.org/show_bug.cgi?id=854795) for details.

It's worth mentioning that there is another Media Fragment, [`#xywh`](https://developer.mozilla.org/en-US/docs/Web/CSS/image/image#image_fragments), that can be used to crop an image during decoding. However, this doesn't actually save any memory because Gecko still decodes the image at full size before cropping. Although it's another convenient option, it can't be combined with donwsampling and isn't an optimization.

### Caching

Caching is an important part of any modern web app, and KaiOS is not exception. However, in 2023 it's not uncommon for servers to provide API responses sized in the megabytes. Memory leaks and garbage collection nuances aside, this can quickly trigger an OOM error, causing your app to crash.

One strategy for client-side caching is to use the disk-backed key-value `SessionStorage` API. As an example, you can wrap `XMLHttpRequest` or `Fetch` calls with a function to check if a response is available using a Least-Recently Used (LRU) caching strategy. `SessionStorage` has a per-origin [**5MB quota**](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/storage/DOMStorageManager.cpp#L27) (defined in the `dom.storage.default_quota` preference) and is automatically deleted when your app is closed, so there's no need for cleanup. After you hit this limit, a `QuotaExceededError` can be thrown when attempting to write additional data.

Of course `SessionStorage` does not replace `LocalStorage`, `IndexedDB`, or `DeviceStorage` for durable offline data storage. That said, it does provide a useful pattern for ephemeral caching with minimal memory usage.

### Prefetch

An easy way to improve performance is with [link prefetching](https://developer.mozilla.org/en-US/docs/Web/HTTP/Link_prefetching_FAQ). Prefetching can be done using HTML `<link>` tags or the HTTP [Link](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Link) header.

```html
<link rel="prefetch" href="/images/big.jpeg" />
```

For paginated content, you can also use [`rel="next"` and `rel="prev"`](https://developers.google.com/search/blog/2011/09/pagination-with-relnext-and-relprev) to prefetch links leading to sequential content. For example:

```html
<link rel="next" href="https://www.example.com/article?story=abc&page=2" />
```

If the content is cross-origin, [`rel="dns-prefetch"`](https://developer.mozilla.org/en-US/docs/Web/Performance/dns-prefetch) is a useful compromise that hints to the browser to resolve domain names before resources get requested. This can lead to shorter round-trip times for external content.

```html
<link rel="dns-prefetch" href="https://fonts.googleapis.com/" />
```

As mentioned, all of these links can also be set via the HTTP `Link` header. Multiple links can be separated as a comma-separated list.

```
Link: <https://fonts.googleapis.com/>; rel=dns-prefetch
```

As a general rule, the `prefetch` hint is best used for critical connections, and `dns-prefetch` is useful in general to save time on DNS lookup.

### Lazy Loading

Along with component virtualization, lazy loading is important to avoid fetching unnecessary off-screen content like images. Unfortunately, KaiOS does not support the `loading` attribute, but there is a [popular polyfill](https://github.com/mfranzke/loading-attribute-polyfill). Using the polyfill is easy:

```html
<noscript class="loading-lazy">
	<img src="simpleimage.jpg" loading="lazy" alt=".." width="250" height="150" />
</noscript>
```

Doing so ensures that images are only loaded when they're visible on screen. In turn, lazy loading shortens the duration of the [critical rendering path](https://developer.mozilla.org/en-US/docs/Web/Performance/Critical_rendering_path), meaning **lazy loading results in reduced page load times**. This also saves on bandwidth and reduces memory usage.

### `"priority"` Manifest Property

Finally, if after rounds of optimization there are still scenarios where your app might experience memory pressure that could trigger a crash, the final option is to mark your application as high-priority within `manifest.webapp`. Doing so decreases the memory threshold that will trigger an OOM crash. This solution is common for multimedia and messaging apps that need to reliably respond to system messages like a notification trigger, but often these applications display external content like images without complete control over size.

```json
{
    "priority": "high"
}
```

<u>Note</u>: this option is only available for Privileged and Certified packaged apps, not hosted web apps or PWAs.

## Conclusion

Optimizing web applications to run well on KaiOS feature phones can be challenging. It requires profiling to identify resource-intensive code paths, then refactoring control flow and UX to factor in asynchronous processing. If you need an experienced partner to guide you in KaiOS refactoring and optimization, contact the author from the [About]({{< ref "about" >}} "About") page.
