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
        for (var i = 0; i < labels.count; i++) {
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
            selected = labels.count-1
        }
        else {
            selected = (selected-1)%labels.count;
        }
        updateColor();
        
    }
    func tappedRight(gesture: UITapGestureRecognizer) {
        print("tapRight")
    }
    func tappedDown (gesture: UITapGestureRecognizer) {
        print("tapDown")
        selected = (selected+1)%labels.count;
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
}