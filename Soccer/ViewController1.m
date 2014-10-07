//
//  ViewController1.m
//  Soccer
//
//  Created by Finguitar on 7/10/2014.
//  Copyright (c) 2014 hao. All rights reserved.
//

#import "ViewController1.h"
#import "MyScene.h"

@interface ViewController1 ()

@end

@implementation ViewController1



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}



- (void)viewDidLoad
{
    
//    
//        [super viewDidLoad];
//        
//        self.headingLabel.font = [UIFont rw_snapFontWithSize:24.0f];
//        self.nameLabel.font = [UIFont rw_snapFontWithSize:16.0f];
//        self.statusLabel.font = [UIFont rw_snapFontWithSize:16.0f];
//        self.waitLabel.font = [UIFont rw_snapFontWithSize:18.0f];
//        self.nameTextField.font = [UIFont rw_snapFontWithSize:20.0f];
//        
//        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.nameTextField action:@selector(resignFirstResponder)];
//        gestureRecognizer.cancelsTouchesInView = NO;
//        [self.view addGestureRecognizer:gestureRecognizer];

    
    
    
    
    [super viewDidLoad];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    //if (!skView.scene) {
//        skView.showsFPS = YES;
//        skView.showsNodeCount = YES;
        
        // Create and configure the scene.
//        SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
//        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        //[skView presentScene:scene];
   // }
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

@end
