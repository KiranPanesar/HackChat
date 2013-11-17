//
//  LandingViewController.m
//  HackChat
//
//  Created by Kiran Panesar on 16/11/2013.
//  Copyright (c) 2013 MobileX Labs. All rights reserved.
//

#import "LandingViewController.h"

#define NAME_LABEL_X_INSET (self.view.frame.size.width / 2 - NAME_LABEL_WIDTH / 2)
#define NAME_LABEL_Y_INSET 200.0f
#define NAME_LABEL_WIDTH   200.0f
#define NAME_LABEL_HEIGHT   50.0f

#define INSTRUCTION_LABEL_X_INSET NAME_LABEL_X_INSET
#define INSTRUCTION_LABEL_Y_INSET (NAME_LABEL_Y_INSET + NAME_LABEL_HEIGHT + 10.0f)
#define INSTRUCTION_LABEL_WIDTH   NAME_LABEL_WIDTH
#define INSTRUCTION_LABEL_HEIGHT  25.0f

@interface LandingViewController ()

-(void)setUpNameLabel;
-(void)setUpInstructionLabel;

-(void)showChatRooms;

@end

@implementation LandingViewController


// Set up the welcome label
-(void)setUpNameLabel {
    usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(NAME_LABEL_X_INSET, NAME_LABEL_Y_INSET, NAME_LABEL_WIDTH, NAME_LABEL_HEIGHT)];
    [usernameLabel setFont:[UIFont boldFlatFontOfSize:20.0f]];
    [usernameLabel setTextAlignment:NSTextAlignmentCenter];
    [usernameLabel setTextColor:[UIColor wetAsphaltColor]];
    [usernameLabel setText:@"Welcome!"];
    
    [self.view addSubview:usernameLabel];
}

// Set up instructions label
-(void)setUpInstructionLabel {
    instructionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(INSTRUCTION_LABEL_X_INSET, INSTRUCTION_LABEL_Y_INSET, INSTRUCTION_LABEL_WIDTH, INSTRUCTION_LABEL_HEIGHT)];
    [instructionsLabel setFont:[UIFont flatFontOfSize:13.0f]];
    [instructionsLabel setTextAlignment:NSTextAlignmentCenter];
    [instructionsLabel setTextColor:[UIColor concreteColor]];
    [instructionsLabel setText:@"Swipe right to view messages."];
    
    [self.view addSubview:instructionsLabel];
}

// Action for the bar button item
-(void)showChatRooms {
    [self.sideMenuViewController presentMenuViewController];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// When the KP_USER_LOGGED_IN_NOTIFICATION is fired, update with username
-(void)loggedIn {
    [usernameLabel setText:[NSString stringWithFormat:@"Welcome, %@!", KP_USERNAME]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"Welcome"];
    [self.view setBackgroundColor:[UIColor cloudsColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loggedIn) name:KP_USER_LOGGED_IN_NOTIFICATION object:nil];
    
    UIBarButtonItem *popBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Rooms"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(showChatRooms)];
    [self.navigationItem setLeftBarButtonItem:popBarButton];
    
    [self setUpNameLabel];
    [self setUpInstructionLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
