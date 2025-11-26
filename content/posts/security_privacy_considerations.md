+++
title = "Security and Privacy on KaiOS"
description = "Security and Privacy considerations for KaiOS smart feature phones"
date = 2023-04-19T00:00:00+08:00
lastmod = 2024-01-31T00:00:00+08:00
toc = true
draft = false
header_img = "img/franck-DoWZMPZ-M9s-unsplash.jpg"
tags = ["KaiOS", "Security", "Privacy", "Tips"]
categories = []
series = ["Advanced Development"]
[params]
  featured_img = "img/franck-DoWZMPZ-M9s-unsplash.jpg"
+++

# Security and Privacy considerations for KaiOS smart feature phones

KaiOS is based on Firefox OS, and as a result, many of the same technologies apply to Security & Privacy within KaiOS apps.

## [Content Security Policy (CSP)](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP)

The Content Security Policy (CSP) prevents attacks like Cross-Site Scripting (XSS) by limiting the origins that specific resources like scripts, objects, and stylesheets can be loaded from. KaiOS imposes default CSPs on Privileged & Certified packaged apps. It's possible to override this using the [`csp` manifest property]({{< ref "./manifest-properties#csp-optional" >}}), but the provided value can only be __more strict__ than KaiOS' default.

**Privileged** (`security.apps.privileged.CSP.default`)

```
default-src * data: blob:; script-src 'self' http://127.0.0.1:8081 http://local-device.kaiostech.com:8081; object-src 'none'; style-src 'self' 'unsafe-inline'
```

<u>Note</u>: local addresses like `http://127.0.0.1:8081` serve KaiAds scripts, and packages like `app://shared.gaiamobile.org` are made accessible to provide a set of shared resources across system apps. Although it's possible, they are not intended to be accessed by third-party apps.

**Certified** (`security.apps.certified.CSP.default`)

```
default-src * data: blob:; script-src 'self' http://127.0.0.1:8081 http://local-device.kaiostech.com:8081 app://theme.gaiamobile.org; object-src 'none'; style-src 'self' 'unsafe-inline' app://theme.gaiamobile.org app://shared.gaiamobile.org
```

<u>Warning</u>: the behavior for the CSP of Certified apps is actually hard-coded in [nsCSPService.cpp](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/security/nsCSPService.cpp#L138).

## Same Origin Policy

The Same-Origin Policy is a security mechanism in web browsers that restricts resources (document or script) loaded by one origin interact with resources from another origin. An origin is defined by:
* scheme (aka protocol, i.e. HTTP & HTTPS),
* port (typically 80 for HTTP and 443 for HTTPS)
* host

What this means in practice is that there are restrictions in place on accessing content (iframes, CSS, JavaScript, forms, images, and audio/ video) served from different domains.

### [Cross-Origin Resource Sharing (CORS)](https://developer.mozilla.org/en-US/docs/Glossary/CORS)

CORS is what allows the sharing of certain resources that would have otherwise been blocked by the Same Origin Policy. With the use of certain HTTP headers like [`Access-Control-Allow-Origin`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Origin), a website can allow resource sharing to any and all origins. This is why it's possible to load scripts hosted by CDNs like [CDNJS](https://cdnjs.com/).

When making certain requests using `XMLHttpRequest` or `fetch`, the browser might first initiate an `OPTIONS` request known as a [CORS preflight](https://developer.mozilla.org/en-US/docs/Glossary/Preflight_request) request. `OPTIONS` is basically a `HEAD` request with no body and specific CORS headers included.

Within a Privileged app on KaiOS it is possible to use [`XMLHttpRequest` without CORS]({{< ref "./ssl-certificate#xmlhttprequest-without-cors" >}}), making APIs from external websites accessible similar to a native app on Android or iOS. What's considered cross-origin on KaiOS? For packaged apps, it is anything that doesn't match the [`origin` property]({{< ref "./manifest-properties#origin-optional" >}}) in `manifest.webapp` (KaiOS 2.5) or `manifest.webmanifest` (KaiOS 3.0). For hosted apps, it is anything that doesn't match the origin serving the app.

<u>Note</u>: packaged apps without an explicit `origin` in their manifest will be assigned a UUID, i.e. `app://b750bc47-2c33-0b4e-9d32-c7ef92463424/` on KaiOS 2.5 or `https://b750bc47-2c33-0b4e-9d32-c7ef92463424.localhost/` on KaiOS 3.0.

## [Transport Layer Security (TLS)](https://developer.mozilla.org/en-US/docs/Web/Security/Transport_Layer_Security)

[TLS is a security protocol](https://www.cloudflare.com/learning/ssl/transport-layer-security-tls/) commonly used on the web and the successor of Secure Sockets Layer (SSL). It provides encryption, authentication, and integrity, identifying an origin server via an [SSL Certificate](https://www.cloudflare.com/learning/ssl/what-is-an-ssl-certificate/) issued by a Certificate Authority for a specific domain. Thanks to public key cryptography, someone can visit https://KaiOS.dev (notice the _HTTPS_), and even if an attacker could read the messages being exchanged, their contents would be unreadable as they are encrypted. This is especially important for websites that offer logins or involve the collection of sensitive data, like banks or messaging services.

<u>Note</u>: due to the expired IdenTrust DST Root CA X3 root certificate, **do not use [Let's Encrypt]({{< ref "./ssl-certificate#lets-encrypt-ssl-certificate-issue" >}}) SSL Certificates** for services accessed by KaiOS apps.

### HyperText Transfer Protocol Secure (HTTPS)

HTTPS is the successor of HTTP–HTTP with TLS (SSL) encryptions–and collectively these protocols make up the web. [Why use HTTPS?](https://www.cloudflare.com/learning/ssl/why-use-https/) Well in 2023, HTTPS is important to safeguard user privacy. Moreover, it is effectively required to avoid "Secure Site Not Available" warnings and for your website to be indexed by search engines like Google. KaiOS apps should only access secure services from websites hosted over HTTPS.

<u>Note</u>: [HTTPS is required](https://developer.kaiostech.com/docs/development/build-your-first-hosted-app/pwa-to-hosted-app/) for hosted web and progressive web apps.

### Secure Context

A secure context is a `Window` or `Worker` scope that meets standards for authentication and confidentiality. Certain Web APIs and features are only accessible in a secure context. The following features require a secure context:

* Push
* Geolocation
* Notifications
* Service Workers
* Storage

To be considered a secure context, the following criteria must be met:

* served over `https://` or `wss://` URLs
  * _or_ served locally via `http://localhost`, `http://*.localhost`, `http://127.0.0.1`
* must not use deprecated network security

This can be checked at runtime via the boolean [`window.isSecureContext`](https://developer.mozilla.org/en-US/docs/Web/API/isSecureContext) property. <u>Note</u>: `window.isSecureContext` is available on KaiOS 3.0 but not KaiOS 2.5. It's best to check this property when available because on Firefox, attempting to access certain APIs outside of a secure context will throw a `DOMException` with the message `The Operation is insecure`.

### [Mixed Content](https://developer.mozilla.org/en-US/docs/Web/Security/Mixed_content)

An HTTPS website that also includes content served over cleartext HTTP is considered **mixed content**. This means that the pages is only partially encrypted, making unencrypted content vulnerable to sniffers and man-in-the-middle (MITM) attacks. That effectively leaves the page unsafe. What browsers do varies depending on whether the mixed content is **passive content** or **active content**.

Passive content includes multimedia like `<img>`, `<video>`, and `<audio>`. Active content includes `fetch` and `XMLHttpRequest`, `<script>`, `<link>`, `<iframe>`, `navigator.sendBeacon`, and CSS `url()` values. Browser behavior with mixed content varies, with the most strict being Safari which does not allow _any_ mixed content. On WebIDE, you will see console statements when attempting to load mixed content. Requests for active content will be blocked, while requests for passive content may generate warnings.

### [HTTP Strict-Transport-Security (HSTS)](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Strict-Transport-Security)

The `Strict-Transport-Security`, referred to as HSTS, is an HTTP header tells a browser that a site should only be accessible using HTTPS. Depending on it's configuration, future attempts to access the site will automatically be upgraded from HTTP to HTTPS.

### [Cookies](https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies)

Like any web browser, KaiOS supports Cookies, with KaiOS 2.5 placing fewer restrictions than KaiOS 3.0. Cookies are useful for many purposes, including session management, personalization, and tracking. The [`sandboxed-cookies` permission]({{< ref "./kaios-permissions#sandboxed-cookies" >}}) on KaiOS 2.5 will replicate the default behavior on KaiOS 3.0, forcing the reading/ writing of cookies to apps individually. On KaiOS 2.5, cookies can be set client side using [`document.cookie`](https://developer.mozilla.org/en-US/docs/Web/API/Document/cookie) including in packaged apps with a defined origin, despite the `app://` protocol. On KaiOS 3.0, this behavior is changed: packaged apps are served from an origin like `https://myapp.localhost`, rendering client-side cookie setting useless since they are scoped to a local loopback address.

<u>Note</u>: cookies can be marked as `HttpOnly`, making them inaccessible via `document.cookie`. It's best practice to limit cookie access as much as possible.

### Subresource Integrity (SRI)

Subresource Integrity (SRI) is an optional security feature browsers  use to verify that resources fetched, like those from Content Delivery Networks (CDNs), are delivered untampered. You specify a cryptographic algorithm and hash using the `integrity` attribute, and the browser will check that the downloaded resource matches the hash provided. If the hash does not match, the resource will not be loaded.

```html
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js" integrity="sha384-8gBf6Y4YYq7Jx97PIqmTwLPin4hxIzQw5aDmUg/DDhul9fFpbbLcLh3nTIIDJKhx" crossorigin="anonymous"></script>
```

This attribute only applies to `<script>` or `<link>` elements. Because of KaiOS' default CSP, SRIs are primarily useful when serving a hosted or progressive web app (PWA) that references resources served by CDNs. Additionally, since the SRI is static, you will need to used pinned-version dependencies like jQuery 2.1.4, instead of `@latest`. Otherwise, when the resource content changes, it would no longer match the hash and it would fail to load.

## KaiOS Web Apps vs Android & iOS Native Apps

### Permissions

KaiOS apps declare [permissions]({{< ref "./kaios-permissions" >}}) in their `manifest.webapp` or `manifest.webmanifest` files. This is similar to how iOS applications request permissions in `Info.plist` and Android in `AndroidManifest.xml`. Available permissions depend on [app type]({{< ref "./kaios-ecosystem#to-package-or-not-to-package" >}}) (web, privileged, or certified). While some permissions are granted transparently, other permissions trigger a dialog at runtime requiring the user to explicitly grant permission (which can later be revoked in Settings). This means it's important to check the availability of certain features and catch `SecurityError` at runtime to build an effective user experience.

### Source Disclosure

Android apps run on the Dalvik Virtual Machine or Android RunTime (ART) using Java/ Kotlin source code compiled into [Dex bytecode](https://source.android.com/docs/core/runtime). iOS apps use LLVM to compile Objective-C/ Swift source code into machine code. Although there are numerous Java decompilers, in practice this means that raw source code is not easily available for native Android or iOS.

In contrast, KaiOS apps are basically web apps. Since JavaScript on the web is an interpreted, not compiled, language, source code is readily available. Of course it's possible (and recommended) to bundle & minify source before shipping. Additionally, it's also possible to use an obfuscator to make it difficult to reverse-engineer your app's functionality. That said, either method provide real safeguard against source disclosure.

### Data Security

Android provides a [Keystore](https://developer.android.com/training/articles/keystore) to easily store encrypted data locally while making it difficult to extract. While KaiOS does not provide a similar, convenient service, it does support the [Web Crypto API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Crypto_API). It is generally possible to encrypt data in [`localStorage`](https://digitalfortress.tech/js/encrypt-localstorage-data/) or `indexedDB` using custom secret keys. Of course the challenge then is storage of the secret key itself. For most use cases this isn't necesaary, and for highly sensitive data, the best approach is simply to not store it on the client at all!

### Code Signing

KaiOS automatically provides code signing via the KaiStore. This is similar to Android, which provides code signing via the Google Play Store, and iOS which provides code signing via the App Store. KaiOS applications packaged as ZIP files from the KaiStore include the following contents:

* application.zip
  * /META-INF
    * id.json
    * manifest.mf
    * zigbert.rsa
    * zigbert.sf

Applications are signed with KaiOS' root certificate, and cryptographic digests (MD5 and SHA1) are provided for each file within `application.zip`. Certificates are validated client-side at the point of installation, and invalid signatures will cause the installation to fail. This effectively places a digital signature on the packaged application, ensuring it's authenticity and integrity against modification or tampering.

<u>Note</u>: code signing happens transparently and automatically for developers. That said, code signatures come with expiration dates (typically one year). On multiple occasions I have seen had my applications become uninstallable due to expired signatures. In these cases, I have had to wait for KaiStore or JioStore support to upload new, re-signed builds.

### [Cross-Site Request Forgery](https://developer.mozilla.org/en-US/docs/Glossary/CSRF)

Because KaiOS apps can be launched just like websites using [Web Activities]({{< ref "./web-activities" >}} "Web Activities"), `window.open`, or both, it's important to require user confirmation and restrict sensitive operations using secure tokens. For instance, on KaiOS 3.0 an application could open another like this:

```js
window.open('https://bankapp.localhost/transfer.html?to=Attacker&amount=500')
```

A very bad Bank App might load the user from a session cookie and initiate the transfer immediately. A more secure Bank App would require user confirmation and passcode re-entry for this action, use the HTTP `POST` protocol, and issue [CSRF Tokens](https://owasp.org/www-community/attacks/csrf) to prevent form submission from third-parties. It may still be a good user experience for services like PayPal or Venmo to pull up a pre-populated transfer page as part of a Transfer activity that allows users to easily request money from friends. However, it's important to do so securely! Even though Android's `Intent` doesn't allow arbitrary pages to be opened, these are still important considerations for native apps as well.

### [Referrer](https://developer.mozilla.org/en-US/docs/Web/Security/Referer_header:_privacy_and_security_concerns)

Unlike native apps, web apps might send a `Referrer` header disclosing the website (or even web page) initiating the request. In the context of KaiOS, the `Referrer` is your app's origin. This can be disabled via several methods, including the [`Referrer-Policy`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Referrer-Policy) header or [`rel`](https://developer.mozilla.org/en-US/docs/Web/HTML/Attributes/rel) attribute for HTML tags like anchor links, i.e. `<a rel="noreferrer">`.

## Conclusion

Although KaiOS functions much like a web browser, there are some special considerations when distributing a web application across smart feature phones. As always, it's easy to misuse security constructs so it is best to include security specialists when securing critical sensitive data. If you need an experienced partner to audit and secure your KaiOS application, contact the author from the [About]({{< ref "about" >}} "About") page.
