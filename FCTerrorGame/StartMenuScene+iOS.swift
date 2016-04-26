//
//  StartMenuScene+iOS.swift
//  MadnessDaze
//
//  Created by Adriano Soares on 08/10/15.
//  Copyright © 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//

import Foundation
import SpriteKit


extension StartMenuScene {
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches
        let location = touch.first!.locationInNode(self)
        _ = self.nodeAtPoint(location)
        self.location = touch.first!.locationInNode(self)

    }
    
    func setupGestureRecognizerIOS(){
        let aSelector : Selector = #selector(StartMenuScene.choose(_:))
        let tapGesture = UITapGestureRecognizer(target: self, action: aSelector)
        tapGesture.numberOfTapsRequired = 1
        self.view!.addGestureRecognizer(tapGesture)
        
        let bSelector : Selector = #selector(StartMenuScene.confirm(_:))
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: bSelector)
        doubleTapGesture.numberOfTapsRequired = 2
        self.view!.addGestureRecognizer(doubleTapGesture)
        
        tapGesture.requireGestureRecognizerToFail(doubleTapGesture)
    }
    
    @IBAction func choose(sender: AnyObject){
        
        if(!UIAccessibilityIsVoiceOverRunning()){
            confirm(sender)
            return
        }
        if (self.location.y > dot2.position.y && self.location.y > dot.position.y && isOnStartMenuOptions ){
            self.loadGame.fontColor = UIColor.redColor()
            self.newGame.fontColor = UIColor.whiteColor()
            self.tutorial.fontColor = UIColor.whiteColor()
            
            print("LOADGAME")
            
            manager.playDirectionNarration("LANG-continuar", frmt: "mp3")
        }else if(self.location.y < dot2.position.y && self.location.y > dot.position.y && isOnStartMenuOptions){
            self.newGame.fontColor = UIColor.redColor()
            self.tutorial.fontColor = UIColor.whiteColor()
            self.loadGame.fontColor = UIColor.whiteColor()
            
            
            manager.playDirectionNarration("LANG-iniciar", frmt: "mp3")
            print("NEWGAME")
        } else if (self.location.y < dot.position.y && self.location.y < dot2.position.y && isOnStartMenuOptions){
            print("TUTORIAL")
            self.newGame.fontColor = UIColor.whiteColor()
            self.tutorial.fontColor = UIColor.redColor()
            self.loadGame.fontColor = UIColor.whiteColor()
            
            manager.playDirectionNarration("LANG-tutorial", frmt: "mp3")
            
        }
        
        if (self.location.y > dot3.position.y && isOnNewGameScreen){
            self.newGameNo.fontColor = UIColor.whiteColor()
            self.newGameYes.fontColor = UIColor.redColor()
            
            print("YES")
            
            manager.playDirectionNarration("LANG-sim", frmt: "mp3")
        }else if(self.location.y < dot3.position.y && isOnNewGameScreen){
            self.newGameNo.fontColor = UIColor.redColor()
            self.newGameYes.fontColor = UIColor.whiteColor()
            
            print("NO")
            
            manager.playDirectionNarration("LANG-nao", frmt: "mp3")
        }
    }
    
    @IBAction func confirm(sender: AnyObject){
        if (self.location.y > dot2.position.y && self.location.y > dot.position.y && !manager.firstPlay && isOnStartMenuOptions){
            print("NOW LOADING GAME")
            self.loadGame.fontColor = UIColor.redColor()
            self.newGame.fontColor = UIColor.whiteColor()
            self.tutorial.fontColor = UIColor.whiteColor()
            continueGame()
        }
        
        if (self.location.y < dot2.position.y && self.location.y > dot.position.y && !manager.firstPlay && isOnStartMenuOptions){
            self.newGame.fontColor = UIColor.redColor()
            self.tutorial.fontColor = UIColor.whiteColor()
            self.loadGame.fontColor = UIColor.whiteColor()
            manager.playDirectionNarration("LANG-novoJogoConfirma", frmt: "mp3")
            self.location = self.dot3.position
            self.newGameScreen()
        } else
            if (self.location.y < dot2.position.y && self.location.y > dot.position.y && manager.firstPlay && isOnStartMenuOptions){
            self.newGame.fontColor = UIColor.redColor()
            self.tutorial.fontColor = UIColor.whiteColor()
            self.loadGame.fontColor = UIColor.whiteColor()
            manager.gameState.eraseJson()
            manager.eraseManager()
            self.manager.initStoryArray()
            self.start()
        }
        
        if (self.location.y < dot2.position.y && self.location.y < dot.position.y && isOnStartMenuOptions){
            print("PLAY TUTORIAL")
            self.newGame.fontColor = UIColor.whiteColor()
            self.tutorial.fontColor = UIColor.redColor()
            self.loadGame.fontColor = UIColor.whiteColor()
            //GameManager.addSoundArray("LANG-tutorialFull", frmt: "mp3", x: 0.0, y: 0.0)
            self.playTutorial()
            //GameAnalytics.addDesignEventWithEventId("UI:Tutorial")
            
        }
        
       
        
        if (self.location.y > dot3.position.y && isOnNewGameScreen && !isOnStartMenuOptions){
            self.newGameNo.fontColor = UIColor.whiteColor()
            self.newGameYes.fontColor = UIColor.redColor()
            manager.gameState.eraseJson()
            manager.eraseManager()
            self.manager.initStoryArray()
            self.start()
        }else if (self.location.y < dot3.position.y && isOnNewGameScreen && !isOnStartMenuOptions){
            self.newGameNo.fontColor = UIColor.redColor()
            self.newGameYes.fontColor = UIColor.whiteColor()
            self.newGameNo.removeFromParent()
            self.newGameYes.removeFromParent()
            
            self.startMenuOptions()
        }
        
    }
    
}