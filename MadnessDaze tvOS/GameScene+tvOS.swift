//
//  GameScene+tvOS.swift
//  MadnessDaze
//
//  Created by Adriano Soares on 30/10/15.
//  Copyright © 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//


import Foundation
import SpriteKit

extension GameScene {
    func setupGestureRecognizerTV () {

        let tapRecognizerMenu   = UITapGestureRecognizer(target: self, action: Selector("tappedMenu:"))
        
        tapRecognizerMenu.allowedPressTypes     = [UIPressType.Menu.rawValue];
        
        
        view!.addGestureRecognizer(tapRecognizerMenu);
    }
    
    func tappedMenu   (gesture: UITapGestureRecognizer) {
        self.enemyControl.gameOver()
        self.manager.stopBGSound()
        self.manager.stopStorySound()
        let transition = SKTransition.fadeWithDuration(0)
        let scene = StartMenuScene(size: self.size)
        if let recognizers = self.view?.gestureRecognizers {
            for recognizer in recognizers {
                self.view?.removeGestureRecognizer(recognizer)
            }
        }
        
        self.view?.presentScene(scene, transition: transition)
        
    }

    
    
    
}