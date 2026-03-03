+++
title = "A closer look at the TCL Go Flip 4 5G and KaiOS 4.0"
description = "Exploring and revisiting security and privacy on KaiOS 4.0 and the TCL Go Flip 4 5G"
date = 2026-03-02T00:00:00+08:00
lastmod = 2026-03-03T00:00:00+08:00
toc = true
draft = false
header_img = "img/TCL-Go-Flip-4-5G.jpeg"
tags = ["KaiOS", "Security", "KaiOS 4.0", "TCL"]
categories = []
series = ["Advanced Development"]
[params]
  featured_img = "img/TCL-Go-Flip-4-5G.jpeg"
+++

The TCL Go Flip 4 5G (commercial reference `T440W-EATBUS1-V` for T-Mobile) is the first device to ship with KaiOS 4.0. Given that [CVE-2023-33294]({{< ref "./CVE-2023-33294" >}}) and [CVE-2023-27108]({{< ref "./CVE-2023-27108" >}}) were discovered on the original Alcatel Go Flip 4 running KaiOS 3.0, it was worth checking whether these issues carried forward to new hardware.

**The short answer**: KaiOS 4.0 is architecturally **indistinguishable from KaiOS 3.0**. Many of the known vulnerabilities have been partially addressed, but the surface area remains broad.

## ADB & Developer Mode Access

![Screenshots from the TCL Go Flip 4 5G](/img/gf4-5g-screenshots.png "Screenshots from the TCL Go Flip 4 5G")

Unlike previous Go Flip models, developer mode is surprisingly easy to enable! This may be an accident, since the build on my Flip 4 5G is signed using `test-keys`. Here's the build fingerprint:

```ini
ro.system_dlkm.build.fingerprint=TCL/gflip5gtmo/gflip5gtmo:14/UKQ1.241125.001/jenkins05072152:user/test-keys
```

Either way, I was able to use standard secret dialer codes:

* `*#*333284#*#*` — developer mode
* `*#8378269#` — launch Engmode app

Web2Dev (W2D) also works! `WebActivity` remains accessible from websites on the Browser app. See [w2d.js.org](https://w2d.js.org) for details.

```js
let w2d = new WebActivity("configure", {
  target: "device",
  section: "developer",
});

w2d.start()
  .then(() => console.log("Developer Tools opened!"));
```

Making a surprising return is the secret Konami Code in the Settings app! Navigate to **Settings > Device > Device Info > More Info**. The following soft key sequence opens a hidden menu:

```text
SoftLeft SoftLeft SoftRight SoftLeft SoftRight SoftRight
```

Finally, another option from the Browser to launch the Engmode app (or any app for that matter) is to use the `kind=app` parameter passed to `window.open` using the Manifest URL of the target app.

```js
window.open(
  "http://engmode.localhost/manifest.webmanifest",
  "_blank",
  "kind=app,noopener=yes"
);
```

### Limitations

Like previous KaiOS 3.0 devices, it's not possible to access the device from Firefox's Remote Debugger due to SELinux and permission issues accessing the debugger socket.

```bash
03-02 11:07:46.865  5108  5108 E adbd    : failed to connect to socket 'localfilesystem:/data/local/firefox-debugger-socket': could not connect to localfilesystem address 'localfilesystem:/data/local/firefox-debugger-socket'
03-02 11:07:46.860  5108  5108 W adbd    : type=1400 audit(0.0:61): avc:  denied  { write } for  name="firefox-debugger-socket" dev="dm-38" ino=5153 scontext=u:r:adbd:s0 tcontext=u:object_r:b2g_data_file:s0 tclass=sock_file permissive=0
```

The default Device Preference values match those from previous ROMs. 

```js
pref("devtools.debugger.unix-domain-socket", "/data/local/firefox-debugger-socket");
pref("devtools.debugger.remote-port", 6000);
```

## CVE-2023-33294: `tctweb_server` Endures

[CVE-2023-33294]({{< ref "./CVE-2023-33294" >}}) documented that the `/system/bin/tctweb_server` binary on KaiOS 3.0 exposed an unauthenticated HTTP server on port 2929 that would execute arbitrary commands as root. This binary disappeared in KaiOS 3.1, but possibly because it's TCL-specific and the only KaiOS 3.1 devices were from other vendors like Nokia.

On the Go Flip 4 5G, `tctweb_server` is back, again listening on `http://127.0.0.1:2929`. It runs as root and is accessible to installed apps and websites via the browser. _However_, this time it's significantly hardened. For starters, SE Linux prevents you from reading or copying the binary. It also implements an internal command and property whitelist. Attempts to issue arbitrary shell commands or read files like `/system/build.prop` are rejected.

```bash
03-02 13:14:12.550  1487 11862 E tctweb_server: [mweb] not in whitelist cat /sys/class/power_supply/battery/temp,
```

The server still responds to `name=query&api=...` style requests for a restricted set of system properties, and `cmd=shell&...` commands limited to diagnostic operations. The broad `cmdshell` passthrough that made the original vulnerability so dangerous appears to no longer be present.

A second daemon, `EsimAfterSalesServer` (run using `mozTCPSocket` inside the System app), runs on port 8612 and handles eSIM provisioning commands (`clear-profile`, `esim-status-check`) via a basic HTTP parser. This provides a specific vector for interacting with carrier eSIM profiles, and once again is globally accessible including from the browser, but lacks general system access.

Consistent with other TCL devices like the Android-based Go Flip 2, this phone ships with a few extra binaries including `mfg_util` and its daemon counterpart, `mfg_utild`, which reads special flags from `/dev/block/by-name/oembin`. This may be useful in a future exploit as it appears to control the `ro.boot.inproductionflag`.

## CVE-2023-27108: `getCallLogList` Fixed

[CVE-2023-27108]({{< ref "./CVE-2023-27108" >}}) documented that the `getCallLogList` Web Activity on KaiOS 3.0 returned call log data to any caller without any origin check.

In KaiOS 4.0, the Communications app manifest now includes an `allowedOrigins` restriction:

```json
"getCallLogList": {
  "filters": {
    "type": {
      "required": true,
      "value": [
        "calllog/tel"
      ]
    }
  },
  "allowedOrigins": [
    "system",
    "http://system.localhost"
  ],
  "returnValue": true
}
```

This is exactly the mitigation recommended in the original CVE write-up. Calls to this activity from third-party apps or websites will now be rejected with the error `NO_PROVIDER`.

## Engmode: Possible Command Injection

The following has yet to be confirmed. Like nearly every previous KaiOS version, the Engmode API (`navigator.b2g.engmodeManager`) is limited to Core apps with the `engmode` permission. It also appears to perform complex input sanitization before passing commands off to `EngmodeService`.

One potential target for command injection is the `updateAtmPressure` method, which constructs a shell command by string concatenation:

```js
updateAtmPressure(pressure) {
  return this.createPromiseWithId(aResolverId => {
    const floatRegex = /^[+-]?[0-9]+\.[0-9]+$/;
    if (
      parseFloat(pressure) > 259.0 &&
      parseFloat(pressure) < 1261.0 &&
      floatRegex.test(JSON.stringify(pressure))
    ) {
      var command =
        "mkdir /mnt/testbox_log/;" +
        "./vendor/bin/pressure_test -sensor=pressure -sample_rate=5 " +
        "-duration=5 -limit1=3 -limit2=-3 -offset=" + pressure +
        " > mnt/testbox_log/atmpressure.txt";

      Services.cpmm.sendAsyncMessage("Engmode:EngmodeTestCommand", {
        param: command,
        useShell: true,
        operation: "start",
        requestID: aResolverId,
      });
    } else {
      this.takePromiseResolver(aResolverId).reject("invalid parameter");
    }
  });
}
```

The `pressure` value is passed directly into the shell command string. The validation — a range check and a regex applied to `JSON.stringify(pressure)` — is intended to restrict input to a decimal number. However, the `JSON.stringify` call wraps string inputs in quotes, so the regex will reject string inputs that would otherwise pass the float check. If `pressure` is a Number rather than a String, the regex comparison behaves as intended.

## Other Changes

### Copy/Paste

KaiOS 4.0 supports copy-paste using its own API.

```js
// Copy text and show transient UI
const copyActivity = new WebActivity("copy-content-view", {
  content: "copy this text",
});

copyActivity.start();

// Displays a dialog showing how copy-paste works
const tutorialDialog = new WebActivity("show-copyPaste-guide");

tutorialDialog.start();
```

Both `navigator.clipboard.writeText` and `navigator.clipboard.readText()` appear to work, but haven't been tested cross-process. This functionality is gated behind a boolean Device Setting, `copypaste.enabled`, which is enabled by default on the Flip 4 5G. It can be disabled from the Developer Menu.


### Content Security Policy (CSP)

Unlike KaiOS 2.5, the [content security policy (CSP)]({{< ref "./security_privacy_considerations#content-security-policy-csp" >}}) for apps is not determined by Device Settings. Instead, `api-daemon` is responsible for serving apps and sets one CSP for packaged apps.

```toml
[vhost]
root_path = "/data/local/webapps/vroot"
csp = "default-src * data: blob:; script-src 'self' http://127.0.0.1 http://shared.localhost; object-src 'none'; style-src 'self' 'unsafe-inline' http://shared.localhost"
```

As user @Cyan2048 noted on Discord, the CSP notably does not include [`wasm-unsafe-eval`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Content-Security-Policy/script-src#unsafe_webassembly_execution). This effectively **blocks packaged apps from using WebAssembly (Wasm)** on KaiOS 4.0.

### Random Finds

The System app once again offers a `show-toast` activity that draws an alert window at the top of the screen. In previous KaiOS versions, this was sometimes restricted. In KaiOS 4.0, any app (or website) can use it.

```js
const showToast = new WebActivity("show-toast", {
  title: "Toast Title",
  text: "This is a longer message...",
  timeout: 5000,
});

showToast.start();
```

Another unusual one is the `reboot-device` activity, which lets apps (or websites) request to reboot the phone. This requires user confirmation, but could still be annoying.

```js
const reboot = new WebActivity("reboot-device", {
  appName: "Secret"
});

reboot.start();
```

The KaiStore also offers many open activities including `kaistore-get-silent-apps`, used by the System app to silently pre-install apps that the user cannot later delete.

#### Kids Mode

The only time apps aren't silently installed is when the phone is set to "Kids Mode" via the `kids.mode.enabled` boolean Device Setting. This can be toggled from Settings > Account > Kids Mode > On. Kids Mode enables age-based restrictions limiting the available apps (removes social media, games, and the KaiStore) as well as blocking certain access from the browser.

#### Special Keys

Like most TCL devices, there are several shortcut keys on the TCL Go Flip 4 5G including:

* `QdCall` - the phone icon on the flip cover that launches the Camera when double clicked
* `Message` - the message bubble icon used to launch SMS Messages
* `FavoriteContacts` - the star button used to launch the Contacts app
* `MicrophoneToggle` - the center "OK" button triggers this key, instead of `Enter`

Interestingly, apps and websites are able to intercept these keys. Apps can also `preventDefault`, but websites cannot.

#### Voice Input

Unlike earlier KaiOS versions, there is no system-wide speech-to-text (STT) on KaiOS 4.0. The Device Preference `voice-input.enabled` is set to `false` and there is no pre-installed application to respond to the `voice-input` activity.

## Conclusion

KaiOS 4.0 on the TCL Go Flip 4 5G is pretty much identical to KaiOS 3.0 from a user perspective. From a security point-of-view, it appears prior vulnerabilities have been hardened. Yet, exposing HTTP services like the eSIM provisioning server circumvents permission and inter-process communication (IPC) safeguards, which is fundamentally poor design.
