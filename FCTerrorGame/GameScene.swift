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
        
        loadRoom()
    }

    
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {

    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    // MARK: Level Functions
    
    func loadRoom () {
        background = SKSpriteNode(imageNamed: level[gameState.room]["background"].stringValue)
        background?.position = CGPoint(x: frame.midX, y: frame.midY)
    
        if let bg = background {
            addChild(bg)
        }
        gameState.saveState()
        
    }

    // MARK: Controls

    
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
                pickItem(event)
                break;
            case "gotoRoom":
                goToRoom(event)
                break;
                
            default:
                break;
                
            }
            
        }
    }
    
    func checkPrerequisite (action: JSON) -> Bool {
        if let prerequisite = action["prerequisite"].string {
            var items = gameState.items.filter( {$0 == prerequisite } )
            if (items.count > 0) {
                return true;
            } else {
                return false;
            }
        } else {
            return true;
        }
    }
    
    func checkItem (action: JSON) -> Bool {
        if let item = action["item"].string {
            var items = gameState.items.filter( {$0 == item } )
            if (items.count > 0) {
                return false;
            }
        }
        
        return true;
    }

    
    // MARK: Actions

    func goToRoom (action :JSON) {
        if (checkPrerequisite(action)) {
            gameState.room = action["room"].intValue
            var transition = SKTransition.fadeWithDuration(1)
            var scene = GameScene(size: self.size)
            self.view?.presentScene(scene, transition: transition)
        }
        
    }
    
    func pickItem (action :JSON) {
        if (checkPrerequisite(action) && checkItem(action)) {
            gameState.items.append(action["item"].stringValue)
        }
    
    }
    
    
}
