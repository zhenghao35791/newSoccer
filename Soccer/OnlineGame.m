//
//  OnlineGame.m
//  Soccer
//
//  Created by rayna on 14-9-17.
//  Copyright (c) 2014年 hao. All rights reserved.
//

#import "OnlineGame.h"

@implementation OnlineGame
    static NSString * const Player1Name = @"Player1";//用这个字符串来标示可移动的node
    static NSString * const Player2Name = @"Player2";
int onlinePlayer1Score = 0;
int onlinePlayer2Score = 0;

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
		if([[touchedNode name] isEqualToString:Player1Name]||[[touchedNode name] isEqualToString:Player2Name]) {
			SKAction *sequence = [SKAction sequence:@[[SKAction rotateByAngle:degToRad(-4.0f) duration:0.1],[SKAction rotateByAngle:0.0 duration:0.1],[SKAction rotateByAngle:degToRad(4.0f) duration:0.1]]];
			[_selectedNode runAction:[SKAction repeatActionForever:sequence]];
		}
	}
}

- (float) degToRad:(float)degree
{
	return degree / 180.0f * M_PI;
}//由于Sprite Kit是利用弧度来做旋转效果的，所以上面这个方法将角度转换为弧度。

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
        newPositionPlayer1.x = currentMaxX;
    }
    if (newPositionPlayer1.y > currentMaxY) {
        newPositionPlayer1.y = currentMaxY;
    }
    if (newPositionPlayer2.x > currentMaxX) {
        newPositionPlayer2.x = currentMaxX;
    }
    if (newPositionPlayer2.y > currentMaxY) {
        newPositionPlayer2.y = currentMaxY;
    }
    if (newPositionSoccer.x > currentMaxX) {
        newPositionSoccer.x = currentMaxX;
    }
    if (newPositionSoccer.y > currentMaxY) {
        newPositionSoccer.y = currentMaxY;
    }
    
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


- (void)didBeginContact:(SKPhysicsContact *)contact
{
//    int maskCode = contact.bodyA.contactTestBitMask|contact.bodyB.contactTestBitMask;
//    
//    if (maskCode == MASK_EDGE|MASK_FLAG) {
//        
//        if contact.bodyA.contactTestBitMask==MASK_FLAG{
//            contact.bodyA.node.removeFromParent()
//        }
//        if contact.bodyB.contactTestBitMask==MASK_FLAG{
//            contact.bodyB.node.removeFromParent()
//        }
//    }else if maskCode == MASK_EDGE|MASK_BALL{
//        //            print("GameOver")
//        self.view.presentScene(GameOverScene(size: self.frame.size))
//    }
    
    
    
    //NSLog(@"collison");
    SKPhysicsBody *firstBody, *secondBody;
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
   // NSLog(@"%d",firstBody.categoryBitMask);
    if ((firstBody.categoryBitMask!=soccerCategory))//firstbody isnt soccer
    {
        SKNode *soccer1 = (contact.bodyA.categoryBitMask & soccerCategory) ? contact.bodyA.node : contact.bodyB.node;
        soccer1.physicsBody.velocity = firstBody.velocity;
        soccer1.physicsBody.velocity = CGVectorMake(soccer1.physicsBody.velocity.dx*10,soccer1.physicsBody.velocity.dy*10);
        
        CGPoint newPosition = CGPointMake(_soccer.position.x + soccer1.physicsBody.velocity.dx, _soccer.position.y + soccer1.physicsBody.velocity.dy);
        
//        NSLog(@"soccer positionx: %f",_soccer.position.x);
//        NSLog(@"soccer positiony: %f",_soccer.position.y);
//        NSLog(@"soccer width,height: %f,%f",screenWidth,screenHeight);
        
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
        if (newPosition.x > screenWidth/2-100 && newPosition.x < screenWidth/2+100 && newPosition.y > screenHeight-60) {
            NSLog(@"score!!!!!!!!!!!!!!!");
            if (firstBody.categoryBitMask == 1) {
                onlinePlayer1Score++;
                NSLog(@"player1 score and he has scored : %d",onlinePlayer1Score);
            }
            if (firstBody.categoryBitMask == 2) {
                onlinePlayer2Score++;
                NSLog(@"player1 score and he has scored : %d",onlinePlayer2Score);
            }
            newPosition = CGPointMake(screenWidth/2, screenHeight/2);
        }
        
        
      [_soccer runAction:[SKAction moveTo:newPosition duration:1]];
        NSLog(@"soccer speed: %f,%f",soccer1.physicsBody.velocity.dx,soccer1.physicsBody.velocity.dy);
    }
}

@end
