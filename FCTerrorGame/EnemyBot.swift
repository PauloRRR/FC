//
//  EnemyBot.swift
//  MadnessDaze
//
//  Created by Rafael on 19/8/15.
//  Copyright (c) 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//

import UIKit

class EnemyBot: NSObject {
    
    var botId:String
    var enemyPosition: Int
    var lastRoom: Int
    var adjacentRooms = [Int]()
    var map = [[Int]]()
    var manager = GameManager.sharedInstance
    var audio = AudioNode(soundName: "footsteps", format: "mp3")
    var breath =  BackGroundSoundNode(soundName: "breathing", format: "mp3")
    var isBreathing = false
    init(botId: String, startRoom: Int, map: [[Int]])
    {
        self.botId = botId
        self.enemyPosition = startRoom
        self.map = map
        self.adjacentRooms = map[self.enemyPosition]
        self.lastRoom = self.enemyPosition
        println("\(adjacentRooms)")
        self.audio.setVolume(0.5)
        self.audio.player3DPosition(0, y: Float(self.enemyPosition*10), z: 0)
        self.audio.playLoop()

    }
    
    func moveToAdjacentRoom()->Int{
        
        self.lastRoom = self.enemyPosition
        let random = Int(arc4random_uniform(UInt32(adjacentRooms.count)))
        self.enemyPosition = adjacentRooms[random]
        self.adjacentRooms = map[self.enemyPosition]
        manager.updateEnemiesListenerPosition()
        println("\(self.botId) esta na sala \(self.enemyPosition)")
        println("jogador esta na sala \(manager.returnPlayerPosition())")
        println("player y pos \(self.audio.enviroNode.listenerPosition.y)")
        return self.actualRoom()
    }
    
    func actualRoom()->Int{
        self.audio.player3DPosition(0,y: Float(self.enemyPosition*10), z: 0)
        println("enemy audio y pos:\(self.audio.getPlayer3DPosition().y)")
        return self.enemyPosition
        
    }
    
    func playBreath(){
        self.breath.backgroundPlayer.volume = Float(1.0)
        self.breath.play()
    }
    func stopBreath(){
        self.breath.backgroundPlayer.stop()
    }
   
    
}
