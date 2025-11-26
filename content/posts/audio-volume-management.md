+++
title = "Audio and Volume Control in KaiOS"
description = "Controlling volume and audio channels on KaiOS"
date = 2023-03-09T00:00:00+08:00
lastmod = 2023-06-10T00:00:00+00:00
toc = true
draft = false
header_img = "img/home-alt.png"
tags = ["KaiOS", "Audio", "Volume", "Music"]
categories = []
series = ["Getting Started"]
+++

# Controlling volume and audio channels on KaiOS

## Getting Started

All KaiOS phones come with a built-in speaker, microphone, and headphone jack. Additionally, most KaiOS phones come with Bluetooth and support for A2DP. Yes, that means you can connect a KaiOS phones to Apple AirPods!

Similar to Android, KaiOS enables app developers to build rich multimedia experience with the Audio Channels, Volume Manager, and Speaker Manager APIs. These collectively allow apps to control volume, known when headphones are unplugged, and force audio output through built-in speakers. KaiOS supports many common [Media Formats](https://wiki.mozilla.org/Firefox_OS/MultimediaPlatform/MediaFormats) including:

* audio/webm
* audio/mp4
* audio/mpeg
* audio/ogg
* audio/3gpp
* audio/x-scpls
* audio/opus

## Audio Channels

KaiOS creates a hierarchy of importance for app audio content using the **Audio Channels API**. This determines when audio will be paused and resumed in response to other audio playback (i.e. a notification received), and allows you to control the volume of different types of audio independently. Although KaiOS does not offer true multitasking, Audio Channels are what enables **background audio playback**.

Apps require permission to use specific audio channels. Below is a list of the available audio channel levels, along with that app types they are allowed on. Permissions start with the prefix `"audio-channel-"`, for instance `"audio-channel-content"` for the Content channel.

| Audio Channel | Web<br />PWA     | Privileged<br />Signed | Certified<br />Core |
|--------------|-----------|------------|------------|
| normal | ☑️        | ☑️        |  ☑️        |
| content | ☑️        | ☑️        |  ☑️        |
| notification | X        | ☑️        |  ☑️        |
| alarm | X        | ☑️        |  ☑️        |
| system | X        | ☑️        |  ☑️        |
| ringer | X        | X        |  ☑️        |
| publicnotification | X        | X        |  ☑️        |

Once permission is granted, audio channels can be controlled app-wide.

```js
// KaiOS 2.5
navigator.mozAudioChannelManager.volumeControlChannel = 'content';

// KaiOS 3.0
navigator.b2g.audioChannelManager.volumeControlChannel = 'content'
```

Audio channels can also be set for specific media elements in HTML using the `mozAudioChannelType` property.

```html
<audio mozAudioChannelType="content" />
<video mozAudioChannelType="content" />
```

Audio channels can also be controlled in JavaScript for `HTMLMediaElement`s and `AudioContext`s using the same property.

```js
const audio = document.createElement('audio');
audio.mozAudioChannelType = 'content';
```

The `"content"` audio channel is probably the most important channel because it allows **background audio playback**. This means when the user pressed Back from your app's homepage, audio playback will continue. Playback will have priority over the `"normal"` channel, but will still get paused via the `"notification"` when a notification arrives.

The `"alarm"` audio channel is also useful for any app that plays sounds when an alarm is triggered. This ensures a wake up alarm paused `"content"` playback until the alarm is dismissed.

## Volume Manager API

Although KaiOS apps cannot control the system volume directly, volume can be controlled for specific elements using [`HTMLMediaElement.volume`](https://developer.mozilla.org/en-US/docs/Web/API/HTMLMediaElement/volume). Additionally, apps with the `"volumemanager"` permission (only available for Privileged and Certified apps), can trigger the heads up display (HUD) that allows the user to raise or lower the **active volume channel**.

![KaiOS Volume HUD. Nokia 8110 4G (left), Orange Neva Mini (right)](/img/kaios-volume-hud.png "KaiOS Volume HUD. Nokia 8110 4G (left), Orange Neva Mini (right)")

On KaiOS 2.5 the **Volume Manager API** is very simple. Each method returns `void`, but triggers the HUD to display over your app. Unfortunately, you cannot configure the HUD style, which is different on different devices and OS versions.

```js
// KaiOS 2.5
navigator.volumeManager.requestUp();
navigator.volumeManager.requestDown();
navigator.volumeManager.requestShow();
```

Once the HUD is displayed, it's important to limit what `KeyEvent`s your app responds to `KeyUp` and `KeyDown` using a resetting `setTimeout` of **2 seconds**. That's because on older versions of KaiOS 2.5, the System app does not take full focus. Without this, the user might inadvertently shift focus and navigate within your app while only intending to change volume.

Why 2 seconds? From my research, this constant within SoundManager is consistent across all devices I have tested.

```js
SoundManager.HIDE_SOUND_DELAY = 2000;
```

The API for KaiOS 3.0 offers the same three methods (only renamed, i.e. `requestVolumeUp` instead of `requestUp`), but requires lots of scaffolding to access `lib_audiovolume.AudioVolumeManager`. See [AudioVolumeManager service](https://developer.kaiostech.com/docs/sfp-3.0/api/next-new-apis/daemon-api/audiovolumemanager/daemon-api-audiovolumemanager/) for how to use api-daemon on KaiOS 3.0.

![Volume Settings Page](/img/volume-settings.png "Volume Settings Page")

<u>Note</u>: **some KaiOS phones do not have volume buttons**, so it's important to offer volume controls within your app! One alternative that doesn't require special permissions is to use Web Activities to launch the Volume page within the Settings app.

```js
// KaiOS 2.5
let request = new MozActivity({
    name: "configure",
    data: {
        target: "device",
        section: "volume"
    },
});

// KaiOS 3.0
let activity = new WebActivity("configure", {
    target: "device",
    section: "volume"
});
activity.start();
```

## Headphones

On KaiOS it's possible to check if headphones are plugged in or not. This allows a podcast or music streaming app like [PodLP](https://podlp.com) to automatically pause playback when headphones come unplugged to avoid accidentally continuing playback on the device's default speaker.

```js
// KaiOS 2.5
if (navigator.mozAudioChannelManager.headphones) { /* TODO */ }
navigator.mozAudioChannelManager.onheadphoneschange = () => {
    /* TODO */
};

// KaiOS 3.0
if (navigator.b2g.audioChannelManager.headphones) { /* TODO */ }

navigator.b2g.audioChannelManager.onheadphoneschange = () => {
    /* TODO */
};
```

## Speaker Manager

It's also possible to force audio play through the device's built-in speakers using the **Speaker Manager API**, available via global constructors.

```js
// KaiOS 2.5
const speakerManager = new SpeakerManager();

// KaiOS 3.0
const speakerManager = new MozSpeakerManager();

if (speakerManager.speakerforced) { /* TODO */ }
speakerManager.forcespeaker = true;
speakerManager.onspeakerforcedchange = () => { /* TODO */ };
```

![FM Radio App](/img/fm-radio-app.png "FM Radio App")

The main use case for the Speaker Manager API is building an FM Radio app. Most devices require headphones be plugged in to serve as the FM antenna, but users might still want to listen through built-in speakers.

<u>Note</u>: the Speaker Manager API is available via the `"speaker-control"` permission, and is only allowed in Privileged & Certified apps.

## Extras

### KeyEvents

KaiOS supports several [Media Keys](https://www.w3.org/TR/uievents-code/#key-media) for headphone media playback controls, including:

* `MediaTrackNext`
* `MediaTrackPrevious`
* `MediaPlay`
* `MediaStop`
* `MediaPause`
* `MediaPlayPause`
* `MediaFastForward`
* `MediaRewind`

These are defined in `b2g/chrome/content/shell.js`, and broadcast via the [System Messages]({{< ref "manifest-properties#messages-optional" >}} "System Messages") `headset-button` and `media-button`.

<u>Note</u>: Media KeyEvents may not work as expected in third-party apps for Bluetooth AVRCP media controls. The pre-installed Music & FM Radio apps always handle these events, which can trigger simultaneous audio playback.


### Autoplay

If you are developing a hosted web or progressive web app (PWA), then it's important to check if autoplay is enabled. KaiOS 2.5 has a special boolean property, `mozAutoplayEnabled`, that's true when autoplay is available.

```js
const audio = document.createElement('audio');
audio.muted = true;
if (audio.mozAutoplayEnabled) {
    /* TODO */
}
```

<u>Note</u>: Autoplay should be available by default for Privileged & Certified apps.

### Audio Capture

Recording audio using the standard [**MediaStream Recording API**](https://developer.mozilla.org/en-US/docs/Web/API/MediaStream_Recording_API/Using_the_MediaStream_Recording_API) requires the `"audio-capture"` permission, which will prompt the user to grant permission (except in Certified apps).

![Microphone Permission Dialog](/img/microphone-permission.png "Microphone Permission Dialog")

### Media Fragments

Like standard browsers, KaiOS supports [Media Fragments](https://www.w3.org/TR/media-frags/), including a few special identifiers. For the purposes of media playback, these can be used to adjust start time, allow temporal clipping using the Normal Play Time (NPT) format, and select specific tracks for playback. URL Fragments (aka URL Hash) are identified after the `#` character and are not sent server-side. Here is an example of a temporal media fragment:

```
https://www.example.org/audio.ogg#t=20
```

<u>Note</u>: For KaiOS media fragment parsing logic, see [nsMediaFragmentURIParser.cpp](https://github.com/kaiostech/gecko-b2g/blob/b2g48/netwerk/base/nsMediaFragmentURIParser.cpp).

### Seeking

Although not KaiOS specific, both it's worth mentioning that there is a method for seeking media content, [`HTMLMediaElement.fastSeek`](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/html/HTMLMediaElement.cpp#L1472) which seeks to the nearest keyframe (`SeekTarget::PrevSyncPoint`) rather than accurately seeking (`SeekTarget::Accurate`) to the specified timestamp.

```js
if ('fastSeek' in audio) {
    audio.fastSeek(time);
} else {
    audio.currentTime = time;
}
```

[Fast seeking](https://developer.mozilla.org/en-US/docs/Web/API/HTMLMediaElement/fastSeek) is available on Firefox, KaiOS, and Safari. It quickly seeks the media to the new time with precision tradeoff.

## Conclusion

KaiOS provides applications with several options for developing rich multimedia experiences. These are integral to developing quality user experiences for music and podcast apps like [PodLP](https://podlp.com), but can provide complex to manage across two OS versions. If you find these details daunting and need support developing top-notch multimedia experiences on KaiOS, contact the author from the [About]({{< ref "about" >}} "About") page.
