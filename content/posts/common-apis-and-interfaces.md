+++
title = "Common KaiOS APIs and Interfaces"
description = "Learn how to use common KaiOS APIs and Interfaces"
date = 2023-07-15T00:00:00+08:00
lastmod = 2024-11-07T00:00:00+08:00
toc = true
draft = false
header_img = "img/home-alt.png"
tags = ["KaiOS", "API", "Interface"]
categories = []
series = ["Getting Started"]
+++

### Learn how to use common KaiOS APIs and Interfaces

## Wake Lock

KaiOS does not support the [Wake Lock API](https://developer.mozilla.org/en-US/docs/Web/API/WakeLock). Instead, it offers it's own API:

```typescript
interface MozWakeLock {
    readonly topic: string;

    /**
     * Release the wake lock.
     * @throw NS_ERROR_DOM_INVALID_STATE_ERR if already unlocked.
     */
    unlock(): void;
}

// KaiOS 2.5
navigator.requestWakeLock(aTopic: string): MozWakeLock;

// KaiOS 3.0
navigator.b2g.requestWakeLock(aTopic: string): MozWakeLock;
```

The KaiOS Wake Lock API will accept _any_ value for `aTopic`, however, the following have actual utility:

* `screen` - Keep the screen on
* `cpu` - Keep the CPU alive
* `gps` - Keep the GPS alive. Use before calling `navigator.geolocation.getCurrentPosition`

<u>Note</u>: wake locks cause significant battery drain and should only be used when necessary.

## DOMRequest

In KaiOS 2.5, most APIs return a `DOMRequest`, similar to `Promise` for asynchronous requests. For instance, `navigator.mozFMRadio.disable()` returns a `DOMRequest`.

```typescript
interface DOMRequest<T> extends EventTarget {
    readonly error?: Error;
    readonly result: T;
    onsuccess: (e: Event & { target: DOMRequest<T> }) => void;
    onerror: (e: ErrorEvent & { target: DOMRequest<T> }) => void;
    readonly then: Promise<T>["then"];
    readonly readyState: "done" | "pending";
}
```

There are a few important details about `DOMRequest`s:

* `DOMRequest` will _not_ throw an `UnhandledPromiseRejectionWarning` (which is not available until KaiOS 3.x)
* `Promise.finally` was introduced in Firefox 58. Since KaiOS 2.5 is based on Firefox 48, this method isn't available

Because KaiOS didn't convert everything to `Promise`, `DOMRequest` was also ported back to KaiOS 3.x. `DOMRequest` is "thennable" so it can be used directly to return a `Promise`, or it can be converted to a `Promise` easily:

```typescript
function toPromise(aRequest: DOMRequest): Promise<any> {
    return new Promise((resolve, reject) => {
        aRequest.onsuccess = () => resolve(aRequest.result);
        aRequest.onerror = () => reject(aRequest.error);
    });
}
```

Converting `DOMRequest` to `Promise` is helpful when using a polyfill or third-party library that includes its own version of `Promise`.

## MozActivity

Apps can communicate with one another via several APIs, including `MozActivity`. In KaiOS 3.0, this API was replaced with **Web Activities** which work similar but return a `Promise` instead of a `DOMRequest`.

```typescript
interface ActivityOptions {
    name: string
    data: any;
    getFilterResults: boolean;
}

interface MozActivity extends DOMRequest {
    new (options: ActivityOptions);

    // An activity is cancelable if it is already opened.
    cancel(): void;
}
```

Using `MozActivity` is simple:

```javascript
let view = new MozActivity({
  name: "view",
  data: {
    type: "url",
    url: "https://kaios.dev"
  }
});
```

Activities can be used to launch websites, share messages, pick an image from the Gallery, or launch Settings. See my [article on Web Activities]({{< ref "./web-activities" >}}) for many examples.

## KeyNames

![KaiOS Device Keys](/img/kaios-keys.png "KaiOS Device Keys (Source: <a href='https://developer.kaiostech.com' rel='external noopener'>developer.kaiostech.com</a>)")

KaiOS has a few special named keys that can be handled via event listeners like `onkeydown`, including:

* `Call` - "Call key"
* `EndCall` - "End/ power"
* `Flip`
* `Notification`
* `SoftLeft` - "LSK"
* `SoftRight` - "RSK"
* `Dollar`
* `HeadsetHook`
* `GoBack` - KaiOS Smart Touch only

KaiOS also uses the following keys in important ways:

* `VolumeDown`/ `VolumeUp` - Hardware volume buttons
* `MicrophoneToggle` - Holding "Enter" (center button)
* `Backspace` - Single press of `EndCall`

`SoftLeft` (LSK) and `SoftRight` (RSK) are by far the most important, as they're critical for in-app navigation. For devices with a voice assistance, `MicrophoneToggle` will trigger a `voice-assistant` MozActivity that launches Google Assistant.

Some devices like the [JioPhone 2]({{< ref "whats-next-jiophone#jiophone-2" >}} "JioPhone 2")) have dedicated hardware shortcut keys. These can trigger a variety of named keys like `LaunchWebBrowser`, `LaunchApplication1`, or `Camera`. Others cannot be intercepted. See [KeyNameList.h](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/events/KeyNameList.h) for the full list.

## Theme Color

You can easily change the system status bar background color using `theme-color`. The KaiOS System app will even listen for changes to this meta tag.

```html
<meta name="theme-color" content="rgb(255, 255, 255)" />
```

Changing the theme color also hints KaiOS to change the status bar icon color between white and black, based on a color contrast calculation.

<u>Note</u>: the KaiOS System app uses regular expressions to parse the theme color. **To parse properly, use the RGB format with spaces after commas**!

If you want to display an image as the system status bar background, you can force the status bar to **overlap** your app using this `manifest.webapp` property:

```json
"chrome": {
    "statusbar":"overlap"
}
```

For a full list of `manifest.webapp` properties check out my [complete list of `manifest.webapp` properties]({{< ref "./manifest-properties" >}}).

## Conclusion

KaiOS does not have to be complicated to develop for. Converting WebIDL files to TypeScript type definitions is one way to make navigating KaiOS-specific APIs easier. If you're confused and need a professional partner for KaiOS development you can find the author's contact information on the [About]({{< ref "about" >}} "About") page.
