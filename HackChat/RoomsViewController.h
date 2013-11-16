//
//  RoomsViewController.h
//  HackChat
//
//  Created by Kiran Panesar on 16/11/2013.
//  Copyright (c) 2013 MobileX Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KPHackChat;

@interface RoomsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView *roomsTableView;
    NSArray *hackChatRooms;
}

@property (strong, nonatomic) KPHackChat *hackChat;
@end
