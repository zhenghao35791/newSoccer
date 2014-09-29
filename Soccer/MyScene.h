//
//  MyScene.h
//  Soccer
//

//  Copyright (c) 2014年 hao. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>
//static const uint32_t soccerCategory = 0x1 << 0;
//static const uint32_t playerCategory = 0x1 << 1;

static const uint8_t playerCategory = 1;
static const uint8_t soccerCategory = 2;

@interface MyScene : SKScene<UIAccelerometerDelegate, SKPhysicsContactDelegate>{
    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenWidth;
    CGFloat player1Direction;
    CGFloat player2Direction;
    CGPoint startLocation;
    CGPoint newLocation;
    double currentMaxX;
    double currentMaxY;
}


@property (strong, nonatomic) CMMotionManager *motionManager;
@property SKSpriteNode *player1;
@property SKSpriteNode *player2;
@property SKSpriteNode *soccer;
@property SKSpriteNode *enemyplayer;
@property SKSpriteNode *propeller;
@property SKSpriteNode *selectedNode;
@property SKSpriteNode *background;
@end
