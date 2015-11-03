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
        let aSelector : Selector = "choose:"
        let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
        tapGesture.numberOfTapsRequired = 1
        self.view!.addGestureRecognizer(tapGesture)
        
        let bSelector : Selector = "confirm:"
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
        
        
//        if (location.y > div.position.y){
//            self.tryAgain.fontColor = UIColor.redColor()
//            self.backToMenu.fontColor = UIColor.whiteColor()
//            tryAgainTouch++
//            backToMenuTouch = 0
//            print("restart")
//            manager.playDirectionNarration("LANG-tentarNovamente", frmt: "mp3")
////            GameManager.addSoundArray("LANG-tentarNovamente", frmt: "mp3", x: 0.0, y: 0.0)
//        }else if (location.y < div.position.y){
//            self.tryAgain.fontColor = UIColor.whiteColor()
//            self.backToMenu.fontColor = UIColor.redColor()
//            backToMenuTouch++
//            tryAgainTouch = 0
//            print("exit")
//            manager.playDirectionNarration("LANG-voltarMenu", frmt: "mp3")
////            GameManager.addSoundArray("LANG-voltarMenu", frmt: "mp3", x: 0.0, y: 0.0)
//        }
//        
//        if (location.y > div.position.y && tryAgainTouch > 1){
//            tryAgainTouch = 0
//            backToMenuTouch = 0
//            self.retry()
//        }else if (location.y < div.position.y && backToMenuTouch > 1){
//            tryAgainTouch = 0
//            backToMenuTouch = 0
//            self.mainMenu()
//        }
        
        
    }

    @IBAction func choose(sender: AnyObject){
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