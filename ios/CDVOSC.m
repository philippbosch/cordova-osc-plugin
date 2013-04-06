//
//  CDVOSC.m
//  PhoneGapOSCTest
//
//  Created by Philipp Bosch on 04.04.13.
//
//

#import "CDVOSC.h"
#import <Cordova/CDV.h>
#import "VVOSC.h"


@implementation CDVOSC

- (void)pluginInitialize
{
    manager = [[OSCManager alloc] init];
    [manager setDelegate:self];
}

- (void)sendMessage:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* host = [command.arguments objectAtIndex:0];
    int port = [[command.arguments objectAtIndex:1] integerValue];
    NSString* address = [command.arguments objectAtIndex:2];
    NSString* typeTag = [command.arguments objectAtIndex:3];
    NSArray* data = [command.arguments objectAtIndex:4];

    if (!outPort || ![outPort.addressString isEqualToString:host] || (outPort.port != port)) {
        outPort = [manager createNewOutputToAddress:host atPort:port];
    }

    if (typeTag.length != data.count) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"data and type tag lenghts do not match"];
    } else {
        newMsg = [OSCMessage createWithAddress:address];

        for (int i=0; i<data.count; i++) {
            id value = [data objectAtIndex:i];
            unichar type = [typeTag characterAtIndex:i];

            if (type == 'i') {
                [newMsg addInt:[value integerValue]];
            } else if (type == 'f') {
                [newMsg addFloat:[value floatValue]];
            } else if (type == 's') {
                [newMsg addString:value];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"unsupported data type"];
                [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
                return;
            }
        }

        [outPort sendThisMessage:newMsg];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"OK"];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)startListening:(CDVInvokedUrlCommand *)command {
    CDVPluginResult* pluginResult = nil;
    int port = [[command.arguments objectAtIndex:0] integerValue];

    if ([manager createNewInputForPort:port]) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"OK"];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"could not listen on port %d", port]];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)receivedOSCMessage:(OSCMessage *)message {
    [self performSelectorOnMainThread:@selector(executeMessageReceivedCallback:) withObject:message waitUntilDone:NO];
}

- (void)executeMessageReceivedCallback:(OSCMessage *)message {
    NSMutableArray* values = [[NSMutableArray alloc] init];

    for (OSCValue* value in message.valueArray) {
        switch (value.type) {
            case OSCValInt:
                [values addObject:[NSNumber numberWithInt:value.intValue]];
                break;

            case OSCValFloat:
                [values addObject:[NSNumber numberWithFloat:value.floatValue]];
                break;

            case OSCValString:
                [values addObject:(id)value.stringValue];
                break;

            default:
                break;
        }
    }

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:values options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *jsStatement = [NSString stringWithFormat:@"window.plugins.osc.messageReceivedCallback('%@', %@);", message.address, jsonString];
    [self writeJavascript:jsStatement];
}

@end
