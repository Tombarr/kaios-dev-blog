+++
title = "Advanced KaiOS Development - CORS, TCP Sockets, and Let's Encrypt SSL Certificates"
description = "Disabling the Same Origin Policy (CORS), Navigator.mozTCPSocket, and issues with SSL certificates"
date = 2023-02-02T00:00:00+08:00
toc = true
draft = false
tags = ["KaiOS", "CORS", "Let's Encrypt", "Socket", "SSL Certificate", "Permissions", "Security"]
categories = []
series = ["Advanced Development"]
header_img = "img/home-alt.png"
+++

Learn more about disabling CORS, `Navigator.mozTCPSocket`, and issues with Let's Encrypt certificates on KaiOS

## `XMLHttpRequest` without CORS

There are several ways that dynamic web apps communicate with a back-end server. [XMLHttpRequest](https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest) (XHR) is the original method, used heavily in [AJAX](https://developer.mozilla.org/en-US/docs/Web/Guide/AJAX) programming. XHR allows web apps to make a variety of HTTP requests like GET, PUT, POST, and DELETE, both synchronously (now deprecated) and asynchronously.

KaiOS fully supports XMLHttpRequest, including a few non-standard flags that can be provided to it's constructor.

```js
let xhr = new XMLHttpRequest({
    mozSystem: true,
    mozAnon: true,
    mozBackground: true,
})
```

The first, and perhaps most useful flag is [`mozSystem`](https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest/mozSystem). Privileged apps with the [`systemXHR`](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/apps/PermissionsTable.jsm#L274) permission are allowed to set this flag. Setting it to `true` disables the same origin policy for the request, allowing requests without the usual Content Security Policy (CSP) errors.

> Content Security Policy: The page’s settings blocked the loading of a resource at https://podlp.com/ (“connect-src”).

The second flag, [`mozAnon`](https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest/mozAnon), works in tandem with the first. In fact, this flag is enabled whenever the `mozSystem` flag is used (see [nsXMLHttpRequest.h](https://github.com/kaiostech/gecko-b2g/blob/b2g48_v2_6/dom/base/nsXMLHttpRequest.h#L260)). Setting `mozAnon` ensures the request is sent anonymously, without cookies or authentication headers. It will also throw an error if you attempt to enable `withCredentials`.

The final flag, [`mozBackground`](https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest/mozBackgroundRequest), is for background service requests. This causes the request to fail in cases where a security dialog (such as authentication or a bad certificate notification) would be shown.

## Fetch

In addition to XHR, KaiOS also supports the `Fetch` API. Similar to XHR, apps holding the `systemXHR` permission are granted special treatment for requests made with the mode `no-cors`. For instance, the [header list is not constrained](https://github.com/kaiostech/gecko-b2g/blob/gonk/dom/fetch/InternalHeaders.h#L55) and a successful request will resolve to a [basic response](https://github.com/kaiostech/gecko-b2g/blob/gonk/dom/fetch/FetchDriver.cpp#L899) instead of an opaque response.

```js
fetch('https://google.com', {
    method: 'GET',
    mode: 'no-cors',
})
```

<u>Note</u>: this behavior is only available on KaiOS 3.0 devices. For better compatibility, developers will continue to prefer XMLHttpRequest with the `mozSystem` flag which works on both KaiOS 2.5 and 3.0.

## `TCPSocket` API

KaiOS includes the non-standard `navigator.mozTCPSocket` API for establishing lower-level TCP socket connections. This API is exposed to Privileged apps with the [`tcp-socket`](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/apps/PermissionsTable.jsm#L62) permission and allows developers to implement protocols on top of TCP like IMAP, IRC, POP, or HTTP.

Apps can both open and listen for socket connections, sending and receiving data either in `String` or `ArrayBuffer` format. This allows apps to act as both clients and servers, exposing connections over `localhost` within and between apps (although multi-tasking on KaiOS is quite limited). Uses cases include:

* Sending and retrieving emails over POP or IMAP
* Chatting via an IRC client
* Transferring files over FTP
* Issuing direct DNS queries, instead of DNS over HTTPS (DoH)

Creating a local HTTP server also allows applications to serve up content requested by image, audio, and video elements, similar to a `ServiceWorker` but without limitations. Of course this comes with the added complexity of writing your own HTTP server, and for multimedia requests also requires handling `Range` requests.

<u>Note</u>: There is also a sibling `UDPSocket` API for UDP socket connections, accessible via the [`udp-socket`](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/apps/PermissionsTable.jsm#L67) permission.

## Let's Encrypt SSL Certificate Issue

Let's Encrypt (LE) is an open certificate authority (CA) that issues free SSL certificates, allowing websites to serve content over HTTPS. LE is so popular that it has issued more than [one billion certificates](https://letsencrypt.org/2020/02/27/one-billion-certs.html). SSL certificates are important for many reasons, and in 2023 they are effectively required to avoid visitors seeing scary warning messages stating, "This Connection is Untrusted."

In September 2021, the IdenTrust DST Root CA X3 root certificate used by Let's Encrypt expired. For most internet users, this was a non-event because modern web-enabled devices include new root certificates with regular updates. However, most budget mobile phones including KaiOS devices do not receive regular over-the-air (OTA) updates. That means that as of the time of writing, most **phones running KaiOS 2.5 will flag Let's Encrypt SSL certificates as insecure**.

![Untrusted Connection Warning on KaiOS](/img/ssl-error.png "KaiOS screenshot of anchor.fm with expired LE root certificate")

As a developer, this means that XMLHttpRequest and Fetch requests to hosts using LE certificates will silently fail with no catchable error. Fortunately, while XHR does not expose the necessary error messages, it is possible to detect invalid SSL Certificates on KaiOS using `mozTCPSocket`. The function below returns a `Promise` that resolves to `true` when the `SecurityCertificate` is thrown.

```js
// @returns [Promise<Boolean|null>] True if the host has an invalid SSL certificate
function isInvalidCertificate(host, timeout = 1000) {
  // API not available, either not KaiOS or missing permission
  if (!navigator.mozTCPSocket) {
    return Promise.resolve(null);
  }

  return new Promise((resolve) => {
    let timeoutId;
    let isResolved = false;
    const socket = navigator.mozTCPSocket
      .open(host, 443, { useSecureTransport: true });

    // Closes socket, if open, and resolves Promise
    const closeAndResolve = (event) => {
      if (socket.readyState !== 'closed') {
        try {
          socket.close();
        } catch (e) {
          console.warn(e);
        }
      }

      // Handle SSL Certificate Scenario
      if (event.type === 'error') {
        if (event.name === 'SecurityError' && event.message === 'SecurityCertificate') {
          isResolved = true;
          clearTimeout(timeoutId);
          return resolve(true); // True = Invalid
        }
      }

      isResolved = true;
      clearTimeout(timeoutId);
      return resolve(false); // False = Valid
    };

    // Set socket timeout
    timeoutId = setTimeout(() => {
      if (!isResolved) {
        closeAndResolve(false);
      }
    }, timeout);

    socket.addEventListener('data', closeAndResolve);
    socket.addEventListener('error', closeAndResolve);
  });
}
```

As expected, `isInvalidCertificate` resolves true for `anchor.fm` which uses a Let's Encrypt SSL Certificate, and resolves false for `google.com` which uses a certificate issued by Google Trust Services.

<u>Tip</u>: in Firefox if you click the lock icon then the arrow under "Connection secure," you can see SSL certificate details.

![Connection details for Google.com](/img/ssl-certificate-authority.png "Screenshot of connection details for Google.com")

## Conclusion

KaiOS offers a variety of APIs to make external requests like a native app, including XHR and Fetch without CORS, as well as TCP and UDP Socket connections. All required permissions are only available to packaged Privileged applications, but enable your application to use third-party APIs, services, and protocols without running into Content Security Policy issues.

If you find these nuances daunting and need support developing tightly-integrated experiences on KaiOS, contact the author from the [About]({{< ref "about" >}} "About") page.