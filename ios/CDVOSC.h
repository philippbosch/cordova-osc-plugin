//
//  CDVOSC.h
//  PhoneGapOSCTest
//
//  Created by Philipp Bosch on 04.04.13.
//
//

#import <Cordova/CDV.h>
#import "VVOSC.h"

@interface CDVOSC : CDVPlugin
{
    OSCManager *manager;
    OSCOutPort *outPort;
    OSCMessage *newMsg;
}

- (void)pluginInitialize;
- (void)sendMessage:(CDVInvokedUrlCommand *)command;
- (void)startListening:(CDVInvokedUrlCommand *)command;

@end
