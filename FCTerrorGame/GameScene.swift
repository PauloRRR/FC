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
    var manager = GameManager.sharedInstance
    
    var playerHidden = false;
    
    override func didMoveToView(view: SKView) {
        //self.manager.setPlayerPosition(0)
        if let filePath = NSBundle.mainBundle().pathForResource("Level1", ofType: "json") {
            level =  JSON(data: NSData(contentsOfFile: filePath)!)
        } else {
            level = JSON.nullJSON
        }
        
        var swipeLeft    = UISwipeGestureRecognizer(target: self, action: Selector("swipeLeft:"))
        var swipeUp      = UISwipeGestureRecognizer(target: self, action: Selector("swipeUp:"))
        var swipeRight   = UISwipeGestureRecognizer(target: self, action: Selector("swipeRight:"))
        var swipeDown    = UISwipeGestureRecognizer(target: self, action: Selector("swipeDown:"))
        var longPress    = UILongPressGestureRecognizer(target: self, action: Selector("longPress:"))
        
        var alternateTap = UIAlternateTapGestureRecognizer(target: self, action: Selector("alternateTapping:"));
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: Selector("presentGameOver"),
            name: "gameOver",
            object: nil)
        
        swipeLeft.direction  = .Left
        swipeUp.direction    = .Up
        swipeRight.direction = .Right
        swipeDown.direction  = .Down
        longPress.minimumPressDuration = 2.0;
        alternateTap.numberOfTapsRequired = 5;
        alternateTap.delegate = self
        
        view.addGestureRecognizer(alternateTap)
        view.addGestureRecognizer(longPress)
        view.addGestureRecognizer(swipeLeft)
        view.addGestureRecognizer(swipeUp)
        view.addGestureRecognizer(swipeRight)
        view.addGestureRecognizer(swipeDown)
        loadRoom()
        
        
        self.runEnemyBehavior()
        
    }

    // MARK: Enemy Behavior
    
    func runEnemyBehavior(){
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.waitForDuration(2.0),
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
        manager.listenerAngularPosition(Float(gameState.rotation)*(-90.0));
        checkStoryRequisite(level[gameState.room])
        checkDirectionSoundRequisite(level[gameState.room])
        if let levelSounds = level[gameState.room]["playOnEnter"].array {
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
    
    func longPress(gesture: UILongPressGestureRecognizer) {
        if (gesture.state == UIGestureRecognizerState.Began) {
            doAction("longPress")
        } else if (gesture.state == UIGestureRecognizerState.Ended) {
            doAction("longPressEnded")
        }
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
            case "longPress":
                if let hideable = level[gameState.room]["hide"].bool {
                    if (hideable) {
                        gameState.playerHidden = true;
                    }
                }
                break;
            case "longPressEnded":
                gameState.playerHidden = false;
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
                //GameManager.addSoundArray("playerSteps", frmt: "mp3", x: 0.0, y: 0.0)
                break;
            default:
                break;
                
            }
            
        }
    }
    
    func checkDirectionSoundRequisite(action: JSON){
        if let prerequisite = action["crossingWay"].int {
            switch prerequisite{
                case 0:
                    //playSound Front or Right
                    if(gameState.rotation == 0){
                        //sound front right
                        GameManager.addSoundArray("hallway-direita_frente_01", frmt: "mp3", x: 0.0, y: 0.0)
                    }else if (gameState.rotation == 1){
                        //sound front left right
                        GameManager.addSoundArray("hallway-direita_esquerda_frente_01", frmt: "mp3", x: 0.0, y: 0.0)
                    }else if (gameState.rotation == 2){
                        //front left
                        GameManager.addSoundArray("hallway-esquerda_frente_01", frmt: "mp3", x: 0.0, y: 0.0)
                    }else {
                        //left right
                        GameManager.addSoundArray("hallway-direita_esquerda_01", frmt: "mp3", x: 0.0, y: 0.0)
                    }
                    break;
                case 1:
                    //playSound front or Left
                    if(gameState.rotation == 0){
                        //sound front left
                        GameManager.addSoundArray("hallway-esquerda_frente_01", frmt: "mp3", x: 0.0, y: 0.0)
                    }else if (gameState.rotation == 1){
                        //sound left right
                        GameManager.addSoundArray("hallway-direita_esquerda_01", frmt: "mp3", x: 0.0, y: 0.0)
                    }else if (gameState.rotation == 2){
                        //front right
                        GameManager.addSoundArray("hallway-direita_frente_01", frmt: "mp3", x: 0.0, y: 0.0)
                    }else {
                        //left right front
                        GameManager.addSoundArray("hallway-direita_esquerda_frente_01", frmt: "mp3", x: 0.0, y: 0.0)
                    }
                    break;
                case 2:
                    //playSound left or right
                    if(gameState.rotation == 0){
                        //sound right left
                        GameManager.addSoundArray("hallway-direita_esquerda_01", frmt: "mp3", x: 0.0, y: 0.0)
                    }else if (gameState.rotation == 1){
                        //sound front right
                        GameManager.addSoundArray("hallway-direita_frente_01", frmt: "mp3", x: 0.0, y: 0.0)
                    }else if (gameState.rotation == 2){
                        //front right left
                        GameManager.addSoundArray("hallway-direita_esquerda_frente_01", frmt: "mp3", x: 0.0, y: 0.0)
                    }else {
                        //left front
                        GameManager.addSoundArray("hallway-esquerda_frente_01", frmt: "mp3", x: 0.0, y: 0.0)
                    }
                    break;
                case 3:
                    //playSound left right front
                    if(gameState.rotation == 0){
                        //sound right left front
                        GameManager.addSoundArray("hallway-direita_esquerda_frente_01", frmt: "mp3", x: 0.0, y: 0.0)
                    }else if (gameState.rotation == 1){
                        //sound left front
                        GameManager.addSoundArray("hallway-esquerda_frente_01", frmt: "mp3", x: 0.0, y: 0.0)
                    }else if (gameState.rotation == 2){
                        //right left
                        GameManager.addSoundArray("hallway-direita_esquerda_01", frmt: "mp3", x: 0.0, y: 0.0)
                    }else {
                        //right front
                        GameManager.addSoundArray("hallway-direita_frente_01", frmt: "mp3", x: 0.0, y: 0.0)
                    }
                    break;
                case 4:
                    //right only
                    if(gameState.rotation == 0){
                        //sound right
                        GameManager.addSoundArray("hallway-direita_01", frmt: "mp3", x: 0.0, y: 0.0)
                    }else if (gameState.rotation == 1){
                        //sound front right
                        GameManager.addSoundArray("hallway-direita_frente_01", frmt: "mp3", x: 0.0, y: 0.0)
                    }else if (gameState.rotation == 2){
                        //front left
                        GameManager.addSoundArray("hallway-esquerda_frente_01", frmt: "mp3", x: 0.0, y: 0.0)
                    }else {
                        //left
                        GameManager.addSoundArray("hallway-esquerda_01", frmt: "mp3", x: 0.0, y: 0.0)
                    }
                    break;
                case 5:
                    //left only
                    if(gameState.rotation == 0){
                        //sound left
                        GameManager.addSoundArray("hallway-esquerda_01", frmt: "mp3", x: 0.0, y: 0.0)
                    }else if (gameState.rotation == 1){
                        //sound right
                        GameManager.addSoundArray("hallway-direita_01", frmt: "mp3", x: 0.0, y: 0.0)
                    }else if (gameState.rotation == 2){
                        //front front right
                        GameManager.addSoundArray("hallway-direita_frente_01", frmt: "mp3", x: 0.0, y: 0.0)
                    }else {
                        //left front
                        GameManager.addSoundArray("hallway-esquerda_frente_01", frmt: "mp3", x: 0.0, y: 0.0)
                    }
                    break;
                case 6:
                    //right front without back
                    if(gameState.rotation == 0){
                        //sound front right
                        GameManager.addSoundArray("hallway-direita_frente_01", frmt: "mp3", x: 0.0, y: 0.0)
                    }else if (gameState.rotation == 1){
                        //sound left front
                        GameManager.addSoundArray("hallway-esquerda_frente_01", frmt: "mp3", x: 0.0, y: 0.0)
                    }else if (gameState.rotation == 2){
                        //left
                        GameManager.addSoundArray("hallway-esquerda_01", frmt: "mp3", x: 0.0, y: 0.0)
                    }else {
                        //right
                        GameManager.addSoundArray("hallway-direita_01", frmt: "mp3", x: 0.0, y: 0.0)
                    }
                    break;
                default:
                    //front left without back
                    if(gameState.rotation == 0){
                        //sound front left
                        GameManager.addSoundArray("hallway-esquerda_frente_01", frmt: "mp3", x: 0.0, y: 0.0)
                    }else if (gameState.rotation == 1){
                        //sound left
                        GameManager.addSoundArray("hallway-esquerda_01", frmt: "mp3", x: 0.0, y: 0.0)
                    }else if (gameState.rotation == 2){
                        //right
                        GameManager.addSoundArray("hallway-direita_01", frmt: "mp3", x: 0.0, y: 0.0)
                    }else {
                        //front right
                        GameManager.addSoundArray("hallway-direita_frente_01", frmt: "mp3", x: 0.0, y: 0.0)
                    }
                    break;
            }
        }
    }
    
    func checkStoryRequisite (action: JSON) {
        if let prerequisite = action["hasStory"].bool {
            manager.playStorySound()
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
            gameState.room = action["room"].intValue
            self.manager.setPlayerPosition(gameState.room)
            self.manager.updateEnemiesListenerPosition()
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
            println(soundName)
            if let format = action["format"]?.string {
                var x:Float = 0.0;
                var y:Float = 0.0;
                if let offsetX = action["x"]?.float {
                    x = offsetX;
                }
                if let offsetY = action["y"]?.float {
                    y = offsetY;
                }
                var offset:Float = 0.0
                if let newOffset = action["offset"]?.float {
                    offset = newOffset;
                }
                runAction(
                    SKAction.sequence([
                        SKAction.waitForDuration(NSTimeInterval(offset)),
                        SKAction.runBlock({ GameManager.addSoundArray(soundName, frmt: format, x: x, y: y) })
                        ])
                    )
            }
        }

    }
    
    func presentGameOver () {
        var transition = SKTransition.fadeWithDuration(0)
        var scene = GameOverScene(size: self.size)
        if let recognizers = self.view?.gestureRecognizers {
            for recognizer in recognizers {
                self.view?.removeGestureRecognizer(recognizer as! UIGestureRecognizer)
            }
        }
        
        self.view?.presentScene(scene, transition: transition)
    
    }
}
