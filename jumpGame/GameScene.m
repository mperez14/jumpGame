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
    SKSpriteNode *cowboy;
    SKNode *_bgLayer;
    SKNode *_characterLayer;
    SKNode *_textLayer;
    int score;
    int cowSpeed;
    int cowAcceleration;
    bool squish;
    bool once;
}
/*TODO:
    -collision detection
        -cow from front
        -cow from bottom
    -affected by gravity
 */
 


/****MAIN****/
-(id)initWithSize:(CGSize)size{
    once = false;
    score = 0;
    cowSpeed = 50;
    cowAcceleration = 5;
    
    if(self = [super initWithSize:size]){
        _bgLayer = [SKNode node];       //init layers
        [self addChild:_bgLayer];
        _characterLayer = [SKNode node];
        [self addChild:_characterLayer];
        _textLayer = [SKNode node];
        [self addChild:_textLayer];
        
        [self initScrollingGround];
        [self initScrollingClouds];
        [self addCow];
        [self addCowboy];
        [self scoreCount];
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

-(void)scoreCount{
    [_textLayer removeFromParent];
    _textLayer = [SKNode node];
    [self addChild:_textLayer];
    
    SKLabelNode *scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    scoreLabel.text =[NSString stringWithFormat:@"Score: %d", score];
    scoreLabel.fontColor = [SKColor yellowColor];
    scoreLabel.position =CGPointMake(self.size.width/2, self.size.height/2 + 100);
    [_textLayer addChild:scoreLabel];
    
}

-(void)addCow{
    cow = [SKSpriteNode spriteNodeWithImageNamed:@"Cow.png"];//change to train png
    cow.name = @"Cow";
    cow.position = CGPointMake(400, 50);
    cow.zPosition = 10;
    cow.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:cow.size];
    cow.physicsBody.affectedByGravity = NO;
    cow.physicsBody.allowsRotation = NO;
    squish = false;
    [_characterLayer addChild:cow];
    //cow.yScale = .5;
}
-(void)addCowboy{
    cowboy = [SKSpriteNode spriteNodeWithImageNamed:@"YellowBoy.png"];//change to train png
    cowboy.name = @"Cowboy";
    cowboy.position = CGPointMake(200, 100);
    cowboy.zPosition = 10;
    cowboy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:cowboy.size];
    cowboy.physicsBody.affectedByGravity = NO;
    cowboy.physicsBody.allowsRotation = NO;
    [cowboy setScale:.4];
    [_characterLayer addChild:cowboy];
}

-(void)squishCow{
    if(squish == false){
        cow.yScale = .5;
        cow.position = CGPointMake(cow.position.x, cow.position.y - 15);
        squish = true;
    }
}

-(void)gameOver{
    //[_textLayer removeFromParent];
    //_textLayer = [SKNode node];
    //[self addChild:_textLayer];
    
    SKLabelNode *gameOver = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    gameOver.text =[NSString stringWithFormat:@"Game Over"];
    gameOver.fontColor = [SKColor redColor];
    gameOver.position =CGPointMake(self.size.width/2, self.size.height/2);
    [_textLayer addChild:gameOver];
}

-(void)jump{
    cowboy.position = CGPointMake(cowboy.position.x, cowboy.position.y+250);
    cowboy.physicsBody.velocity = CGVectorMake(0, 0);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    CGPoint location = [[touches anyObject] locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    //if([node.name isEqual:@"cow"]){
    if(cowboy.position.y <=85){
        [self jump];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if(cowboy.position.y > 85){ //make ground, cowboy doesnt fall past certain point
        cowboy.position = CGPointMake(cowboy.position.x, cowboy.position.y - 5);
    }
    else if(cowboy.position.x<=-10){
        if(once == false){
            [_characterLayer removeFromParent];
            [self gameOver];
            _characterLayer = [SKNode node];
            [self addChild:_characterLayer];
            [self initScrollingGround];
            once = true;
        }
    }
    if(score<=10)
        cow.physicsBody.velocity = CGVectorMake(-cowSpeed, 0);
    else
        [cow.physicsBody applyForce:CGVectorMake(-cowAcceleration, 0)];
    if(cow.position.x <= -40 || cow.position.y <= -10){  //cow starting position
        cow.physicsBody.velocity = CGVectorMake(0, 0);
        [cow removeFromParent];
        if(score<=10)
            cowSpeed = cowSpeed+20;
        else
            cowAcceleration++;
        if(squish == false){    //dont count squished cows
            score++;
        }
        [self scoreCount];
        [self addCow];
    }
}

@end
