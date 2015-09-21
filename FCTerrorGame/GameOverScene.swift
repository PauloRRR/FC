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
    
    override func didMoveToView(view: SKView) {
        manager.enemiesCreated = false;
        //var tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("retry"))
        //self.view?.addGestureRecognizer(tapRecognizer);
        
        
        //self.runAction(SKAction.playSoundFileNamed("scream2.mp3", waitForCompletion: false))
        
        self.gameOverScreen()
        self.view?.scene?.runAction(SKAction.waitForDuration(5.0))
        self.gameOverOptions()

    }
    
    func gameOverScreen(){
        self.background = SKSpriteNode(imageNamed: "gameOver")
        self.background.position = CGPoint(x: frame.midX, y: frame.midY)
        self.background.size = self.frame.size
//        self.background.xScale -= 0.5
//        self.background.yScale -= 0.65
        
        addChild(self.background)
        
        
        //self.background.removeFromParent()
    }
    
    func gameOverOptions(){
        self.background = SKSpriteNode(imageNamed: "background")
        self.background.position = CGPoint(x: frame.midX, y: frame.midY)
        self.background.xScale -= 0.5
        self.background.yScale -= 0.65
        
        addChild(self.background)
        
        
        
        self.tryAgain = SKLabelNode(fontNamed: "futura-condensed-normal")
        self.tryAgain.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/1.5)
        self.tryAgain.text = "TENTAR NOVAMENTE"
        self.tryAgain.name = "tryAgain"
        self.tryAgain.fontSize = 30
        self.tryAgain.fontColor = UIColor.whiteColor()
        addChild(self.tryAgain)
        
        self.backToMenu = SKLabelNode(fontNamed: "futura-condensed-normal")
        self.backToMenu.position = CGPoint(x: self.tryAgain.position.x, y: self.tryAgain.position.y/2.5)
        self.backToMenu.name = "backToMenu"
        self.backToMenu.text = "VOLTAR AO MENU"
        self.backToMenu.fontSize = 30
        self.backToMenu.fontColor = UIColor.whiteColor()
        addChild(self.backToMenu)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches
        let location = touch.first!.locationInNode(self)
        let node = self.nodeAtPoint(location)
        
        if (node.name == "tryAgain"){
            print("restart")
            self.retry()
        }else if (node.name == "backToMenu"){
            print("exit")
            self.mainMenu()
        }
    }
    



    func mainMenu () {
        let transition = SKTransition.crossFadeWithDuration(0)
        let scene = StartMenuScene(size: self.size)
        let state = GameState()
        state.room = 0
        self.manager.playerPosition = 0
        state.rotation = 1
        
        if let recognizers = self.view?.gestureRecognizers {
            for recognizer in recognizers {
                self.view?.removeGestureRecognizer(recognizer )
            }
        }
        
        
        self.view?.presentScene(scene, transition: transition)
        

    }
    
    func retry () {
        let transition = SKTransition.fadeWithDuration(0)
        self.state.room = 0
        self.manager.playerPosition = 0
        self.state.rotation = 1
        
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
