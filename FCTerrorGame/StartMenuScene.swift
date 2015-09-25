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
    
    var musicPlayer = AVAudioPlayer()
    
    
    override func didMoveToView(view: SKView) {
        
        self.startMenuOptions()
        
    }
    
    func startMenuOptions(){
        
        //manager.playBGSound("menuMusic", frmt: "wav")
        
        let url = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("menuMusic", ofType: "wav")!)
        
        self.musicPlayer = try! AVAudioPlayer(contentsOfURL: url)
        
        self.musicPlayer.prepareToPlay()
        self.musicPlayer.volume = 0.5
        self.musicPlayer.play()
        
        //self.runAction(SKAction.playSoundFileNamed("menuMusic", waitForCompletion: false))
        
        GameManager.addSoundArray("menu_PT-BR_01", frmt: "mp3", x: 0.0, y: 0.0)
        
        self.background = SKSpriteNode(imageNamed: "background")
        self.background.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        self.background.size = self.frame.size
        self.background.zPosition = 0
        //        self.background.xScale -= 0.5
        //        self.background.yScale -= 0.65
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
    
    func continueGame(){
        let transition = SKTransition.fadeWithDuration(0)
        self.musicPlayer.stop()
        
        let scene = GameScene(size: self.size)
        
        if let recognizers = self.view?.gestureRecognizers {
            for recognizer in recognizers {
                self.view?.removeGestureRecognizer(recognizer )
            }
        }
        
        self.view?.presentScene(scene, transition: transition)

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches 
        let location = touch.first!.locationInNode(self)
        let node = self.nodeAtPoint(location)
        
        
        
        if (node.name == "newGame"){
                newGameTouch++
                loadGameTouch = 0
                tutorialTouch = 0
                GameManager.addSoundArray("iniciar_PT-BR_01", frmt: "mp3", x: 0.0, y: 0.0)
                print("NEWGAME")
            
            }else if (node.name == "tutorial"){
                print("TUTORIAL")
                tutorialTouch++
                newGameTouch = 0
                loadGameTouch = 0
                GameManager.addSoundArray("tutorial_PT-BR_01", frmt: "mp3", x: 0.0, y: 0.0)
                }else if (node.name == "loadGame"){
                    loadGameTouch++
                    newGameTouch = 0
                    tutorialTouch = 0
                    print("LOADGAME")
                    GameManager.addSoundArray("continuar_PT-BR_01", frmt: "mp3", x: 0.0, y: 0.0)
                }
        
        if (node.name == "newGame" && newGameTouch > 1 && !manager.firstPlay){
            GameManager.addSoundArray("novoJogoConfirma_PT-BR_01", frmt: "mp3", x: 0.0, y: 0.0)
            self.newGameScreen()
        } else if (node.name == "newGame" && newGameTouch > 1 && manager.firstPlay){
            self.start()
        }
            
            
        if (node.name == "tutorial" && tutorialTouch > 1){
            print("PLAY TUTORIAL")
            GameManager.addSoundArray("tutorialFull_PT-BR_01", frmt: "mp3", x: 0.0, y: 0.0)
            self.tutorialTouch = 0
            self.newGameTouch = 0
            self.loadGameTouch = 0
        }
        
        if (node.name == "loadGame" && loadGameTouch > 1 && !manager.firstPlay){
            print("NOW LOADING GAME")
            continueGame()
        }
        
        if (node.name == "newGameNo"){
            noTouch++
            yesTouch = 0
            print("NO")
            GameManager.addSoundArray("nao_PT-BR_01", frmt: "mp3", x: 0.0, y: 0.0)
        }else if (node.name == "newGameYes"){
            yesTouch++
            noTouch = 0
            print("YES")
            GameManager.addSoundArray("sim_PT-BR_01", frmt: "mp3", x: 0.0, y: 0.0)
        }
        
        
        
        if (node.name == "newGameNo" && noTouch > 1){
            self.newGameNo.removeFromParent()
            self.newGameYes.removeFromParent()
            newGameTouch = 0
            loadGameTouch = 0
            tutorialTouch = 0
            noTouch = 0
            yesTouch = 0
            self.startMenuOptions()
        }else if (node.name == "newGameYes" && yesTouch > 1){
                manager.gameState.eraseJson()
                manager.playerPosition = 0
                manager.i = 0
                self.start()
            }
        }
    
    
    
}
