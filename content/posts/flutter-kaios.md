+++
title = "Developing with Flutter on KaiOS"
description = "Developing apps for KaiOS using Flutter"
date = 2024-02-26T00:00:00+08:00
lastmod = 2024-02-26T00:00:00+08:00
toc = true
draft = false
header_img = "img/home-alt.png"
tags = ["KaiOS", "Flutter"]
categories = []
series = ["Advanced Development"]
+++

## Developing with Flutter on KaiOS

**Why it matters?** [Flutter](https://flutter.dev/) is a leading, open source, multi-platform development framework by Google to build apps for iOS and Android, as well as web browsers and embedded devices.

**In a nutshell**. [Framework selection]({{< ref "optimization-tips#framework-selection" >}} "Framework selection") is critical for KaiOS development, since devices have limited storage and resources. **Runtimes like Flutter notorious for large bundle sizes are not recommended for KaiOS**.

### Practical Optimizations

Developers have been experimenting with [Flutter on KaiOS](https://jod.li/2021/05/01/flutter-on-kaios/) since at least 2021. If you're determined to build a KaiOS application using Flutter, or you'd like to optimize an existing Flutter project for KaiOS, use the following tips.

1. Remove the default [`cupertino_icons`](https://pub.dev/packages/cupertino_icons) from `pubspec.yml`
2. Set [`uses-material-design`](https://docs.flutter.dev/ui/design/material) to `false` in `pubspec.yml`
3. Use the HTML [web renderer](https://docs.flutter.dev/platform-integration/web/renderers)
4. Don't bundle debug resources like [source maps](https://web.dev/articles/source-maps)
5. Remove the [NOTICES file](https://stackoverflow.com/questions/64601515/how-do-i-minimize-the-size-of-a-flutter-web-release-is-the-notices-file-require), if present

When building for KaiOS, use the following command:

```bash
flutter build web --release --web-renderer html --no-web-resources-cdn --no-source-maps
```

**Flags**

* `--release` minifies the compiled code
* `--web-renderer html` selects the HTML web renderer (instead of CanvasKit)
* `--no-web-resources-cdn` compiles resources locally (needed because of KaiOS' default [Content Security Policy (CSP)]({{< ref "./manifest-properties#csp-optional" >}}))
* `--no-source-maps` removes source maps like those referenced via terminal comments `//# sourceMappingURL=flutter.js.map`

#### Minification

Always [minify](https://docs.flutter.dev/deployment/web#minification) your compiled code before packaging and shipping a Flutter app for KaiOS. Tree-shaking and minification are only performed when the `--release` flag is set.

| Build Type       | Minification   | Tree-Shaking   |
|------------------|----------------|----------------|
| debug            | No             | No             |
| profile          | No             | Yes            |
| release          | Yes            | Yes            |

### Flutter Bundle Size

With all of the above optimizations on a Hello, World application, compiled file sizes for Flutter were as follows:

| Build File                  | Size   |
|-----------------------------|--------|
| `main.dart.js`              | 1.4 MB |
| `flutter_service_worker.js` | 8 KB   |
| `flutter.js`                | 4 KB   |
| `index.html`                | 2 KB   |

This test was done using Flutter 3.19.1, Dart 3.3.0, and DevTools 2.31.1. The **final bundle size (zipped) of a Hello, World Flutter app for KaiOS was 471 KB**. This isn't ideal since it doesn't include fonts, images, or application code, but it is manageable.

<u>Use Terser</u>: additionally, use a minification library like [Terser](https://terser.org/). Terser v5.20.0 shaved 87 KB (6.4%) off `main.dart.js`. More than enough to be worth it.

![Network tab for a Hello, World Flutter App](/img/flutter-network-info.png "Network tab for a Hello, World Flutter App")

### CanvasKit and Skasm

**Don't use [CanvasKit](https://skia.org/docs/user/modules/canvaskit/) on KaiOS**. CanvasKit is great. It renders components pixel-perfect and more consistently across browsers than HTML. However, CanvasKit adds about 1.5 MB to your application bundle and worse, the runtime performance on non-hardware accelerated budget KaiOS phones makes it simply unusable.

**Skasm doesn't work on KaiOS**. KaiOS 3.0 introduced native [WASM support](https://developer.kaiostech.com/docs/sfp-3.0/introduction/overview/). For all devices running KaiOS 2.5 (the majority of KaiOS phones), you'll need to use asm.js and emscripten. _Yes_, you can run [DOOM](https://github.com/pelya/doom-kaios) on KaiOS 2.5, but it's not recommended.

### Other Resources

The KaiOS developer community hasn't invested heavily in Flutter. [SnowQueen](https://www.reddit.com/r/KaiOS/comments/163rp0g/snowqueen_a_framework_for_building_native_kaios/) is one tool you can use to [compile pure Dart](https://github.com/breitburg/snowqueen) alongside a set of basic UI elements. For more resources, see the full list of [open source KaiOS projects]({{< ref "kaios-open-source" >}} "open source KaiOS projects").

## Conclusion

![Call tree of a simple button click in a Flutter app](/img/flutter-call-tree.png "Call tree of a simple button click in a Flutter app")

While the Flutter web renderer reached a [stable milestones](https://medium.com/flutter/flutter-web-support-hits-the-stable-milestone-d6b84e83b425) in 2021, it generates large bundle sizes with non-optimal runtime performance on low-end KaiOS devices. If you're developing a new application, pick a [framework]({{< ref "optimization-tips#framework-selection" >}} "framework") like [Svelte](https://svelte.dev/) or [SolidJS](https://www.solidjs.com/) as these produce [smaller bundle sizes](https://dev.to/pazu/which-js-framework-is-the-smallest-161p) and perform well on under-resourced devices. If you need support optimizing your application for KaiOS, contact the author from the [About]({{< ref "about" >}} "About") page.
