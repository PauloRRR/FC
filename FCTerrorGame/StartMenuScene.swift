//
//  StartMenuScene.swift
//  MadnessDaze
//
//  Created by Paulo Ricardo Ramos da Rosa on 9/10/15.
//  Copyright (c) 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//

import SpriteKit

class StartMenuScene: SKScene {
    
    var manager = GameManager.sharedInstance;
    var newGame = SKSpriteNode()
    var loadGame = SKSpriteNode()
    var chapterSelect = SKSpriteNode()
    var background = SKSpriteNode()
    
    
    override func didMoveToView(view: SKView) {
        //var tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("start"))
        //self.view?.addGestureRecognizer(tapRecognizer);
        //self.view?.scene?.backgroundColor = UIColor.blackColor()
        
        self.background = SKSpriteNode(imageNamed: "background")
        self.background.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        self.background.xScale -= 0.5
        self.background.yScale -= 0.65
        addChild(background)
        
        self.newGame = SKSpriteNode(imageNamed: "iniciar")
        self.newGame.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        self.newGame.name = "newGame"
        addChild(newGame)
        
        self.chapterSelect = SKSpriteNode(imageNamed: "capitulos")
        self.chapterSelect.position = CGPoint(x: self.newGame.position.x, y: self.newGame.position.y/2.5)
        self.chapterSelect.name = "chapterSelect"
        addChild(chapterSelect)
        
    }
    
    
    func start () {
        _ = NSTimeInterval()
        let transition = SKTransition.crossFadeWithDuration(5.0)
        let scene = GameScene(size: self.size)
        let state = GameState()
        state.room = 0
        state.rotation = 1
        //scene.loadRoom()
        
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
                print("NEWGAME")
                self.start()
            }else if (node.name == "chapterSelect"){
                print("CHAPTERSELECT")
            }
        }
    
}
