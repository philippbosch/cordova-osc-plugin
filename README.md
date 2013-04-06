Cordova OSC Plugin
==================

This plugin enables your app to send and receive [OSC](http://opensoundcontrol.org/spec-1_1) messages.


Installation
------------

1. Clone the repository: `git clone https://github.com/philippbosch/cordova-osc-plugin.git`,
   *or:* download a [ZIP file](https://github.com/philippbosch/cordova-osc-plugin/archive/master.zip) and extract it.
2. Copy `CDVOSC.h` and `CDVOSC.m` from the `ios` folder to the `Plugins` folder in your XCode project.
3. Copy `osc.js` from the `www` folder to the www folder in your XCode project.
4. Add a reference to the JavaScript file in your HTML code right after the `cordova-x.x.x.js` script, like so:
   `<script src="osc.js"></script>`.
5. In your app's `config.xml` file look out for the `<plugins>` section and append `<plugin name="OSC" value="CDVOSC" />` to it.



License
-------

[MIT](http://philippbosch.mit-license.org/)
