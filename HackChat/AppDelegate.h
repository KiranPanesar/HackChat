//
//  AppDelegate.h
//  HackChat
//
//  Created by Kiran Panesar on 16/11/2013.
//  Copyright (c) 2013 MobileX Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SignInViewController;
@class LandingViewController;
@class KPHackChat;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SignInViewController  *signInViewController;
@property (strong, nonatomic) LandingViewController *landingViewController;
@property (strong, nonatomic) KPHackChat *chat;

@end
