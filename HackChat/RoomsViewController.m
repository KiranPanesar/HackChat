//
//  RoomsViewController.m
//  HackChat
//
//  Created by Kiran Panesar on 16/11/2013.
//  Copyright (c) 2013 MobileX Labs. All rights reserved.
//

#import "RoomsViewController.h"
#import "KPHackChat.h"
#import "ChatRoomViewController.h"
#import "RESideMenu.h"

#define TABLE_VIEW_X_INSET 0.0f
#define TABLE_VIEW_Y_INSET 0.0f
#define TABLE_VIEW_WIDTH   self.view.frame.size.width
#define TABLE_VIEW_HEIGHT  self.view.frame.size.height

@interface RoomsViewController () <KPHackChatDelegate>

-(void)setUpTableView;
-(void)userLoggedIn;
@end

@implementation RoomsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init {
    self = [super self];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(userLoggedIn)
                                                     name:KP_USER_LOGGED_IN_NOTIFICATION
                                                   object:nil];
    }
    
    return self;
}

-(void)userLoggedIn {
    _hackChat = [[KPHackChat alloc] init];
    [_hackChat setDelegate:self];
    [_hackChat loadRoomsForUser:KP_USERNAME];
}

-(void)hackChat:(KPHackChat *)chat didLoadRooms:(NSArray *)rooms {
    hackChatRooms = rooms;
    [roomsTableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [hackChatRooms count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.textLabel setFont:[UIFont flatFontOfSize:15.0f]];
        [cell.textLabel setTextColor:[UIColor cloudsColor]];
        [cell.textLabel setText:[hackChatRooms objectAtIndex:indexPath.row]];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Pick a Room";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatRoomViewController *room = [[ChatRoomViewController alloc] initWithRoomName:[hackChatRooms objectAtIndex:indexPath.row]];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:room];
    
    [self.sideMenuViewController setContentViewController:navController animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

-(void)setUpTableView {
    roomsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 107.0f, self.view.frame.size.width, 350.0f) style:UITableViewStylePlain];
    roomsTableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    roomsTableView.delegate = self;
    roomsTableView.dataSource = self;
    roomsTableView.opaque = NO;
    roomsTableView.backgroundColor = [UIColor clearColor];
    
    roomsTableView.backgroundView = nil;
    roomsTableView.backgroundColor = [UIColor clearColor];
    roomsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:roomsTableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setUpTableView];
    [self.view setBackgroundColor:[UIColor clearColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
