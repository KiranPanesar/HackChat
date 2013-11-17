//
//  SignInViewController.m
//  HackChat
//
//  Created by Kiran Panesar on 16/11/2013.
//  Copyright (c) 2013 MobileX Labs. All rights reserved.
//

#import "SignInViewController.h"
#import "KPHackChat.h"

#define NAVIGATION_BAR_OFFSET 44.0f

#define ICON_IMAGE_VIEW_X_INSET (self.view.frame.size.width/2.0f - ICON_IMAGE_VIEW_WIDTH/2.0f)
#define ICON_IMAGE_VIEW_Y_INSET (80.0f)
#define ICON_IMAGE_VIEW_WIDTH   135.0f
#define ICON_IMAGE_VIEW_HEIGHT  ICON_IMAGE_VIEW_WIDTH

#define LOG_IN_VIEW_X_INSET (self.view.frame.size.width/2.0f - LOG_IN_VIEW_WIDTH/2.0f)
#define LOG_IN_VIEW_Y_INSET (ICON_IMAGE_VIEW_Y_INSET + 30.0f + ICON_IMAGE_VIEW_HEIGHT)
#define LOG_IN_VIEW_WIDTH   280.0f
#define LOG_IN_VIEW_HEIGHT  150.0f

#define INFO_LABEL_X_INSET LOG_IN_VIEW_X_INSET
#define INFO_LABEL_Y_INSET (self.view.frame.size.height - INFO_LABEL_HEIGHT - 20.0f)
#define INFO_LABEL_WIDTH   LOG_IN_VIEW_WIDTH
#define INFO_LABEL_HEIGHT  21.0f

#define DESCRIPTION_X_INSET SIGN_IN_BUTTON_X_INSET
#define DESCRIPTION_Y_INSET 10.0f
#define DESCRIPTION_WIDTH   SIGN_IN_BUTTON_WIDTH
#define DESCRIPTION_HEIGHT  21.0f

#define SIGN_IN_BUTTON_X_INSET ((LOG_IN_VIEW_WIDTH / 2) - (SIGN_IN_BUTTON_WIDTH / 2))
#define SIGN_IN_BUTTON_Y_INSET (70.0f + INFO_LABEL_HEIGHT)
#define SIGN_IN_BUTTON_WIDTH   250.0f
#define SIGN_IN_BUTTON_HEIGHT  50.0f

#define USERNAME_X_INSET DESCRIPTION_X_INSET
#define USERNAME_Y_INSET (DESCRIPTION_Y_INSET + DESCRIPTION_HEIGHT + 15.0f)
#define USERNAME_WIDTH   DESCRIPTION_WIDTH
#define USERNAME_HEIGHT  30.0f

@interface SignInViewController () <UITextFieldDelegate, KPHackChatDelegate>

@end

@implementation SignInViewController

// When the user signs in, save their username and hide this vc (revealing the landing vc)
-(void)pushSignInButton:(id)sender {
    // Save username
    [[NSUserDefaults standardUserDefaults] setObject:usernameTextField.text forKey:KP_USERNAME_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Notify listeners that user has signed in
    [[NSNotificationCenter defaultCenter] postNotificationName:KP_USER_LOGGED_IN_NOTIFICATION object:nil];
    
    // Side keyboard
    [self textFieldDidEndEditing:usernameTextField];
    [self dismissViewControllerAnimated:YES completion:nil]; // hide VC
}

// Set up the icon image view
-(void)setUpIconImageView {
    
    iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ICON_IMAGE_VIEW_X_INSET, ICON_IMAGE_VIEW_Y_INSET, ICON_IMAGE_VIEW_WIDTH, ICON_IMAGE_VIEW_HEIGHT)];
    [[iconImageView layer] setMasksToBounds:YES];
    [[iconImageView layer] setCornerRadius:20.0f]; // Round corners
    [iconImageView setImage:[UIImage imageNamed:@"icon_medium"]]; // Set image
    
    [self.view addSubview:iconImageView];
}

// Set up the panning image view
-(void)setUpImageView {
    wallImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 960.0f, self.view.frame.size.height)];
    [wallImageView setContentMode:UIViewContentModeScaleAspectFill];
    [wallImageView setImage:[UIImage imageNamed:@"photo_wall.jpg"]];
    
    [self.view addSubview:wallImageView];
}

// Set up central log in view
-(void)setUpLogInBackgroundView {
    signInBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(LOG_IN_VIEW_X_INSET, LOG_IN_VIEW_Y_INSET, LOG_IN_VIEW_WIDTH, LOG_IN_VIEW_HEIGHT)];
    [signInBackgroundView setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.8f]];
    [[signInBackgroundView layer] setMasksToBounds:YES];
    [[signInBackgroundView layer] setCornerRadius:5.0f];
    
    signInButton = [[FUIButton alloc] initWithFrame:CGRectMake(SIGN_IN_BUTTON_X_INSET, SIGN_IN_BUTTON_Y_INSET, SIGN_IN_BUTTON_WIDTH, SIGN_IN_BUTTON_HEIGHT)];
    
    [signInButton addTarget:self action:@selector(pushSignInButton:) forControlEvents:UIControlEventTouchUpInside];
    [signInButton setButtonColor:[UIColor turquoiseColor]];
    [signInButton setShadowColor:[UIColor greenSeaColor]];
    [signInButton setShadowHeight:3.0f];
    [signInButton setCornerRadius:2.0f];
    [signInButton setTitleColor:[UIColor cloudsColor] forState:UIControlStateNormal];
    [signInButton setTitle:@"Sign In" forState:UIControlStateNormal];
    [signInButton.titleLabel setFont:[UIFont boldFlatFontOfSize:20.0f]];
    
    signInLabel = [[UILabel alloc] initWithFrame:CGRectMake(DESCRIPTION_X_INSET, DESCRIPTION_Y_INSET, DESCRIPTION_WIDTH, DESCRIPTION_HEIGHT)];
    [signInLabel setBackgroundColor:[UIColor clearColor]];
    [signInLabel setTextColor:[UIColor cloudsColor]];
    [signInLabel setTextAlignment:NSTextAlignmentCenter];
    [signInLabel setNumberOfLines:5];
    [signInLabel setText:@"To get started, pick a username!"];
    [signInLabel setFont:[UIFont flatFontOfSize:18.0f]];
    
    usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(USERNAME_X_INSET, USERNAME_Y_INSET, USERNAME_WIDTH, USERNAME_HEIGHT)];
    [usernameTextField setDelegate:self];
    [usernameTextField setKeyboardAppearance:UIKeyboardAppearanceDark];
    [usernameTextField setPlaceholder:@" Enter Username"];
    [usernameTextField setFont:[UIFont flatFontOfSize:16.0f]];
    [[usernameTextField layer] setCornerRadius:2.0f];
    [usernameTextField setBackgroundColor:[UIColor cloudsColor]];
    
    [signInBackgroundView addSubview:usernameTextField];
    [signInBackgroundView addSubview:signInLabel];
    [signInBackgroundView addSubview:signInButton];
    
    [self.view addSubview:signInBackgroundView];
}

// Set up label at the bottom
-(void)setUpInfoLabel {
    infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(INFO_LABEL_X_INSET, INFO_LABEL_Y_INSET, INFO_LABEL_WIDTH, INFO_LABEL_HEIGHT)];
    [infoLabel setFont:[UIFont flatFontOfSize:17.0f]];
    [infoLabel setTextAlignment:NSTextAlignmentCenter];
    [infoLabel setBackgroundColor:[UIColor clearColor]];
    [[infoLabel layer] setShadowColor:[UIColor blackColor].CGColor];
    [[infoLabel layer] setShadowOffset:CGSizeMake(1, 1)];
    [[infoLabel layer] setShadowOpacity:0.9f];
    [[infoLabel layer] setShadowRadius:0.8f];
    
    [infoLabel setTextColor:[UIColor cloudsColor]];
    [infoLabel setText:@"Simple, anonymous chat"];
    [self.view addSubview:infoLabel];
}

// Pan background. this is so CPU intensive...
-(void)beginAnimatingBackground {
    [UIView animateWithDuration:45.0f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [wallImageView setFrame:CGRectMake(-320.0f, 0.0f, 960.0f, self.view.frame.size.height)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:45.0f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            [wallImageView setFrame:CGRectMake(0.0f, 0.0f, 960.0f, self.view.frame.size.height)];
        } completion:^(BOOL finished) {
            [self beginAnimatingBackground];
        }];
    }];
}

// When the user starts editing, move the log in view up and hide the keyboard
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView animateWithDuration:.2 animations:^{
        [signInBackgroundView setFrame:CGRectMake(LOG_IN_VIEW_X_INSET, 80.0f + NAVIGATION_BAR_OFFSET, LOG_IN_VIEW_WIDTH, LOG_IN_VIEW_HEIGHT)];
        [iconImageView setAlpha:0.0f];
    }];
}

// When they're done editing, hide keyboard, move log in view down and show icon
-(void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    [UIView animateWithDuration:.2 animations:^{
        [signInBackgroundView setFrame:CGRectMake(LOG_IN_VIEW_X_INSET, LOG_IN_VIEW_Y_INSET, LOG_IN_VIEW_WIDTH, LOG_IN_VIEW_HEIGHT)];
        [iconImageView setAlpha:1.0f];
    }];
}

// Hide keyboard when user hits return
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self textFieldDidEndEditing:textField];
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setTitle:@"Sign In"];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor midnightBlueColor]}];
    
    [self setUpImageView];
    
    [self setUpLogInBackgroundView];
    [self setUpIconImageView];
    [self setUpInfoLabel];
    
    [self beginAnimatingBackground];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
