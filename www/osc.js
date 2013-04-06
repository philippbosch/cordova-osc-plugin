(function(cordova) {
    function OSCMessage(address) {
        this.address = address;
        this.typetag = '';
        this.values = [];
    }

    OSCMessage.prototype.add = function(value) {
        switch(typeof value) {
            case 'string':
                this.typetag += 's';
                this.values.push(value);
                break;

            case 'number':
                if (value % 1 === 0) {
                    this.typetag += 'i';
                } else {
                    this.typetag += 'f';
                }
                this.values.push(value);
                break;

            default:
                console.log('Unsupported data type: ' + typeof value);
        }
    }

    function OSCRemoteLocation(host, port) {
        this.host = host;
        this.port = port;
    }

    function OSC() {}

    OSC.prototype.sendMessage = function(msg, location, success, fail) {
        cordova.exec(success, fail, 'OSC', 'sendMessage', [location.host, location.port, msg.address, msg.typetag, msg.values]);
    }

    OSC.prototype.createMessage = function(address) {
        return new OSCMessage(address);
    }

    OSC.prototype.createRemoteLocation = function(host, port) {
        return new OSCRemoteLocation(host, port);
    }

    OSC.prototype.listen = function(port, success, fail) {
        cordova.exec(success, fail, 'OSC', 'startListening', [port]);
    }

    OSC.prototype.messageReceivedCallback = function(address, msgArray) {
        var msg = this.createMessage(address);
        for (var i in msgArray) {
            msg.add(msgArray[i]);
        }

        var ev = document.createEvent('HTMLEvents');
        ev.message = msg;
        ev.initEvent('oscmessagereceived', true, true);
        document.dispatchEvent(ev);
    };

    cordova.addConstructor(function() {
        if(!window.plugins) window.plugins = {};
        window.plugins.osc = new OSC();
    });

})(window.cordova || window.Cordova);
