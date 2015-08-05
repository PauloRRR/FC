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
        print(hasEvent("swipeLeft"))
        println("Left")
    }
    
    func swipeUp(gesture: UISwipeGestureRecognizer) {
        print(hasEvent("swipeUp"))
        
        println("Up")
    }
    func swipeRight(gesture: UISwipeGestureRecognizer) {
        print(hasEvent("swipeRight"))
        
        println("Right")
    }
    
    func swipeDown(gesture: UISwipeGestureRecognizer) {
        print(hasEvent("swipeDown"))
        
        println("Down")
    }
    
    func hasEvent(name: String) -> Int {
        if let room = self.room {
            println("hasRoom")
            var array = room["Events"] as! [NSDictionary]
            for index in 0..<array.count {
                var event = array[index] as NSDictionary
                if (event.objectForKey("action") as? String == name) {
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
