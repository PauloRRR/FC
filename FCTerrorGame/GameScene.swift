//
//  GameScene.swift
//  FCTeste
//
//  Created by Adriano Soares on 04/08/15.
//  Copyright (c) 2015 bepid. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, UIGestureRecognizerDelegate, UIAlternateTapGestureRecognizerDelegate {
    var gameState = GameState.sharedInstance;
    var level: JSON!
    var background: SKSpriteNode?
    var enemyControl = EnemyControl()
    
    override func didMoveToView(view: SKView) {
        if let filePath = NSBundle.mainBundle().pathForResource("Level1", ofType: "json") {
            level =  JSON(data: NSData(contentsOfFile: filePath)!)
        } else {
            level = JSON.nullJSON
        }
        
        var swipeLeft    = UISwipeGestureRecognizer(target: self, action: Selector("swipeLeft:"))
        var swipeUp      = UISwipeGestureRecognizer(target: self, action: Selector("swipeUp:"))
        var swipeRight   = UISwipeGestureRecognizer(target: self, action: Selector("swipeRight:"))
        var swipeDown    = UISwipeGestureRecognizer(target: self, action: Selector("swipeDown:"))
        var alternateTap = UIAlternateTapGestureRecognizer(target: self, action: Selector("alternateTapping:"));
        
        swipeLeft.direction  = .Left
        swipeUp.direction    = .Up
        swipeRight.direction = .Right
        swipeDown.direction  = .Down
        alternateTap.numberOfTapsRequired = 5;
        alternateTap.delegate = self
        view.addGestureRecognizer(alternateTap)
        view.addGestureRecognizer(swipeLeft)
        view.addGestureRecognizer(swipeUp)
        view.addGestureRecognizer(swipeRight)
        view.addGestureRecognizer(swipeDown)
        loadRoom()
        Singleton.playBGSound("asylum", frmt: "mp3")
        
        self.runEnemyBehavior()
        
        
    }

    // MARK: Enemy Behavior
    
    func runEnemyBehavior(){
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.waitForDuration(5.0),
                SKAction.runBlock({
                    self.enemyControl.updateEnemiesPosition()
                })
                ])
            ))
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
        if let levelSounds = level[gameState.room]["playOnEnter"].array {
            println("locked")
            playSoundArray(levelSounds)
        }

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
    
    func didTap(gesture: UIAlternateTapGestureRecognizer) {
        doAction("tap")
    }
    
    func alternateTapping(gesture: UITapGestureRecognizer) {
        doAction("alternateTap");
    
    }
    
    func doAction(name: String) {
        var newAction = name;
        switch name {
            case "swipeLeft":
                newAction = gameState.actions[(0+gameState.rotation)%4]
                break;
            case "swipeUp":
                newAction = gameState.actions[(1+gameState.rotation)%4]
                break;
            case "swipeRight":
                newAction = gameState.actions[(2+gameState.rotation)%4]
                break;
            case "swipeDown":
                newAction = gameState.actions[(3+gameState.rotation)%4]
                break;
            default:
                break;
        }
        let event = level[gameState.room]["events"][newAction]
        if (event.description != "null") {
            switch event["action"].stringValue {
            case "pickItem":
                pickItem(event)
                break;
            case "gotoRoom":
                goToRoom(event, swipeDirection: newAction)
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
                if let failPrerequisite = action["failPrerequisite"].array {
                    println("locked")
                    playSoundArray(failPrerequisite)
                }
                
                
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
                if let hasItem = action["hasItem"].array {
                    println("hasItem")
                    playSoundArray(hasItem)
                }
                return false;
            }
        }
        
        return true;
    }

    
    // MARK: Actions

    func goToRoom (action :JSON, swipeDirection: String) {
        if (checkPrerequisite(action)) {
            
            
            println("🍺 state was \(gameState.rotation)")
            switch swipeDirection {
            case "swipeRight":
                gameState.rotation = 1;
                break;
            case "swipeUp":
                gameState.rotation = 0;
                break;
            case "swipeLeft":
                gameState.rotation = 3;
                break;
            case "swipeDown":
                gameState.rotation = 2;
                break;
            default:
                break;
            }
            println("🍺 state now is \(gameState.rotation)")
            gameState.room = action["room"].intValue
            gameState.updateState()
            var transition = SKTransition.fadeWithDuration(0)
            var scene = GameScene(size: self.size)
            if let recognizers = self.view?.gestureRecognizers {
                for recognizer in recognizers {
                    self.view?.removeGestureRecognizer(recognizer as! UIGestureRecognizer)
                }
            }
            
            self.view?.presentScene(scene, transition: transition)
           

        }
        
    }
    
    func pickItem (action :JSON) {
        if (checkPrerequisite(action) && checkItem(action)) {
            gameState.items.append(action["item"].stringValue)
            gameState.updateState()
            
        }
    
    }
    
    func playSoundArray (action : [JSON]) {
        for sound: JSON in action {
            playSound(sound.dictionaryValue)
        }
    }
    
    func playSound (action: [String: JSON]) {
        if let soundName = action["sound"]?.string {
            if let format = action["format"]?.string{
                var x = action["x"]?.float
                var y = action["y"]?.float
                var offset = action["offset"]?.float
                runAction(
                    SKAction.sequence([
                        //SKAction.waitForDuration(NSTimeInterval(offset!)),
                        SKAction.runBlock({ Singleton.addSoundArray(soundName, frmt: format, x: x!, y: y!) })
                        ])
                    )
            }
        }

    }
}
