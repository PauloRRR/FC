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
    var level: NSDictionary?
    var room: NSDictionary?
    
    override func didMoveToView(view: SKView) {
        var filePath = NSBundle.mainBundle().pathForResource("Level1",
            ofType: "plist")
        level = NSDictionary(contentsOfFile: filePath!)
        room = NSDictionary(dictionary: (level!["Rooms"] as! NSArray)[gameState.room]
            as! [NSObject : AnyObject])
        
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
        var event = fetchEvent("swipeLeft")
        if (event >= 0) {
            println("Left")

        
        }
    }
    
    func swipeUp(gesture: UISwipeGestureRecognizer) {
        var event = fetchEvent("swipeUp")
        if (event >= 0) {
            println("Up")
            
            
        }
    }
    func swipeRight(gesture: UISwipeGestureRecognizer) {
        var event = fetchEvent("swipeRight")
        if (event >= 0) {
            println("Right")
            
            
        }
    }
    
    func swipeDown(gesture: UISwipeGestureRecognizer) {
        var event = fetchEvent("swipeDown")
        if (event >= 0) {
            println("Down")
            
        }
    }
    
    func fetchEvent(name: String) -> Int {
        if let room = self.room {
            var array = room["Events"] as! [NSDictionary]
            for index in 0..<array.count {
                var event = array[index] as NSDictionary
                if (event.objectForKey("trigger") as? String == name) {
                    return index;
                }
            }
        
        }

    
        return -1;
    }
    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {

    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
