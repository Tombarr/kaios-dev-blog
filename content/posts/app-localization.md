+++
title = "Localization for KaiOS Apps"
description = "Best practices for localization and translation of KaiOS Apps"
date = 2023-11-07T00:00:00+08:00
lastmod = 2023-11-07T00:00:00+08:00
toc = true
draft = false
header_img = "img/home-alt.png"
tags = ["KaiOS", "Localization", "Translation", "L10n"]
categories = []
series = ["Getting Started"]
+++

# Localization (L10n) for KaiOS Apps

![PodLP Localization in Arabic, English, and Hindi](/img/podlp-localization.png "PodLP Localization in Arabic, English, and Hindi")

**Why it matters?** KaiOS is available in [over 100 countries](https://developer.kaiostech.com/docs/introduction/history/), with top demographics in India, United States, Nigeria, Tanzania, and Uganda. Localization facilitates market entry, improves user experience, and increases retention.

## How it Works

Localization isn't an outcome, it's a process of adapting your application to specific markets. It includes many elements like:

* **Translating** content into multiple languages (i.e. English and Hindi)
* **Formatting** units like time, date, currency, and phone numbers according to regional standards (i.e. MM/DD/YYYY in Europe, DD/MM/YYYY in US)
* **Supporting** regional payment methods (i.e. UPI in India, M-Pesa in Kenya)
* **Aligning** content directionality according to linguistic standards (i.e. LTR for English, RTL for Arabic)
* **Selecting** appropriate symbols, iconography, and colors based on cultural contexts
* **Encoding** content in UTF-8 and ensuring fonts support all required languages

This article will focus on the technical considerations specific to KaiOS, and offer a few options for each to help inform your localization strategy.

## Translation

Translation is a key component of localization. When I first launched [PodLP](https://podlp.com/) on the JioStore in India, it was only available in English. The result was user attrition. Fortunately fast-follow updates included translations in Hindi, Bengali, Marathi, Telugu, Tamil, Gujurati, and more.

An easy and affordable way to translate your app is with [Fiverr](https://www.fiverr.com/pe/velmNq). For just $5-20 per language, you can have all content within your app translated to many of the world's most common languages. Once you have your strings translated, the next task is to present this in the UI.

**Pro Tip**: if you're developing a new app, **do not hardcode strings** within code! Separate content and code from the start so it's easy to translate later.

### System Language

There are several ways to detect the user-selected system language. In JavaScript, there are the [`navigator.language`](https://developer.mozilla.org/en-US/docs/Web/API/Navigator/language) and [`navigator.languages`](https://developer.mozilla.org/en-US/docs/Web/API/Navigator/languages) properties as well as the [`languagechange` event](https://developer.mozilla.org/en-US/docs/Web/API/Window/languagechange_event). There's also the [`Accept-Language`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Accept-Language) HTTP header.

Within your application, you can define the content language using the [`lang`](https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes/lang) HTML attribute, [`:lang`](https://developer.mozilla.org/en-US/docs/Web/CSS/:lang) CSS selector, and [`Content-Language`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Language) HTTP header.

<u>**Best Practice**</u>: default your application to _match the system language_, if available, but let the user _override within your app_ because multi-lingual users may prefer one language for a variety of reasons.

### String Storage

There are two main ways to store translated strings: on device and remotely. Each has it's advantages and disadvantages.

**Local string storage** (bundled within your app)

* 👍 No internet access needed
* 👍 No server required
* 👍 No bandwidth cost ($$)
* 👍 Prohibits tampering
* 👎 Changing requires update
* 👎 Bloats package size

Within locally-stored strings there are two options: static and dynamically loaded. Static loading is when strings get packaged inline with your JavaScript bundle. Dynamic loading is when strings are loaded via AJAX from within your app bundle. For larger applications, dynamic loading uses less memory by only loading the user-selected language, and ensures proper separation of content and code.

**Remote string storage** (fetched from server)

* 👍 Change without update
* 👍 Smaller package size
* 👍 Usage analytics (request count)
* 👎 Initial fetch requires internet
* 👎 Web server required

<u>**Best Practice**</u>: store strings remotely when possible, using static file hosting and global Content Delivery Networks (CDNs) like [Cloudflare Pages](https://pages.cloudflare.com/). Cache requests locally for when the user is offline.

## Formatting

It's important to format numbers, dates, times, and currencies according to linguistic expectations to reduce confusion and cognitive burden on the user. For KaiOS 3.0, the ECMAScript Internationalization API under the [`Intl`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl) namespace is the easiest option. Unfortunately, the majority of KaiOS devices run 2.5 and have poor support for `Intl`. For KaiOS 2.5, use appropriately-sized formatting libraries like [Day.js](https://day.js.org/) to automatically localize quantities to the user-selected language.

<u>**Warning**</u>: popular packages like [moment.js](https://bundlephobia.com/package/moment@2.29.4) are ~300kB unminified. For fast loading and smaller package sizes, it's best to **avoid large dependencies**.

## Layout & Alignment

For certain languages like Arabic, it's important to ensure your application can be [mirrored](https://blog.prototypr.io/mirroring-how-to-design-for-arabic-users-a1dbcd3aa566) to allow users to perceive progression and forward movement from right to left. When images are floated left of text, it means this is flipped. This also applies to certain (but not all!) iconography.

The [`dir`](https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes/dir) HTML attribute and [`direction`](https://developer.mozilla.org/en-US/docs/Web/CSS/direction) CSS property are the primary way of expressing direction within a KaiOS app. Here's a few tips to help ensure your application can be mirrored effectively:

* Prefer [block and inline layout](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_flow_layout/Block_and_inline_layout_in_normal_flow) properties (i.e. `padding-inline-start` instead of `padding-left`). These automatically flip with layout direction
* Use flexible layouts like flexbox instead of fixed layouts like tables
* Position elements using relative metrics
* Use `transform: scale(-1, 1)` to flip symbols and icons when needed

**Pro Tip**: as a first step, grep your code for padding, margin, borders, and layouts defined using `top`, `right`, `bottom`, and `left`. Replace them with `block-start`, `inline-end`, `block-end`, and `inline-start`, respectively.

## Symbols & Icons

There are a variety of free icons available. While it's tempting to pick easy solutions [Font Awesome](https://fontawesome.com/), these bloat package size when often you only need a handleful of icons. A better option is to use standard Gaia Icons available as individual [SVGs](https://github.com/why19861124/gaia-icon/tree/master/images) for a [TTF Font](https://github.com/Cwiiis/gaia-icons/blob/master/fonts/gaia-icons.ttf). These icons will be familiar to KaiOS users because they are used in most pre-installed system applications.

**SVGs**

* 👍 Scale well
* 👍 Smaller package size (if you only need a few icons)
* 👍 Styled via CSS
* 👍 Can be animated
* 👍 Accessible (with alt text)
* 👎 Harder to use

Keep in mind, SVGs can be made easier to use with [SVG Symbols](https://developer.mozilla.org/en-US/docs/Web/SVG/Element/symbol). This effectively allows you to define an SVG icon once and use it many times like `<svg><use href="#my-icon"/></svg>`.

<u>**Pro Tip**</u>: use an SVG optimizer like [SVGO](https://github.com/svg/svgo) to minify SVGs by removing unnecessary attributes and tag metadata, hidden elements, and non-optimal values.

**Font Icons**

* 👍 Scale well
* 👍 Easy to use
* 👍 Accessible
* 👎 Larger bundle size
* 👎 Limited customization beyond color and size
* 👎 [Flash of unstyled text (FOUT)](https://fonts.google.com/knowledge/glossary/fout) when loading

For best performance, bundle icon fonts with your application's ZIP file, [compress fonts](https://web.dev/articles/reduce-webfont-size) using formats like WOFF and [optimally load](https://web.dev/articles/optimize-webfont-loading) them to reduce FOUT.

## Conclusion

Localizing applications for the many markets that KaiOS is available to is a complex undertaking. Localization goes far beyond translation. If you need an experienced partner to guide your KaiOS localization, contact the author from the [About]({{< ref "about" >}} "About") page.
