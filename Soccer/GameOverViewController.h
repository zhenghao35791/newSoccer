//
//  GameOverViewController.h
//  Soccer
//
//  Created by Hongnan Yang on 2014-10-7.
//  Copyright (c) 2014年 hao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameOverViewController : UIViewController <UITextFieldDelegate>{

    __weak IBOutlet UITextView *resultRank;
    __weak IBOutlet UITextView *resultScore;
}
- (IBAction)go2HomePage:(id)sender;
- (IBAction)TryAgain:(id)sender;



@property (strong, nonatomic) NSString *score;
@property (strong, nonatomic) NSString *rank;
@end
