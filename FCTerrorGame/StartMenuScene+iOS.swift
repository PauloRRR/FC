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
        
        #if os(iOS)
            print("iOS")
            #else
            print("tvOS")
        #endif
        
//        if (node.name == "newGame"){
//            self.newGame.fontColor = UIColor.redColor()
//            self.tutorial.fontColor = UIColor.whiteColor()
//            self.loadGame.fontColor = UIColor.whiteColor()
//            newGameTouch++
//            loadGameTouch = 0
//            tutorialTouch = 0
//            
//            manager.playDirectionNarration("LANG-iniciar", frmt: "mp3")
//            print("NEWGAME")
//            
//        }else if (node.name == "tutorial"){
//            print("TUTORIAL")
//            self.newGame.fontColor = UIColor.whiteColor()
//            self.tutorial.fontColor = UIColor.redColor()
//            self.loadGame.fontColor = UIColor.whiteColor()
//            tutorialTouch++
//            newGameTouch = 0
//            loadGameTouch = 0
//           
//            manager.playDirectionNarration("LANG-tutorial", frmt: "mp3")
//        }else if (node.name == "loadGame"){
//            self.loadGame.fontColor = UIColor.redColor()
//            self.newGame.fontColor = UIColor.whiteColor()
//            self.tutorial.fontColor = UIColor.whiteColor()
//            loadGameTouch++
//            newGameTouch = 0
//            tutorialTouch = 0
//            print("LOADGAME")
//            
//            manager.playDirectionNarration("LANG-continuar", frmt: "mp3")
//        }
        
//        if (node.name == "newGame" && newGameTouch > 1 && !manager.firstPlay){
//            
//            manager.playDirectionNarration("LANG-novoJogoConfirma", frmt: "mp3")
//            self.newGameScreen()
//        } else if (node.name == "newGame" && newGameTouch > 1 && manager.firstPlay){
//            manager.gameState.eraseJson()
//            manager.eraseManager()
//            self.manager.initStoryArray()
//            self.start()
//        }
//        
//        
//        if (node.name == "tutorial" && tutorialTouch > 1){
//            print("PLAY TUTORIAL")
//            GameManager.addSoundArray("LANG-tutorialFull", frmt: "mp3", x: 0.0, y: 0.0)
//
//            self.tutorialTouch = 0
//            self.newGameTouch = 0
//            self.loadGameTouch = 0
//        }
//        
//        if (node.name == "loadGame" && loadGameTouch > 1 && !manager.firstPlay){
//            print("NOW LOADING GAME")
//            continueGame()
//        }
        
//        if (node.name == "newGameNo"){
//            self.newGameNo.fontColor = UIColor.redColor()
//            self.newGameYes.fontColor = UIColor.whiteColor()
//            noTouch++
//            yesTouch = 0
//            print("NO")
//
//             manager.playDirectionNarration("LANG-nao", frmt: "mp3")
//        }else if (node.name == "newGameYes"){
//            self.newGameNo.fontColor = UIColor.whiteColor()
//            self.newGameYes.fontColor = UIColor.redColor()
//            yesTouch++
//            noTouch = 0
//            print("YES")
//
//             manager.playDirectionNarration("LANG-sim", frmt: "mp3")
//        }
        
//        
//        if (node.name == "newGameNo" && noTouch > 1){
//            self.newGameNo.removeFromParent()
//            self.newGameYes.removeFromParent()
//            newGameTouch = 0
//            loadGameTouch = 0
//            tutorialTouch = 0
//            noTouch = 0
//            yesTouch = 0
//            self.startMenuOptions()
//        } else if (node.name == "newGameYes" && yesTouch > 1){
//            manager.gameState.eraseJson()
//            manager.eraseManager()
//            self.manager.initStoryArray()
//            self.start()
//        }
        
        
        
        if (location.y > dot2.position.y && location.y > dot.position.y && isOnStartMenuOptions){
            self.loadGame.fontColor = UIColor.redColor()
            self.newGame.fontColor = UIColor.whiteColor()
            self.tutorial.fontColor = UIColor.whiteColor()
            loadGameTouch++
            newGameTouch = 0
            tutorialTouch = 0
            print("LOADGAME")
            
            manager.playDirectionNarration("LANG-continuar", frmt: "mp3")
        }else if(location.y < dot2.position.y && location.y > dot.position.y && isOnStartMenuOptions){
            self.newGame.fontColor = UIColor.redColor()
            self.tutorial.fontColor = UIColor.whiteColor()
            self.loadGame.fontColor = UIColor.whiteColor()
            newGameTouch++
            loadGameTouch = 0
            tutorialTouch = 0
            
            manager.playDirectionNarration("LANG-iniciar", frmt: "mp3")
            print("NEWGAME")
        } else if (location.y < dot.position.y && location.y < dot2.position.y && isOnStartMenuOptions){
            print("TUTORIAL")
            self.newGame.fontColor = UIColor.whiteColor()
            self.tutorial.fontColor = UIColor.redColor()
            self.loadGame.fontColor = UIColor.whiteColor()
            tutorialTouch++
            newGameTouch = 0
            loadGameTouch = 0
            
            manager.playDirectionNarration("LANG-tutorial", frmt: "mp3")

        }
        
        if (location.y > dot2.position.y && location.y > dot.position.y && loadGameTouch > 1 && !manager.firstPlay && isOnStartMenuOptions){
            print("NOW LOADING GAME")
            continueGame()
        }
        
        if (location.y < dot2.position.y && location.y > dot.position.y && newGameTouch > 1 && !manager.firstPlay && isOnStartMenuOptions){
            
            manager.playDirectionNarration("LANG-novoJogoConfirma", frmt: "mp3")
            self.newGameScreen()
        } else if (location.y < dot2.position.y && location.y > dot.position.y && newGameTouch > 1 && manager.firstPlay && isOnStartMenuOptions){
            manager.gameState.eraseJson()
            manager.eraseManager()
            self.manager.initStoryArray()
            self.start()
        }
        
        if (location.y < dot2.position.y && location.y < dot.position.y && tutorialTouch > 1 && isOnStartMenuOptions){
            print("PLAY TUTORIAL")
            GameManager.addSoundArray("LANG-tutorialFull", frmt: "mp3", x: 0.0, y: 0.0)
            
            self.tutorialTouch = 0
            self.newGameTouch = 0
            self.loadGameTouch = 0
        }
        
        if (location.y > dot3.position.y && isOnNewGameScreen){
            self.newGameNo.fontColor = UIColor.whiteColor()
            self.newGameYes.fontColor = UIColor.redColor()
            yesTouch++
            noTouch = 0
            print("YES")
            
            manager.playDirectionNarration("LANG-sim", frmt: "mp3")
        }else if(location.y < dot3.position.y && isOnNewGameScreen){
            self.newGameNo.fontColor = UIColor.redColor()
            self.newGameYes.fontColor = UIColor.whiteColor()
            noTouch++
            yesTouch = 0
            print("NO")
            
            manager.playDirectionNarration("LANG-nao", frmt: "mp3")
        }
        
        if (location.y > dot3.position.y && yesTouch > 1 && isOnNewGameScreen){
            manager.gameState.eraseJson()
            manager.eraseManager()
            self.manager.initStoryArray()
            self.start()
        }else if (location.y < dot3.position.y && noTouch > 1 && isOnNewGameScreen){
            self.newGameNo.removeFromParent()
            self.newGameYes.removeFromParent()
            newGameTouch = 0
            loadGameTouch = 0
            tutorialTouch = 0
            noTouch = 0
            yesTouch = 0
            self.startMenuOptions()
        }
    }
}