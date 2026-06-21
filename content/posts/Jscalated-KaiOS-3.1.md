+++ title = "JScalated: From the browser to ADB on KaiOS 3.1" description = "A detailed guide to authorizing ADB on your KaiOS 3.1 phone" date = 2026-06-20T10:00:00+10:00 lastmod = 2026-06-21T02:30:00-05:00 toc = true draft = false header_img = "img/JScalated-Enable-Dev.jpg" tags = ["KaiOS", "Security", "KaiOS 3.1", "ADB"] categories = [] series = ["Advanced Development"] [params] featured_img = "img/JScalated-Enable-Dev.jpg" +++

JScalated exploits a Mozilla web development feature left enabled by the authors of KaiOS. It allows custom Javascript execution in the context of any currently displayed webpage. For most operating systems, this would not give the user a significant amount of extra control over their device, but KaiOS features a well-known rooted Engmode API. 

The Engmode API allows webapps to talk to the underlying Android operating system.  It has become more and more hardened throughout the history of KaiOS.  However, a few vulnerabilities have been found in the KaiOS 3.1 Engmode manager so that injection is trivial.  JScalated uses the improperly handled SetpropertyLE command shown below:
```ini
{if
(Object.keys(this.allowedPropsList)
.includes(propskey)){var command=
"setprop"+this.allowedPropsList[propskey]+"
"+value;if(DEBUG)
{debug("setPropertyLE: command = "+command);
}
```
The `propskey` is allowlisted, but the `value` is passed directly to `/system/bin/sh -c` Allowing commands to be appended with `&` or `;`.

The JScalated exploit is friendly to users who want to enable development tools on their phones (like ADB) and fortunately it is not a vulnerability that has been proven to be exploitable by unauthorized parties.  Thus the likelihood of KaiOS patching it is low.

## Summary
The exploit uses `javascript:` which is a quick and popular method for testing websites using script injection.  This is handled similarly to `about:` and `data:`  It is a built in Mozilla feature that can be called simply by typing `javascript:` into the address bar.  It's default domain (when ran without a page)  is `about:blank` which does not run with any KaiOS API permissions.

The tool that will be loaded has a wide set of capabilities, more will be added as it is a work in progress.  For those who want to debug-enable their devices and achieve more control, access, and debugging over their phones, please follow the guide below.
## Instructions
**(Step One)** The first step  is to connect your phone to the internet. When you type the Javascript commands below, please ensure that you can connect to `https://jscalated.netlify.app`
beforehand. They will fail if there is no connection.

**(Step Two)** The next step is to navigate to your KaiOS 3.1 phone web browser.  Go to `system.localhost/proxy.js` (Or any file in that domain) If you do not know how to navigate to a website address then you should not be following this guide. 

The next two steps are the hardest but of course the most rewarding.

**(Step Three)** Once you have navigated to system.localhost/proxy.js open the address bar (Without navigating away!) and type:
```js
javascript:s=document.createElement
('script')
```
You should see:
```
[object HTMLScriptElement]
```
**(Step Four)** The last step or at least the last step to initiate the tool is to type the following Javascript command: 
```js
javascript:(function(){var s=
document.createElement('script');s.src=
'https://jscalated.netlify.app/adb.js'
;document.body.appendChild(s)})()
```
## The Tool and Its Features
As of now, it has four capabilities.  Firstly it has the ability to start a relay that pings a local (or remote) server for shell commands.  The server and its usage instructions can be found at [kaios-agent.netlify.app](https://kaios-agent.netlify.app)  It can also enable ADB on any KaiOS 3.1 phone as long as the phone's  `/data/misc/` directory and its sub-directories are B2G accessible (Most KaiOS SELinux policies should allow it) The second feature is disabling preinstalled apps. The Important apps are protected from being disabled by JScalated, although it is possible to modify them using the third feature which is a B2G root shell restricted by SELinux. 
![JScalated Tool Javascript Picture](/img/JScalated-Tool.png "JScalated adb.js")

**Use:**
```ini 
unlink /data/local/webapps/vroot/*App-Name*
mkdir /data/local/webapps/installed/*App-Name*
cp /path/to/modded/application.zip /data/local/webapps/installed/*App-Name*/application.zip
cp /path/to/modded/manifest.webmanifest /data/local/webapps/installed/*App-Name*/manifest.webmanifest
ln -s /data/local/webapps/installed/*App-Name* /data/local/webapps/vroot/*App-Name*

```

**Advanced information regarding the exploit primitive:**

JScalated provides three easily accessible SELinux domains:
* `B2G`
* `Api-daemon`, 
* `Shell`
The logmanager domain is also partially accessible by corrupting the protperties fed into their init binaries.  One example is the Qualcomm specific binary in `/system/bin/lmqxdmservice`
```ini
function lmqxdmservice(){
  PATH_base=$(getprop persist.sys.kaiosqxdm.path)
  if [ ! "$PATH_base" == "" ] ; then
    chmod -R 777 ${PATH_base%/*}
  fi
  if [ "$(getprop persist.sys.kaiosqxdm.enable)" == "1" ] ; then
    if [ "$(getprop persist.sys.autolog.enable)" == "1" ] ; then
      startlmqxdmservice2
    else
      startlmqxdmservice
    fi
  fi
```
However, the logmanager domain has only the same capabilities as B2G. 

Init makes use of a lot of properties that are accessible to B2G but injecting into that domain is still being researched.  


**Coming Soon...**
As of the day of authorship, it has been discovered that the firefox-debugger socket is indeed accessible on KaiOS 3.1 phones.  This discovery has effectivly made the KaiOS 3.1 development landscape nearly identical to that of KaiOS 2.5, However root access is yet to be universally achieved.  The feature will be added to the tool soon as a one-click button, but the overall proccess is described below:
Place a user.js file in: `/data/b2g/mozilla/<Profile>.default/user.js`
The contents could be something like:
```js
user_pref("devtools.remote.usb.enabled", true);
user_pref("devtools.debugger.remote-enabled", true);
user_pref("devtools.debugger.unix-domain-socket", "/data/local/firefox-debugger-socket");
```
Then try:
```
chmod 600 /data/b2g/mozilla/f5b2oed3.default/user.js
setprop ctl.restart b2g
```
And with ADB:
```
adb forward tcp:6000 localfilesystem:/data/local/firefox-debugger-socket
```
**Use of the debugger socket**
Install a supported version of Firefox, Firefox Nightly or Pale Moon (Untested) with WebIDE.

Open Firefox or Pale Moon and click the menu at the top of the application.  Look for developer section and click WebIDE in the drop-down. The exact instructions differ for every build.
More information regarding use of the debugger socket can be found at [Bananahackers](https://sites.google.com/view/bananahackers/development/webide)

Overall the development of this tool took about a year of research with some background knowledge and a failed attempt to hack the Nokia 2760.  It will be updated and maintained as long as possible.  Enjoy and use responsibly!



