+++
title = "Running in the Background on KaiOS"
description = "How to respond to events and perform background tasks on KaiOS"
date = 2023-10-30T00:00:00+08:00
lastmod = 2023-11-01T00:00:00+08:00
toc = true
draft = false
header_img = "img/home-alt.png"
tags = ["KaiOS", "Background", "Asychrnonous", "Threads", "Alarm", "RequestSync"]
categories = []
series = ["Advanced Development"]
+++

# Running in the Background on KaiOS

Despite KaiOS operating on resource-constrained hardware, apps can execute tasks in the background using several approaches.

* Background Media
* Activities & System Messages
* Service Workers
* Alarm API
* Request Sync API

## Background Media

The simplest way to do anything in the background is by using [Audio Channels]({{< ref "audio-volume-management#audio-channels" >}} "Audio Channels") to continue audio playback while using another app. Using the `content` audio channel on an `audio` or `video` element, when the user presses Back/ EndCall, it will trigger your application to enter the background.

The property can be set as an HTML attribute:

```html
<audio mozAudioChannelType="content" />
<video mozAudioChannelType="content" />
```

Or via a JavaScript property:

```js
const audio = document.createElement('audio');
audio.mozAudioChannelType = 'content';
```

That's it! When the user exits your app, audio will continue to play in the background.

<u>Note</u>: due to resource constraints, devices that are experiencing memory pressure may close your app, stopping audio playback. It's best _not_ to use video for background audio playback, since that requires significantly more memory.

## Activities and System Messages

The easiest way to perform work in the background is by having your app respond to activities using [MozActivity]({{< ref "common-apis-and-interfaces#mozactivity" >}} "MozActivity") an the [messages]({{< ref "manifest-properties#messages-optional" >}} "messages") manifest.webapp property.
Responding apps can either
1) Launch fully and become the foreground app
2) Launch an interstitial (i.e. to select photos from a gallery)
3) Perform a task and return a result.

In the case of system messages, some may be triggered by the system without user interaction, while most activities will be triggered by the user directly.

**What it's good for?** Responding to user-triggered events or certain system messages.

⚠️ <u>Warning</u>: **Activities are exposed to all apps and the web browser**. This is how [CVE-2023-27108]({{< ref "./cve-2023-27108" >}} "CVE-2023-27108") works: the Communications app exposes an activity that returns the user's call log without authorization checks.

## Service Workers

Like all modern web browsers, one way to performs limited set of background tasks is through Service Workers, most notably via [push notifications]({{< ref "push-notifications" >}} "push notifications"). That said, service workers execute in a [worker scope](https://developer.mozilla.org/en-US/docs/Web/API/ServiceWorkerGlobalScope) with no access to the Document Object Model (DOM) and without many common APIs like XMLHttpRequest (XHR). However, service workers can process information off the main thread and can return transferable objects (i.e. `String` and `ArrayBuffer`) using [message passing](https://developer.mozilla.org/en-US/docs/Web/API/ServiceWorker/postMessage).

**What it's good for?** Responding to push notifications; basic background processing via message passing.

On KaiOS 3.0, all background processing is routed via a Service Worker that, in some cases (i.e. when called via `notificationclick`), can launch a UI.

ℹ️ <u>Important</u>: Service Workers have a default **30 second idle timeout** for Events like `PusgEvent`. It's controlled by `dom.serviceWorkers.idle_timeout`, and [while this may seem short](https://bugzilla.mozilla.org/show_bug.cgi?id=1378587), longer-running tasks are best moved to the main thread.

## Alarm API

The [**Alarm API**](https://developer.kaiostech.com/docs/api/web-apis/alarm/alarm/) wakes up the phone at a specified time. The OS dispatches system messages to an app with both the [`alarm` permission]({{< ref "kaios-permissions#alarms" >}} "alarm permission") and `alarm` message declared in manifest.webapp. The Alarm API is accessible via the `navigator.mozAlarms` (KaiOS 2.5) and `navigator.b2g.alarmManager` (KaiOS 3.0).

ℹ️ <u>Important</u>: unlike the RequestSync API, **alarms do not have timeouts**. If you use the Alarm API for background synchronization, it's important to call `window.close` to terminate your application once completed.

Apps first need to declare the permission and message in their manifest:

```json
"permissions": {
    "alarms": { },
},
"messages": [
    { "alarm": "/index.html" }
]
```

### Registering for Notifications

Then register for incoming system messages via `navigator.mozSetMessageHandler`, or `navigator.mozSetMessageHandlerPromise` if they want to wait until some asynchronous process is completed. On KaiSO 3.0, you need to register a ServiceWorker than subscribe for the `alarm` systems messages.

```js
// KaiOS 2.5
navigator.mozSetMessageHandler('alarm', (mozAlarm) => {
    console.log('alarm fired:', JSON.stringify(mozAlarm.data));
});

// KaiOS 3.0
navigator.serviceWorker.ready.then(() => {
    registration.systemMessageManager.subscribe('alarm');
});
```

### Adding Alarms

Finally, the app then needs to set an alarm at a specific time:

```js
let tomorrow = new Date();
tomorrow.setMinutes(0);
tomorrow.setSeconds(0);
tomorrow.setDate(new Date().getDate() + 1);

let data = { timestamp: tomorrow.valueOf() };

// KaiOS 2.5, returns DOMRequest
navigator.mozAlarms.add(
    tomorrow,
    'honorTimezone',
    data
);

// KaiOS 3.0, returns Promise
navigator.b2g.alarmManager.add({
    date: date,
    data: data,
    ignoreTimezone: false,
});
```

The first parameter is the `Date` for the alarm to trigger, the second is an enum to `honorTimezone` or `ignoreTimezone`, and the third `data` parameter is optional, and must be JSON-serializable.

**Honoring timezones** means that the alarm remains the same in UTC Coordinated Universal Time. If the alarm was set for 1PM Pacific Standard Time (PST) but the user has travelled to the east coast, it will run at 4PM Eastern Standard Time (EST).

**Ignoring timezones** means that the alarm remains at __the same time of day__. If the alarm was set for 1PM Pacific Standard Time (PST), it will also run at 1PM Eastern Standard Time (EST).

### Getting and Removing Alarms

You can get a list of all the alarms that **your app set** using `getAll`. It returns a `Promise` or `DOMRequest` that resolves to an Array of objects, each with an `id` property unique to that alarm.

```js
// KaiOS 2.5, returns DOMRequest
navigator.mozAlarms.getAll();

// KaiOS 3.0, returns Promise
navigator.b2g.alarmManager.getAll();
```

You can remove the alarm with `remove` by passing the alarm `id` as the parameter. These methods return `void`, so there's no need to wait or check their results.

```js
// KaiOS 2.5
navigator.mozAlarms.remove(alarm.id);

// KaiOS 3.0
navigator.b2g.alarmManager.remove(alarm.id);
```

### Alarm API Use Cases

One downside of the Alarm API is that you don't have information on the device state, so if you need internet access and your alarm triggers when internet is unavailable, you'll have to alert the user (likely with a notification) and try again later. I have also found that it can be unreliable when setting intervals, with alarms not running at the time set or not running at all.

**Intervals**: apps can set multiple alarms, so to replicate regular intervals (i.e. daily, weekly) they can set an alarm for every day in the next X months, or when triggered, set an alarm for the next day. For an example of this, check out my [Daily Bing Wallpaper](https://github.com/Tombarr/bing-wallpaper-kaios) app.

**What it's good for?** The Alarm API is good for waking up the device and launching your app at a specific time (i.e. an alarm clock). With a bit more effort, it can also be used for periodic background polling (i.e. auto-update, checking for new emails).

<u>Note</u>: the Alarm API is only available on **privileged** packaged apps, and excessive use will drain the battery. It's available based on the `dom.mozAlarms.enabled` device preference, which is enabled by default.

## Request Sync API

The final approach executing background tasks on KaiOS is the **Request Sync API**. Note that is **only works on KaiOS 2.** (was removed in KaiOS 3.0) and requires the app be **[certified]({{< ref "certified-apps" >}} "certified")**. Since there's more book keeping involved, and the RequestSyncService needs to obtain a `cpu` wakelock for tasks, RequestSync may drain the battery more than the Alarm API.

That said, it's a fairly simple API and, in my experience, has proved **more reliable than the Alarm API**. The [RequestSync API](https://bugzilla.mozilla.org/show_bug.cgi?id=1018320) was originally introduced in Boot2Gecko (B2G) as a background sync schedule for the email app to periodically poll for new email messages. It was meant as a substitute for the [BackgroundSync API](https://developer.mozilla.org/en-US/docs/Web/API/Background_Synchronization_API), which is only available for installed Progressive Web Apps (PWAs) and Firefox has not implemented to this day.

ℹ️ <u>Important</u>: because the RequestSync API is meant for background synchronization, it has a _minimum_ internal of 100 seconds (customizable via `dom.requestSync.minInterval`), and a **_timeout_ of 2 minutes** (customizable via `dom.requestSync.maxTaskTimeout`).

In your manifest.webapp, declare the [`requestsync-manager` permission]({{< ref "kaios-permissions#certified" >}} "requestsync-manager") and the `request-sync` message.

```json
"permissions": {
    "requestsync-manager": { },
},
"messages": [
    { "request-sync": "/index.html" }
]
```

<u>Note</u>: the RequestSync API is available behind the `dom.requestSync.enabled` device preference, which is enabled by default on KaiOS 2.5.

### Register Tasks

Registering RequestSync tasks is done via the `navigator.sync` API.

```js
let taskName = 'myapp-dailytask';

// KaiOS 2.5 only, returns Promise
return navigator.sync.register(taskName, {
    minInterval: 60 * 60 * 24, // 1 day, in seconds
    oneShot: false, // run repeatedly
    wifiOnly: false, // run with or without WiFi
    wakeUpPage: location.href // launch this page
});
```

In this example, we run a task daily. When the app launches, we register the task in the background like in my app [Quotez](https://github.com/Tombarr/quotez).

### Unregister Tasks

Tasks can also be unregistered easily via task name.

```js
let taskName = 'myapp-dailytask';

// KaiOS 2.5 only
navigator.sync.unregister(taskName);
```

### Enumerating Tasks

You can easily enumerate all tasks that your app registered. This resolves to an Array of task objects with all the same configuration parameters, as well as some metadata on execution history.

Here is a snippet of the WebIDL definition for a RequestSync Task:

```ts
interface RequestSyncTask {
  // This object describes the app that is owning the task.
  readonly attribute RequestSyncApp app;

  // These attributes are taken from the configuration of the task:
  readonly attribute USVString task;
  readonly attribute DOMTimeStamp lastSync;
  readonly attribute USVString wakeUpPage;
  readonly attribute boolean oneShot;
  readonly attribute long minInterval;
  readonly attribute boolean wifiOnly;
  readonly attribute any data;

  Promise<void> runNow();
}
```

Enumerating all registration is simple:

```js
navigator.sync.registrations()
    .then((registrations) => {
        if (Array.isArray(registrations) && registrations.length) {
            // Registrations are present
        }
    });
```

<u>Note</u>: it's a good idea to check if you've already registered the tasks, to avoid double registration.

**What it's good for?** For certified apps targeting KaiOS 2.5 only: running tasks at specific intervals (i.e. daily) or only running tasks when WiFi is available.

<table class="table" style="table-layout: fixed">
<thead>
<tr>
<td></td><td><b>ServiceWorker</b></td><td><b>Alarm</b></td><td><b>RequestSync</b></td>
</tr>
</thead>
<tbody>
<tr>
<td>Type</td><td>Push Notification</td><td>One-Off Alarm</td><td>Sync Intervals</td>
</tr>
<tr>
<td>Trigger</td><td><code>push</code> event</td><td><code>alarm</code> system message</td><td><code>request-sync</code> system message</td>
</tr>
<tr>
<td>Min Permission</td><td>Hosted</td><td>Privileged</td><td>Certified</td>
</tr>
<tr>
<td>Timeout</td><td>30 seconds</td><td>N/A</td><td>2 minutes</td>
</tr>
<tr>
<td>Scope</td><td><a href="https://developer.mozilla.org/en-US/docs/Web/API/ServiceWorkerGlobalScope" rel="external noopener">SW Global Scope</a></td><td><a href="https://developer.mozilla.org/en-US/docs/Web/API/Window"rel="external noopener">Window (2.5)</a><br /><a href="https://developer.kaiostech.com/docs/sfp-3.0/api/next-new-apis/b2g/alarmManager/navigator-b2g-alarmManager/" rel="external noopener">SW (3.0)</a></td><td><a href="https://developer.mozilla.org/en-US/docs/Web/API/Window"rel="external noopener">Window</a></td>
</tr>
<tr>
<td>Works Offline?</td><td>X</td><td>☑️</td><td>☑️</td>
</tr>
<tr>
<td>WiFi-Only Option?</td><td>X</td><td>X</td><td>☑️</td>
</tr>
<tr>
<td>KaiOS 2.5</td><td>☑️</td><td>☑️</td><td>☑️</td>
</tr>
<tr>
<td>KaiOS 3.0</td><td>☑️</td><td>☑️</td><td>X</td>
</tr>
</tbody>
</table>

## Conclusion

Despite hardware constraints, background task execution is available in KaiOS. In fact, it's an important component of certain services like the Email app, which needs to poll for new email messages without the user opening the app. If you're looking for a partner to ensure the best user experience and deliver background synchronization on KaiOS, you can find the author's contact info on the [About]({{< ref "about" >}} "About") page.
