//
//  SignInViewController.h
//  HackChat
//
//  Created by Kiran Panesar on 16/11/2013.
//  Copyright (c) 2013 MobileX Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KPHackChat;

@interface SignInViewController : UIViewController {
    UITextField *usernameTextField;
    UIImageView *wallImageView;
    
    UIImageView *iconImageView;
    
    UIView    *signInBackgroundView;
    UILabel   *signInLabel;
    FUIButton *signInButton;
    
    UILabel   *infoLabel;
}

@property (strong, nonatomic) KPHackChat *hackChat;

@end
