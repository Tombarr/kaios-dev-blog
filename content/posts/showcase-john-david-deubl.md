+++
title = "Swiss Bike Courier Turned KaiOS Developer"
description = "Learn about John-David Deubl's journey as a bike messenger and KaiOS developer"
date = 2024-03-20T00:00:00+08:00
lastmod = 2024-03-20T00:00:00+08:00
toc = true
draft = false
header_img = "img/strukturart-banner-kaios.png"
tags = ["KaiOS", "Developer", "Showcase"]
categories = []
series = ["Case Study"]
[params]
  featured_img = "img/strukturart-banner-kaios.png"
+++

## About John-David Deubl

[John-David Deubl](https://strukturart.com), who goes by the aliases [perry](https://www.reddit.com/user/perry_______/) and [strukturart](https://github.com/strukturart) on GitHub, is a graphic designer, bike messenger, and an early KaiOS developer. John-David began programming for smart feature phones in 2020 out of a personal interest to combat his smartphone addiction. All of John-David's apps are open source available under the [MIT License](https://github.com/strukturart/feedolin/blob/master/LICENSE.md).

---

### How did you get started with KaiOS?

I am a bicycle messenger, programmer, and designer. I came to KaiOS in 2020 because, after years of using my smartphone, I noticed an addiction that was limiting me. With the limited possibilities of a feature phone, I am more independent again. Since some system apps in KaiOS are not fully optimized for use with a feature phone, I started writing and publishing some apps myself.

### What technologies do you use for KaiOS development?

I use [Mithril.js](https://mithril.js.org/) because it is a very easy to learn framework with a very active community. I also use [Parcel](https://parceljs.org/) as a bundler, VSCodium for an IDE, and [Waterfox Classic]({{< ref "./kaios-development-on-mac#waterfox-classic" >}}) to install apps. My development devices including the [Nokia 8110 4G](https://amzn.to/49Bvi7S) and [Nokia 2780 Flip](https://amzn.to/3Tjhppi).

### What is your first KaiOS app?

My first app on the KaiStore was [feedolin](https://kaios.app/apps/d6s6Wn8x2RwFvWaz11Xw), an RSS feed reader, which I wrote so that I could continue to read news on the go. At first I only published my applications on the BananaHackers store because the obligation to display KaiAds advertising in the apps really bothered me. But now I have found a way to display advertising in a less dominant view, which KaiOS accepts.

### What other KaiOS apps have you published?

I've published [5 apps](https://kaios.app/developers/strukturart) on the KaiStore including:

* [feedolin](https://kaios.app/apps/d6s6Wn8x2RwFvWaz11Xw): RSS/Atom reader and Podcast player, Youtube player (Channels), and all content that is otherwise published via RSS/Atom
* [o.map](https://kaios.app/apps/MlipXQ2U5VCkmkPXxDpy): map app with the super power of openstreetmap (favorite)
* [passport](https://kaios.app/apps/wkl_u74jPnyHuTXBmBrV): file viewer, with extras
* [parrot](https://kaios.app/apps/hDAcxW9NNCCVxFKzvJPz): T9 vocabulary editor
* [greg](https://kaios.app/apps/KEhiSJT4sSbVzJz2_z_T): an easy to use calendar app

Beyond apps that I developed, I use WhatsApp and [PodLP](https://podlp.com). Both apps have a well-thought-out UI/UX, the design is simple, and the screen size is adapted to the KaiOS devices.

### How do you pick what app to build next?

My next app is [flop](https://github.com/strukturart/flop), a peer-to-peer (P2P) messenger app.

I've wanted to write an interface for a messenger app for a long time, I first thought of Signal but I couldn't find an easy-to-understand JS library. That's when I came across [PeerJS](https://peerjs.com/), which greatly simplifies Web Real-Time Communication (RTC) and they offer a free PeerJS server.

I still have to wait for the feedback from the users as to whether WebRTC was a good idea, because in order for the users to be able to connect they have to exchange their peer ID. At the moment I'm using a URL and [Web Activities]({{< ref "./web-activities" >}}) to accomplish this, which makes it a bit complicated to do spontaneously communicate. If the app doesn't have much success, I'll probably switch to XMMP, which makes it easier to establish contact between two users. Let's see.

### What advice would you give to a new KaiOS developer?

Try to **solve as much as possible with HTML and CSS**, look at all (really _all_) HTML elements. There is one for almost every need. Make it as easy as possible for the user to enter data via helpful tools like QR codes. It's an advantage if you also use KaiOS in your daily life, at least that's how I noticed most of the bugs and came up with improvements.

### Is there anything you would do differently?

**Don't be afraid of frameworks** and use Mithril.JS.

### What's your favorite KaiOS phone?

The [Nokia 800 Tough](https://amzn.to/3Tkeblx). It is almost indestructible, the buttons are easy to use, and you can even use the device to open a beer!

### What achievements are you most proud of?

I'm proud that I understood that:  `i.view = !i.view`; (AKA toggle), and that **I belong to a small KaiOS dev community**, which is probably responsible for the fact that KaiOS still exists.

### What do you do outside of KaiOS apps?

I love outdoor sports like climbing and gravel biking and in winter I practice Aikido.

### Where can we learn more about you and your work?

You can find me on my websites, [strukturart.com](https://strukturart.com) and [kawumba.ch](https://kawumba.ch), as well as my GitHub, [github.com/strukturart/](https://github.com/strukturart/).

---

This case study was provided by John-David Deubl without compensation. John-David is an early KaiOS adopter and developer, selecting KaiOS as a form of digital detox to combat his smartphone addiction. John-David is based in Switzerland and all of his applications are available free and open source.

<u>Affiliate Disclosure</u>: Some links above are affiliate links. This means that, at no cost to you, I may earn affiliate commission if you click the link and finalize a purchase, which supports this blog financially.
