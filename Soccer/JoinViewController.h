//
//  JoinViewController.h
//  Snap
//
//  Created by Finguitar on 24/09/2014.
//  Copyright (c) 2014 Hollance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchmakingClient.h"
@class JoinViewController;
@protocol JoinViewControllerDelegate <NSObject>
- (void)joinViewControllerDidCancel:(JoinViewController *)controller;
- (void)joinViewController:(JoinViewController *)controller didDisconnectWithReason:(QuitReason)reason;

@end



@interface JoinViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,MatchmakingClientDelegate>

@property (nonatomic, weak) id <JoinViewControllerDelegate> delegate;


@end
