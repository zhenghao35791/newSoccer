//
//  HostViewController.m
//  Snap
//
//  Created by Finguitar on 24/09/2014.
//  Copyright (c) 2014 Hollance. All rights reserved.
//

#import "HostViewController.h"
#import "PeerCell.h"


@interface HostViewController ()
@property (nonatomic, weak) IBOutlet UILabel *headingLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *startButton;

@end

@implementation HostViewController
{
    MatchmakingServer *_matchmakingServer;
    QuitReason _quitReason;
}
@synthesize headingLabel = _headingLabel;
@synthesize nameLabel = _nameLabel;
@synthesize nameTextField = _nameTextField;
@synthesize statusLabel = _statusLabel;
@synthesize tableView = _tableView;
@synthesize startButton = _startButton;
@synthesize delegate = _delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.nameTextField action:@selector(resignFirstResponder)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"host view display");
    [super viewDidAppear:animated];
    if(_matchmakingServer == nil)
    {
        _matchmakingServer = [[MatchmakingServer alloc] init];
        _matchmakingServer.delegate = self;

        _matchmakingServer.maxClients = 3;
        NSLog(@"host start session");
        [_matchmakingServer startAcceptingConnectionsForSessionID:SESSION_ID];
        
        self.nameTextField.placeholder = _matchmakingServer.session.displayName;
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (IBAction)startAction:(id)sender
{
}

- (IBAction)exitAction:(id)sender
{
    _quitReason = QuitReasonServerQuit;
    [_matchmakingServer endSession];
    [self.delegate hostViewControllerDidCancel:self];
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_matchmakingServer != nil)
    {
        return [_matchmakingServer connectedClientCount];
    }
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
        cell = [[PeerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    NSString *peerID = [_matchmakingServer peerIDForConnectedClientAtIndex:indexPath.row];
    cell.textLabel.text = [_matchmakingServer displayNameForPeerID:peerID];
    
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)matchmakingServer:(MatchmakingServer *)server clientDidDisconnect:(NSString *)peerID
{
    [self.tableView reloadData];
}

-(void)matchmakingServer:(MatchmakingServer *)server clientDidConnect:(NSString *)peerID
{
    NSLog(@"connected");
    [self.tableView reloadData];
}

-(void)matchmakingServerNoNetwork:(MatchmakingServer *)server
{
    _matchmakingServer.delegate = nil;
    _matchmakingServer = nil;
    [self.tableView reloadData];
    [self.delegate hostViewController:self didEndSessionWithReason:_quitReason];
    
}

-(void)matchmakingServerSessionDidEnd:(MatchmakingServer *)server
{
    _quitReason = QuitReasonNoNetwork;
}
@end
