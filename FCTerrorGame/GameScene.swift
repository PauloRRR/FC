//
//  GameScene.swift
//  FCTeste
//
//  Created by Adriano Soares on 04/08/15.
//  Copyright (c) 2015 bepid. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene, UIGestureRecognizerDelegate, UIAlternateTapGestureRecognizerDelegate, AVAudioPlayerDelegate {
    var gameState = GameState.sharedInstance;
    var level: JSON!
    var background: SKSpriteNode?
    var overlay: SKSpriteNode?
    var musicPlayer = AVAudioPlayer()
    var enemyControl = EnemyControl()
    var manager = GameManager.sharedInstance
    var playerHidden = false;
    var hasGun = false
    var soundWarning = SKSpriteNode(imageNamed:"soundWarning")
    let soundWarningAction = SKAction.sequence([SKAction.fadeInWithDuration(1.0),SKAction.fadeOutWithDuration(0)])
    var soundWarningAnimation = false
    override func didMoveToView(view: SKView) {
        scene!.scaleMode = SKSceneScaleMode.AspectFit
         self.backgroundColor = (UIColor.blackColor())
        //self.manager.setPlayerPosition(0)
        manager.firstPlay = false
        if let filePath = NSBundle.mainBundle().pathForResource("Level1", ofType: "json") {
            level =  JSON(data: NSData(contentsOfFile: filePath)!)
        } else {
            level = JSON.nullJSON
        }
        let swipeLeft    = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipeLeft(_:)))
        let swipeUp      = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipeUp(_:)))
        let swipeRight   = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipeRight(_:)))
        let swipeDown    = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.swipeDown(_:)))
        let longPress    = UILongPressGestureRecognizer(target: self, action: #selector(GameScene.longPress(_:)))
        
        #if os(tvOS)
            setupGestureRecognizerTV();
        #endif
        
        let tapGesture = UITapGestureRecognizer(target: self, action:
            #selector(GameScene.tapping(_:)))
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: #selector(GameScene.presentGameOver),
            name: "gameOver",
            object: nil)
        
        //GameManager.clearRoomSoundArray(); // Room sounds now stop playing on change room
       
        soundWarning.size = CGSize(width: soundWarning.size.width * 0.5, height: soundWarning.size.height * 0.5)
        soundWarning.position = CGPoint(x: self.frame.width * 0.9, y: self.frame.height * 0.9)
        soundWarning.zPosition = 2.0
        soundWarning.alpha = 0;
        
        self.addChild(soundWarning)
        swipeLeft.direction  = .Left
        swipeUp.direction    = .Up
        swipeRight.direction = .Right
        swipeDown.direction  = .Down
        longPress.minimumPressDuration = 0.15;
        tapGesture.delegate = self
        
        view.addGestureRecognizer(longPress)
        view.addGestureRecognizer(swipeLeft)
        view.addGestureRecognizer(swipeUp)
        view.addGestureRecognizer(swipeRight)
        view.addGestureRecognizer(swipeDown)
        view.addGestureRecognizer(tapGesture)
        loadRoom()
        
        manager.playBGSound("storm", frmt: "mp3")
        
        self.runEnemyBehavior()
        
    }

    // MARK: Enemy Behavior
    
    func runEnemyBehavior(){
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.waitForDuration(2.0),
                SKAction.runBlock({
                    if (!self.manager.storyP[self.level[self.gameState.room]["storyNumber"].intValue].storyPlayer.playing){
                        self.enemyControl.updateEnemiesPosition()
                        self.enemyControl.playEnemiesPosition()
                        self.manager.updateEnemiesListenerPosition()
                        self.stopSoundWarning()
                    }else{
                        self.enemyControl.stopEnemiesPosition()
                        self.soundWarning.runAction(SKAction.repeatActionForever(self.soundWarningAction))
                        self.soundWarningAnimation = true

                    }
                })
                ])
            ))
    }
    func stopSoundWarning(){
        if soundWarningAnimation == true{
            soundWarning.removeAllActions()
            soundWarning.alpha = 0
            soundWarningAnimation = false
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    // MARK: Level Functions
    
    func loadRoom () {
        manager.stopStorySound(); //StorySound now stop playing on change room
        background?.texture = nil;
        background?.removeFromParent();
        var tex = SKTexture(imageNamed: level[gameState.room]["background"].stringValue + "-" + gameState.rotation.description)
        print(tex.description);

        if (tex.size().width != 128) {
            background = SKSpriteNode(texture: tex);
            background?.position = CGPoint(x: frame.midX, y: frame.midY)
            addChild(background!)
        } else {
            tex = SKTexture(imageNamed: level[gameState.room]["background"].stringValue)
            if (tex.size().width != 128) {
                background = SKSpriteNode(texture: tex);
                background?.position = CGPoint(x: frame.midX, y: frame.midY)
                addChild(background!)
            } else {
                background = SKSpriteNode(imageNamed: "asylumRoom2")
                background?.position = CGPoint(x: frame.midX, y: frame.midY)
                addChild(background!)
            }
            
        }
        
        #if os(iOS)
            //GameAnalytics.addDesignEventWithEventId("Progression:Enter:" + gameState.level.description + ":" + gameState.room.description);
        #endif
        
        /*
        GameAnalytics.addProgressionEventWithProgressionStatus(GAProgressionStatusStart,
            progression01: gameState.level.description,
            progression02: gameState.room.description, progression03: "")
        */
        
        gameState.saveState()
        manager.listenerAngularPosition(Float(gameState.rotation)*(90.0));
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
    }
    
    func longPress(gesture: UILongPressGestureRecognizer) {
        if (gesture.state == UIGestureRecognizerState.Began) {
            doAction("longPress")
        } else if (gesture.state == UIGestureRecognizerState.Ended) {
            doAction("longPressEnded")
        }
    }
    
    
    func tapping(gesture: UITapGestureRecognizer){
        doAction("tap")
        print("tap")
    }
    
    
    
    func doAction(name: String) {
        var newAction = name;
        _ = 0
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
            case "tap":
                if(hasGun){
                    manager.gunshot()
                }
                break;

            case "longPress":
                if let hideable = level[gameState.room]["hide"].bool {
                    if (hideable) {
                        NSNotificationCenter.defaultCenter().postNotificationName("muffle", object: self)
                        gameState.playerHidden = true;
                    }
                }
                break;
            case "longPressEnded":
                NSNotificationCenter.defaultCenter().postNotificationName("unmuffle", object: self)
                gameState.playerHidden = false;
                break;
            default:
                break;
        }
        //&& !manager.storyP[manager.i-1].storyPlayer.playing == no swipe until speech is over
        let event = level[gameState.room]["events"][newAction]
        if ((event.description != "null" &&  !manager.storyP[self.level[self.gameState.room]["storyNumber"].intValue].storyPlayer.playing) && !gameState.debug) {
            switch event["action"].stringValue {
            case "pickItem":
                pickItem(event)
                break;
            case "gotoRoom":
                goToRoom(event, swipeDirection: newAction)
                GameManager.addSoundArray("playerSteps2", frmt: "mp3", x: 0.0, y: 0.0)
                break;
            default:
                break;
                
            }
            
        }
    }
    
    func checkDirectionSoundRequisite(action: JSON){
        if let prerequisite = action["crossingWay"].int {
            var soundName = "";
            switch prerequisite {
                case 0:
                    //playSound Front or Right
                    if(gameState.rotation == 0){
                        //sound front right
                        soundName = "LANG-hallway-direita_frente_01"
                    } else if (gameState.rotation == 1){
                        //sound front left right
                        soundName = "LANG-hallway-direita_esquerda_frente_01"
                    } else if (gameState.rotation == 2){
                        //front left
                         soundName = "LANG-hallway-esquerda_frente_01"
                    } else {
                        //left right
                         soundName = "LANG-hallway-direita_esquerda_01"
                    }
                    if(gameState.rotation == 2 && gameState.room == 87){
                        soundName = "LANG-narrativa-salaRecreacaoEsquerda"
                    }else if(gameState.rotation == 0 && gameState.room == 87){
                        soundName = "LANG-narrativa-salaRecreacaoDireita"
                    }
                    break;
                case 1:
                    //playSound front or Left
                    if(gameState.rotation == 0){
                        //sound front left
                         soundName = "LANG-hallway-esquerda_frente_01"
                    } else if (gameState.rotation == 1){
                        //sound left right
                         soundName = "LANG-hallway-direita_esquerda_01"
                    } else if (gameState.rotation == 2){
                        //front right
                         soundName = "LANG-hallway-direita_frente_01"
                    } else {
                        //left right front
                         soundName = "LANG-hallway-direita_esquerda_frente_01"
                    }
                    if(gameState.rotation == 0 && gameState.room == 51){
                        soundName = "LANG-narrativa-salaRecreacaoEsquerda"
                    }else if(gameState.rotation == 2 && gameState.room == 51){
                            soundName = "LANG-narrativa-salaRecreacaoDireita"
                        }else if (gameState.rotation == 0 && gameState.room == 134){
                                soundName = "LANG-narrativa-escritorioAdmEsquerda"
                            }else if (gameState.rotation == 2 && gameState.room == 134){
                                    soundName = "LANG-narrativa-escritorioAdmDireita"
                                }
                    break;
                case 2:
                    //playSound left or right
                    if(gameState.rotation == 0){
                        //sound right left
                         soundName = "LANG-hallway-direita_esquerda_01"
                    }else if (gameState.rotation == 1){
                        //sound front right
                         soundName = "LANG-hallway-direita_frente_01"
                    }else if (gameState.rotation == 2){
                        //front right left
                         soundName = "LANG-hallway-direita_esquerda_frente_01"
                    }else {
                        //left front
                         soundName = "LANG-hallway-esquerda_frente_01"
                    }
                    break;
                case 3:
                    //playSound left right front
                    if(gameState.rotation == 0){
                        //sound right left front
                         soundName = "LANG-hallway-direita_esquerda_frente_01"
                    }else if (gameState.rotation == 1){
                        //sound left front
                         soundName = "LANG-hallway-esquerda_frente_01"
                    }else if (gameState.rotation == 2){
                        //right left
                         soundName = "LANG-hallway-direita_esquerda_01"
                    }else {
                        //right front
                         soundName = "LANG-hallway-direita_frente_01"
                    }
                    if(gameState.rotation == 1 && gameState.room == 38){
                        soundName = "LANG-narrativa-salaPertencesEsquerda"
                    }else if(gameState.rotation == 3 && gameState.room == 38){
                        soundName = "LANG-narrativa-salaPertencesDireita"
                    }
                    break;
                case 4:
                    //right only
                    if(gameState.rotation == 0){
                        //sound right
                         soundName = "LANG-hallway-direita_01"
                    }else if (gameState.rotation == 1){
                        //sound front right
                         soundName = "LANG-hallway-direita_frente_01"
                    }else if (gameState.rotation == 2){
                        //front left
                         soundName = "LANG-hallway-esquerda_frente_01"
                    }else {
                        //left
                         soundName = "LANG-hallway-esquerda_01"
                    }
                    break;
                case 5:
                    //left only
                    if(gameState.rotation == 0){
                        //sound left
                         soundName = "LANG-hallway-esquerda_01"
                    }else if (gameState.rotation == 1){
                        //sound right
                        soundName = "LANG-hallway-direita_01"
                    }else if (gameState.rotation == 2){
                        //front front right
                         soundName = "LANG-hallway-direita_frente_01"
                    }else {
                        //left front
                         soundName = "LANG-hallway-esquerda_frente_01"
                    }
                    if(gameState.rotation == 1 && gameState.room == 154){
                        soundName = "LANG-narrativa-salaEnfermariaDireita"
                    }
                    break;
                case 6:
                    //right front without back
                    if(gameState.rotation == 0){
                        //sound front right
                         soundName = "LANG-hallway-direita_frente_01"
                    }else if (gameState.rotation == 1){
                        //sound left front
                         soundName = "LANG-hallway-esquerda_frente_01"
                    }else if (gameState.rotation == 2){
                        //left
                         soundName = "LANG-hallway-esquerda_01"
                    }else {
                        //right
                         soundName = "LANG-hallway-direita_01"
                    }
                    if(gameState.rotation == 2 && gameState.room == 91){
                        soundName = "LANG-narrativa-banheiroMasculinoEsquerda"
                    }
                    
                    break;
                case 7:
                    //front left without back
                    if(gameState.rotation == 0){
                        //sound front left
                         soundName = "LANG-hallway-esquerda_frente_01"
                    }else if (gameState.rotation == 1){
                        //sound left
                         soundName = "LANG-hallway-esquerda_01"
                    }else if (gameState.rotation == 2){
                        //right
                         soundName = "LANG-hallway-direita_01"
                    }else {
                        //front right
                         soundName = "LANG-hallway-direita_frente_01"
                    }
                    if(gameState.rotation == 2 && gameState.room == 55){
                        soundName = "LANG-narrativa-banheiroFemininoDireita"
                    }
                    break;
                case 8:
                        soundName = "LANG-hallway-direita_esquerda_frente_01"
                break;
                default:
                    break;
            }
//            print("\(soundName)")
//            let soundPlay = BackGroundSoundNode(soundName: soundName, format: "mp3")
//            soundPlay.play()
            manager.playDirectionNarration(soundName, frmt: "mp3")
            //GameManager.addRoomSoundArray(soundName, frmt: "mp3", x: 0.0, y: 0.0)
        }
    }
    
    func checkStoryRequisite (action: JSON) {
        if let _ = action["hasStory"].bool {
            if (!manager.storyP[action["storyNumber"].intValue].played){
                manager.playStorySound(action["storyNumber"].intValue)
            }
        }
    }
    
    func checkPrerequisite (action: JSON) -> Bool {
        if let prerequisite = action["prerequisite"].string {
            let items = gameState.items.filter( {$0 == prerequisite } )
            if (items.count > 0) {
                return true;
            } else {
                if let failPrerequisite = action["failPrerequisite"].array {
                    print("locked")
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
            let items = gameState.items.filter( {$0 == item } )
            if (items.count > 0) {
                if let hasItem = action["hasItem"].array {
                    print("hasItem")
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
            
            #if os(iOS)
                //GameAnalytics.addProgressionEventWithProgressionStatus(GAProgressionStatusComplete,
                    //progression01: gameState.level.description,
                    //progression02: gameState.room.description, progression03: "")
            #endif

            
            gameState.room = action["room"].intValue
            print("\(gameState.room)")
            if(gameState.room == 1 && gameState.debug){
                gameState.items.append("watchedLockersRoom")
                gameState.items.append("tombKey")
                gameState.items.append("foundGuard")
                gameState.items.append("allItems")
                gameState.items.append("lockerKey")
                gameState.items.append("needle")
            }
            if (gameState.room == 39 && !manager.watched39){
                gameState.items.append("watchedLockersRoom")
                manager.watched39 = true
                gameState.updateState()
            }
            if (gameState.room == 128 && !manager.watched128){
                gameState.items.append("foundGuard")
                manager.watched128 = true
                gameState.updateState()
            }
            if (gameState.room == 129){
                if (gameState.items.count >= 5){
                    gameState.items.append("allItems")
                    gameState.updateState()
                }
            }
            self.manager.setPlayerPosition(gameState.room)
            self.manager.updateEnemiesListenerPosition()
            gameState.updateState()
            
            if (gameState.room == 174){
                manager.watched174 = true
                let url = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("\(manager.language)-chegadaSalaFinal", ofType: "mp3")!)
                
                self.musicPlayer = try! AVAudioPlayer(contentsOfURL: url)
                
                self.musicPlayer.prepareToPlay()
                self.musicPlayer.volume = 1
                self.musicPlayer.play()
                self.musicPlayer.delegate = self
            }
            /*
            let transition = SKTransition.fadeWithDuration(0)
            let scene = GameScene(size: self.size)
            if let recognizers = self.view?.gestureRecognizers {
                for recognizer in recognizers {
                    self.view?.removeGestureRecognizer(recognizer)
                }
            }
            
            self.view?.presentScene(scene, transition: transition)
            */
            loadRoom()
        }
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if (manager.watched174){
            manager.gameState.eraseJson()
            manager.eraseManager()
            self.manager.initStoryArray()
            self.manager.firstPlay = true
            let transition = SKTransition.fadeWithDuration(0)
            let scene = StartMenuScene(size: self.size)

            gameState.room = 0
            gameState.rotation = 1
            self.manager.playerPosition = 0
            
            
            if let recognizers = self.view?.gestureRecognizers {
                for recognizer in recognizers {
                    self.view?.removeGestureRecognizer(recognizer)
                }
            }
            
            
            self.view?.presentScene(scene, transition: transition)
        }
        
    }
    
    func pickItem (action :JSON) {
        var soundName = ""
        if (checkPrerequisite(action) && checkItem(action)) {
            gameState.items.append(action["item"].stringValue)
            #if os(iOS)
                //GameAnalytics.addDesignEventWithEventId("Progression:Item:" + gameState.level.description + ":" + action["item"].stringValue);
            #endif
            gameState.updateState()
            if(action["item"].stringValue == "lockerKey"){
                soundName = "LANG-narrativa_encontreiChave_escritorioAdm"
            }else if(action["item"].stringValue == "needle"){
                    soundName = "LANG-narrativa_sonifero_enfermaria"
                }else if (action["item"].stringValue == "tombKey"){
                        soundName = "LANG-encontreiChaveBilhete"
                    }
            
            manager.playDirectionNarration(soundName, frmt: "mp3")
            
        }
    
    }
    
    
    func playSoundArray (action : [JSON]) {
        for sound: JSON in action {
            playSound(sound.dictionaryValue)
        }
    }
    
    func playSound (action: [String: JSON]) {
        if let soundName = action["sound"]?.string {
            print(soundName)
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
        #if os(iOS)
            //GameAnalytics.addDesignEventWithEventId("Progression:Death:" + gameState.level.description + ":" + gameState.room.description);
        #endif
        
        /*
        GameAnalytics.addProgressionEventWithProgressionStatus(GAProgressionStatusFail,
            progression01: gameState.level.description,
            progression02: gameState.room.description, progression03: "")
        */
        
        self.enemyControl.gameOver()
        self.manager.stopBGSound()
        let transition = SKTransition.fadeWithDuration(0)
        let scene = GameOverScene(size: self.size)
        if let recognizers = self.view?.gestureRecognizers {
            for recognizer in recognizers {
                self.view?.removeGestureRecognizer(recognizer )
            }
        }
        
        self.view?.presentScene(scene, transition: transition)
    
    }
}
