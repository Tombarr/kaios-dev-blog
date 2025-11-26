+++
title = "Announcing kaios-types: KaiOS TypeScript Declarations"
description = "The kaios-types library includes TypeScript declarations for many proprietary KaiOS APIs and extensions"
date = 2025-11-24T00:00:00+08:00
lastmod = 2025-11-24T00:00:00+08:00
toc = true
draft = false
header_img = "img/home-alt.png"
tags = ["KaiOS", "TypeScript", "Types"]
categories = []
series = ["Advanced Development"]
+++

Building for KaiOS using modern tools can be challenging. Most KaiOS devices run KaiOS 2.5 which is based on Firefox 48, initially released nearly a decade ago in 2016. However, KaiOS includes several modern features like `Promises`and CSS `grid` that don't perfectly align with it's base Gecko engine.

Building KaiOS apps often requires a transpiler like [Babel](https://babeljs.io/), but to make things even more complicated, KaiOS uses a number of non-standard APIs or APIs based on outdated specifications. That's where [`kaios-types`](https://github.com/Tombarr/kaios-types) can help!

## Introducing `kaios-types`

`kaios-types` is an open-source–[Apache 2.0](https://github.com/Tombarr/kaios-types/blob/main/LICENSE) licensed–library containing [TypeScript](https://www.typescriptlang.org/) type declarations for most KaiOS 2.5 APIs. It's hosted on [NPM](https://www.npmjs.com/package/kaios-types) where it can be installed and configured for any codebase.

`kaios-types` provides more confidence developing KaiOS apps with type safety. It also leverages [TSDoc syntax](https://tsdoc.org/) for documentation and is structured in a way to support [IntelliSense](https://code.visualstudio.com/docs/editing/intellisense), enabling Visual Studio Code to provide structured code completion.

### Installation

**NPM**

```bash
npm install --save-dev kaios-types
```

**PNPM**

```bash
pnpm add kaios-types --save-dev
```

**Bun**

```bash
bun add --development kaios-types
```

### Configuration

Add the types to your `tsconfig.json`:

```json
{
  "compilerOptions": {
    "types": ["kaios-types"]
  }
}
```

Or use a triple-slash directive at the top of your TypeScript files:

```typescript
/// <reference types="kaios-types" />

// Now KaiOS APIs are available with full type checking
const settings = navigator.mozSettings;
settings.createLock().set({ 'wifi.enabled': true });
```

#### Modular Imports

You can also import specific types directly:

```typescript
import { MozActivity, ActivityOptions } from 'kaios-types/apps/moz-activity';
import { BluetoothManager } from 'kaios-types/bluetooth/bluetooth-manager';

const activity = new MozActivity({
  name: 'pick',
  data: { type: 'image/jpeg' }
});
```

## Conclusion

Building KaiOS apps just got easier with `kaios-types`. However, feature phone web development remains fragments across three major KaiOS versions–2.5, 3.0, and 4.0–in addition to Cloud Phone. If you need a partner to assist in flip phone development, contact the author from the [About]({{< ref "about" >}} "About") page.
