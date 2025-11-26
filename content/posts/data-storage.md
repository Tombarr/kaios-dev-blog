+++
title = "Data Storage on KaiOS"
description = "The complete guide to client-side data storage on KaiOS, including the Device Storage and Data Stores APIs"
date = 2024-01-16T00:00:00+08:00
lastmod = 2024-11-07T00:00:00+08:00
toc = true
draft = false
header_img = "img/home-alt.png"
tags = ["KaiOS", "Storage", "Data", "Device Storage", "Data Stores"]
categories = []
series = ["Getting Started"]
+++

# Data Storage on KaiOS

KaiOS offers standard Web Storage APIs (`localStorage` and `sessionStorage`), `indexedDB`, `document.cookie`, and the [Cache API](https://developer.mozilla.org/en-US/docs/Web/API/Cache) as well as platform-specific APIs like [Device Storage](https://developer.kaiostech.com/docs/api/web-apis/deviceStorage/device-storage/) and [Data Store](https://developer.kaiostech.com/docs/api/web-apis/dataStore/data-store/). The ideal API for your use case depends on factors including data size, security, and simplicity. Keep in mind that KaiOS devices have limited storage available (i.e. the [Blu Zoey Smart](https://www.bluproducts.com/devices/zoey-smart/index.html) only has 512MB), and many users will not have an external micro SD card, so its best to store the minimum data necessary and assume most persistence is best-effort.

## Web Storage (`localStorage` and `sessionStorage`)

`localStorage` is by far the simplest Web Storage API. It offers a synchronous key-value data store with one data type–strings–capped at 5MiB per application (configured via the `dom.storage.default_quota` preference). Since JSON can serialize nearly any object to a string, it's possible to store more complex data as well. Ideally, `localStorage` is used for small amounts of persisted, non-sensitive data like the timestamp when an API was last polled or user style and language preferences.

⚠️ <u>Warning</u>: wrap `localStorage` calls to catch errors like `NS_ERROR_DOM_QUOTA_REACHED`. Beware that certain user preference changes may act similarly to [private browsing](https://muffinman.io/blog/localstorage-and-sessionstorage-in-safaris-private-mode/), effectively setting the storage limit to 0.

Unfortunately, `localStorage` is not co-operatively scheduled and because it is fully synchronous, it blocks all execution until completion. As a result, it's best not to retrieve data from `localStorage` in loops. It's also only available from the main thread, so it's inaccessible from Web Worker or Service Workers.

* 👍 Easy to use
* 👍 Standard API
* 👎 5MiB limit
* 👎 Blocks main thread
* 👎 Not accessible via Workers
* 👎 String serialization

ℹ️ <u>Pro Tip</u>: [`sessionStorage`](https://developer.mozilla.org/en-US/docs/Web/API/Window/sessionStorage) works just like `localStorage`, but only persists while your app is open. **`sessionStorage` a great way to cache up to 5MiB of data** that you might otherwise have stored in memory.

## IndexedDB

IndexedDB is a standard Web API that offers a NoSQL name-value database with indexes, transactions, fast asynchronous lookups, and the ability to store objects and binary blobs without string serialization. However, it gets a bad reputation because its APIs are complex and use outdated callback syntax instead of modern approaches like `Promise` or `async` and `await`.

* 👍 Asynchronous
* 👍 Standard API
* 👍 Binary Data
* 👍 Main Thread & Workers
* 👎 Complex API
* 👎 Unintelligible Errors
* 👎 No Storage Utilization Information

Unlike `localStorage`, **IndexedDB is available in all contexts** (main thread, web workers, and service workers). Further, it's main shortcoming can be mitigated by using a library like [idb](https://www.npmjs.com/package/idb) that improves usability by wrapping API calls with `Promise` and providing TypeScript type definitions.

⚠️ <u>Warning</u>: overuse of IndexedDB can cause device-wide performance degradation and frequent errors that may necessitate a factory reset. Use caution when storing large amounts of data in IndexedDB.

## Cookies

Cookies are the technology that allows for persisted session state, enabling users to log in and stay logged in for a fixed period of time. However, they're also the technology that allows advertisers to track users across websites. The [`document.cookie`](https://developer.mozilla.org/en-US/docs/Web/API/Document/cookie) is a simple API for reading and writing cookies.

Apps can store up to 20 named cookies with a maximum string length of 4Kb (80kb total). All data is serialized to URL-safe strings (no commas, semicolons, whitespace, etc), and sent along with HTTPS requests for the appropriate domains via the `Cookie` header.

* 👍 Simple
* 👍 Standard API
* 👍 Essential for logins
* 👎 80kb limit
* 👎 String serialization
* 👎 May require consent warning (i.e. per GDPR/ ePD)

Cookies are the only standard data storage technology that can **persist beyond when an application is uninstalled** (but not a factory reset). This means that Cookies can be a powerful tracking mechanism for deduplicating users who might uninstall and reinstall your application.

⚠️ <u>Warning</u>: app origins changed between KaiOS 2.5 (i.e. `app://podlp.com`) and KaiOS 3.0 (i.e. `https://podlp.localhost/`). As a result, **cookies in KaiOS 3.0 cannot be set client-side for remote origins** like [https://podlp.com](https://podlp.com), and cookies set using the `Set-Cookie` header are not accessible via the `document.cookie` property.

## Cache API

The Cache API offers browser-dependent persistence for `Request` and `Response` object pairs. It's primarily used in Service Workers to cache responses for faster subsequent retrieval. Persistence is [best effort](https://developer.mozilla.org/en-US/docs/Web/API/Storage_API/Storage_quotas_and_eviction_criteria) and will be preferentially evicted when there is storage pressure. As a result, the Cache API should be treated as ephemeral.

* 👍 Asynchronous, Promise-based
* 👍 Standard API
* 👍 Offline Usage
* 👎 Ephemeral
* 👎 Request/ Response Only

⚠️ <u>Warning</u>: watch out when caching [`Range` requests](https://web.dev/articles/sw-range-requests) typical for streaming audio and video.

## Device Storage

The Device Storage API provides access to the file system within an app. It's only available to Privileged apps, and requires a different [permission]({{< ref "./kaios-permissions" >}}) for each storage name.

* `apps` - _Certified only_, used to store user data needed by apps
* `music` - Location for music and sounds
* `pictures` - Location for pictures and wallpapers
* `sdcard` - General data storage location; may be internal (emulated sdcard)
* `videos` - Location for videos and movies

Device Storage transparently maps storage names to mount points that are consistent across all applications. This means that files written by one application (i.e. the Camera app) are accessible by others apps (i.e. the Gallery app), with the appropriate permission. Permissions are declared in `manifest.webapp` and require the `access` property, which can be `readonly` or `readwrite`, depending on whether write access is required.

```json
"permissions": {
  "device-storage:music": { "access": "readonly" },
  "device-storage:pictures": { "access": "readwrite" }
}
```

Device Storage accepts `Blob`s which are written to files. Here's a simple example writing a text file to the `sdcard` storage name.

```js
let sdcard = navigator.getDeviceStorage("sdcard");
let file = new Blob(["Test text file"], { type: "text/plain" });

let request = sdcard.addNamed(file, "text-file.txt");

request.onsuccess = (e) => {
  console.log('File "' + e.target.result.name + '" successfully wrote on the sdcard storage area');
};

request.onerror = (e) => {
  console.warn('Unable to write the file: ' + e.target.error);
};
```

Device Storage APIs to read and write files are asynchronous and return [DOMRequest]({{< ref "common-apis-and-interfaces#domrequest" >}} "DOMRequest") objects that provide `onsuccess` and `onerror` event handlers. Alternatively, `DOMRequest` is "thennable" and can return a `Promise`.

⚠️ <u>Warning</u>: Don't be fooled! Some **APIs like [`getEditable`](https://developer.kaiostech.com/docs/api/web-apis/deviceStorage/devicestorage/geteditable/) were never fully implemented**, returning a `File` instead of a `FileHandle`. **Don't rely solely on documentation, always validate on commercial devices**.

The full API signature is available at [DeviceStorage.webidl](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/webidl/DeviceStorage.webidl), but here's a summary of key functions on the `DeviceStorage` object returns by `navigator.getDeviceStorage`.

* `addNamed` - Create a new file
* `appendNamed` - Append to an existing file
* `get` - Retrieve an existing file
* `delete` - Delete an existing file
* `enumerate` - Enumerate files in a directory
* `freeSpace` - Amount of free storage space available
* `usedSpace` - Amount of storage space in use
* `isDiskFull` - True if free space of `/data` is under 30MB (preference: `disk_space_watcher.low_threshold`)

ℹ️ <u>FYI</u>: the default KaiOS Music and Video apps do not honor `.nomedia` hidden files, so all audio or video files with specific extensions (i.e. `.mp3`) will be displayed in these pre-installed apps.

It is worth pointing out that unlike other data storage technologies, **Device Storage allows appending to files**. This means that data can be streamed in chunks (i.e. audio and video) and persisted to a single location, without bumping up against memory limits. It's also the only KaiOS Storage API that **persists beyond uninstalls** and provides information on used and available space, allowing apps to responsibly manage data stored while providing users with warnings regarding utilization.

![KaiOS Permission Request Dialog](/img/permission-request.png "KaiOS Permission Request Dialog")

Finally, the Device Storage API is the only API that **requires user-granted permission** prompted for privileged apps. Calling `navigator.getDeviceStorage` will prompt the user to grant permission one-time, with an option to remember their choice. Permission can be revoked at any time from the Settings app, in which case API calls will trigger a `SecurityError`.

* 👍 Asynchronous
* 👍 File storage
* 👍 Append API
* 👎 Main thread only
* 👎 Always shared
* 👎 Cannot restrict to specific origins

## Data Store

Data Store is a KaiOS-specific storage mechanism to store and share data. The API acts as an intermediary store to allow multiple applications to share data between one another. Behind the scenes, Data Store is actually a wrapper around IndexedDB where data is stored in various revisions under the database name, `DataStoreDB`. KaiOS manages read and write access to data stores based on declarations in `manifest.webapp`.

```json
"datastores-owned": {
  "myData": {
    "access": "readwrite",
    "description": "my data store"
  }
},
"datastores-access": {
  "myData": {
    "access": "readonly",
    "description": "Read and modify my data store"
  }
}
```

Privileged apps can declare Data Stores that they create using `datastores-owned`, and Data Stores that they access using `datastores-access`. Similar to Device Storage, the `access` property is required to allow `readonly` or `readwrite` access.

* 👍 Asynchronous
* 👍 Shared storage
* 👍 Main Thread & Workers
* 👎 Cannot restrict to specific origins
* 👎 Poorly documented

# KaiOS Data Storage Summary

|               | IndexedDB         | localStorage  | Device Storage    | Data Store   | Cookie       |
|------------|------------|------------|------------|------------|------------|
| Type          | Object            | Key-Value     | File              | Object       | Plaintext    |
| Formats       | Binary            | String        | Binary            | Binary       | String       |
| Permission    | N/A               | N/A           | Privileged        | Privileged   | N/A          |
| Shared        | X                 | X             | ☑️                 | ☑️            | X            |
| Location      | Internal          | Internal      | Internal/ External| Internal     | Internal     |
| Availability  | Main, Worker      | Main          | Main              | Main, Worker | Main         |
| Quota         | N/A               | 5MiB          | N/A               | N/A          | 80kb         |
| Retention     | Uninstall         | Uninstall     | Deletion          | Uninstall    | Expiration   |
| Append        | X                 | X             | ☑️                 | X            | X            |
| Asynchronous  | ☑️                 | X             | ☑️                 | ☑️            | X            |

Each storage technology writes data to a different location. Here are some default locations. `/<profile>/` denotes the profile location, `/data/b2g/mozilla/*.default`, and `*` denotes a random identifier for Mozilla's [default profile](https://support.mozilla.org/en-US/kb/profiles-where-firefox-stores-user-data) where bookmarks, passwords and other user data are stored.

| API        | Location   |
|------------|------------|
| IndexedDB      | `/<profile>/indexedDB/<databaseid>` |
| localStorage   | `/<profile>/webappsstore.sqlite`    |
| Cache API      | `/<profile>/caches.sqlite`          |
| Cookies        | `/<profile>/cookies.sqlite`         |
| Device Storage | `/sdcard` or `/sdcard1`             |
| Data Store     | `/<profile>/indexedDB/<databaseid>` |

## Recap

In addition to the APIs mentioned above, the web is littered with a graveyard of deprecated vendor-specific storage solutions including [`window.name`](https://developer.mozilla.org/en-US/docs/Web/API/Window/name), [WebSQL](https://developer.chrome.com/blog/deprecating-web-sql/), and [AppCache](https://web.dev/articles/appcache-removal). Here's a quick recap of how you might use each storage technology.

* A cookie (or two) for session state
* localStorage for persisted user preferences
* sessionStorage for larger, ephemeral state
* IndexedDB for purgeable binary data
* The Cache API for serving responses offline
* Device Storage for files (i.e. music and pictures)
* Data Store for shared data (i.e. contacts)

KaiOS provides many methods for storing and retrieving data client-side. Picking the right solution is important, since KaiOS has partially-implemented APIs, client-side data migrations can be challenging, and storage pressure warnings can force factory resets. If you need an experienced partner to inform your KaiOS data storage strategy, contact the author from the [About]({{< ref "about" >}} "About") page.
