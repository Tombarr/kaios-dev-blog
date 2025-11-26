+++
title = "WebAssembly (WASM) on KaiOS"
description = "WebAssembly (WASM) and asm.js on KaiOS smart feature phones"
date = 2024-03-05T00:00:00+08:00
lastmod = 2024-03-05T00:00:00+08:00
toc = true
draft = false
header_img = "img/home-alt.png"
tags = ["KaiOS", "WASM", "WebAssembly", "asm.js"]
categories = []
series = ["Advanced Development"]
+++

# WebAssembly and asm.js on KaiOS

**What is [WebAssembly (WASM)](https://developer.mozilla.org/en-US/docs/WebAssembly)?** WASM allows developers to execute assembly-like low-level code written in languages like C/C++ or Rust via speecifically-compiled binaries within a web browser (in a sandboxed environment).

**KaiOS 2.5 doesn't support WASM**. However, **KaiOS supports [asm.js](https://developer.mozilla.org/en-US/docs/Games/Tools/asm.js)**, a highly optimized subset of JavaScript used as a low-level language compilation target.

**KaiOS 3.0 supports WASM**. Fortunately, KaiOS 3.0, which is based on Gecko 84, _does_ [support WebAssembly](https://developer.kaiostech.com/docs/sfp-3.0/introduction/overview) natively.

## Why use WebAssembly (WASM)?

WebAssembly is the best way to improve performance for CPU-bound tasks and is helpful in a variety of use cases.

* Recognizing QR code links in image via [tesserect.js](https://github.com/naptha/tesseract.js/)
* Detecting faces and facial features in photos via [pigo](https://github.com/esimov/pigo)
* Executing Python via Jupyter notebooks in the browser via [JupyterLite](https://github.com/jupyterlite/jupyterlite)
* Providing fast content search via [Stork](https://github.com/jameslittle230/stork)
* As a form of code protection via [SecurityWorker](https://github.com/ErosZy/SecurityWorker)

## asm.js and KaiOS 2.5

WebAssembly is typically used along performance-critical code paths for features like image processing (compression, scaling, and object detection). However, KaiOS 2.5 doesn't support WebAssembly natively so developers need to use compilers like [emscripten](https://github.com/emscripten-core/emscripten) to compile code written using a low-level language into a smaller, strict subset of JavaScript (JS) called asm.js.

asm.js modules are compiled accepting three standard parameters: a standard library, a foreign function interface (FFI), and an `ArrayBuffer` heap. The `"use asm"` pragma instructs the browser to treat the code below not as "normal" JS, but as the optimized subset. Performance gains are primarily due to type consistency and _virtually_ no garbage collection since memory is manually managed via a large typed array.

```js
function KaiAsmModule(stdlib, foreign, heap) {
    "use asm";

    // module code...

    return {
        export1: f1,
        export2: f2,
        // etc...
    };
}
```

**asm.js is optimized for machines, not humans**. As a result, developers shouldn't write asm.js code directly, but should compile it from a target language like C/C++. From a performance perspective, the intermediate asm.js code is closer to the performance of native code because it only provides access to strictly-typed integers, floats, arithmetic, function calls, and heap access. Some browsers, including that used in **KaiOS 2.5 recognize asm.js code and performs further optimizations**.

### Declaring asm.js Code

**Define asm.js modules with the [`precompile` property in `manifest.webapp`]({{< ref "manifest-properties#precompile-optional" >}} "precompile property")**. KaiOS compiles the code at install time off the main thread. This increases installation time, but decreases startup time.

```json
{
    "precompile": [
        "game.js",
        "database.js"
    ]
}
```

That's it! As an reference, take a look at [DOOM for KaiOS](https://github.com/pelya/doom-kaios).

Under the hood, [ScriptPreloader.jsm](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/apps/ScriptPreloader.jsm) calls [mozJSSubScriptLoader.cpp](https://github.com/kaiostech/gecko-b2g/blob/b2g48/js/xpconnect/loader/mozJSSubScriptLoader.cpp) to precompile defined scripts. Compiled script are then cached in persistent storage for faster access after installation. This behavior only applies to production applications signed and downloaded from the KaiStore or JioStore, not apps sideloaded in WebIDE.

If you're interested in how to program a KaiOS application using asm.js, check out Ian Rees' article on [Programming Rust for KaiOS](https://ianrrees.github.io/2019/11/04/programming-for-kaios.html).

### asm.js Deprecated

In 2018, [asm.js was deprecated](https://blog.unity.com/engine-platform/webassembly-is-here) with the introduction of WebAssembly (WASM). WASM is faster, smaller and more memory-efficient than asm.js. It's also [widely supported](https://caniuse.com/wasm) in 2024. However, since KaiOS 2.5 is based on Gecko 48 and doesn't support WASM, it's preferred to use asm.js for performance-critical code.

Firefox 22 was the first browser to support asm.js under the name [OdinMonkey](https://blog.mozilla.org/luke/2013/03/21/asm-js-in-firefox-nightly/). Chrome supported asm.js in [version 61](https://v8.dev/blog/v8-release-61#asm.js-is-now-validated-and-compiled-to-webassembly). Since asm.js was succeeded by WASM, it's primarily used for browsers like KaiOS 2.5 that doesn't support WASM.

If you're interested, the [WASM design FAQ](https://github.com/WebAssembly/design/blob/main/FAQ.md) covers the motivations behind WASM replacing asm.js. In summary, experiments showed compiled code decoded 20× faster and had shorter cold-load times than the already-optimized asm.js.

## WebAssembly (WASM) on KaiOS 3.0

Unlike KaiOS 2.5, **KaiOS 3.0 supports WebAssembly natively**. While asm.js files are text (albeit not human readable), WASM files are compiled binaries. Developers can still use [emscripten](https://emscripten.org/) or [binaryen](https://github.com/WebAssembly/binaryen) for compilation, and low-level code can remain largely unchanged from that used to generate asm.js code.

### Loading WASM Binaries

KaiOS 3.0 apps can include WASM binaries within the app bundle (for packaged apps), or download remotely and cache in storage like [IndexedDB]({{< ref "data-storage#indexeddb" >}} "IndexedDB"). If your binary changes regularly, it's best to download remotely, while static binaries are best packaged with application code.

WASM binary files use the `.wasm` file suffix and the `application/wasm` MIME type. They can be compiled and instantiated via the global [`WebAssembly` object](https://developer.mozilla.org/en-US/docs/WebAssembly/JavaScript_interface/instantiate_static).

```js
const importObject = {
  imports: {
    imported_func(arg) {
      console.log(arg);
    },
  },
};

// Using fetch then static instantiation
fetch("kaiModule.wasm")
  .then((response) => response.arrayBuffer())
  .then((bytes) => WebAssembly.instantiate(bytes, importObject))
  .then((result) => {
    result.instance.exports.exported_func()
  });

// Using the faster streaming instantiation
WebAssembly.instantiateStreaming(fetch("kaiModule.wasm"), importObject).then(
  (result) => result.instance.exports.exported_func(),
);
```

**KaiOS 3.0 supports both static and streaming instantiation**, with streaming instantiation being the most efficient, optimized way to load a WASM module. **Use the `application/wasm` MIME type** for remote WASM binaries. If you don't, `WebAssembly.instantiateStreaming` will throw an error.

> `WebAssembly.instantiateStreaming` failed. Assuming this is because your server does not serve wasm with `application/wasm` MIME type.

### Behind the Scenes

The Device Preference, `javascript.options.wasm`, controls whether WASM is available on KaiOS. By default, it's set to `true` for all KaiOS 3.0 devices, and `false` for KaiOS 2.5 devices. There's a handful of other, relevant preferences:

```js
pref("javascript.options.asmjs", true);
pref("javascript.options.wasm", true);
pref("javascript.options.wasm_trustedprincipals", true);
pref("javascript.options.wasm_verbose", false);
pref("javascript.options.wasm_baselinejit", true);
pref("javascript.options.wasm_reftypes", true);
pref("javascript.options.wasm_gc", false);
pref("javascript.options.wasm_multi_value", true);
```

On desktop Firefox, these values can be changed via `about:config`. However, on KaiOS 3.0 there is no way to modify Device Preferences, and on KaiOS 2.5, the preference `javascript.options.wasm` is present but has no effect.

### Debugging WASM

Since there are no KaiOS 3.0 devices that support Developer Tools, it's **not possible to debug WASM binaries on KaiOS** as of the time of writing. It's best to debug using Firefox 84 on a desktop.

## Conclusion

WASM is portable, compact, and fast. Compiling and executing native binaries on the web opens up many new possibilities for games and apps alike. However, it can be complicated managing multiple compilation targets and testing on two major platform versions. If you need support adapting your WebAssembly-based application for KaiOS, contact the author on the [About]({{< ref "about" >}} "About") page.
