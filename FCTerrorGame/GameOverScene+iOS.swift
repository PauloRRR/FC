//
//  GameOverScene+iOS.swift
//  MadnessDaze
//
//  Created by Adriano Soares on 14/10/15.
//  Copyright © 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//

import Foundation
import SpriteKit

extension GameOverScene {
    
    func setupGestureRecognizerIOS(){
        let aSelector : Selector = #selector(GameOverScene.choose(_:))
        let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
        tapGesture.numberOfTapsRequired = 1
        self.view!.addGestureRecognizer(tapGesture)
        
        let bSelector : Selector = #selector(GameOverScene.confirm(_:))
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: bSelector)
        doubleTapGesture.numberOfTapsRequired = 2
        self.view!.addGestureRecognizer(doubleTapGesture)
        
        tapGesture.requireGestureRecognizerToFail(doubleTapGesture)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches
        let location = touch.first!.locationInNode(self)
        _ = self.nodeAtPoint(location)
        self.location = touch.first!.locationInNode(self)
        
        
    }

    @IBAction func choose(sender: AnyObject){
        if(!UIAccessibilityIsVoiceOverRunning()){
            confirm(sender)
            return
        }
        if (location.y > div.position.y){
            self.tryAgain.fontColor = UIColor.redColor()
            self.backToMenu.fontColor = UIColor.whiteColor()
            
            print("restart")
            manager.playDirectionNarration("LANG-tentarNovamente", frmt: "mp3")
        }else if(location.y < div.position.y){
            self.tryAgain.fontColor = UIColor.whiteColor()
            self.backToMenu.fontColor = UIColor.redColor()
            
            print("exit")
            manager.playDirectionNarration("LANG-voltarMenu", frmt: "mp3")
        }
    }
    
    @IBAction func confirm(sender: AnyObject){
        if (location.y > div.position.y){
            self.tryAgain.fontColor = UIColor.redColor()
            self.backToMenu.fontColor = UIColor.whiteColor()
            
            self.retry()
        }else if(location.y < div.position.y){
            self.tryAgain.fontColor = UIColor.whiteColor()
            self.backToMenu.fontColor = UIColor.redColor()
            
            self.mainMenu()
        }
        
    }

}