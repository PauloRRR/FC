//
//  StartMenuScene.swift
//  MadnessDaze
//
//  Created by Paulo Ricardo Ramos da Rosa on 9/10/15.
//  Copyright (c) 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//

import SpriteKit

class StartMenuScene: SKScene {
    
    var manager = GameManager.sharedInstance;
    
    
    override func didMoveToView(view: SKView) {
        var tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("start"))
        self.view?.addGestureRecognizer(tapRecognizer);
        self.view?.scene?.backgroundColor = UIColor.blackColor()
        
    }
    
    
    func start () {
        var interval = NSTimeInterval()
        var transition = SKTransition.crossFadeWithDuration(5.0)
        var scene = GameScene(size: self.size)
        var state = GameState()
        state.room = 0
        state.rotation = 1
        //scene.loadRoom()
        
        
        
        self.view?.presentScene(scene, transition: transition)
        
    }
}
