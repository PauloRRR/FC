//
//  StartMenuScene.swift
//  MadnessDaze
//
//  Created by Paulo Ricardo Ramos da Rosa on 9/10/15.
//  Copyright (c) 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//

import SpriteKit
import AVFoundation

class StartMenuScene: SKScene {
    
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
    
    var labels: [SKLabelNode] = []
    
    var selected = 1;
    
    
    var musicPlayer = AVAudioPlayer()
    
    
    override func didMoveToView(view: SKView) {
        
        self.startMenuOptions()
        
        
        #if os(tvOS)
            setupGestureRecognizerTV();
        #endif
        
    }
    
    func startMenuOptions(){
        
        
        let url = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("menuMusic", ofType: "wav")!)
        
        self.musicPlayer = try! AVAudioPlayer(contentsOfURL: url)
        
        self.musicPlayer.prepareToPlay()
        self.musicPlayer.volume = 0.5
        self.musicPlayer.play()
        
        
        GameManager.addSoundArray("menu_PT-BR_01", frmt: "mp3", x: 0.0, y: 0.0)
        
        self.background = SKSpriteNode(imageNamed: "background")
        self.background.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        self.background.size = self.frame.size
        self.background.zPosition = 0
        addChild(self.background)
        
        self.newGame = SKLabelNode(fontNamed: "futura-condensed-normal")
        self.newGame.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2.1)
        self.newGame.text = "INICIAR"
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
        self.loadGame.text = "CONTINUAR"
        self.loadGame.fontSize = 0.1 * self.frame.size.width
        self.loadGame.fontColor = UIColor.whiteColor()
        self.loadGame.zPosition = 1
        addChild(self.loadGame)
    }
    
    func newGameScreen(){
        self.newGame.removeFromParent()
        self.tutorial.removeFromParent()
        self.loadGame.removeFromParent()
        
        
        self.newGameYes = SKLabelNode(fontNamed: "futura-condensed-normal")
        self.newGameYes.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/1.5)
        self.newGameYes.name = "newGameYes"
        self.newGameYes.text = "SIM"
        self.newGameYes.fontSize = 0.1 * self.frame.size.width
        self.newGameYes.fontColor = UIColor.whiteColor()
        self.newGameYes.zPosition = 1
        addChild(self.newGameYes)
        
        self.newGameNo = SKLabelNode(fontNamed: "futura-condensed-normal")
        self.newGameNo.position = CGPoint(x: self.newGameYes.position.x, y: self.newGameYes.position.y/2.5)
        self.newGameNo.name = "newGameNo"
        self.newGameNo.text = "NÃO"
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
