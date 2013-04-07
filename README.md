Cordova OSC Plugin
==================

This plugin enables your [Cordova](http://cordova.apache.org/) / [PhoneGap](http://phonegap.com/) app to send and receive [OSC](http://opensoundcontrol.org/spec-1_1) messages. It depends on the [VVOSC library](https://github.com/markcerqueira/vvosc-ios).


Installation
------------

1. Get **VVOSC** from [here](https://github.com/markcerqueira/vvosc-ios), either by cloning the repo (`git clone https://github.com/markcerqueira/vvosc-ios.git`) or by downloading and extracting a [ZIP file](https://github.com/markcerqueira/vvosc-ios/archive/master.zip).
2. Drag `VVOSC/include` and `VVOSC/libVVOSC.a` into your XCode project. Select the *Copy items into destination folder* and *Create groups for any added folders* options.
3. Clone the repository: `git clone https://github.com/philippbosch/cordova-osc-plugin.git`,
   *or:* download a [ZIP file](https://github.com/philippbosch/cordova-osc-plugin/archive/master.zip) and extract it.
4. Drag `CDVOSC.h` and `CDVOSC.m` from the `ios` folder to the `Plugins` folder in your XCode project.
5. Copy `osc.js` from the `www` folder to the `www` folder in your XCode project.
6. Add a reference to the JavaScript file in your HTML code right after the `cordova-x.x.x.js` script, like so:
   `<script src="osc.js"></script>`.
7. In your app's `config.xml` file look out for the `<plugins>` section and append `<plugin name="OSC" value="CDVOSC" />` to it.


Usage
-----

### Sending messages

```javascript
// setup the remote host to which you want to send messages
var remote = window.plugins.osc.createRemoteLocation('192.168.0.123', 11000);

// create an empty message with the desired address pattern
var msg = window.plugins.osc.createMessage('/address');

// add values to your message
msg.add(123);        // [i]ntegers, ...
msg.add(45.67);      // [f]loats, ...
msg.add("foo bar");  // or [s]trings are currently supported.

// send the message
window.plugins.osc.sendMessage(msg, remote, function() {
    console.log('Yay, the message was sent!');
}, function() {
    console.log('Oops, could not send the message.');
});
```

### Receiving messages

```javascript
// open a port for incoming messages
window.plugins.osc.listen(11001, function() {

    // add an event listener with a callback that is fired for each incoming message
    document.addEventListener('oscmessagereceived', function(event) {
        console.log(event.message.values);  // an array of all values
        console.log(event.message.typetag); // a string describing the data types, e.g. "ifs"
    });

}, function(error) {
    console.log("Unable to listen for messages: " + error);
});
```

License
-------

[MIT](http://philippbosch.mit-license.org/)
