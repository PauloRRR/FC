//
//  GameOverScene.swift
//  MadnessDaze
//
//  Created by Adriano Soares on 03/09/15.
//  Copyright (c) 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//

import SpriteKit



class GameOverScene: SKScene {
    var manager = GameManager.sharedInstance;
    var state = GameState.sharedInstance;
    
    var background = SKSpriteNode()
    var tryAgain = SKLabelNode()
    var backToMenu = SKLabelNode()
    var tryAgainTouch = 0
    var backToMenuTouch = 0
    var div = SKNode()
    
    
    var labels: [SKLabelNode] = []
    var selected = 0;
    
    override func didMoveToView(view: SKView) {
        manager.enemiesCreated = false;
        
        self.runAction(SKAction.playSoundFileNamed("scream2.mp3", waitForCompletion: false))
        
        self.gameOverScreen()
        

        

    }
    
    func gameOverScreen(){
        
        self.background = SKSpriteNode(imageNamed: "gameOver")
        self.background.position = CGPoint(x: frame.midX, y: frame.midY)
        self.background.size = self.frame.size
        self.background.zPosition = 0

        
        addChild(self.background)
        self.runAction(SKAction.waitForDuration(5.0), completion: {
            self.background.removeFromParent()
            self.gameOverOptions()
            #if os(tvOS)
                self.setupGestureRecognizerTV();
            #endif
            })
        

    }
    
    func gameOverOptions(){
        manager.playDirectionNarration("LANG-gameOverTela", frmt: "mp3")

//        GameManager.addSoundArray("LANG-gameOverTela", frmt: "mp3", x: 0.0, y: 0.0)
        
        div.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        div.zPosition = 3
        self.addChild(div)
        
        self.background = SKSpriteNode(imageNamed: "background")
        self.background.position = CGPoint(x: frame.midX, y: frame.midY)
        self.background.size = self.frame.size
        self.background.zPosition = 0

        
        addChild(self.background)
        
        
        
        self.tryAgain = SKLabelNode(fontNamed: "futura-condensed-normal")
        self.tryAgain.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/1.5)
        
        if(manager.language == "pt-BR"){
            self.tryAgain.text = "TENTAR NOVAMENTE"
        }else{
            self.tryAgain.text = "TRY AGAIN"
        }
        
        self.tryAgain.name = "tryAgain"
        self.tryAgain.fontSize = 0.1 * self.frame.size.width
        self.tryAgain.zPosition = 1
        self.tryAgain.fontColor = UIColor.whiteColor()
        addChild(self.tryAgain)
        
        self.backToMenu = SKLabelNode(fontNamed: "futura-condensed-normal")
        self.backToMenu.position = CGPoint(x: self.tryAgain.position.x, y: self.tryAgain.position.y/2.5)
        self.backToMenu.name = "backToMenu"
        if(manager.language == "pt-BR"){
            self.backToMenu.text = "VOLTAR AO MENU"
        }else{
            self.backToMenu.text = "BACK TO MENU"
        }
        
        self.backToMenu.fontSize = 0.1 * self.frame.size.width
        self.backToMenu.zPosition = 1
        self.backToMenu.fontColor = UIColor.whiteColor()
        addChild(self.backToMenu)
    }



    func mainMenu () {
        self.div.removeFromParent()
        let transition = SKTransition.fadeWithDuration(0)
        let scene = StartMenuScene(size: self.size)
        let state = GameState()
        state.room = 0
        self.manager.playerPosition = 0
        state.rotation = 1
        
        if let recognizers = self.view?.gestureRecognizers {
            for recognizer in recognizers {
                self.view?.removeGestureRecognizer(recognizer)
            }
        }
        
        
        self.view?.presentScene(scene, transition: transition)
        

    }
    
    func retry () {
        self.div.removeFromParent()
        let transition = SKTransition.fadeWithDuration(0)
        self.state.room = 0
        self.manager.playerPosition = 0
        self.state.rotation = 1
        manager.enemiesCreated = true;

        
        let scene = GameScene(size: self.size)
        
        if let recognizers = self.view?.gestureRecognizers {
            for recognizer in recognizers {
                self.view?.removeGestureRecognizer(recognizer )
            }
        }
        
        self.view?.presentScene(scene, transition: transition)
    
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
