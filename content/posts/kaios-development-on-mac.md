+++
title = "Developing for KaiOS on Mac"
description = "Developing KaiOS apps on Mac (updated for Ventura 13.2)"
date = 2023-02-12T00:00:00+08:00
toc = true
draft = false
header_img = "img/home-alt.png"
tags = ["KaiOS", "Mac", "Ventura", "OS X", "Development"]
categories = []
series = ["Getting Started"]
+++

Developing KaiOS apps on Mac (updated for Ventura 13.2)

## Getting Started

Developing and testing KaiOS apps on a real device using Mac is easy, and a great way to validate your apps on actual hardware. For setup, all you need is [`adb`](https://stackoverflow.com/questions/31374085/installing-adb-on-macos), WebIDE (a debug tool that used to come pre-packaged with Firefox), and a [debug-enabled KaiOS device](https://sites.google.com/view/bananahackers/development/debug-mode) like the [Nokia 8110 4G](https://www.nokia.com/phones/en_int/nokia-8110-4g?sku=16ARGYW1A09).

### Waterfox Classic

According to the [KaiOS ENV Setup](https://developer.kaiostech.com/docs/getting-started/env-setup/os-env-setup#macos) guide, Firefox 59 is recommended for KaiOS development. However, as of Mac Ventura 13.2, Firefox 59 has a fatal crash on startup. Since Firefox 59 stopped working on Mac Ventura, **the best choice for KaiOS development on Mac is [Waterfox Classic](https://classic.waterfox.net/)**. Waterfox Classic is a legacy web browser for older systems and with WebIDE, XPCOM and XUL extensions, and numerous [unpatched security advisories](https://github.com/WaterfoxCo/Waterfox-Classic/wiki/Unpatched-Security-Advisories). Perfect for KaiOS development, but not recommended as your default web browser.

<u>FYI</u>: [Pale Moon v28.6.1](https://archive.palemoon.org/palemoon/28.x/28.6.1/) is another alternative that some developers use.

### WebIDE

![WebIDE in Waterfox Classic](/img/waterfox-classic.png "WebIDE in Waterfox Classic")

<u>Note</u>: the list of "Runtime Apps" on the left sidebar is only visible for devices with  unrestricted DevTools privileges.

WebIDE will feel instantly familiar to any web developer. By default, the "Debug App" tool includes the following tabs:

* Inspector
* Console
* Debugger
* Style Editor
* Performance
* Memory
* Network
* Storage

⚠️ <u>Warning</u>: often the "Storage" causes KaiOS, Waterfox, or both to crash!

These tabs work similarly to Firefox's Web Developer Tools, only you're debugging the windows on your KaiOS device. Inspector lets you select and modify elements in the DOM, Console lets you execute JavaScript, and Network lets you monitor HTTP requests from XHR, WebSockets, Images, etc. On the right sidebar there's several options, but most importantly there is a button to take Screenshots.

Recall that KaiOS has two app types: **packaged apps** and **hosted apps** (details in [KaiOS Ecosystem]({{< relref path="kaios-ecosystem.md" >}} "KaiOS Ecosystem")). The left sidebar includes buttons to "Open Packaged App" and "Open Hosted App." "Open Packaged App" will open a file navigation dialog where you can select the root folder of a packaged app containing the `manifest.webapp` file. "Open Web App" will open a dialog with an input for a remote manifest URL, i.e. https://myawesomeapp.com/manifest.webapp.

![Open Hosted App in Waterfox Classic](/img/waterfox-open-hosted-app.png "Open Hosted App in Waterfox Classic")

## Conclusion

It's easy debugging KaiOS apps with Waterfox Classic. Unlike Firefox 59, it works well with Apple Silicon (i.e. M1) and there's no need to modify browser preferences in `about:config` or install XPI extensions. Once you're able to debug a Hello, World app, you can begin development using your favorite IDE like Visual Studio Code, Atom, Sublime, Vim, etc. For packaged apps, there's no equivalent to [Browserify](https://browserify.org/) for hot-reloading, but it's straightforward enough to press the "Install and Run" button to test new builds.

Developing for KaiOS is very similar to developing web applications, just on 240x320 displays and devices with limited storage and memory. If necessity is the mother of invention, then KaiOS warrants invention from developers fitting modern experiences on tiny screens.