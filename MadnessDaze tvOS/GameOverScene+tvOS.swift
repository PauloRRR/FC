//
//  GameOverScene+tvOS.swift
//  MadnessDaze
//
//  Created by Adriano Soares on 14/10/15.
//  Copyright © 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//

import Foundation
import SpriteKit

extension GameOverScene {
    func setupGestureRecognizerTV () {
        let tapRecognizerUp     = UITapGestureRecognizer(target: self, action: #selector(GameOverScene.tappedUp(_:)))
        let tapRecognizerRight  = UITapGestureRecognizer(target: self, action: #selector(GameOverScene.tappedRight(_:)))
        let tapRecognizerDown   = UITapGestureRecognizer(target: self, action: #selector(GameOverScene.tappedDown(_:)))
        let tapRecognizerLeft   = UITapGestureRecognizer(target: self, action: #selector(GameOverScene.tappedLeft(_:)))
        let tapRecognizerSelect = UITapGestureRecognizer(target: self, action: #selector(GameOverScene.selectClick(_:)))
        let tapRecognizerMenu   = UITapGestureRecognizer(target: self, action: #selector(self.mainMenu))
        let tapRecognizerPlay   = UITapGestureRecognizer(target: self, action: #selector(self.retry))
        //let tapRecognizerMenu   = UITapGestureRecognizer(target: self, action: Selector("mainMenu"))
        //let tapRecognizerPlay   = UITapGestureRecognizer(target: self, action: Selector("retry"))
        
        
        tapRecognizerUp.allowedPressTypes       = [UIPressType.UpArrow.rawValue];
        tapRecognizerRight.allowedPressTypes    = [UIPressType.RightArrow.rawValue];
        tapRecognizerDown.allowedPressTypes     = [UIPressType.DownArrow.rawValue];
        tapRecognizerLeft.allowedPressTypes     = [UIPressType.LeftArrow.rawValue];
        tapRecognizerSelect.allowedPressTypes   = [UIPressType.Select.rawValue];
        tapRecognizerMenu.allowedPressTypes     = [UIPressType.Menu.rawValue];
        tapRecognizerPlay.allowedPressTypes     = [UIPressType.PlayPause.rawValue];

        
        view!.addGestureRecognizer(tapRecognizerUp);
        view!.addGestureRecognizer(tapRecognizerRight);
        view!.addGestureRecognizer(tapRecognizerDown);
        view!.addGestureRecognizer(tapRecognizerLeft);
        view!.addGestureRecognizer(tapRecognizerSelect);
        view!.addGestureRecognizer(tapRecognizerMenu);
        view!.addGestureRecognizer(tapRecognizerPlay);

        
        
        labels.append(tryAgain)
        labels.append(backToMenu)
        
        updateColor();
    }
    
    
    override func pressesBegan(presses: Set<UIPress>, withEvent event: UIPressesEvent?) {
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }
    
    func updateColor () {
        for i in 0 ..< labels.count {
            if (i == selected) {
                labels[i].fontColor = UIColor.redColor()
            } else {
                labels[i].fontColor = UIColor.whiteColor()
            }
        }
        voice();
    }
    
    
    func voice () {
        switch (selected) {
        case 0:
            manager.playDirectionNarration("LANG-tentarNovamente", frmt: "mp3")
            
            break;
            
        case 1:
            manager.playDirectionNarration("LANG-voltarMenu", frmt: "mp3")
            
            break;
        default:
            break;
            
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
        print("selectClick")
        if (selected == 0) {
            self.retry()
        } else if (selected == 1) {
            self.mainMenu()
            
        }
        
    }
    
    
    
}