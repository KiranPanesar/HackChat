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

// Used to connect to the server
-(void)connectSocket {
    _socketIO = [[SocketIO alloc] initWithDelegate:self];
    [_socketIO connectToHost:@"10.156.142.103" onPort:8000]; // Edit this to match your server
}

// Load the rooms for the user
-(void)loadRoomsForUser:(NSString *)username {
    // Set up end points
    endpoint = @"connect";
    arguments = @{@"username": username};
    
    // Connect sockets
    [self connectSocket];
}

// Join a room
-(void)joinRoom:(NSString *)roomName {
    // Set up endpoint
    endpoint = @"joinRoom";
    arguments = @{@"room": roomName, @"username":KP_USERNAME};

    // Connect
    [self connectSocket];
}

// Send a message
-(void)sendMessage:(NSString *)message fromUsername:(NSString *)username roomID:(NSString *)roomID {
    // Send an event to the server with roomID, username and message.
    [_socketIO sendEvent:@"msg" withData:@{@"room": roomID, @"username":username, @"msg":message}];
}

# pragma mark -
# pragma mark socket.IO-objc delegate methods

// When the socket has connected, run whatever request was queued up
- (void) socketIODidConnect:(SocketIO *)socket
{
    // If there's a request queued
    if (endpoint && arguments) {
        // Run the request
        [socket sendEvent:endpoint withData:arguments andAcknowledge:^(id argsData) {
        }];
    }
}

// When the server sends an event, process it and call the appropriate delegate method
- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    // If the event == loaded rooms
    if ([[[packet dataAsJSON] objectForKey:@"name"] isEqualToString:@"onConnect"]) {
        // Run delegate method for loading rooms
        if ([_delegate respondsToSelector:@selector(hackChat:didLoadRooms:)]) {
            [_delegate hackChat:self didLoadRooms:[[[[packet dataAsJSON] objectForKey:@"args"] objectAtIndex:0] allKeys]];
        }
    } else if ([[[packet dataAsJSON] objectForKey:@"name"] isEqualToString:@"onJoinRoom"]) {

        // If the user has just joined the room, call delegate method with messages returned
        if ([_delegate respondsToSelector:@selector(hackChat:didJoinRoom:)]) {
            NSMutableArray *messages = [[NSMutableArray alloc] init];
            
            for (NSDictionary *d in [[packet dataAsJSON] objectForKey:@"args"]) {
                NSDictionary *message = @{@"message": d[@"msg"], @"username":d[@"username"]};
                [messages addObject:message];
            }
            [_delegate hackChat:self didJoinRoom:messages];
        }
    } else if ([[[packet dataAsJSON] objectForKey:@"name"] isEqualToString:@"onMsg"]) {
        // If the user received a message, run the appropriate delegate method
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
