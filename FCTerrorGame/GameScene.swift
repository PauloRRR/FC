//
//  GameScene.swift
//  FCTeste
//
//  Created by Adriano Soares on 04/08/15.
//  Copyright (c) 2015 bepid. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, UIGestureRecognizerDelegate {
    var gameState = GameState.sharedInstance;
    var level: JSON!
    var audio = AudioNode(soundName: "helicopterMono", format: "mp3")
    
    
    override func didMoveToView(view: SKView) {
        if let filePath = NSBundle.mainBundle().pathForResource("Level1", ofType: "json") {
            level =  JSON(data: NSData(contentsOfFile: filePath)!)
        } else {
            level = JSON.nullJSON
        }
        println(level[0])
        
        
        var swipeLeft   = UISwipeGestureRecognizer(target: self, action: Selector("swipeLeft:"))
        var swipeUp     = UISwipeGestureRecognizer(target: self, action: Selector("swipeUp:"))
        var swipeRight  = UISwipeGestureRecognizer(target: self, action: Selector("swipeRight:"))
        var swipeDown   = UISwipeGestureRecognizer(target: self, action: Selector("swipeDown:"))
        swipeLeft.direction  = .Left
        swipeUp.direction    = .Up
        swipeRight.direction = .Right
        swipeDown.direction  = .Down
        view.addGestureRecognizer(swipeLeft)
        view.addGestureRecognizer(swipeUp)
        view.addGestureRecognizer(swipeRight)
        view.addGestureRecognizer(swipeDown)
    }
    
    func swipeLeft(gesture: UISwipeGestureRecognizer) {
        doAction("swipeLeft")
    }
    
    func swipeUp(gesture: UISwipeGestureRecognizer) {
        doAction("swipeUp")
    }
    func swipeRight(gesture: UISwipeGestureRecognizer) {
        doAction("swipeRight")
    }
    
    func swipeDown(gesture: UISwipeGestureRecognizer) {
        doAction("swipeDown")
    }
    
    func doAction(name: String) {
        let event = level[gameState.room]["events"][name]
        if (event.description != "null") {
            switch event["action"].stringValue {
                case "pickItem":
                    println("pickItem")
                    break;
                case "gotoRoom":
                    println("goto")
                    break;
            
                default:
                    break;
            
            }
        
        }
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {

    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
