//
//  TBXMPPMessagesHandler.m
//  Cryptocat
//
//  Created by Thomas Balthazar on 01/10/13.
//  Copyright (c) 2013 Thomas Balthazar. All rights reserved.
//

#import "TBXMPPMessagesHandler.h"

#import "XMPP.h"
#import "TBXMPPManager.h"
#import <TBOTRManager.h>
#import "XMPPMessage+XEP0045.h"
#import "XMPPMessage+Cryptocat.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TBXMPPMessagesHandler () <TBOTRManagerDelegate>

@property (nonatomic, strong) TBXMPPManager *XMPPManager;
@property (nonatomic, strong) TBOTRManager *OTRManager;

- (void)handlePrivateMessage:(XMPPMessage *)message myRoomJID:(XMPPJID *)myRoomJID;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TBXMPPMessagesHandler

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Initializer

////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithXMPPManager:(TBXMPPManager *)XMPPManager {
  if (self=[super init]) {
    _XMPPManager = XMPPManager;
    _OTRManager = [TBOTRManager sharedOTRManager];
    _OTRManager.delegate = self;
  }
  
  return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public Methods

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)handleMessage:(XMPPMessage *)message myRoomJID:(XMPPJID *)myRoomJID {
  if ([message tb_isArchiveMessage]) return;
  if (message.from==myRoomJID) return;
  
  // TODO: If message is from someone not on buddy list, ignore.
  
  // -- composing
  if ([message tb_isComposingMessage]) {
    TBLOG(@"-- %@ is composing", message.fromStr);
  }
  
  // TODO : Check if message has an "active" (stopped writing) notification.
  
  // -- publicKey
  else if ([message tb_isPublicKeyMessage]) {
    TBLOG(@"-- publicKey message : %@", message);
  }
  
  // -- publicKey request
  else if ([message tb_isPublicKeyRequestMessage]) {
    TBLOG(@"-- this is a public key request message : %@", [message body]);
  }
  
  // -- group chat
  else if ([message isGroupChatMessage]) {
    TBLOG(@"-- group message from %@ to %@ : %@", message.fromStr, message.toStr, message.body);
  }
  
  // -- private chat
  else if ([message isChatMessage]) {
    [self handlePrivateMessage:message myRoomJID:myRoomJID];
  }
  
  // -- other messages
  else {
    TBLOG(@"-- message : %@", message);
  }
  
  //  - (BOOL)isChatMessage;
  //  - (BOOL)isChatMessageWithBody;
  //  - (BOOL)isErrorMessage;
  //  - (BOOL)isMessageWithBody;
  //  - (BOOL)isGroupChatMessage;
  //  - (BOOL)isGroupChatMessageWithBody;
  //  - (BOOL)isGroupChatMessageWithSubject;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private Methods

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)handlePrivateMessage:(XMPPMessage *)message myRoomJID:(XMPPJID *)myRoomJID {
  TBLOG(@"-- private message from %@ to %@ : %@", message.fromStr, message.toStr, message.body);
  
  NSString *messageBody = message.body;
  NSString *accountName = myRoomJID.full;
  NSString *sender = message.fromStr;

  NSString *decodedMessage = [self.OTRManager decodeMessage:messageBody
                                                     sender:sender
                                                accountName:accountName
                                                   protocol:@"xmpp"];
  
  NSLog(@"-- decoded message : |%@|", decodedMessage);

// send a dummy message
//  if (![decodedMessage isEqualToString:@""]) {
//    NSString *encryptedMessage = [self.OTRManager encodeMessage:@"Not much!"
//                                                      recipient:message.fromStr
//                                                    accountName:myRoomJID.full
//                                                       protocol:@"xmpp"];
//    [self.XMPPManager sendMessageWithBody:encryptedMessage recipient:message.fromStr];
//  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TBOTRManagerDelegate

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)OTRManager:(TBOTRManager *)OTRManager
       sendMessage:(NSString *)message
       accountName:(NSString *)accountName
                to:(NSString *)recipient
          protocol:(NSString *)protocol {
  [self.XMPPManager sendMessageWithBody:message recipient:recipient];
}

@end