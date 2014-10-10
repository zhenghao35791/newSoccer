//
//  MyScene.m
//  Soccer
//
//  Created by rayna on 14-9-17.
//  Copyright (c) 2014年 hao. All rights reserved.
//

#import "MyScene.h"
#import "math.h"

@implementation MyScene
    static NSString * const Player1Name = @"Player1";//用这个字符串来标示可移动的node
    static NSString * const Player2Name = @"Player2";
int player1Score = 0;
int player2Score = 0;

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        //init self for contact
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsWorld.contactDelegate = self;
        
        // Setup the scene
        screenRect = [[UIScreen mainScreen]bounds];
        screenHeight = screenRect.size.height;
        screenWidth = screenRect.size.width; 
        
        //adding backgroud
        _background = [SKSpriteNode spriteNodeWithImageNamed:@"background.jpeg"];
        [_background setName:@"background"];
        [_background setAnchorPoint:CGPointZero];
        [self addChild:_background ];
        
        //adding soccer
        _soccer = [SKSpriteNode spriteNodeWithImageNamed:@"soccer"];
        _soccer.position = CGPointMake(screenWidth/2, screenHeight/2);
        [self addChild:_soccer];
        [self CallingAi];
        
        //loading players
        _player1 = [SKSpriteNode spriteNodeWithImageNamed:@"player1"];
        _player2 = [SKSpriteNode spriteNodeWithImageNamed:@"player2"];
        _player1.position = CGPointMake(screenWidth/2, _player1.size.height/2+15);
        _player2.position = CGPointMake(screenWidth/2, _player2.size.height/2+150);
        [_player1 setName:Player1Name];
        [_player2 setName:Player2Name];
        [self addChild:_player1];
        [self addChild:_player2];
        
        // contact area of soccer
        _soccer.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius: _soccer.frame.size.width/2];
        _soccer.physicsBody.categoryBitMask = soccerCategory;//which category it belogs to
        _soccer.physicsBody.contactTestBitMask = player1Category|player2Category; //which category it contact with
        
        
        // contact area of player1
        _player1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_player1.size];
        _player1.physicsBody.categoryBitMask = player1Category;
        _player1.physicsBody.contactTestBitMask = soccerCategory;
        
        
        // contact area of player2
        _player2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_player2.size];
        _player2.physicsBody.categoryBitMask = player2Category;
        _player2.physicsBody.contactTestBitMask = soccerCategory;
        
        
        //adding propeller
        _propeller = [SKSpriteNode spriteNodeWithImageNamed:@"PROPELLER 1"];
        _propeller.scale = 0.2;
        _propeller.position = CGPointMake(screenWidth/2-100, screenHeight-60);
        SKTexture *propeller1 = [SKTexture textureWithImageNamed:@"PROPELLER 1"];
        SKTexture *propeller2 = [SKTexture textureWithImageNamed:@"PROPELLER 2"];
        SKAction *spin = [SKAction animateWithTextures:@[propeller1,propeller2] timePerFrame:0.1];
        SKAction *spinforever = [SKAction repeatActionForever:spin];
        [_propeller runAction:spinforever];//runaction
        [self addChild:_propeller];
       // startGameLabel = childNodeWithName("startGameLabel") as SKLabelNode
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    [self selectNodeForTouch:positionInScene];
}

- (void)selectNodeForTouch:(CGPoint)touchLocation {
    //1
    SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
    //2
	if(![_selectedNode isEqual:touchedNode]) {
		[_selectedNode removeAllActions];
		[_selectedNode runAction:[SKAction rotateToAngle:0.0f duration:0.1]];
		_selectedNode = touchedNode;
		//3
        //only for test
		if([[touchedNode name] isEqualToString:Player1Name]||[[touchedNode name] isEqualToString:Player2Name]) {
			//SKAction *sequence = [SKAction sequence:@[[SKAction rotateByAngle:degToRad(-4.0f) duration:0.1],[SKAction rotateByAngle:0.0 duration:0.1],[SKAction rotateByAngle:degToRad(4.0f) duration:0.1]]];
			//[_selectedNode runAction:[SKAction repeatActionForever:sequence]];
		}
	}
}

//float degToRad(float degree) {
	//return degree / 180.0f * M_PI;
//}//由于Sprite Kit是利用弧度来做旋转效果的，所以上面这个方法将角度转换为弧度。

- (CGPoint)boundLayerPos:(CGPoint)newPos {
    CGSize winSize = self.size;

    CGPoint retval = newPos;
    retval.x = MIN(retval.x, 0);
    retval.x = MAX(retval.x, -[_background size].width+ winSize.width);
    retval.y = [self position].y;
    return retval;
}
- (void)panForTranslation:(CGPoint)translation {
    CGPoint position = [_selectedNode position];
    if([[_selectedNode name] isEqualToString:Player1Name]) {
        [_selectedNode setPosition:CGPointMake(position.x + translation.x, position.y + translation.y)];
        _player1.physicsBody.velocity = CGVectorMake(translation.x, translation.y);//speed
    }
    if([[_selectedNode name] isEqualToString:Player2Name]) {
        [_selectedNode setPosition:CGPointMake(position.x + translation.x, position.y + translation.y)];
        _player2.physicsBody.velocity = CGVectorMake(translation.x, translation.y);//speed
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint positionInScene = [touch locationInNode:self];
	CGPoint previousPosition = [touch previousLocationInNode:self];
	CGPoint translation = CGPointMake(positionInScene.x - previousPosition.x, positionInScene.y - previousPosition.y);
	[self panForTranslation:translation];
}

- (void)update:(NSTimeInterval)currentTime{
    CGPoint newPositionPlayer1 = CGPointMake(_player1.position.x, _player1.position.y);
    CGPoint newPositionPlayer2 = CGPointMake(_player2.position.x, _player2.position.y);
    CGPoint newPositionSoccer = CGPointMake(_soccer.position.x, _soccer.position.y);
    currentMaxX = screenWidth - _player1.size.width/2;
    currentMaxY = screenHeight - _player1.size.height/2;
    if (newPositionPlayer1.x > currentMaxX) {
        newPositionPlayer1.x = currentMaxX-1;
    }
    if (newPositionPlayer1.y > currentMaxY) {
        newPositionPlayer1.y = currentMaxY-1;
    }
    if (newPositionPlayer2.x > currentMaxX) {
        newPositionPlayer2.x = currentMaxX-1;
    }
    if (newPositionPlayer2.y > currentMaxY) {
        newPositionPlayer2.y = currentMaxY-1;
    }
    if (newPositionSoccer.x > currentMaxX) {
        newPositionSoccer.x = currentMaxX-1;
    }
    if (newPositionSoccer.y > currentMaxY) {
        newPositionSoccer.y = currentMaxY-1;
    }
    //???????
    if (newPositionPlayer1.x < _player1.size.width) {
        newPositionPlayer1.x = _player1.size.width;
    }
    if (newPositionPlayer1.y < _player1.size.height) {
        newPositionPlayer1.y = _player1.size.height;
    }
    if (newPositionPlayer2.x < _player2.size.width) {
        newPositionPlayer2.x = _player2.size.width;
    }
    if (newPositionPlayer2.y < _player2.size.height) {
        newPositionPlayer2.y = _player2.size.height;
    }
    if (newPositionSoccer.x < _soccer.size.width) {
        newPositionSoccer.x = _soccer.size.width;
    }
    if (newPositionSoccer.y < _soccer.size.height) {
        newPositionSoccer.y = _soccer.size.height;
    }
    
    
    _player1.position = newPositionPlayer1;
    _player2.position = newPositionPlayer2;
    _soccer.position = newPositionSoccer;
    
//    static int maxSpeed = 10;
//    float speed = sqrt(_soccer.physicsBody.velocity.dx*_soccer.physicsBody.velocity.dx + _soccer.physicsBody.velocity.dy * _soccer.physicsBody.velocity.dy);
//    if (speed > maxSpeed) {
//        _soccer.physicsBody.linearDamping = 0.4f;
//    } else {
//        _soccer.physicsBody.linearDamping = 0.0f;
//    }
}

//- (NSMutableDictionary *)didBeginContact:(SKPhysicsContact *)contact
//{
//    NSLog(@"collison");
//    CGPoint newPositionPlayer1 = CGPointMake(_player1.position.x, _player1.position.y);
//    CGPoint newPositionPlayer2 = CGPointMake(_player2.position.x, _player2.position.y);
//    CGPoint newPositionSoccer = CGPointMake(_soccer.position.x, _soccer.position.y);
//    CGVector newSpeedPlayer1 = CGVectorMake(_player1.physicsBody.velocity.dx,_player1.physicsBody.velocity.dx);
//    CGVector newSpeedPlayer2 = CGVectorMake(_player2.physicsBody.velocity.dx,_player2.physicsBody.velocity.dx);
//    CGVector newSpeedSoccer = CGVectorMake(_soccer.physicsBody.velocity.dx,_soccer.physicsBody.velocity.dx);
//    NSString *player1NewPosition = NSStringFromCGPoint(newPositionPlayer1);
//    NSString *player2NewPosition =NSStringFromCGPoint(newPositionPlayer2);
//    NSString *soccerNewPosition =NSStringFromCGPoint(newPositionSoccer);
//    NSString *player1NewSpeed = NSStringFromCGVector(newSpeedPlayer1);
//    NSString *player2NewSpeed = NSStringFromCGVector(newSpeedPlayer2);
//    NSString *soccerNewSpeed = NSStringFromCGVector(newSpeedSoccer);
//    NSMutableDictionary *results = [[NSMutableDictionary alloc] init];
//    [results setObject:player1NewPosition forKey:@"player1NewPosition"];
//    [results setObject:player2NewPosition forKey:@"player2NewPosition"];
//    [results setObject:soccerNewPosition forKey:@"soccerNewPosition"];
//    [results setObject:player1NewSpeed forKey:@"player1NewSpeed"];
//    [results setObject:player2NewSpeed forKey:@"player2NewSpeed"];
//    [results setObject:soccerNewSpeed forKey:@"soccerNewSpeed"];
//
//    
//    if((contact.bodyB.categoryBitMask!=soccerCategory && contact.bodyA.categoryBitMask!=soccerCategory))
//    {
//        NSLog(@"collision between players");
//    }
//    
//    SKPhysicsBody *currentplayer, *soccer1;
//    //player1: 1; player2: 2; soccer: 3
//    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
//    {
//        currentplayer = contact.bodyA;
//        soccer1 = contact.bodyB;
//    }
//    else
//    {
//        soccer1 = contact.bodyB;
//        currentplayer = contact.bodyA;
//    }
//    
//    //collision between player and ball
//    if((soccer1.categoryBitMask==soccerCategory))
//    {
//        if (currentplayer.velocity.dx!=0 && currentplayer.velocity.dy!=0)
//        {
//            //
//            soccer1.velocity = CGVectorMake(newSpeedSoccer.dx+currentplayer.velocity.dx*30,newSpeedSoccer.dy+currentplayer.velocity.dy*30);
//            if (currentplayer.categoryBitMask == 1){
//                [results setObject:player1NewPosition forKey:@"player1NewPosition"];
//                [results setObject:player1NewSpeed forKey:@"player1NewSpeed"];
//                //_player1.physicsBody.velocity = CGVectorMake(0, 0);
//            }
//            if (currentplayer.categoryBitMask == 2){
//                [results setObject:player1NewPosition forKey:@"player1NewPosition"];
//                [results setObject:player1NewSpeed forKey:@"player1NewSpeed"];
//                //_player2.physicsBody.velocity = CGVectorMake(0, 0);
//            }
//            NSString *soccerNewSpeed1 = NSStringFromCGVector(soccer1.velocity);
//            [results setObject:soccerNewPosition forKey:@"soccerNewPosition"];
//            [results setObject:soccerNewSpeed1 forKey:@"soccerNewSpeed"];
//            
//        }
//    }
//    return results;
//}

// AI gate keeper
- (void) CallingAi{
    //loading ai1,2
    _ai1 = [SKSpriteNode spriteNodeWithImageNamed:@"player1"];
    _ai2 = [SKSpriteNode spriteNodeWithImageNamed:@"player2"];
    _ai1.position = CGPointMake(screenWidth/2, 900);
    _ai2.position = CGPointMake(screenWidth/2, _ai2.size.height/2+750);
    NSLog(@"ASD,%f",_ai1.position.x);
    CGMutablePathRef cgpath = CGPathCreateMutable();
    CGPoint start = CGPointMake(_ai1.position.x, _ai1.position.y);
    CGPoint end = CGPointMake(screenWidth/2+150, _ai1.position.y);
    CGPoint path1 = CGPointMake(screenWidth/2 -150, _ai1.position.y);
    CGPoint path2 = CGPointMake(_ai1.position.x, _ai1.position.y);
    CGPathMoveToPoint(cgpath,NULL, start.x, start.y);
    CGPathAddCurveToPoint(cgpath, NULL, path1.x, path1.y, path2.x, path2.y, end.x, end.y);
    SKAction *defend = [SKAction followPath:cgpath asOffset:NO orientToPath:YES duration:3];
    [self addChild:_ai1];
    [self addChild:_ai2];
    [_ai1 runAction:[SKAction repeatActionForever:(defend)]];
}

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    NSLog(@"collison");
    SKPhysicsBody *currentplayer, *soccer1;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        currentplayer = contact.bodyA;
        soccer1 = contact.bodyB;
    }
    else
    {
        soccer1 = contact.bodyB;
        currentplayer = contact.bodyA;
    }
    
    //player collision
    if((contact.bodyB.categoryBitMask!=soccerCategory && contact.bodyA.categoryBitMask!=soccerCategory)){
        NSLog(@"collision between players");
        _player1.physicsBody.velocity = CGVectorMake(0, 0);
        _player2.physicsBody.velocity = CGVectorMake(0, 0);
        CGPoint newPosition1 = CGPointMake(_player1.position.x , _player1.position.y );
        CGPoint newPosition2 = CGPointMake(_player2.position.x , _player2.position.y );
        [_player1 runAction:[SKAction moveTo:newPosition1 duration:1]];
        [_player2 runAction:[SKAction moveTo:newPosition2 duration:1]];
    }
    
    //shooting
    if((soccer1.categoryBitMask==soccerCategory))
    {
        if (currentplayer.velocity.dx!=0 && currentplayer.velocity.dy!=0)
        {
            soccer1.velocity = CGVectorMake(currentplayer.velocity.dx*30,currentplayer.velocity.dy*30);
            CGPoint newPosition = CGPointMake(_soccer.position.x , _soccer.position.y );
            CGFloat soccerMovingOffsetX = 0.0;
            CGFloat soccerMovingOffsetY = 0.0;
            _soccer.physicsBody.velocity = CGVectorMake(currentplayer.velocity.dx*30,currentplayer.velocity.dy*30);
            CGFloat speedX = _soccer.physicsBody.velocity.dx;
            CGFloat speedY = _soccer.physicsBody.velocity.dy;
            CGFloat speedXOriginal = _soccer.physicsBody.velocity.dx;
            CGFloat speedYOriginal = _soccer.physicsBody.velocity.dy;
            int i = 1;
            while(fabs(soccerMovingOffsetX) < fabs(soccer1.velocity.dx) &&
                  fabs(soccerMovingOffsetY) < fabs(soccer1.velocity.dy))
            {
                soccerMovingOffsetX += soccer1.velocity.dx/5;
                soccerMovingOffsetY += soccer1.velocity.dy/5;
                speedX -= speedXOriginal/5;
                speedY -= speedYOriginal/5;
            
                newPosition = CGPointMake(_soccer.position.x + soccerMovingOffsetX, _soccer.position.y + soccerMovingOffsetY);
                _soccer.physicsBody.velocity = CGVectorMake(speedX,speedY);
        
                if (newPosition.x > screenWidth - _soccer.size.width) {
                    newPosition.x = screenWidth - _soccer.size.width;
                }
                if (newPosition.y > screenHeight - _soccer.size.height) {
                    newPosition.y = screenHeight - _soccer.size.height;
                }
                if (newPosition.x < _soccer.size.width) {
                    newPosition.x = _soccer.size.width;
                }
                if (newPosition.y < _soccer.size.height) {
                    newPosition.y = _soccer.size.height;
                }
                if (newPosition.x > screenWidth-_soccer.size.width) {
                    newPosition.x = screenWidth-_soccer.size.width;
                }
                if (newPosition.y > screenHeight - _soccer.size.height) {
                    newPosition.y = screenHeight - _soccer.size.height;
                }
                //moving ball
                [_soccer runAction:[SKAction moveTo:newPosition duration:1]];
                //if goal
                if (newPosition.x > screenWidth/2-100 && newPosition.x < screenWidth/2+100 && newPosition.y > screenHeight-60)
                {
                    //NSLog(@"score!!!!!!!!!!!!!!!");
                    if (currentplayer.categoryBitMask == 1) {
                        player1Score++;
                        [self alertStatus:@"Player1 gets 1 score" :@"GOAL" :0];
                        //NSLog(@"player1 score and he has scored : %d",player1Score);
                    }
                    if (currentplayer.categoryBitMask == 2) {
                        player2Score++;
                        [self alertStatus:@"Player2 gets 1 score" :@"GOAL" :0];
                        //NSLog(@"player1 score and he has scored : %d",player2Score);
                    }
                    newPosition = CGPointMake(screenWidth/2, screenHeight/2);
                    [_soccer runAction:[SKAction moveTo:newPosition duration:1]];
                }
                i+=1;
                NSLog(@"%d", i);
                NSLog(@"soccer1: (%f,%f)",soccer1.velocity.dx,soccer1.velocity.dy);
                NSLog(@"_soccer: (%f,%f)",_soccer.physicsBody.velocity.dx,_soccer.physicsBody.velocity.dy);
                if(i == 1){
                    if (currentplayer.categoryBitMask == 1){
                        _player1.physicsBody.velocity = CGVectorMake(0, 0);
                    }
                    if (currentplayer.categoryBitMask == 2){
                        _player2.physicsBody.velocity = CGVectorMake(0, 0);
                    }
                }
            }
        }
    }
    
    //something new
    
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


@end
