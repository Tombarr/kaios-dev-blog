+++
title = "Web Activities on KaiOS"
description = "Sharing, selecting, and viewing data cross-app with Web Activities and deep links"
date = 2023-02-15T00:00:00+08:00
lastmod = 2024-01-16T00:00:00+08:00
toc = true
draft = false
header_img = "img/home-alt.png"
tags = ["KaiOS", "WebActivity", "Activity", "Intent", "MozActivity", "Deep Link"]
categories = []
series = ["Getting Started"]
+++

Sharing, selecting, and viewing data cross-app with Web Activities and deep links

## Web Activities

![User Flow of Configure Activity](/img/appPermissions-activity.png "Example User Flow of <code>configure</code> Activity")

Like [App Intents](https://developer.apple.com/documentation/appintents/) on iOS and [Intents](https://developer.android.com/reference/android/content/Intent) on Android, Web Activities are the way to share, pick, and view across apps on KaiOS. The interfaces are very similar across platforms, consisting of two components: a **name** (or action in Android) and an arbitrary **data** payload. Again similar to Android's Intents, Web Activities are registered on KaiOS within an app's static manifest.

Web Activities have many uses, including:

* Launching a specific Settings page
* Sending an email or SMS
* Sharing text or an image across apps
* Opening a specific file format like a PDF
* Selecting a photo from the Gallery
* Viewing a website
* Setting the default ringtone
* Responding to alarms via the [Alarm API](https://developer.kaiostech.com/docs/api/web-apis/alarm/alarm/)

**Web Activities are available in all KaiOS app types**, including hosted web apps and packaged privileged or certified apps. Furthermore, **Web Activities are even available to websites**! In 2020 this is how I stumbled upon a [universal jailbreak](https://groups.google.com/g/bananahackers/c/YxZ-zvkETcU) for KaiOS that let's users open the hidden Developer menu from their browser.

### Differences in KaiOS 2.5 and KaiOS 3.0

On KaiOS 2.5, this API is `MozActivity` and on KaiOS 3.0, it's [`WebActivity`](https://developer.kaiostech.com/docs/sfp-3.0/migration-from-2.5/next-new-apis/others/WebActivity/other-WebActivity/). This feature has been called deep linking and it's one of the most common ways to interact with System apps. On KaiOS 2.5, the `MozActivity` inherits from `DOMRequest` while on KaiOS 3.0 the `WebActivity` class has a `start` method that returns a `Promise`. Here's a simple example on both versions that would open a website in the Browser app.

<table class="table" style="table-layout: fixed">
<thead>
<tr>
<td> <b>KaiOS 2.5</b> </td> <td> <b>KaiOS 3.0</b> </td>
</tr>
</thead>
<tr>
<td>

```js
let openURL = new MozActivity({
    name: "view",
    data: {
        type: "url",
        url: "https://kaios.dev"
    }
});

openURL.onsuccess = () =>
    console.log('Opened!');
openURL.onerror = () =>
    console.warn('Error!');
```

<td>

```js
let openURL = new WebActivity(
    "view", {
        type: "url",
        url: "https://kaios.dev"
    }
);

openURL.start()
    .then(() =>
        console.log('Opened!'))
    .catch(() =>
        console.warn('Error!'));
```

</td>
</td>
</tr>
</table>

If you're building an app using WebActivities, it's easy to standardize the APIs for consistent, cross-version support. Here's a function that works on both KaiOS 2.5 and KaiOS 3.0 with a consistent `Promise` return type.

```js
function startActivity(name, data) {
    // KaiOS 2.5 uses MozActivity
    if (typeof MozActivity !== 'undefined') {
        return new Promise((resolve, reject) => {
            let activity = new MozActivity({ name, data });
            activity.onsuccess = () => resolve(activity);
            activity.onerror = (e) => reject(e);
        });
    // KaiOS 3.0 uses WebActivity
    } else if (typeof WebActivity !== 'undefined') {
        let activity = new WebActivity(name, data);
        return activity.start();
    }

    // Not KaiOS?
    return Promise.resolve(null);
}
```

### Registering your app for an activity

So far we've covered _launching_ Web Activities, but it's also possible to respond to activity requests from within your app. To do so, you need to register an **activity handler**.

Static activity registration is declared in the `manifest.webapp` or `manifest.webmanifest`.

```json
{
    "name": "My App",
    "description": "Awesome app",
    "activities": {
       "view": {
            "filters": {
                "type": "url",
                "url": {
                    "required": true,
                    "regexp":"/^https?:/"
                }
            },
            "returnValue": false
        }
    }
}
```

<u>Note</u>: `returnValue` is `false` by default. Set it to `true` to allow your activity to return a value via `postResult()`.

**KaiOS 2.5**

Then within app code, an activity handler callback can be registered and invoked when the system sends a message to your app. In KaiOS 2.5 the API is simple:

```js
let register = navigator.mozSetMessageHandler('view', (e) => {
    if (e.source.name === 'view') {
        console.log(e.source.data);
    }
});

register.onerror = () => {
    console.log("Failed to register");
};
```

You can check if your application has queued messages by calling `navigator.mozHasPendingMessage()` with a given `name` as the parameter. When a message handler is set, all queued messages will be asynchronously delivered to the application.

Registering to receive **system messages** like `activity` or `serviceworker-notification` (covered in Push Notifications) requires an additional property be set in `manifest.webapp`:

```json
{
    "name": "My App",
    "description": "Awesome app",
    "messages": [
    { "serviceworker-notification": "/index.html" },
    { "activity": "/index.html" }
  ],
}
```

There's also one other important function, `navigator.mozSetMessageHandlerPromise`, which accepts a `Promise` as input. This method can only be called from the activity handler callback allows the page to set a `Promise` to keep alive the app until an asynchronous operation is fully completed. This could be used to process data or access a remote resource before returning a response.

```js
let register = navigator.mozSetMessageHandler('view', (e) => {
    let url = e.source.data.url;
    if (url.startsWith('https')) {
        navigator.mozSetMessageHandlerPromise(fetch(url))
            .then((response) => response.text())
            .then((responseText) => e.postResult(responseText)));
    } else {
        e.postError(new Error('Insecure URL.'));
    }
});
```

For instance, in this trivial example above an activity handler is registered for the `view` event that requires a `url` be provided in the `data` payload. If the URL is insecure (doesn't start with HTTPS), then an error is posted. Otherwise, the resource is downloaded via `fetch` and the response text is passed as the result to the activity caller.

<u>Note</u>: a real-world example should perform better input validation and sanitization before downloading a remote resource.

**KaiOS 3.0**

For KaiOS 3.0, activity registration is declared in the `b2g_features`, section of  `manifest.webmanifest`.

```json
{
    "name": "My App",
    "description": "Awesome app",
    "b2g_features": {
        "activities": {
        "view": {
                "filters": {
                    "type": "url",
                    "url": {
                        "required": true,
                        "regexp":"/^https?:/"
                    }
                }
            }
        }
    }
}
```

The process for handling activity requests from within a KaiOS 3.0 app is more complicated than on KaiOS 2.5. First, it requires an active and registered ServiceWorker. Second, the ServiceWorker needs to handle the KaiOS-specific `systemmessage` event.

```js
// Context: application code
if (swRegistration.systemMessageManager) {
    swRegistration.systemMessageManager.subscribe('view');
}

// Context: ServiceWorker
self.addEventListener('systemmessage', (e) => {
    if (e.name === 'view') {
        console.log(e.data);
    }
});
```

Often this means posting messages and opening windows using the `Clients` interface to respond to the message within the app's UI.

<u>Note</u>: see [SystemMessageService.cpp](https://github.com/kaiostech/gecko-b2g/blob/gonk/dom/b2g/messages/SystemMessageService.cpp) for a list of system messages that can be received like `media-button`.

### Common Activities

KaiOS ships with a number of pre-installed apps including Settings, Browser, Music, FM Radio, Gallery, and more. Each of these apps has a manifest with registered activities. Additionally, popular third-party apps like WhatsApp often register activity handlers as well. Here's a selection of popular activities you might want to include in your apps.

**Settings**

The Settings app can be launched using the `configure` name and an optional `section` for specific pages.

```js
let request = new MozActivity({
    name: "configure",
    data: {
        target: "device",
        section: "TODO"
    },
});
```

There's easily over 100 different values for `section`, but here's a few popular ones:

* `developer` - Developer menu
* `volume` - Volume control
* `downloads` - Downloads list
* `battery` - Battery info
* `appPermissions` - Permissions page
* `dateTime` - Date & Time
* `bluetooth` - Bluetooth
* `wifi` - WiFi
* `geolocation` - Geolocation & GPS

Launching the Settings app to a specific page can be a great UX enhancement! For instance, if your app requires an internet connection and you detect none is available, you can prompt the user to connect and easily navigate back to your app.

<u>Note</u>: it's important to test these activities on real devices because it's not uncommon for the Settings app to launch a blank page even for sections is specifically accepts.

**Share**

Share text or an image via SMS, WhatsApp, etc.

```js
let shareText = new MozActivity({
  name: "share",
  data: {
    type: "text/plain",
    blobs: [ "This is a message to share" ]
  }
});

let shareImage = new MozActivity({
  name: "share",
  data: {
    type: "image/png",
    number: 1,
    blobs: [ blob ], // i.e. Canvas.toBlob
    filenames: [ "myimage.png" ]
  }
});
```

**Pick**

![Pick Activity](/img/pick.png "Pick Activity")

Launch the Gallery or Camera app to select an image.

```js
let pick = new MozActivity({
    name: "pick",
    data: {
        type: ["image/png", "image/jpg", "image/jpeg"]
    }
});
```

Launch the Contacts app to select a contact.

```js
let pick = new MozActivity({
    name: "pick",
    data: {
        type: ["webcontacts/contact"],
    },
});
```

<u>Note</u>: when more than one app is able to respond to an activity request, a list is presented to the user to select.

**Dial**

![Dial Activity](/img/dial.png "Dial Activity")

Launch the phone dialer to call a number (requires user confirmation).

```js
let dial = new MozActivity({
    name: "dial",
    data: {
        number: "*345#"
    }
});
```

**View**

Launch a website in the Browser.

```js
let view = new MozActivity({
  name: "view",
  data: {
    type: "url",
    url: "https://kaios.dev"
  }
});
```

**Open**

The `"open"` action will always launch an activity using the original content type to allow for third party applications to handle arbitrary types of content.

```js
let open = new MozActivity({
    name: "open",
    data: {
        type: contentType,
        blob: openBlob,
        filename: null
    }
});
```

**New**

![New Contact Activity](/img/new-contact.png "New Contact Activity")

Create a new contact.

```js
let newActivity = new MozActivity({
    name: "new",
    data: {
        type: "webcontacts/contact",
        params: {
            giveName: "Tom",
            familyName: "Barrasso",
            tel: "+1234567890",
            email: "tom@barrasso.me",
            address: "USA",
            note: "Memo",
            company: "PodLP"
        }
    }
});
```

Create a new text message (SMS).

```js
let newActivity = new MozActivity({
    name: "new",
    data: {
        type: "websms/sms",
        number: "1234567890",
    },
});

```

**Save**

![Bookmark Activity](/img/bookmark.png "Bookmark Activity")

Save a website as a bookmark on the homescreen.

```js
let saveBookmark = new MozActivity({
    name: "save-bookmark",
    data: {
        type: "url",
        url: "https://kaios.dev",
        name: "KaiOS.dev",
        icon: "https://kaiostech.com/favicon.ico"
    }
});
```

**Set Ringtone**

![Set Ringtone Activity](/img/setringtone.png "Set Ringtone Activity")

Set an audio file as the system ringtone.

```js
let ringtoneActivity = new MozActivity({
    name: "setringtone",
    data: {
        blobs: [ audioBlob ],
        type: "audio/*",
        metadata: [{
            title: "Umbrella",
            artist: "Rihanna",
            picture: pictureBlog
        }]
    }
});
```

**Set Wallpaper**

Set an image blob as the system wallpaper.

```js
let wallpaperActivity = new MozActivity({
    name: "setwallpaper",
    data: {
        blobs: [ imageBlob ],
        type: "image/*",
        number: 1
    }
});

let wallpaperActivity = new WebActivity("set-wallpaper", {
    blobs: [ imageBlob ],
    type: "image/*",
    number: 1
});
```

<u>Note</u>: this is available on KaiOS 3.0 and later KaiOS 2.5 devices. It requires the pre-installed Wallpaper (Gaia Wallpaper Picker) app, and may be named `"setwallpaper"` or `"set-wallpaper"`.

### Cancelling and Error Handling

On both KaiOS 2.5 and 3.0, to cancel a started activity, use `cancel()`. You can cancel an activity before or after it's been loaded. On KaiOS 2.5, the pending `DOMRequest` of `new MozActivity` will trigger `onerror`, and on KaiOS 3.0 the pending promise of `start()` will be rejected.

The `onerror` callback returns a `DOMError` on KaiOS 2.5, and by far the most common error `name` you'll receive is `"NO_PROVIDER"`, which means there is no available app to respond to that activity request. When an activity is cancelled the error `name` will be `ActivityCanceled`.

## Additional Activities

**Open Page**

![Open Page Activity](/img/open-page.png "Open Page Activity")

The `open-page` activity is supported by the KaiStore and JioStore. It lets you launch the app store to a specific app detail page for quicker installation, and can be used with Install banners on websites. This is how the [KaiStore's web directory](https://www.kaiostech.com/store/apps/) prompts for app installations on KaiOS phones. Below is an example that would open [PodLP](https://podlp.com) on the KaiStore.

```js
let openPage = new MozActivity({
    name: "open-page",
    data: {
        type: "url",
        url: "https://api.kaiostech.com/apps/manifest/UxappJMyyWGDpPORzsyl"
    }
});
```

<u>Note</u>: app identifiers are consistently-generated hashes between the KaiStore and JioStore, but Manifest URLs are different. For instance, PodLP's ID is `UxappJMyyWGDpPORzsyl` but the prefix for JioStore Manifest URLs is https://api.kai.jiophone.net/v2.0/apps/manifest/.

### Deep Linking

Deep linking is the ability for an app to respond to a URL loaded within the system. For instance, the KaiStore supports deep linking on KaiOS with declarations in the `manifest.webapp` file.

```json
{
    "deeplinks": {
        "regex": "^(app://)(kaios-store|kaios-plus)(.kaiostech.com)($|/$|/\\?(apps|postResult)=)",
        "action": "open-deeplink"
    },
    "activities": {
        "open-deeplink": {
            "href": "./index.html",
            "disposition": "window",
            "filters": {
                "type": "url",
                "url": {
                    "required": true,
                    "pattern": "(app|rtsp|data):.{1,16384}"
                }
            },
            "returnValue": true
        }
    }
}
```

Deep links require two parts: a `deeplinks` section with a regular expression for a specific URL and an action activity that's typically named `"open-deeplink"`. This feature is supported in later versions of KaiOS 2.5, as well as all versions of KaiOS 3.0. Implementation details for deep link registration and handling can be found in [AppsServiceDelegate.jsm](https://github.com/kaiostech/gecko-b2g/blob/gonk/b2g/components/AppsServiceDelegate.jsm#L38) and [nsURILoader.cpp](https://github.com/kaiostech/gecko-b2g/blob/gonk/uriloader/base/nsURILoader.cpp#L136).

## Conclusion

There are many ways to use web activities to develop high-quality user experiences on KaiOS apps and websites. Activities can increase install conversation, nudge users to easily grant permissions, and conveniently share content. If you're looking for a partner to ensure the best possible user experience on KaiOS, you can find the author's contact info on the [About]({{< ref "about" >}} "About") page.
