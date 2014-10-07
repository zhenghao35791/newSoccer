//
//  GameOverViewController.m
//  Soccer
//
//  Created by Hongnan Yang on 2014-10-7.
//  Copyright (c) 2014年 hao. All rights reserved.
//

#import "GameOverViewController.h"

@interface GameOverViewController ()

@end

@implementation GameOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //NSString *currentUser = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentUser"];
    NSMutableDictionary *jsonDataPreferences = [[NSMutableDictionary alloc] init];
    //jsonDataPreferences = [self getPreferencesBy:currentUser];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)go2HomePage:(id)sender {
    [self performSegueWithIdentifier:@"back_2_home_segue" sender:self];//page nivagation
}

- (IBAction)TryAgain:(id)sender {
     [self performSegueWithIdentifier:@"try_again_segue" sender:self];//page nivagation
}
@end
