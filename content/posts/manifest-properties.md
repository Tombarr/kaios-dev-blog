+++
title = "Complete manifest.webapp Guide"
description = "Complete Guide to manifest.webapp Properties on KaiOS"
date = 2023-03-11T00:00:00+08:00
lastmod = 2024-01-31T00:00:00+08:00
toc = true
draft = false
header_img = "img/home-alt.png"
tags = ["KaiOS", "Manifest", "Security", "manifest.webapp", "manifest.webmanifest", "AndroidManifest.xml", "Info.plist"]
categories = []
series = ["Advanced Development"]
+++

# Complete Guide to manifest.webapp Properties

The complete guide to _every_ `manifest.webapp` property on KaiOS! This includes many undocumented but useful properties (like `userAgentInfo`) as well as properties only intended for system apps. The `manifest.webapp` file is a JSON-formatted document that contains important information about your app, including `version`, `name`, `description`, `icon`, `locales`, and more.

Most importantly, the app manifest contains the list of APIs, permissions, and dependencies that your app needs. It's analogous to `AndroidManifest.xml` for Android apps or `Info.plist` for iOS apps.

<u>Aside</u> from `manifest.webapp`, KaiOS 2.5 will also accept a packaged app with the file `manifest.json` instead (same format, different extension).

## manifest.webapp Properties

### `name` (**required**)

The human-readable `name` for the app. Maximum length is 20 characters (KaiStore) and 8 characters (JioStore).

```json
{
    "name": "PodLP"
}
```

### `display` (**optional**)

Similar to `name`, `display` if the human-readable name for the app that will be displayed within the Launcher app drawer.

```json
{
    "display": "PodLP"
}
```

### `version` (**required**)

A string that represents the app `version`. Format is integers separated by dots.

```json
{
    "version": "2.2.1"
}
```

<u>Note</u>: format is 3 digits for the KaiStore (i.e. `2.2.1`) and 4 digits for the JioStore (i.e. `2.2.1.0`).

### `subtitle` (**required**)

The subtitle that appears below app name in the KaiStore and JioStore. A compelling subtitle increases impressions and installs. Maximum length is 40 characters.

```json
{
    "subtitle": "Listen and subscribe to podcast"
}
```

### `description` (**required**)

The human-readable description that appears on the app detail page in the KaiStore and JioStore. Descriptions should be short and striking.

```json
{
    "description": "Discover, listen, and subscribe to podcasts from around the world for free. PodLP is designed specifically for KaiOS to be easy to use both online and offline."
}
```

### `type` (**optional**)

The app `type` that defines access to sensitive device APIs. Must be one of `web`, `hosted`, `privileged`, or `certified`. Defaults to `web`.

```json
{
    "type": "privileged"
}
```

### `launch_path` (**optional**)

The path within the app's bundle or origin loaded when the app starts. Defaults to `/index.html`.

```json
{
    "launch_path": "/index.html"
}
```

### `icons` (**required**)

An object of icon sizes to icon URIs, absolute from the app's origin. Icons must be square and in `.png` format. Icons can be animated ONGs and should have transparent backgrounds. KaiOS recommends a 8-10px transparent border for circle or rounded rectangle shapes with a 30% opacity drop shadow.

```json
{
    "icons": {
        "56": "/img/podlp-logo-56.png",
        "112": "/img/podlp-logo-112.png"
    }
}
```

<u>Note</u>: 56x56 and 112x112 are required for the KaiStore; an additional 84x84 icon is required for the JioStore.

### `categories` (**required**)

Your app's `categories` for placement within the KaiStore.

```json
{
    "categories": [
        "news",
        "entertainment"
    ],
}
```

Must be one of the following:

* `social`
* `games` (KaiStore only)
* `utilities`
* `life style`
* `entertainment`
* `health`
* `sports`
* `book/reference`
* `shopping` (KaiStore only)

<u>Note</u>: the JioStore catalogs Games in a separate app, JioGames, while the KaiStore includes a Games tab.

### `theme_color` (**optional**)

The app's theme color, used as the highlight color in the Launcher's app drawer. Must be in HEX format.

```json
{
    "theme_color": "#005665"
}
```

<u>Note</u>: this property key is `theme` on the JioStore.

### `developer` (**required**)

An object identifying the app's developer, including a human-readable name and URL. Displayed in the app detail page on the KaiStore.

```json
{
    "developer": {
        "name": "PodLP",
        "url": "https://podlp.com"
    },
}
```

### `cursor` (**optional**)

A boolean that enables the emulated cursor similar to the Browser app.

```json
{
    "cursor": false,
}
```

<u>Note</u>: for the best user experience, [don't use the emulated cursor]({{< ref "./do_and_dont#rely-on-emulated-cursor-navigation" >}} "don't use the emulated cursor"). Instead, use D-Pad navigation (`ArrowUp`, `ArrowDown`, `ArrowLeft`, `ArrowRight`) to change focus, similar to accessible web navigation.

### `fullscreen` (**optional**)

A boolean that determines whether to launch the app in full-screen mode (hides the `26px`-tall system status bar).

```json
{
    "fullscreen": false,
}
```

### `origin` (**optional**)

The `origin` field determines your app's `location.origin` at runtime. The `origin` value must start with the `app:` protocol and you must be the owner of the specified domain name. Defaults to an auto-generated UUID, i.e. `app://ff0a7f9f-8911-445b-a08c-d111a3347a4f`.


```json
{
    "origin": "app://podlp.com",
}
```

<u>Note</u>: only applies to `privileged` and `certified` packaged apps.

### `userAgentInfo` (**optional**)

Appends a string to the end of the `User-Agent` header went with _most_ requests, including XMLHTTPRequest, media elements (i.e. `img`, `audio`, and `video`), as well as document navigation.

```json
{
    "userAgentInfo": "PodLP/2.2.1",
}
```

<u>Note</u>: you can only append to the device `User-Agent`, you cannot replace it. `User-Agent` was considered a [forbidden header](https://developer.mozilla.org/en-US/docs/Glossary/Forbidden_header_name) that cannot be set in XMLHTTPRequest or Fetch on KaiOS.

### `chrome` (**optional**)

Paired with `"fullscreen": true`, and `"background_color": "transparent"`, this property sizes your app to 100% height (320x240) with the system status bar displayed _on top_ of your app. Useful for apps that have image backgrounds but don't want to hide the system status bar. Only valid property and value pair is `"statusbar": "overlap"`; defaults to non-overlapping.

```json
{
    "fullscreen": true,
    "background_color": "transparent",
    "chrome": {
        "statusbar": "overlap"
    },
}
```

<u>Note</u>: this value is ignored if the app is not `fullscreen`.

### `permissions` (**optional**)

The list of `permissions` that your app requests. Must correspond to the appropriate level based on app `type`, or permissions will be rejected. Check out the [complete list of KaiOS permissions]({{< ref "./kaios-permissions.md" >}} "complete list of KaiOS permissions") for information on available permissions and security levels.

```json
{
    "permissions": {
        "audio-channel-content": {
            "description": "To play podcast audio files in the background."
        },
    },
}
```

### `priority` (**optional**)

Sets the `mozapptype` to `hipri` on the app's `iframe`. Default is null, and only allowed value is `"high"`. Only applies to `privileged` and `certified` packaged apps.

<u>Warning</u>: This property is intended for important apps that receive urgent messages or calls (i.e. WhatsApp). Setting it does not guarantee your app will not be terminated due to memory pressure.

```json
{
    "priority": "high",
}
```

This property adjusts several properties in the Hardware Abstraction Layer (HAL), resulting in terminating preallocated process before the priority foreground app to maintain memory for memory-sensitive apps.

<u>FYI</u>: once an app is no longer visible, it's in the background and can be marked for termination. The grace period is 1 second by default, or 5 seconds if the app is "perceivable," like playing music on the `"content"` audio channel (see Pref `dom.ipc.processPriorityManager.backgroundPerceivableGracePeriodMS`).

### `messages` (**optional**)

A list of System Messages that your app responds to. Many system messages require special permissions that are for `certified` apps only. See [SystemMessagePermissionsChecker.jsm](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/messages/SystemMessagePermissionsChecker.jsm) for the list of permissions.

```json
{
    "messages": [
        { "serviceworker-notification": "/index.html" }
    ],
}
```

The following is a list of useful System Messages on KaiOS 2.5:

* `audiochannel-interruption-begin`
* `audiochannel-interruption-ended`
* `media-button`
* `headset-button`
* `activity`
* `alarm` (requires `alarms` permission)
* `serviceworker-notification` (requires `desktop-notification` permission)
* `notification` (requires `desktop-notification` permission)
* `push` (requires `push` permission)
* `push-register` (requires `push` permission)

### `redirects` (**optional**)

Internal URLs your app uses to handle external processes. Common example includes OAuth authentication.

```json
{
    "redirects": [{
        "from": "http://facebook.com/authentication/success.html",
        "to": "/app/main_interface.html"
    }]
}
```

<u>Note</u>: only applies to `privileged` and `certified` apps.

### `activities` (**optional**)

A list of Web Activities that your app will respond to, with optional filters. This includes common activities for viewing and sharing content, as well as custom activities for your app.

```json
{
    "activities": {
        "share": {
            "href": "/index.html",
            "disposition": "window",
            "filters": {
                "type": "url",
                "url": {
                    "required": true,
                    "regexp": "https?:.{1,2048}"
                }
            }
        }
    },
}
```

Common activities include:

* `view`
* `share`
* `pick`
* `browse`
* `open`

For more examples and details, see the article on [KaiOS Web Activities]({{< ref "./web-activities.md" >}} "KaiOS Web Activities").

### `locales` (**optional**)

An object of `locales` for translating the app's `name`, `subtitle`, and `description`. Keys are language tags defined in (RFC 4646).

```json
{
    "locales": {
        "en-US": {
            "name": "PodLP",
            "subtitle": "Listen, download, and subscribe to podcasts",
            "description": "Discover, listen, and subscribe to podcasts from around the world for free. PodLP is designed specifically for KaiOS to be easy to use both online and offline."
        }
    },
}
```

### `default_locale` (**optional**)

The default locale for the app. Must match one set in `located`.

```json
{
    "default_locale": "en-US",
}
```

### `orientation` (**optional**)

Supported orientations for the app. Can be an array or a single value.

```json
{
    "orientation": [
        "portrait-primary",
        "landscape-primary"
    ],
    "orientation": "default",
}
```

Must be one or more of the following:

* `portrait`
* `landscape`
* `portrait-primary`
* `landscape-primary`
* `portrait-secondary`
* `landscape-secondary`

<u>Note</u>: there is only two devices in the landscape orientation (320x230), the popular [JioPhone 2](https://www.jio.com/en-in/jiophone2) and the [Xandos X5](https://www.imei.info/phonedatabase/xandos-x5/).

### `role` (**optional**)

If set, must be one of `system`, `homescreen`, `theme`, `addon`, or `langpack`. Only certified apps can be `theme`s and only privileged or certified apps can be `addon`s.

```json
{
    "role": "system",
}
```

<u>Note</u>: this is only intended for pre-installed `certified` apps, not third-party apps.

### `datastores-access` (**optional**)

Data stored accessed using the [**Data Store API**](https://developer.kaiostech.com/docs/api/web-apis/dataStore/data-store/).

```json
{
    "datastores-access": {
        "download_store": {
            "readonly": false,
            "description": "Stores download finished"
        }
    },
}
```

<u>Note</u>: only applies to `certified` apps.

### `datastores-owned` (**optional**)

Data stored owned by this app, exposed via the [**Data Store API**](https://developer.kaiostech.com/docs/api/web-apis/dataStore/data-store/).

```json
{
    "datastores-owned": {
        "silent-apps": {
            "access": "readwrite",
            "description": "Silent install app list"
        }
    },
}
```

<u>Note</u>: only applies to `certified` apps.

### `csp` (**optional**)

The Content Security Policy (CSP) for the app.

```json
{
    "csp": "default-src *; script-src 'self'; object-src 'none'; style-src 'self' 'unsafe-inline'",
}
```

The default policies applied on KaiOS are:

**Privileged**

```
default-src *; script-src 'self'; object-src 'none'; style-src 'self' 'unsafe-inline'
```

**Certified**

```
default-src *; script-src 'self'; object-src 'none'; style-src 'self'
```

<u>Note</u>: defaults CSPs cannot be overridden, only added to (more restrictive).

### `appcache_path` (**optional**)

Location of an [Application Cache](https://web.dev/appcache-beginner/) manifest file.

```json
{
    "appcache_path": "/cache.manifest",
}
```

<u>Note</u>: `appcache_path` only applies to `hosted` app types.

### `dependencies` (**optional**)

Specify required `dependencies` which, if missing, will prevent installation. Recommended when using the [KaiAds SDK](https://kaiads.com/publishers/sdk.html).

```json
{
    "dependencies": {
		"ads-sdk": "1.5.8"
	},
}
```
<u>Note</u>: `dependencies` only applies to `privileged` or `certified` apps.

### `widgetPages` (**optional**)

The [**Widget API**](https://wiki.mozilla.org/WebAPI/WidgetAPI) allows `privileged` apps to embed other applications in their own iframe, e.g. homescreen, lockscreen, etc. `widgetPages` exposes widgets and apps embedding widgets require the [`"embed-widgets"` permission](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/apps/PermissionsTable.jsm#L299).

```json
{
    "widgetPages": [
        "/widget.html"
    ],
}
```

<u>Warning</u>: The Widgets API was never finalized and is disabled by default in [nsGenericHTMLFrameElement.cpp](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/html/nsGenericHTMLFrameElement.cpp#L531).

### `background_color` (**optional**)

The app background color, used to influence the system status bar theme (light or dark). System status bar theme can also be controlled dynamically using the meta tag in the page `<head>`, i.e. `<meta name="theme-color" content="rgb(255, 255, 255)" />`.

```json
{
    "background_color": "transparent",
}
```

### `deeplinks` (**optional**)

Register deep links that will trigger a Web Activity, also registered in your app's manifest, using the value in `"action"` (i.e. `"open-deeplink"`).

```json
{
    "deeplinks": {
        "regex": "^(app://)(kaios-store|kaios-plus)(.kaiostech.com)($|/$|/\\?(apps|postResult)=)",
        "action": "open-deeplink"
    },
}
```

<u>Note</u>: available on KaiOS 3.0 and select sub-versions of KaiOS 2.5.

### `connections` (**optional**)

Register for system [Inter-App Communications (IAC)](https://wiki.mozilla.org/WebAPI/Inter_App_Communication_Alt_proposal).

```json
{
    "connections": {
        "kaipay-to-kaistore": {
            "description": "Communication with KaiPay",
            "rules": { }
        }
    },
}
```

<u>Note</u>: only intended for pre-installed `certified` apps.

### `receipts` (**optional**)

Up to 1 MiB, format is JWT + "~" + JWT.

```json
{
    "receipts": [
        ""
    ]
}
```

### `precompile` (**optional**)

An array of script URIs containing "asm.js" to compile at install time off the main thread. **KaiOS 2.5 only**, since KaiOS 3.0 supports WASM. Compilation makes installation time longer, but reduces the time to start the app.

```json
{
    "precompile": [
        "game.js",
        "database.js"
    ]
}
```

### `entry_points` (**optional**)

An object of entry points into the app. Let's you define sub-apps that will also show in the default Launcher's app drawer.

```json
{
    "entry_points": {
        "lsk": {
            "launch_path": "/index.html?entry=rupee&localentry=rupee",
            "name": "JioPay",
            "locales": {
                "en-US": {
                    "name": "JioPay",
                    "description": "Use JioPay to make payment securely from Jiophone"
                }
            }
        }
    },
}
```

## `manifest.webmanifest` on KaiOS 3.0

KaiOS 3.0 changed the manifest structure to align with the standard Web Manifest format. Instead of a single `manifest.webapp` file for every locale, KaiOS 3.0 requires one `manifest.webmanifest` (i.e. `manifest.en-US.webmanifest`) file for each locale. Most properties are the same, but they have been moved to the proprietary `b2g_features` section.

Here's a short example from my [Bing Wallpaper](https://www.reddit.com/r/KaiOS/comments/udum00/get_the_latest_daily_wallpaper_from_bing_on_kaios/) app.

```json
{
  "id": "bingv3",
  "name": "Bing Wallpaper",
  "description": "Beautiful wallpapers from Bing, available daily. Not affiliated with nor endorsed by Microsoft Corporation.",
  "display": "standalone",
  "theme_color": "#00897b",
  "lang": "en-US",
  "start_url": "/index.html",
  "icons": [
    {
      "src": "/logo_56.png",
      "type": "image/png",
      "sizes": "56x56"
    },
    {
      "src": "/logo_112.png",
      "type": "image/png",
      "sizes": "112x112"
    }
  ],
  "b2g_features": {
    "display": "Bing Wallpaper",
    "version": "3.0.0",
    "subtitle": "Beautiful wallpapers daily",
    "type": "web",
    "categories": [
      "utilities"
    ],
    "developer": {
      "name": "Last Byte LLC",
      "url": "https://kaios.dev/"
    },
    "cursor": false,
    "fullscreen": true,
    "chrome": {
      "statusbar": "overlap"
    }
  }
}
```

<u>Note</u>: the only non-standard property in the manifest root is `id`. It's required to uniquely identify your app and is often just the lowercase version of your app name.

## Conclusion

As you can see, a lot more than just app name and icons go into KaiOS' `manifest.webapp` file. The app's manifest is what enables it to access certain APIs, interact with the system for tighter integration, and enables the best possible user experience.

For more examples, see the [KaiOS Manifest](https://developer.kaiostech.com/docs/getting-started/main-concepts/manifest/) documentation. If you're confused about specific manifest properties and need an experienced partner for KaiOS development, contact the author from the [About]({{< ref "about" >}} "About") page.
