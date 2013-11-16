//
//  ChatRoomViewController.m
//  HackChat
//
//  Created by Kiran Panesar on 16/11/2013.
//  Copyright (c) 2013 MobileX Labs. All rights reserved.
//

#import "ChatRoomViewController.h"
#import "KPHackChat.h"
#import "RESideMenu.h"

@interface ChatRoomViewController () <KPHackChatDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

-(void)setUpTableView;
-(void)setUpToolbar;

@end

@implementation ChatRoomViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithRoomName:(NSString *)nameOfRoom {
    self = [super self];
    
    if (self) {
        roomName = nameOfRoom;
    }
    
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [messagesArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell.textLabel setText:[[messagesArray objectAtIndex:indexPath.row] objectForKey:@"message"]];
        [cell.detailTextLabel setText:[[messagesArray objectAtIndex:indexPath.row] objectForKey:@"username"]];
        [cell.textLabel setAdjustsFontSizeToFitWidth:YES];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)hackChat:(KPHackChat *)chat didJoinRoom:(NSMutableArray *)messages {
    [messagesArray addObjectsFromArray:messages];
    [messagesTableView reloadData];
}

-(void)hackChat:(KPHackChat *)chat didReceieveMessage:(NSMutableArray *)messages {
    [messagesArray addObjectsFromArray:messages];
    [messagesTableView reloadData];
}

-(void)setUpTableView {
    messagesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    [messagesTableView setDelegate:self];
    [messagesTableView setDataSource:self];
    [self.view addSubview:messagesTableView];
}

-(void)setUpToolbar {
    messageToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 44.0f)];
    [messagesTableView setTableFooterView:messageToolbar];
}

-(void)setUpTextField {
    messagesTextField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 44.0f)];
    [messagesTextField setDelegate:self];
    [messageToolbar addSubview:messagesTextField];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [messagesArray addObject:@{@"username": KP_USERNAME, @"message":textField.text}];
    [_hackChat sendMessage:textField.text fromUsername:KP_USERNAME roomID:roomName];
    [messagesTableView reloadData];
    [textField setText:@""];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationItem setTitle:roomName];
    UIBarButtonItem *popBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Rooms"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(showChatRooms)];
    [self.navigationItem setLeftBarButtonItem:popBarButton];

    [self.view setBackgroundColor:[UIColor cloudsColor]];
    messagesArray = [[NSMutableArray alloc] init];
    
    _hackChat = [[KPHackChat alloc] init];
    [_hackChat setDelegate:self];
    [_hackChat joinRoom:roomName];

    [self setUpTableView];
    [self setUpToolbar];
    [self setUpTextField];
}

-(void)showChatRooms {
    [self.sideMenuViewController presentMenuViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
