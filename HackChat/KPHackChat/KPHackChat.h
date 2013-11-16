//
//  KPHackChat.h
//  HackChat
//
//  Created by Kiran Panesar on 16/11/2013.
//  Copyright (c) 2013 MobileX Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketIO.h"

@class KPHackChat;

@protocol KPHackChatDelegate <NSObject>

@optional
-(void)hackChat:(KPHackChat *)chat didLoadRooms:(NSArray *)rooms;
-(void)hackChat:(KPHackChat *)chat didJoinRoom:(NSMutableArray *)messages;
-(void)hackChat:(KPHackChat *)chat didReceieveMessage:(NSMutableArray *)messages;

@end

@interface KPHackChat : NSObject  <SocketIODelegate> {
    NSString *endpoint;
    NSDictionary *arguments;
}

@property (strong, nonatomic) SocketIO *socketIO;
@property (strong, nonatomic) id<KPHackChatDelegate> delegate;

-(void)connectSocket;
-(void)loadRoomsForUser:(NSString *)username;
-(void)joinRoom:(NSString *)roomName;
-(void)sendMessage:(NSString *)message fromUsername:(NSString *)username roomID:(NSString *)roomID;

@end
