//
//  HostViewController.h
//  Snap
//
//  Created by Finguitar on 24/09/2014.
//  Copyright (c) 2014 Hollance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchmakingServer.h"

@class HostViewController;
@protocol HostViewControllerDelegate <NSObject>

- (void)hostViewControllerDidCancel:(HostViewController *)controller;

@end

@interface HostViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, MatchmakingServerDelegate>
@property (nonatomic, weak) id <HostViewControllerDelegate> delegate;

@end


