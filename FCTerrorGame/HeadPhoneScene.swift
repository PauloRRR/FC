//
//  HeadPhoneScene.swift
//  MadnessDaze
//
//  Created by Rafael on 11/11/15.
//  Copyright © 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//


import SpriteKit
import AVFoundation

var headphone : SKSpriteNode!
var headphoneFrames : [SKTexture]!

class HeadPhoneScene: SKScene {
    override func didMoveToView(view: SKView) {
       
        backgroundColor = (UIColor.blackColor())
        let headphoneAnimatedAtlas = SKTextureAtlas(named: "Headphone")
        var pulseFrames = [SKTexture]()
        
        let numImages = headphoneAnimatedAtlas.textureNames.count
        for var i=1; i<=numImages/2; i++ {
            let bearTextureName = "Screen_\(i)"
            pulseFrames.append(headphoneAnimatedAtlas.textureNamed(bearTextureName))
        }
        
        headphoneFrames = pulseFrames
        
        let firstFrame = headphoneFrames[0]
        headphone = SKSpriteNode(texture: firstFrame)
        headphone.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        addChild(headphone)
        
        pulse()
    }
    
    func pulse() {
        //This is our general runAction method to make our bear walk.
        headphone.runAction(SKAction.repeatActionForever(
            SKAction.animateWithTextures(headphoneFrames,
                timePerFrame: 0.1,
                resize: false,
                restore: true)),
            withKey:"pulseHeadphone")
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}