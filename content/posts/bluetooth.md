+++
title = "Bluetooth Low Energy on KaiOS"
description = "Working with Bluetooth Low Energy (BLE) on KaiOS"
date = 2023-08-14T00:00:00+08:00
lastmod = 2023-08-15T00:00:00+08:00
toc = true
draft = false
header_img = "img/home-alt.png"
tags = ["KaiOS", "Bluetooth", "BLE"]
categories = []
series = ["Advanced Development"]
+++

Working with Bluetooth Low Energy (BLE) on KaiOS

## Use Cases

Bluetooth Low Energy (BLE) is a recent version of Bluetooth designed for very low power consumption. Compared to Bluetooth Enhanced Data Rate (EDR), BLE is designed to transfer much smaller amounts of data between devices via an ephemeral connection, not a durable pairing. Common BLE applications include:

* Healthcare devices - Thermometer, heart rate and glucose monitor, etc
* Proximity sensing - Tile, AirTag, "Find my" device
* Contact tracing - People near me
* Remote sensing - Battery level, volume, etc

## Accessing Bluetooth APIs

### Permissions

The [`"bluetooth"`](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/apps/PermissionsTable.jsm#L155) permission is needed to access Bluetooth Low Energy APIs on KaiOS. Although the permission is available to both `privileged` and [`certified` apps]({{< ref "./kaios-permissions" >}}), **many Bluetooth features are only available in `certified` apps.**

### Availability

While most KaiOS devices support Bluetooth, it's possible your app might get installed on a device without Bluetooth. KaiOS has no direct analog to the [`uses-feature`](https://developer.android.com/guide/topics/manifest/uses-feature-element) element in `AndroidManifest.xml`, so it's not possible to prevent installation on unsupported devices. However, **you can detect Bluetooth support at runtime**.

The [`feature-detection`]({{< ref "./kaios-permissions#feature-detection" >}}) permission exposes an API to check the availability of specific device features and capabilities. For Bluetooth, check the `device.bt` key using the code below:

```js
navigator.hasFeature('device.bt')
    .then((hasBluetooth) => {
        if (hasBluetooth) {
            /* Use Bluetooth */
        }
    });
```

<u>Note</u>: feature detection returns static values that describe what the device model is reportedly capably of, not what capabilities are presently available.

### BT Interfaces

Bluetooth APIs are accessible via the BluetoothManager interface for both KaiOS 2.5 & 3.0.

KaiOS 2.5: `navigator.mozBluetooth`<br />
KaiSO 3.0: `navigator.b2g.mozBluetooth`

*Runtime Check*: If your app was not granted the `bluetooth` permission, then these APIs will not be available. Confirm with a simple check, i.e. `navigator.mozBluetooth !== null`.

<u>Note</u>: **KaiOS does not support the [Web Bluetooth API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Bluetooth_API)**. Instead, use [BluetoothAdapter](https://wiki.mozilla.org/B2G/Bluetooth/WebBluetooth-v2/BluetoothAdapter) from FirefoxOS/ Boot2Gecko (B2G). The APIs are largely unchanged on KaiOS.

### Bluetooth Adapter

Although KaiOS APIs support multiple BluetoothAdapters, **all devices available today have a single antenna**. The default adapter is accessible via `mozBluetooth.defaultAdapter`. However, the default BluetoothAdapter may not be immediately available after `DOMContentLoaded`. To listen for availability without polling, listen for the `attributechanged` event on BluetoothManager. The event passed to the callback is a [`BluetoothAttributeEvent`](https://github.com/kaiostech/gecko-b2g/blob/gonk/dom/webidl/BluetoothAttributeEvent.webidl) with an extra `attrs` property, listing all the attributes that have changed.

The example below can be used at any point in the DOM rendering lifecycle and returns a `Promise` that will resolve to the default BluetoothAdapter, when it becomes available.

```js
function getBluetoothAdapter() {
    if (navigator.mozBluetooth.defaultAdapter) {
        return Promise.resolve(navigator.mozBluetooth.defaultAdapter);
    }

    return new Promise((resolve) => {
        navigator.mozBluetooth.onattributechanged = (e) => {
            if (e.attrs.some((attr) => attr === 'defaultAdapter')) {
                navigator.mozBluetooth.onattributechanged = null;
                resolve(navigator.mozBluetooth.defaultAdapter);
            }
        };
    });
}
```

<u>Note</u>: a more robust version of this function would include a timeout, in the event that the BluetoothAdapter does not become available.

## Bluetooth Low Energy

### BLE Interfaces

```ts
mozBluetooth.defaultAdapter.gattServer;
mozBluetooth.defaultAdapter.startLeScan(serviceUuids: string[]): Promise<BluetoothDiscoveryHandle>;
mozBluetooth.defaultAdapter.stopLeScan(discoveryHandle: BluetoothDiscoveryHandle);
```

### Discovering (Peripheral)

Scan for nearby BLE devices with `startLeScan`. It takes an optional list of GATT Service UUIDs to filter results and returns a `Promise` that resolves to a handle that can be passed to `stopLeScan` to stop discovering devices.

```ts
mozBluetooth.defaultAdapter.startLeScan(serviceUuids: string[]): Promise<BluetoothDiscoveryHandle>;
mozBluetooth.defaultAdapter.stopLeScan(discoveryHandle: BluetoothDiscoveryHandle);
```

The [`BluetoothDiscoveryHandle`](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/webidl/BluetoothDiscoveryHandle.webidl) published a `devicefound` that can be listened to when new devices are discovered. For BLE devices, the event passed to the callback is a [`BluetoothLeDeviceEvent`](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/webidl/BluetoothLeDeviceEvent.webidl) with a few important properties, namely `device` which is a [`BluetoothDevice`](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/webidl/BluetoothDevice.webidl) and `rssi` (received signal strength indication) which is a relative index of how close or far the device is.

Here is a simple example putting it all together that scans for 5 seconds and logs devices to the console.

```js
navigator.mozBluetooth.defaultAdapter.startLeScan()
    .then((handle) => {
        handle.ondevicefound = (leDeviceEvent) => {
            let nameOrAddress = leDeviceEvent.device.name || leDeviceEvent.device.address;
            console.log(`Device found ${nameOrAddress} RSSI = ${leDeviceEvent.rssi}`);
        };

        setTimeout(() => {
            navigator.mozBluetooth.defaultAdapter.stopLeScan(handle);
        }, 5000)
    });
```

### Connecting

Once a device has been discovered, the next step is to connect to it. `BluetoothDevice` has the `gatt` property (type [`BluetoothGatt`](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/webidl/BluetoothGatt.webidl)) that help a few helpful methods:

* `connect` and `disconnect` to connect/cisconnect to the remote BLE device.
* `discoverServices` to discover services, characteristics, descriptors offered by the remote GATT.
* `readRemoteRssi` to read RSSI for the remote BLE device.

<u>Note</u>: All of the above methods return a `Promise` that might reject depending on the connection state of the remote device.

#### Services and Characteristics

Once connected, the next step is to find the service(s) of interest and read/ write values. The `services` array of [`BluetoothGattService`](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/webidl/BluetoothGattService.webidl) lists services that can be identified via UUID. Each service itself has an array of [`BluetoothGattCharacteristic`](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/webidl/BluetoothGattCharacteristic.webidl) from which we can finally read or write values, depending on permissions.

#### Reading and Writing

The value of a characteristic is stored as an `ArrayBuffer` via the `value` property. Calling `readValue` will return a `Promise` that resolves to the remote characteristic value. Writing works via the `writeValue` method.

```js
handle.ondevicefound = (leDeviceEvent) => {
    let device = leDeviceEvent.device;
    device.gatt.connect()
        .then(() => device.gatt.discoverServices())
        .then(() => device.gatt.services[0].characteristics[0].readValue())
        .then((valueBuffer) => /* TODO: read ArrayBuffer */)
};
```

#### Notifications and Indications

**KaiOS does not support notifications or indications**! During runtime testing across a number of devices, I have been unable to receive notifications or indications via the `startNotifications` method. No `characteristicchanged` events (or any BLE events) are published for notifications.

### GATT Server (Central)

KaiOS devices can also act as central devices and provide GATT services. The first step is to create a `BluetoothGattService` using the constructor, then add characteristics to the service with the appropriate properties and permissions.

```js
const SERVICE_UUID = '57bb7cb8-7700-4971-a20b-74a1f0c070c0';
let service = new BluetoothGattService({
    isPrimary: true,
    uuid: SERVICE_UUID,
});
let defaultAdapter = navigator.mozBluetooth.defaultAdapter;
```

<u>Note</u>: `addCharacteristic` returns a `Promise`, so it's best to wait for this to resolve before adding the service to the [BluetoothGattServer](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/webidl/BluetoothGattServer.webidl).

```js
service.addCharacteristic(
    'e8ef9b49-3b70-411b-9ded-f8bf6d651f38',
    { read: true, readEncrypted: true },
    { read: true, broadcast: true },
    new ArrayBuffer()
)
.then(() => defaultAdapter.gattServer.addService(service))
.then(() => defaultAdapter.setDiscoverable(true))
.then(() => defaultAdapter.gattServer.startAdvertising({
    includeDevName: true,
    includeTxPower: true
    serviceUuid: SERVICE_UUID,
    serviceUuids: [SERVICE_UUID],
}));
```

Once the service is added, make sure the device is discoverable and finally, call `startAdvertising` to begin advertising the GATT service to nearby devices. `startAdvertising` accepts a [`BluetoothAdvertisingData`](https://github.com/kaiostech/gecko-b2g/blob/b2g48/dom/webidl/BluetoothGattServer.webidl#L7) object with some optional properties like `includeDevName`, which will broadcast the device's name (i.e. "Nokia 8110 4G" by default) and `includeTxPower`, which will broadcast the Transmit (Tx) power. You can even set the name yourself via the `defaultAdapter.setName` method.

<u>Note</u>: during runtime testing, I have found that **only one service** can be active and broadcast at a time. The service can have multiple characteristics, but KaiOS does not appear to reliably support broadcasting multiple services.

## Conclusion

With different Bluetooth standard versions and configurations, it can be a challenge to leverage complex networking technologies like Bluetooth. Always test your code on actual devices, since KaiOS phones may not perform as expected or as documented. Finally, test connectivity with a range of devices and prototype quickly with free utility apps like [Bluetility](https://github.com/jnross/Bluetility) (Mac OS) and [LightBlue](https://apps.apple.com/us/app/lightblue/id557428110) (iOS).

<u>Tip</u>: It can be helpful to convert the Firefox WebIDL interface definitions into TypeScript type definitions to more easily and safely code with unfamliar KaiOS Bluetooth APIs.

### Credits

Thank you to Jan Frydendal of [MochaSoft](https://mochasoft.dk/) who provided insights from his own testing of Bluetooth Low Energy compatibility and support on KaiOS.

### Contact Author

Bluetooth Low Energy (BLE) is a very useful technology for discovering and connecting to nearby devices to exchange small pieces of information. If you are interested in extending your company's Bluetooth offering to KaiOS, learn more about the author and find contact information on the [About]({{< ref "about" >}} "About") page.
