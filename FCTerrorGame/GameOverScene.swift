//
//  GameOverScene.swift
//  MadnessDaze
//
//  Created by Adriano Soares on 03/09/15.
//  Copyright (c) 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//

import SpriteKit



class GameOverScene: SKScene {
    var manager = GameManager.sharedInstance;
    
    
    override func didMoveToView(view: SKView) {
        manager.enemiesCreated = false;
        var tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("retry"))
        self.view?.addGestureRecognizer(tapRecognizer);
        
    }
    
    
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
    }
    
    
    
    func mainMenu () {
    
    }
    
    func retry () {
        var transition = SKTransition.fadeWithDuration(0)
        var scene = GameScene(size: self.size)
        if let recognizers = self.view?.gestureRecognizers {
            for recognizer in recognizers {
                self.view?.removeGestureRecognizer(recognizer as! UIGestureRecognizer)
            }
        }
        
        self.view?.presentScene(scene, transition: transition)
    
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
