+++
title = "Advanced KaiOS Development: Push Notifications"
description = "Sending Notifications with the Web Push Protocol on KaiOS"
date = 2023-02-09T00:00:00+08:00
toc = true
draft = false
tags = ["KaiOS", "Push", "Notifications", "Web", "Permissions"]
categories = []
header_img = "img/home-alt.png"
series = ["Advanced Development"]
+++

Sending Notifications with the Web Push Protocol on KaiOS.

# The Web Push Protocol

![Push Notifications on KaiOS](/img/podlp-notifications.png "Push Notifications on KaiOS")

Push Notifications on KaiOS work more or less the same as they do in a web browser like Firefox, with some caveats. They are a great way to provide utility and drive engagement. For instance:

* Chat app with notifications for new messages
* Email app with notifications for new emails
* Podcast app with notifications for new episodes
* Sports app with notifications for game scores
* Bank app with notifications for transactionals

Push Notifications require two components: a client with a registered ServiceWorker to receive notifications, and a web server to store subscriptions and send notifications. This article focuses on KaiOS-specific client-side interactions, as there are many great back-end libraries like [web-push](https://github.com/web-push-libs/web-push). There are also alternatives such as [WebSockets and Server-Sent Events (SSE)](https://developer.ibm.com/articles/wa-http-server-push-with-websocket-sse/), although these are limited to interactions while the app is active in the foreground, while Web Push allows notifications to be received even if the app isn't open.

## Permissions

In KaiOS 2.5, applications must explicitly request permission to subscribe and receive push notifications by declaring the [`"push"`](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/apps/PermissionsTable.jsm#L175) permission in their `manifest.webapp` file. In KaiOS 3.0, the [`"push"` permission is available by default](https://github.com/kaiostech/gecko-b2g/blob/gonk/b2g/components/PermissionsTable.jsm#L31) to all applications.

Similarly, on KaiOS 2.5 (but not KaiOS 3.0), the [`"serviceworker"`](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/apps/PermissionsTable.jsm#L180) permission is needed to use register a [ServiceWorker](https://developer.mozilla.org/en-US/docs/Web/API/ServiceWorker) to receive push notifications. This permission was removed in KaiOS 3.0 to align with standard Progressive Web App (PWA) functionality.

<u>Note</u>: it's impossible to forget the `"serviceworker"` permission because without it, on KaiOS 2.5 `navigator.serviceWorker` will be `undefined`.

Finally, the [`"desktop-notification"`](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/apps/PermissionsTable.jsm#L253) is needed on both KaiOS 2.5 and 3.0 to display notifications using the `Notification` constructor or `ServiceWorkerRegistration.showNotification()`. In KaiOS 2.5, by default the permission is granted for all app types, while in KaiOS 3.0 `"pwa"` type apps will display a prompt for the user to confirm. While user interaction is not required to display notifications or request permission in KaiOS 2.5, it is for `"pwa"` apps in KaiOS 3.0.

<u>Note</u>: it's important to check for permission before using the above APIs. Depending on the KaiOS version and app type, users might be able revoke default permissions in Settings > Privacy & Security > App Permissions.

## Notification Types and ServiceWorkers

![KaiOS Notification Types](/img/kaios-notification-types.png "KaiOS Notification Types. Left <code>requireInteraction = false</code>, right <code>requireInteraction = true</code>")

Depending on whether [`Notification.requireInteraction`](https://developer.mozilla.org/en-US/docs/Web/API/Notification/requireInteraction) is set, KaiOS will display notifications differently. If `requireInteraction` is enabled, notifications will display in the foreground as a modal with actions (by default, "Dismiss"). The user must take an action to proceed. If `requireInteraction` is disabled, which it is by default, then the notification will display for several seconds before becoming available in the Notification Center.

There are two ways to display web notifications, using the [`Notification` constructor](https://developer.mozilla.org/en-US/docs/Web/API/Notification/Notification) and by calling [`ServiceWorkerRegistration.showNotification()`](https://developer.mozilla.org/en-US/docs/Web/API/ServiceWorkerRegistration/showNotification). Using the `Notification` constructor creates **non-persistent notifications** that users can only respond to while your application is open. In contrast, actions are only supported for persistent notifications. In contrast, a notification associated with a ServiceWorker is a [**persistent notification**](https://notifications.spec.whatwg.org/#persistent-notification) that will trigger the the `notificationclick` and `notificationclose` events.

ServiceWorkers on KaiOS work similarly to Firefox, but on KaioS 2.5 there's one special function worth mentioning: the [`Clients.openApp`](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/webidl/Clients.webidl#L24) function which is part of the [`Clients`](https://developer.mozilla.org/en-US/docs/Web/API/Clients) interface. `openApp` launches a web app with the same origin of its service worker scope.

```js
self.addEventListener('notificationclick', (event) => {
  let found = false;
  clients.matchAll().then((clients) => {
    // Check if the app is already opened
    for (i = 0; i < clients.length; i++) {
      if (clients[i].url === event.data.url) {
        found = true;
        break;
      }
    }

    // If not, launch the app
    if (!found) {
      clients.openApp({ msg: 'Data' });
    }
  });
});
```

The optional `msg` property is a String that gets passed to the app via the `serviceworker-notification` system message. Apps need to register for this event in `manifest.webapp` (KaiOS 2.5).

```json
{
    "messages": [
        { "serviceworker-notification": "/" }
    ]
}
```

These messages can then be received by the application using system message handlers. In KaiOS 2.5, it's as simple as calling `navigator.mozSetMessageHandler`. In KaiOS 3.0 this isn't necessary because `Clients.openApp` was removed in favor of the standard `Clients.openWindow`, `WindowClient.focus`, and `Client.postMessage`, but there is an analogous [SystemMessage API](https://developer.kaiostech.com/docs/sfp-3.0/api/next-new-apis/others/SystemMessage/other-SystemMessage/).

```js
navigator.mozSetMessageHandler("serviceworker-notification", (event) => {
    console.log(event.msg)
});
```

By combining a ServiceWorker, the `push` event, `Clients.openApp`, and a message handler for the `serviceworker-notification` event, it's now possible to build a KaiOS web app that receives push messages, displays notifications, and opens the appropriate page.

### VAPID Keys

Although `applicationServerKey` is required in browsers like Chrome and Edge, KaiOS and Firefox allow developers to send push notifications without setting `applicationServerKey` during subscription.

```js
serviceWorkerRegistration.pushManager.subscribe({
    userVisibleOnly: true,
    applicationServerKey: null,
})
```

However, if [Voluntary Application Server Identification for Web Push](https://datatracker.ietf.org/doc/draft-ietf-webpush-vapid/) **(VAPID) keys are not configured, only empty push notifications will be allowed**. This significantly limits the utility of push notifications. For that reason, it's best to generate and use VAPID keys. It's simple with the web-push library:

```bash
web-push generate-vapid-keys --json
```

This generates a public & private key pair. The public key is that's provided to `applicationServerKey` in the form of a `Uint8Array`, while the private key is to send notifications server-side and should not be shared!

```json
{
"publicKey":"BF7_KAxbQWoYtHwB7YnL0BlSQ-tvfmWrbp6Z9pUC_8kAdBUDv2QAZ4QScnQjwS982cpV5mqtT6QebWQLP5GpGwM",
"privateKey":"4cjKnRevSuxLh6KHBEQzG9I3pzM_LFZwyxkqBsW1Kdg"
}
```

Converting a Base64-encoded String into a `Uint8Array` is simple with a function like `urlB64ToUint8Array`, for instance [base64-to-uint8array](https://github.com/gbhasha/base64-to-uint8array/blob/master/index.js):


```js
function urlB64ToUint8Array(base64String) {
  let padding = '='.repeat((4 - base64String.length % 4) % 4);
  let base64 = (base64String + padding)
    .replace(/\-/g, '+')
    .replace(/_/g, '/');

  let rawData = window.atob(base64);
  let outputArray = new Uint8Array(rawData.length);

  for (let i = 0, e = rawData.length; i < e; ++i) {
    outputArray[i] = rawData.charCodeAt(i);
  }
  return outputArray;
};
```

`PushManager.subscribe()` returns a `Promise`, with the important details in the response object. Putting it all together:

```js
const PUBLIC_KEY = "BF7_KAxbQWoYtHwB7YnL0BlSQ-tvfmWrbp6Z9pUC_8kAdBUDv2QAZ4QScnQjwS982cpV5mqtT6QebWQLP5GpGwM";

serviceWorkerRegistration.pushManager.subscribe({
    userVisibleOnly: true,
    applicationServerKey: urlB64ToUint8Array(PUBLIC_KEY),
}).then(
    (pushSubscriptionObj) => {
        // Serialized endpoint & keys property
        const pushSubscription = pushSubscriptionObj.toJSON();
        saveServerSide(pushSubscription); // TODO
});
```

The `pushSubscription` object will contain two important properties, `endpoint` and `keys`. Here's an example of what that looks like on KaiOS:

```json
{
    "endpoint": "https://push.kaiostech.com:8443/wpush/v2/gAAAAABf4QzE-pX31ttCqVfnQQH90dCU9QvwXmWJgcdcHR6BZWMMQ1S_uRfi217k4FAoivLjhJviXJDWF2s7ya47OnfcSjZt2J98HIHFK2UQzZgG5VA7Jagvh-R0SrggsMpSWugCe90Sk9_mqCILmJPe1BN8NF5_jbaDO0U3VwTiF7lMGo9eccI",
    "keys": {
        "auth": "SIQaHqu_J-jZfskndcqeYw",
        "p256dh": "ABykpssKmfXKskWYi6tVwvCZUthXodHLBMJnxUtTym3PCcNse5WFeRbepfXDFhn21jIVxEc_HrFdgKuURbJFh74"
    }
}
```

On the JioPhone, push subscriptions will look similar but resolve to a different domain.

```json
{
    "endpoint": "https://update.kai.jiophone.net:8443/wpush/v1/gAAAAABj6Fj8YbiwPc4ydWXSl0lPT_D8lFpddlATEBrtdZ58fPVd7HDKGqo3nZhkuYtu-_-Hx-COEGk-R5NEbX_J8xLJKAt0Z5uqesPeBv5LaqmZmYBNhp8YuojDqAioJD2BN-wM5mZs",
    "keys": {
        "auth": "uhvorcFRq-pTnoHZwiN7sw",
        "p256dh": "BPcvklqnsLZ8n8T_dK71XZQHCp0hZnrNYsY9HJbzNuwRRs0Pyz_Bc48n21whq6Lq8s9_E41pZCVFfZ5xiFII1nU"
    }
}
```

<u>Note</u>: as of the time of writing, the JioStore does not allow third-party applications access to the permissions needed to send push notifications.

## Sending Push Notifications

Once you have the `endpoint` and `keys` for a user, sending push notifications is simple. Push notifications can be send from the command line using `web-push`:

```bash
web-push send-notification \
  --endpoint=$ENDPOINT \
  --key=$p256dh \
  --auth="SIQaHqu_J-jZfskndcqeYw" \
  --vapid-pubkey="BF7_KAxbQWoYtHwB7YnL0BlSQ-tvfmWrbp6Z9pUC_8kAdBUDv2QAZ4QScnQjwS982cpV5mqtT6QebWQLP5GpGwM" \
  --vapid-pvtkey="4cjKnRevSuxLh6KHBEQzG9I3pzM_LFZwyxkqBsW1Kdg" \
  --vapid-subject="https://myapp.com" \
  --ttl=10 \
  --encoding="aesgcm" \
  --payload="Hello, World"
```

Push notifications can also be sent using NodeJS.

```js
const pushSubscription = { endpoint, keys };
const message = 'Hello, World';
const options = {
  timeout: 1000, // milliseconds
  TTL: 10,
  contentEncoding: 'aesgcm',
};

webpush.setVapidDetails(
    SUBJECT,
    PUBLIC_KEY,
    PRIVATE_KEY,
);

webpush.sendNotification(
      pushSubscription,
      message,
      options,
)
```

<u>Note</u>: the default `contentEncoding` for web-push is `aes128gcm`, however, **for KaiOS only `aesgcm` is supported**.

### Tags, Timestamps & `mozbehavior`

KaiOS 2.5 & 3.0 both support the [`tag`](https://developer.mozilla.org/en-US/docs/Web/API/Notification/tag) property, allowing developers to replace existing notifications, rather than sending duplicates. Tags are a simple string that identifies the notification during construction. For instance, in [PodLP](https://podlp.com) a `tag` is set to the Podcast ID to avoid duplicate new episode notifications.

Unfortunately, neither Firefox nor KaiOS support the [`timestamp`](https://developer.mozilla.org/en-US/docs/Web/API/Notification/timestamp). As a result, all notifications will display a timestamp from the moment they are displayed to the user, even if the event happened in the past.

KaiOS also has a custom property, [`mozbehavior`](https://github.com/kaiostech/gecko-b2g/blob/gonk/dom/webidl/Notification.webidl#L90), with the following properties defined in `Notification.webidl`.

```js
dictionary NotificationLoopControl {
  boolean sound;
  unsigned long soundMaxDuration;
  boolean vibration;
  unsigned long vibrationMaxDuration;
};

dictionary NotificationBehavior {
  boolean noscreen = false;
  boolean noclear = false;
  boolean showOnlyOnce = false;
  DOMString soundFile = "";
  sequence<unsigned long> vibrationPattern;
  NotificationLoopControl loopControl;
};
```

<u>Note</u>: `NotificationLoopControl` is only available on KaiOS 3.0.

The two most useful properties are `soundFile`, while allows for custom notification sounds including via a remote file, and `vibrationPattern` which allows for custom [vibration patterns](https://developer.mozilla.org/en-US/docs/Web/API/Vibration_API#vibration_patterns).

### Good Vibrations

Since [`Notification.vibrate`](https://developer.mozilla.org/en-US/docs/Web/API/Notification/vibrate) isn't available on Firefox or KaiOS, the main use for `mozbehavior` is to set the `vibrationPattern` to a custom pattern.

```js
let options = {
    body: "Body",
    mozbehavior: {
        vibrationPattern: [ 30, 200, 30 ]
    },
};
let notification = new Notification("Title", options);
```

With that, the notification will trigger a vibration when it's received similar to calling `navigator.vibrate`.

## Conclusion

Push notifications in KaiOS work similar to other modern browsers, but with a few special features, properties and quirks. Notifications are a great way to drive user engagement and keep users informed. If you're looking for a partner to ensure the best possible user experience on KaiOS, you can find the author's contact info on the [About]({{< ref "about" >}} "About") page.