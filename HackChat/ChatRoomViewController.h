//
//  ChatRoomViewController.h
//  HackChat
//
//  Created by Kiran Panesar on 16/11/2013.
//  Copyright (c) 2013 MobileX Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KPHackChat;

@interface ChatRoomViewController : UIViewController {
    UITableView *messagesTableView;
    NSMutableArray *messagesArray;
    NSString *roomName;
    
    UIToolbar *messageToolbar;
    UITextField *messagesTextField;
}

-(id)initWithRoomName:(NSString *)nameOfRoom;

@property (strong, nonatomic) KPHackChat *hackChat;

@end
