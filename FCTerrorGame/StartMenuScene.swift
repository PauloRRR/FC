//
//  StartMenuScene.swift
//  MadnessDaze
//
//  Created by Paulo Ricardo Ramos da Rosa on 9/10/15.
//  Copyright (c) 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//

import SpriteKit
import AVFoundation

class StartMenuScene: SKScene, AVAudioPlayerDelegate {
    
    var manager = GameManager.sharedInstance;
    var newGame = SKLabelNode()
    var loadGame = SKLabelNode()
    var tutorial = SKLabelNode()
    var background = SKSpriteNode()
    var newGameYes = SKLabelNode()
    var newGameNo = SKLabelNode()
    var newGameTouch = 0
    var loadGameTouch = 0
    var tutorialTouch = 0
    var yesTouch = 0
    var noTouch = 0
    var dot = SKNode()
    var dot2 = SKNode()
    var dot3 = SKNode()
    var isOnNewGameScreen = false
    var isOnStartMenuOptions = false
    
    var labels: [SKLabelNode] = []
    
    var selected = 1;
    
    
    var musicPlayer = AVAudioPlayer()
    var lastVolume: Float = 0.0;

    let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func didMoveToView(view: SKView) {
        
        if (!NSUserDefaults.standardUserDefaults().boolForKey("FirstPlay")){
            self.startScreen()
        } else {
            finishedTutorial();
        
        }

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("mute"), name: "muteSound", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("normalVolume"), name: "resumeSound", object: nil)
        
        
        
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    func mute() {
        lastVolume = musicPlayer.volume;
        musicPlayer.volume = 0.0;
    }
    
    func normalVolume() {
        musicPlayer.volume = lastVolume;
    }
    
    
    func startScreen(){
        
        
        self.background = SKSpriteNode(imageNamed: "splashScreen")
        self.background.position = CGPoint(x: frame.midX, y: frame.midY)
        self.background.size = self.frame.size
        self.background.zPosition = 0
        
        addChild(self.background)
        
        let url = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("\(manager.language)-tutorialFull", ofType: "mp3")!)
        
        self.musicPlayer = try! AVAudioPlayer(contentsOfURL: url)
        
        self.musicPlayer.prepareToPlay()
        self.musicPlayer.volume = 1
        self.musicPlayer.play()
        self.musicPlayer.delegate = self
        
    }
    
    
    func finishedTutorial () {
        #if os(iOS)
            appDelegate.registerNotification()
        #endif
        self.background.removeFromParent()
        NSUserDefaults.standardUserDefaults().setBool(true , forKey: "FirstPlay")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        self.startMenuOptions()
        
        
        #if os(tvOS)
            setupGestureRecognizerTV();
        #endif
    
    
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if (!NSUserDefaults.standardUserDefaults().boolForKey("FirstPlay")){
            finishedTutorial();
        }
        
    }
    
    func startMenuOptions(){
        self.isOnStartMenuOptions = true
        self.isOnNewGameScreen = false
        self.dot3.removeFromParent()
        
        dot.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2.5)
        dot.zPosition = 3
        self.addChild(dot)
        dot2.position = CGPointMake(self.frame.size.width/2, dot.position.y * 1.75)
        dot2.zPosition = 3
        self.addChild(dot2)
        
        let url = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("menuMusic", ofType: "mp3")!)
        
        self.musicPlayer = try! AVAudioPlayer(contentsOfURL: url)
        
        self.musicPlayer.prepareToPlay()
        self.musicPlayer.volume = 0.5
        self.musicPlayer.numberOfLoops = -1
        self.musicPlayer.play()
        
        if(UIAccessibilityIsVoiceOverRunning()){
            GameManager.addSoundArray("LANG-menu", frmt: "mp3", x: 0.0, y: 0.0)
        }
        self.background = SKSpriteNode(imageNamed: "background")
        self.background.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        self.background.size = self.frame.size
        self.background.zPosition = 0
        addChild(self.background)
        
        self.newGame = SKLabelNode(fontNamed: "futura-condensed-normal")
        self.newGame.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2.1)
        
        if(manager.language == "pt-BR"){
            self.newGame.text = "INICIAR"
        }else{
            self.newGame.text = "START"
        }
    
    
        self.newGame.name = "newGame"
        self.newGame.fontSize = 0.1 * self.frame.size.width
        self.newGame.fontColor = UIColor.whiteColor()
        self.newGame.zPosition = 1
        addChild(self.newGame)
        
        self.tutorial = SKLabelNode(fontNamed: "futura-condensed-normal")
        self.tutorial.position = CGPoint(x: self.newGame.position.x, y: self.newGame.position.y/2.6)
        self.tutorial.name = "tutorial"
        self.tutorial.text = "TUTORIAL"
        self.tutorial.fontSize = 0.1 * self.frame.size.width
        self.tutorial.fontColor = UIColor.whiteColor()
        self.tutorial.zPosition = 1
        addChild(self.tutorial)
        
        self.loadGame = SKLabelNode(fontNamed: "futura-condensed-normal")
        self.loadGame.position = CGPoint(x: self.newGame.position.x, y: self.newGame.position.y * 1.6)
        self.loadGame.name = "loadGame"
        if(manager.language == "pt-BR"){
             self.loadGame.text = "CONTINUAR"
        }else{
             self.loadGame.text = "CONTINUE"
        }
       
        self.loadGame.fontSize = 0.1 * self.frame.size.width
        self.loadGame.fontColor = UIColor.whiteColor()
        self.loadGame.zPosition = 1
        addChild(self.loadGame)
        
    }
    
    func newGameScreen(){
        self.newGame.removeFromParent()
        self.tutorial.removeFromParent()
        self.loadGame.removeFromParent()
        self.dot.removeFromParent()
        self.dot2.removeFromParent()
        self.isOnNewGameScreen = true
        self.isOnStartMenuOptions = false
        
        dot3.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        dot3.zPosition = 3
        self.addChild(dot3)
        
        
        self.newGameYes = SKLabelNode(fontNamed: "futura-condensed-normal")
        self.newGameYes.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/1.5)
        self.newGameYes.name = "newGameYes"
        if(manager.language == "pt-BR"){
            self.newGameYes.text = "SIM"
        }else{
            self.newGameYes.text = "YES"
        }
        
        
        self.newGameYes.fontSize = 0.1 * self.frame.size.width
        self.newGameYes.fontColor = UIColor.whiteColor()
        self.newGameYes.zPosition = 1
        addChild(self.newGameYes)
        
        self.newGameNo = SKLabelNode(fontNamed: "futura-condensed-normal")
        self.newGameNo.position = CGPoint(x: self.newGameYes.position.x, y: self.newGameYes.position.y/2.5)
        self.newGameNo.name = "newGameNo"
        if(manager.language == "pt-BR"){
            self.newGameNo.text = "NÃO"
        }else{
            self.newGameNo.text = "NO"
        }
        
        self.newGameNo.fontSize = 0.1 * self.frame.size.width
        self.newGameNo.fontColor = UIColor.whiteColor()
        self.newGameNo.zPosition = 1
        addChild(self.newGameNo)
    }
    
    
    func start () {
        
        self.musicPlayer.stop()
        
        _ = NSTimeInterval()
        let transition = SKTransition.fadeWithDuration(5.0)
        let scene = GameScene(size: self.size)
        let state = GameState()
        state.room = 0
        state.rotation = 1
        self.manager.playerPosition = 0

        
        if let recognizers = self.view?.gestureRecognizers {
            for recognizer in recognizers {
                self.view?.removeGestureRecognizer(recognizer)
            }
        }
        
        
        self.view?.presentScene(scene, transition: transition)
        
        
    }
    
    func restartGame(){
        self.musicPlayer.stop()
        
        let transition = SKTransition.fadeWithDuration(5.0)
        let scene = GameScene(size: self.size)
        let state = GameState()
        state.room = 0
        state.rotation = 1
        self.manager.playerPosition = 0
        
        
       self.manager.initStoryArray()
        if let recognizers = self.view?.gestureRecognizers {
            for recognizer in recognizers {
                self.view?.removeGestureRecognizer(recognizer)
            }
        }
        
        
        self.view?.presentScene(scene, transition: transition)
    }
    
    
    
    func continueGame(){
        let transition = SKTransition.fadeWithDuration(0)
        self.musicPlayer.stop()
        
        let scene = GameScene(size: self.size)
        
        
        self.manager.gameState.room = 0
        self.manager.playerPosition = 0
        self.manager.gameState.rotation = 1

        if let recognizers = self.view?.gestureRecognizers {
            for recognizer in recognizers {
                self.view?.removeGestureRecognizer(recognizer)
            }
        }
        
        self.view?.presentScene(scene, transition: transition)

    }

    
    
    
}
