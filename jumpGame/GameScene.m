//
//  GameScene.m
//  jumpGame
//
//  Created by Matthew Perez on 4/24/15.
//  Copyright (c) 2015 Matthew Perez. All rights reserved.
//

#import "GameScene.h"
#import <AVFoundation/AVFoundation.h>

@implementation GameScene{
    SKSpriteNode *cow;
    SKNode *_bgLayer;
    SKNode *_characterLayer;
}
/****MAIN****/
-(id)initWithSize:(CGSize)size{
    
    
    if(self = [super initWithSize:size]){
        _bgLayer = [SKNode node];       //init layers
        [self addChild:_bgLayer];
        _characterLayer = [SKNode node];
        [self addChild:_characterLayer];
        
        [self initScrollingGround];
        [self initScrollingClouds];
        [self addCow];
    }
    return self;
}

-(void)initScrollingGround{ //Scrolling tracks function
    SKTexture *groundTexture = [SKTexture textureWithImageNamed:@"grass_1.png"]; //change runway to train tracks
    SKAction *moveGroundSprite = [SKAction moveByX:-groundTexture.size.width*2 y:0 duration:.02*groundTexture.size.width*2];
    SKAction *resetGroundSprite = [SKAction moveByX:groundTexture.size.width*2 y:0 duration:0];
    SKAction *moveGroundSpriteForever = [SKAction repeatActionForever:[SKAction sequence:@[moveGroundSprite, resetGroundSprite]]];
    
    for(int i=0; i<2 +self.frame.size.width/(groundTexture.size.width);i++){      //place image
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:groundTexture];
        [sprite setScale:1];
        sprite.zPosition = 10;
        sprite.anchorPoint = CGPointZero;
        sprite.position = CGPointMake(i*sprite.size.width, 0);
        [sprite runAction:moveGroundSpriteForever];
        [_characterLayer addChild:sprite];
    }
}

-(void)initScrollingClouds{   //scrolling CLOUDS function
    SKTexture *backgroundTexture = [SKTexture textureWithImageNamed:@"Clouds.png"];        //reuse sky image
    SKAction *moveBg= [SKAction moveByX:-backgroundTexture.size.width y:0 duration: 0.1*backgroundTexture.size.width]; //move Bg
    SKAction *resetBg = [SKAction moveByX:backgroundTexture.size.width y:0 duration:0];   //reset background
    SKAction *moveBackgroundForever = [SKAction repeatActionForever:[SKAction sequence:@[moveBg, resetBg]]];    //repeat moveBg and resetBg
    for(int i =0; i<2+self.frame.size.width/(backgroundTexture.size.width); i++){     //place image
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:backgroundTexture];
        [sprite setScale:1];
        sprite.zPosition=-20;
        sprite.anchorPoint=CGPointZero;
        sprite.position=CGPointMake(i*sprite.size.width, 500);
        [sprite runAction:moveBackgroundForever];
        [_bgLayer addChild:sprite];
    }
}

-(void)addCow{
    cow = [SKSpriteNode spriteNodeWithImageNamed:@"Cow.png"];//change to train png
    cow.name = @"cow";
    cow.position = CGPointMake(400, 50);
    cow.zPosition = -5;
    cow.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(50, 50)];
    cow.physicsBody.affectedByGravity = NO;
    cow.physicsBody.allowsRotation = NO;
    [_characterLayer addChild:cow];
    [cow.physicsBody applyForce:CGVectorMake(-25, 0)];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
