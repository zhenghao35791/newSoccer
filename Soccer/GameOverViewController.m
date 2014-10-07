//
//  GameOverViewController.m
//  Soccer
//
//  Created by Hongnan Yang on 2014-10-7.
//  Copyright (c) 2014年 hao. All rights reserved.
//

#import "GameOverViewController.h"
#include "SystemSettings.h"

@interface GameOverViewController ()

@end

@implementation GameOverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //NSString *currentUser = [[NSUserDefaults standardUserDefaults]objectForKey:@"currentUser"];
    //NSMutableDictionary *jsonDataPreferences = [[NSMutableDictionary alloc] init];
    NSString *currentUser = @"test1";
    NSString *rank = [self getRankBy:currentUser:self.score];
    resultScore.text = self.score;
    resultRank.text = rank;
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

-(NSString *) getRankBy:(NSString *)username: (NSString *)score
{
    NSMutableDictionary *jsonData;
    NSString *rank;
    @try {
        //username = [[AESCrypt encrypt:username password:KEY] urlEncode];
        NSString *post = [[NSString alloc] initWithFormat:@"action=recordResult&username=%@&score=%@",username,score];
        //NSLog(@"PostData: %@",post);
        NSURL *url = [NSURL URLWithString:URLADDRESS];
        //NSLog(@"PostURL: %@",url);
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long) [postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSError *error = [[NSError alloc] init];
        NSHTTPURLResponse *response = nil;
        NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        //NSLog(@"Response code: %ld", (long)[response statusCode]);
        
        if ([response statusCode] >= 200 && [response statusCode] < 300)
        {
            //NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
            //NSLog(@"Response ==> %@", responseData);
            
            NSError *error = nil;
            //NSDictionary *jsonData1;
            //NSMutableDictionary *jsonData;
            id jso = [NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingMutableContainers error:&error];
            
            if (jso == nil) {
                
            } else if ([jso isKindOfClass:[NSArray class]]) {
                //NSLog(@"It is an array");
                NSArray *jsonArray = jso;
                //NSUInteger numofentries = jsonArray.count;
                //printf("%d",numofentries);
                for (int i = 0; i < jsonArray.count; i++)
                {
                    
                    jsonData = jsonArray[i];
                }
                
                // process array elements
            } else if ([jso isKindOfClass:[NSDictionary class]]) {
                //NSLog(@"It is an dictionnary");
                jsonData = jso;
                // process dictionary elements
            } else {
                // Shouldn't happen unless you use the NSJSONReadingAllowFragments flag.
            }
            
            //jsonData = [jsonData1 mutableCopy];
            
            if(![jsonData[@"rank"] isEqualToString:@""]){
                rank = jsonData[@"rank"];
            }
            else{
                rank = @"--";
            }
            
        }
        else{
            [self alertStatus:@"connection failed" :@"failed to update score to database" :0];
        }
    }
    
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
        [self alertStatus:@"Please set preference for notification service." :@"Notice" :0];
        //sampleDetail.text = self.sampleDetailInit;
    }
    return rank;
    
}

- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    alertView.tag = tag;
    [alertView show];
}

- (IBAction)go2HomePage:(id)sender {
    [self performSegueWithIdentifier:@"back_2_home_segue" sender:self];//page nivagation
}

- (IBAction)TryAgain:(id)sender {
     [self performSegueWithIdentifier:@"try_again_segue" sender:self];//page nivagation
}
@end
