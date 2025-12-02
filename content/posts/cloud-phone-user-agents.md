+++
title = "Deep Dive on Cloud Phone User Agents"
description = "Analyzing hundreds of Cloud Phone user agent headers"
date = 2025-06-03T00:00:00+08:00
lastmod = 2025-06-03T00:00:00+08:00
toc = true
draft = false
header_img = "img/home-alt.png"
tags = ["Cloud Phone", "User Agent"]
categories = []
series = ["Advanced Development"]
+++

## Deep Dive on Cloud Phone User Agents

**Why it matters?** User agents are the most common way to identify devices on the web.

A similar deep dive was completed for **[KaiOS user agents]({{< ref "user-agents" >}})**.

### Key Takeaways

Cloud Phone user agents follow a [consistent pattern](https://developer.cloudfone.com/docs/guides/get-started/#user-agent) including several components:

**User Agent Components**

* `Cloud Phone` identifies all Cloud Phone devices
* `Puffin` identifies the remote-browser architecture shared with the [Puffin browser](https://puffin.com)
* `Nokia 225 4G` is the device model name. `Generic` is used by the Cloud Phone Simulator or pre-production devices
* `Chrome/128.0.6613.170` identifies the Chromium version used by Cloud Phone servers

For compatibility, Chromium adds strings like `KHTML, like Gecko` and `Safari`.

### User Agents

Here's a list of `User-Agent` header values from recent requests to [PodLP](https://podlp.com/).

```
Mozilla/5.0 (Cloud Phone 2.7; LVIX L1 4G-1; ASR) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.7.74689FP
Mozilla/5.0 (Cloud Phone 2.7; LVIX L1 4G-2; ASR) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.7.74689FP
Mozilla/5.0 (Cloud Phone 2.7; LVIX L1 4G-3; ASR) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.7.74689FP
Mozilla/5.0 (Cloud Phone 2.7; ringme R1 BOLD 2; ASR) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.5.74038FP
Mozilla/5.0 (Cloud Phone 2.7; ringme R1 BOLD 3; ASR) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.7.74689FP
Mozilla/5.0 (Cloud Phone 2.7; ringme BOLD 4G Gen2; ASR) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.7.74689FP
Mozilla/5.0 (Cloud Phone 2.5; ringme R1 Plus; UNISOC) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.7.74689FP
Mozilla/5.0 (Cloud Phone 2.7; ringme Supreme; ASR) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.7.74689FP
Mozilla/5.0 (Cloud Phone 2.7; Generic; ASR) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.7.74689FP
Mozilla/5.0 (Cloud Phone 2.7; Generic; UNISOC) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.7.74689FP
Mozilla/5.0 (Cloud Phone 2.5; MTR SPEED; UNISOC) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.7.74689FP
Mozilla/5.0 (Cloud Phone 2.5; Mobicel C6; UNISOC) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.7.74689FP
Mozilla/5.0 (Cloud Phone 2.6; Mobicel S4; UNISOC) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.7.74689FP
Mozilla/5.0 (Cloud Phone 2.7; Proton Bolt 4G; UNISOC) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.7.74689FP
Mozilla/5.0 (Cloud Phone 3.1; Generic; ASR) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.7.74689FP
Mozilla/5.0 (Cloud Phone 3.1; Generic; UNISOC) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.5.16.72427FP
Mozilla/5.0 (Cloud Phone 3.1; Generic; SIMULATOR) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.5.74038FP
Mozilla/5.0 (Cloud Phone 2.7; Gamma W5; ASR) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.7.74689FP
Mozilla/5.0 (Cloud Phone 2.3; Snexian Guru; ASR) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.5.9.69953FP
Mozilla/5.0 (Cloud Phone 2.3; Snexian GURU 4G; ASR) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.4.5.68109FP
Mozilla/5.0 (Cloud Phone 2.3; Snexian ROCK; ASR) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.5.5.67765FP
Mozilla/5.0 (Cloud Phone 2.7; Snexian ROCK Gen2; ASR) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.7.74689FP
Mozilla/5.0 (Cloud Phone 2.7; Snexian bravo 4G; ASR) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.7.74689FP
Mozilla/5.0 (Cloud Phone 2.7; SIAVANTAGE Pro 4G 1; ASR) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.7.74689FP
Mozilla/5.0 (Cloud Phone 2.7; SIAVANTAGE Pro 4G 2; ASR) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.7.74689FP
Mozilla/5.0 (Cloud Phone 2.7; GDL Go 4G; UNISOC) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.7.74689FP
Mozilla/5.0 (Cloud Phone 2.6; GDL Switch 4G; UNISOC) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.7.74689FP
Mozilla/5.0 (Cloud Phone 2.5; BlackZone ULTRA 4G; UNISOC) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.7.74689FP
Mozilla/5.0 (Cloud Phone 2.5; BlackZone XR 4G; UNISOC) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.7.74689FP
Mozilla/5.0 (Cloud Phone 2.6; BlackZone LEGEND 4G; UNISOC) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.7.74689FP
Mozilla/5.0 (Cloud Phone 2.5; BlackZone TAURUS 4G; UNISOC) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.7.74689FP
Mozilla/5.0 (Cloud Phone 2.6; SEGO Super 4G; UNISOC) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.7.74689FP
Mozilla/5.0 (Cloud Phone 2.6; SEGO Super 4G Ultra; UNISOC) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.7.74689FP
Mozilla/5.0 (Cloud Phone 2.7; Goly Rebel 4G; ASR) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.7.74689FP
Mozilla/5.0 (Cloud Phone 3.1; CloudMosa CP01EU; UNISOC) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.7.74689FP
Mozilla/5.0 (Cloud Phone 3.1; CloudMosa CP01US; UNISOC) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.5.74038FP
Mozilla/5.0 (Cloud Phone 2.6; STYLO CLOUD 4G; UNISOC) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.5.74038FP
Mozilla/5.0 (Cloud Phone Touch; Generic) AppleWebKit/537.36 (KHTML like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.1.0.60975FP
Mozilla/5.0 (Cloud Phone 2.5; Generic; UNISOC) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.5.74038FP
Mozilla/5.0 (Cloud Phone Touch 3.1; Generic; UNISOC) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.3.72758FP
Mozilla/5.0 (Cloud Phone 2.5; Viettel Sumo 4G V1S; UNISOC) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.5.74038FP
Mozilla/5.0 (Cloud Phone 2.7; Foneme FM-2; ASR) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.5.16.72427FP
Mozilla/5.0 (Cloud Phone 2.5; Symphony EVO 10; UNISOC) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.5.12.71058FP
Mozilla/5.0 (Cloud Phone 2.3; itel it9020; UNISOC) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.0.70259FP
Mozilla/5.0 (Cloud Phone 2.5; itel it9300; UNISOC) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.4.6.69361FP
Mozilla/5.0 (Cloud Phone 2.5; itel it9310; UNISOC) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.6.2.69FP
Mozilla/5.0 (Cloud Phone 2.5; itel it9310A; UNISOC) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.5.15.71745FP
Mozilla/5.0 (Cloud Phone 2.5; HMD 105 4G; UNISOC) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.4.5.68109FP
Mozilla/5.0 (Cloud Phone 2.5; HMD 110 4G; UNISOC) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.4.5.68109FP
Mozilla/5.0 (Cloud Phone 2.4; Nokia 110 4G; UNISOC) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.4.6.69361FP
Mozilla/5.0 (Cloud Phone 2.4; Nokia 225 4G; UNISOC) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.6613.170 Mobile Safari/537.36 Puffin/128.5.16.72427FP
```

<u>Limitations</u>: these user agents are limited to a sample from a fixed time window, deduplicated on Cloud Phone version and build identifiers. PodLP is not available on all Cloud Phone models.

### Using User Agents

The most important user agent segmentation is between Cloud Phone and non-Cloud Phone devices. All Cloud Phone models will include the identifier `Cloud Phone`.

```js
function isCloudPhone() {
    const normalizedUserAgent = (navigator.userAgent || '').toLowerCase();
    return (
      normalizedUserAgent.includes('cloud phone')
    );
}
```

User agents can also be used for check Cloud Phone version (i.e. 2.7 vs 3.1), although [feature detection](https://developer.cloudfone.com/docs/reference/feature-detection/) and runtime checks for specific APIs are a more reliable way than version detection.

Finally, user agents could be used in contexts where feature detection isn't available to identify information like the device model and manufacturer. From the list above, popular Cloud Phone manufacturers include: Nokia, HMD, GDL, Goly, ringme, Foneme, BlackZone, Snexian, Itel, Viettel, and Proton.

## Conclusion

User agents are an easy way to adapt your widget to a variety of devices. While it's preferred to use [feature detection](https://developer.cloudfone.com/docs/reference/feature-detection/), knowing the gamut of available user agents helps determine the most reliable identifiers for segmentation or behavior change. If you need support adapting your Cloud Phone widget, contact the author from the [About]({{< ref "about" >}} "About") page.
