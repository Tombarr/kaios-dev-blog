+++
title = "Special Keys on KaiOS"
description = "Handle special keys (soft keys, volume, camera) on KaiOS"
date = 2024-02-13T00:00:00+08:00
lastmod = 2024-02-13T00:00:00+08:00
toc = true
draft = false
header_img = "img/home-alt.png"
tags = ["KaiOS", "Keyboard", "Keys", "Camera", "Soft Keys"]
categories = []
series = ["Getting Started"]
+++

Handle special keys (soft keys, volume, camera) on KaiOS

**Why it matters**. A great user experience on KaiOS starts with directional navigation and proper keyboard handling.

**Dive deeper**. Not all devices support the same hard keys, and while most have a T9 layout, some like the [JioPhone 2]({{< ref "whats-next-jiophone#jiophone-2" >}} "JioPhone 2") have full QWERTY keyboards.

## Special Keys

| Key               | Key Code | Code		    | Description	      |
|-------------------|-------|-------------------|---------------------|
| SoftLeft          | 0     | F13               | Left Soft Key (LSK), typically performs action |
| SoftRight         | 0     | F15               | Right Soft Key (RSK), typically opens options menu |
| MicrophoneToggle  | 0     | N/A               | Launch the Voice Assistant (VA) via `voice-assistant` [Web Activity]({{< ref "./web-activities" >}}) |
| Enter             | 13    | Home              | Select the currently-focused element |
| Backspace         | 8     | KeyB              | Go to previous page |
| GoBack            | 0     | N/A               | Go to previous back (KaiOS Smart Touch only) |
| BrowserBack	    | 0     | N/A               | Go to previous page (web browser only) |
| VolumeUp          | 182   | AudioVolumeUp     | Raise volume        |
| VolumeDown        | 183   | AudioVolumeDown   | Lower volume        |
| Call              | 0     | N/A               | Launch the call screen or accept current action |
| EndCall           | 95    | Power             | Cancel the current action or close app |
| Power             | 95    | Power             | Toggle screen on/ off; long-press to power down |
| Camera            | 0     | N/A               | Open Camera app |
| HeadsetHook       | 0     | N/A               | Open Music app |
| LaunchWebBrowser  | 0     | F14               | Launch Browser app  |
| LaunchMail		| 0     | N/A               | Launch Email app |
| Message   		| 0     | KeyA              | Launch SMS app |
| Notification		| 0     | N/A               | Open Notification panel |
| Symbol		    | 224   | F17               | Toggle symbol input (i.e. #, *, -, +, @, etc) |

Always use the [`KeyboardEvent#key`](https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/key) property, as many keys lack a `keyCode`, and the `code` property changes based on keyboard layout and device configuration. Keep in mind that many keys are limited to certain devices, although _every_ KaiOS device has d-pad navigation as well as LSK and RSK.

<u>Pro Tip</u>: use [Feature Detection]({{< ref "./feature-detection" >}} "Feature Detection") to check if the device has hardware camera or volume buttons.

### Using Special Keys

Here are a few ideas for how to use special keys:

**Volume**

* For an eReader app, scroll the page up or down
* For an image gallery, zoom in or out
* For a calendar app, toggle day/ week/ month view

**Soft Keys**

* For a game, perform an action like `A` or `B` buttons
* For an image gallery, pan the image right or left
* For an app, open options or launch search page

<u>Warning</u>: Never block the user from leaving your app. Although KaiOS allows apps to intercept important navigational keys like `Backspace` and `Power`, users can typically long-press these keys to terminate your app.

### Voice Assistant

There is one setting, `voice-assistant.enabled`, and two device preferences, `dom.microphonetoggle.supported` and `dom.microphonetoggle.hardwareKey`, that control the Voice Assistant (VA). Typically long-pressing `Enter` will trigger the `MicrophoneToggle` event, launching the `voice-assistant` activity that includes a single data element, `from`, that is either `Homescreen`, `System`, or the name of the app or website that the user was on before triggering the VA.

## Conclusion

It's easy to overlook special keys, but directional navigation and soft keys are important at delivering a top-notch user experience on KaiOS. If you need support adapting your website or PWA for easy navigation on KaiOS, contact the author from the [About]({{< ref "about" >}} "About") page.
