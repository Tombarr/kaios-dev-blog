+++
title = "The Download on KaiOS Downloads"
description = "How to stream and store files on KaiOS"
date = 2023-02-25T00:00:00+08:00
toc = true
draft = false
tags = ["KaiOS", "Downloads", "XHR", "DeviceStorage", "Offline"]
categories = []
series = ["Advanced Development"]
header_img = "img/home-alt.png"
+++

# How to stream and store files on KaiOS

## Background

Although KaiOS is based on Firefox, unlike modern smartphones or desktops, KaiOS phones are quite resource constrained. All KaiOS-powered devices have either 256MB or 512MB RAM for the entire operating system. That memory gets allocated for core system services like telephony, audio, and graphics. Only a fraction of that memory is available to your app.

![KaiOS Memory Low Warning](/img/memory-low.png "KaiOS Memory Low Warning")

As a developer, that means reducing your app's memory footprint to avoid the dreaded Out of Memory Error. One area where memory allocation is most direct and measurable is downloads, namely downloads done using XMLHttpRequest (XHR) and `fetch`.

During early testing of [PodLP](https://podlp.com), users would report the app crashed when downloading popular podcasts like The Joe Rogan Experience (JRE) prior to it becoming a Spotify Exclusive. The JRE is very long-format, typically 2-4 hours. This results in MP3 files that are hundreds of megabytes. Even if the KaiOS device has an external SD Card with sufficient storage, PodLP would crash because it attempted to download the entire file as a Blob.

If you search for tutorials on [downloads using JavaScript](https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest/Sending_and_Receiving_Binary_Data), you ultimately find code snippets that looks like this:

```js
const req = new XMLHttpRequest();
req.open("GET", "/audio.mp3", true);
req.responseType = "blob";

req.onload = (event) => {
  const blob = req.response;
  // ...
};

req.send();
```

However, this example will crash on KaiOS if "audio.mp3" is sufficiently large. A precise cutoff is difficult to provide, but generally that's roughly 20-40MB depending on the device.

## Downloads, the Right Way

Fortunately, KaiOS provides several ways to download large remote resources: chunking and streaming. On KaiOS 2.5 and older versions of Firefox, there are two special XHR response types: `moz-chunked-arraybuffer` and `moz-chunked-text`. Instead of providing the entire response object during the `load` event, these response types will return "chunks" of varying sizes during the `progress` event.

```js
const req = new XMLHttpRequest();
req.open('GET', "/audio.mp3", true);
req.responseType = 'moz-chunked-arraybuffer';

let bytesReceived = 0;
let total = 0;
let percent = 0;

req.onprogress = (event) => {
    const chunk = event.target.response;

    // Calculate percent progress from byte lengths
    total = event.total;
    bytesReceived += chunk.byteLength;
    percent = bytesReceived / total;

    // ...
};
```

Using this example, it's now possible to download large audio or video files in "chunks," without running out of memory. This can be combined with the `systemXHR` permission to download large files without running into Same Origins either!

While **`moz-chunked-arraybuffer` was removed on KaiOS 3.0**, similar and more standard approach is available [using readable streams](https://developer.mozilla.org/en-US/docs/Web/API/Streams_API/Using_readable_streams) and `fetch`.

```js
fetch("/audio.mp3")
  .then((response) => {
    const reader = response.body.getReader();
    const total = Number.parseInt(response.headers.get('Content-Length'), 10);

    let bytesReceived = 0;
    let progress = 0;

    return reader.read()
        .then(({ done, value }) => {
            bytesReceived += value.length;
            progress = bytesReceived / total;

            // ...
        })
  })
  .catch((err) => /* TODO */);
```

This example accomplishes the same outcome as `moz-chunked-arraybuffer` but uses `fetch` readable streams to process large assets in smaller pieces of varying sizes.

<u>Note</u>: For both XHR and fetch it's possible that the `Content-Length` header isn't present. In this case, the total size may not be known in advance.

## Storing Chunks

Although streaming and chunking solve one problem (downloading large files using limited memory), they create another: storing and accessing those chunks. Developers can still use `localStorage` and `indexedDB`, but neither supports an "append" operation. This means files would need to be stored and accessed in chunks, which _can work_ for timeseries data like audio or video, but is certainly difficult to work with!

<u>Caution</u>: Certain non-standard interfaces like [`IDBMutableFile`](https://developer.mozilla.org/en-US/docs/Web/API/IDBMutableFile) do not actually work on KaiOS. Accessing these resources throws a `FileHandleInactiveError` because the necessary internals were never implemented.

The easiest way to store files in chunks on KaiOS is using the [DeviceStorage API](https://developer.kaiostech.com/docs/api/web-apis/deviceStorage/device-storage/). DeviceStorage allows apps to request access to store "music," "pictures," "videos," or generic data on "sdcard" via the `navigator.getDeviceStorage()` function.

<u>Note</u>: Media stored using named storage will show up in default system apps. i.e. "pictures" are available in Gallery, "music" is available in Music. **KaiOS does not support [`.nomedia` files](https://www.lifewire.com/nomedia-file-4172882)**.

Permission must first be requested in `manifest.webapp` (or `manifest.webmanifest`) for the `navigator.getDeviceStorage()` functions to be present. Each permission has a required `"access"` property that can be one of `"readonly"` for read-only access or `"readwrite"` for read & write access.

```json
{
    "name": "My App",
    "description": "Awesome App",
    "permissions": {
        "device-storage:videos": {
            "access": "readonly"
        },
        "device-storage:pictures": {
            "access": "readwrite"
        }
    }
}
```

![KaiOS Permission Request Dialog](/img/permission-request.png "KaiOS Permission Request Dialog")

For both hosted web and privileged apps, **the first time you call `navigator.getDeviceStorage()` it will display a permission request dialog**. It is important to provide context to the user beforehand, because if permission is denied the user has to go to Settings > Security > App Permissions to change it.

Once the user has granted permission, you can now add, modify, and retrieve files stored locally. This works will with chunked downloads. For instance, here's an example on KaiOS 2.5 for saving each chunk locally.

```js
const req = new XMLHttpRequest();
req.open('GET', "/audio.mp3", true);
req.responseType = 'moz-chunked-arraybuffer';

let bytesReceived = 0;
let music = navigator.getDeviceStorage("music");

req.onprogress = (event) => {
    const blob = new Blob([ event.target.response ], { type: 'audio/mp3' });

    if (bytesReceived === 0) {
        music.addNamed(blob, "audio.mp3");
    } else {
        music.appendNamed(blob, "audio.mp3");
    }

    bytesReceived += chunk.byteLength;
};
```
<u>Caution</u>: This example is an oversimplification. Since `progress` events are asynchronous, a more robust solution would be to queue writes to `DeviceStorage` to avoid writing chunks out of order.

The best part is that retrieval is very simple! The `get` function returns a `File` for a given name. This can then be passed to `URL.createObjectURL` to create an object URL to use as the source for `<img>`, `<audio>`, and `<video>` elements.

```js
let music = navigator.getDeviceStorage("music");
let request = music.get("audio.mp3");

request.onsuccess = () => {
  let file = request.result;
  let objectURL = URL.createObjectURL(file);

  audioEl.src = objectURL;
};
```

## Conclusion

Although KaiOS is built on Firefox OS, it runs on resource constrained hardware. Developers need to pay attention to how much memory their apps use to avoid freezing and crashing. If you find these nuances challenging and need support developing performant and reliable experiences on KaiOS, contact the author from the [About]({{< ref "about" >}} "About") page.
