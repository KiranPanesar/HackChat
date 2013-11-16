//
//  KPHackChat.m
//  HackChat
//
//  Created by Kiran Panesar on 16/11/2013.
//  Copyright (c) 2013 MobileX Labs. All rights reserved.
//

#import "KPHackChat.h"
#import "SocketIOPacket.h"

@implementation KPHackChat

-(void)connectSocket {
    _socketIO = [[SocketIO alloc] initWithDelegate:self];
    [_socketIO connectToHost:@"10.156.142.103" onPort:8000];
}

-(void)loadRoomsForUser:(NSString *)username {
    endpoint = @"connect";
    arguments = @{@"username": @"k_panesar"};
    
    [self connectSocket];
}

-(void)joinRoom:(NSString *)roomName {
    endpoint = @"joinRoom";
    arguments = @{@"room": roomName, @"username":KP_USERNAME};

    [self connectSocket];
}

-(void)sendMessage:(NSString *)message fromUsername:(NSString *)username roomID:(NSString *)roomID {
    [_socketIO sendEvent:@"msg" withData:@{@"room": roomID, @"username":username, @"msg":message}];
}

# pragma mark -
# pragma mark socket.IO-objc delegate methods

- (void) socketIODidConnect:(SocketIO *)socket
{
    NSLog(@"socket.io connected.");

    if (endpoint && arguments) {
        [socket sendEvent:endpoint withData:arguments andAcknowledge:^(id argsData) {
            NSLog(@"Data: %@", argsData);
        }];
    }
}

-(void)socketIO:(SocketIO *)socket didSendMessage:(SocketIOPacket *)packet {
    
}

- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    if ([[[packet dataAsJSON] objectForKey:@"name"] isEqualToString:@"onConnect"]) {
        if ([_delegate respondsToSelector:@selector(hackChat:didLoadRooms:)]) {
            [_delegate hackChat:self didLoadRooms:[[[[packet dataAsJSON] objectForKey:@"args"] objectAtIndex:0] allKeys]];
        }
    } else if ([[[packet dataAsJSON] objectForKey:@"name"] isEqualToString:@"onJoinRoom"]) {
        if ([_delegate respondsToSelector:@selector(hackChat:didJoinRoom:)]) {
            NSMutableArray *messages = [[NSMutableArray alloc] init];
            
            for (NSDictionary *d in [[packet dataAsJSON] objectForKey:@"args"]) {
                NSDictionary *message = @{@"message": d[@"msg"], @"username":d[@"username"]};
                [messages addObject:message];
            }
            [_delegate hackChat:self didJoinRoom:messages];
        }
    } else if ([[[packet dataAsJSON] objectForKey:@"name"] isEqualToString:@"onMsg"]) {
        if ([_delegate respondsToSelector:@selector(hackChat:didReceieveMessage:)]) {
            NSMutableArray *messages = [[NSMutableArray alloc] init];
            
            for (NSDictionary *d in [[packet dataAsJSON] objectForKey:@"args"]) {
                NSDictionary *message = @{@"message": d[@"message"], @"username":d[@"username"]};
                [messages addObject:message];
            }
            [_delegate hackChat:self didReceieveMessage:messages];
        }
    }
}

- (void) socketIO:(SocketIO *)socket onError:(NSError *)error
{
    NSLog(@"onError() %@", error);
}


- (void) socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error
{
    NSLog(@"socket.io disconnected. did error occur? %@", error);
}

@end
