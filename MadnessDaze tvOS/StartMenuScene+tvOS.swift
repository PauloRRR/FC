//
//  StartMenuScene+tvOS.swift
//  MadnessDaze
//
//  Created by Adriano Soares on 08/10/15.
//  Copyright © 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//

import Foundation
import Foundation
import SpriteKit


extension StartMenuScene {
    
    
    func setupGestureRecognizerTV () {
        let tapRecognizerUp     = UITapGestureRecognizer(target: self, action: Selector("tappedUp:"))
        let tapRecognizerRight  = UITapGestureRecognizer(target: self, action: Selector("tappedRight:"))
        let tapRecognizerDown   = UITapGestureRecognizer(target: self, action: Selector("tappedDown:"))
        let tapRecognizerLeft   = UITapGestureRecognizer(target: self, action: Selector("tappedLeft:"))
        let tapRecognizerSelect = UITapGestureRecognizer(target: self, action: Selector("selectClick:"))
        
        tapRecognizerUp.allowedPressTypes       = [UIPressType.UpArrow.rawValue];
        tapRecognizerRight.allowedPressTypes    = [UIPressType.RightArrow.rawValue];
        tapRecognizerDown.allowedPressTypes     = [UIPressType.DownArrow.rawValue];
        tapRecognizerLeft.allowedPressTypes     = [UIPressType.LeftArrow.rawValue];
        tapRecognizerSelect.allowedPressTypes   = [UIPressType.Select.rawValue];
        
        view!.addGestureRecognizer(tapRecognizerUp);
        view!.addGestureRecognizer(tapRecognizerRight);
        view!.addGestureRecognizer(tapRecognizerDown);
        view!.addGestureRecognizer(tapRecognizerLeft);
        view!.addGestureRecognizer(tapRecognizerSelect);
        
        labels.append(loadGame)
        labels.append(newGame)
        labels.append(tutorial)
        
        updateColor();
    }
    
    
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }
    
    func updateColor () {
        for (var i = 0; i < 3; i++) {
            if (i == selected) {
                labels[i].fontColor = UIColor.redColor()
            } else {
                labels[i].fontColor = UIColor.whiteColor()
            }
        
        
        }
        
        
        
        
        
    
    
    }
    
    func tappedUp   (gesture: UITapGestureRecognizer) {
        print("tapUp")
        if (selected-1 < 0) {
            selected = 2
        }
        else {
            selected = (selected-1)%3;
        }
        updateColor();

    }
    func tappedRight(gesture: UITapGestureRecognizer) {
        print("tapRight")
    }
    func tappedDown (gesture: UITapGestureRecognizer) {
        print("tapDown")
        selected = (selected+1)%3;
        updateColor();

    }
    func tappedLeft (gesture: UITapGestureRecognizer) {
        print("tapLeft")
    }
    
    func selectClick(gesture: UITapGestureRecognizer) {
        if (selected == 0) {
            continueGame();
        } else if (selected == 1) {
            manager.gameState.eraseJson()
            manager.eraseManager()
            self.manager.initStoryArray()
            self.start()
        
        }
        
        print("selectClick")
    }
    
    /*
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        
        
        
        
        let touch = touches
        let location = touch.first!.locationInNode(self)
        let node = self.nodeAtPoint(location)
        
        #if os(iOS)
            print("iOS")
            #else
            print("tvOS")
        #endif
        
        if (node.name == "newGame"){
            newGameTouch++
            loadGameTouch = 0
            tutorialTouch = 0
            GameManager.addSoundArray("iniciar_PT-BR_01", frmt: "mp3", x: 0.0, y: 0.0)
            print("NEWGAME")
            
        }else if (node.name == "tutorial"){
            print("TUTORIAL")
            tutorialTouch++
            newGameTouch = 0
            loadGameTouch = 0
            GameManager.addSoundArray("tutorial_PT-BR_01", frmt: "mp3", x: 0.0, y: 0.0)
        }else if (node.name == "loadGame"){
            loadGameTouch++
            newGameTouch = 0
            tutorialTouch = 0
            print("LOADGAME")
            GameManager.addSoundArray("continuar_PT-BR_01", frmt: "mp3", x: 0.0, y: 0.0)
        }
        
        if (node.name == "newGame" && newGameTouch > 1 && !manager.firstPlay){
            GameManager.addSoundArray("novoJogoConfirma_PT-BR_01", frmt: "mp3", x: 0.0, y: 0.0)
            self.newGameScreen()
        } else if (node.name == "newGame" && newGameTouch > 1 && manager.firstPlay){
            manager.gameState.eraseJson()
            manager.eraseManager()
            self.manager.initStoryArray()
            self.start()
        }
        
        
        if (node.name == "tutorial" && tutorialTouch > 1){
            print("PLAY TUTORIAL")
            GameManager.addSoundArray("tutorialFull_PT-BR_01", frmt: "mp3", x: 0.0, y: 0.0)
            self.tutorialTouch = 0
            self.newGameTouch = 0
            self.loadGameTouch = 0
        }
        
        if (node.name == "loadGame" && loadGameTouch > 1 && !manager.firstPlay){
            print("NOW LOADING GAME")
            continueGame()
        }
        
        if (node.name == "newGameNo"){
            noTouch++
            yesTouch = 0
            print("NO")
            GameManager.addSoundArray("nao_PT-BR_01", frmt: "mp3", x: 0.0, y: 0.0)
        }else if (node.name == "newGameYes") {
            yesTouch++
            noTouch = 0
            print("YES")
            GameManager.addSoundArray("sim_PT-BR_01", frmt: "mp3", x: 0.0, y: 0.0)
        }
        
        
        
        if (node.name == "newGameNo" && noTouch > 1){
            self.newGameNo.removeFromParent()
            self.newGameYes.removeFromParent()
            newGameTouch = 0
            loadGameTouch = 0
            tutorialTouch = 0
            noTouch = 0
            yesTouch = 0
            self.startMenuOptions()
        } else if (node.name == "newGameYes" && yesTouch > 1){
            manager.gameState.eraseJson()
            manager.eraseManager()
            self.manager.initStoryArray()
            self.start()
        }
    }
    */
}