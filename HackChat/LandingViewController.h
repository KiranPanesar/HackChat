//
//  LandingViewController.h
//  HackChat
//
//  Created by Kiran Panesar on 16/11/2013.
//  Copyright (c) 2013 MobileX Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"

@interface LandingViewController : UIViewController {
    UILabel     *usernameLabel;
    UILabel     *instructionsLabel;
    UIImageView *instructionsArrow;
}

-(id)initWithUsername:(NSString *)username;

@end
