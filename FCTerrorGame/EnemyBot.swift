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
    var map = [Int]()
    var arrayPosition: Int
    var manager = GameManager.sharedInstance
    var audio = AudioNode(soundName: "zombi", format: "mp3")
    var breath =  BackGroundSoundNode(soundName: "breathing", format: "mp3")
    var isBreathing = false
    var going = true
    init(botId: String, startRoom: Int, map: [Int])
    {
        let coord = AudioCoordinate()
        self.botId = botId
        self.arrayPosition = startRoom
        self.map = map
        self.enemyPosition = map[startRoom]
        //self.adjacentRooms = map[self.enemyPosition]
        self.lastRoom = self.enemyPosition
        print("\(adjacentRooms)")
        self.audio.setVolume(3.0)
        self.audio.player3DPosition(coord.coordX(self.enemyPosition),y: coord.coordY(self.enemyPosition), z: 0)
        self.audio.playLoop()

    }
    
    func moveToAdjacentRoom()->Int{
        
        if( map.count > 1){
        
            if(self.going){
            
                if(self.arrayPosition == self.map.count - 1){
                    going = false
                    self.arrayPosition--
                }
                else{
                    self.arrayPosition++
                }
            }
            else{
                if(self.arrayPosition == 0){
                    going = true
                    self.arrayPosition++
                }
                else{
                    self.arrayPosition--
                }
            
            }
        }
        
        self.lastRoom = self.enemyPosition
        
        self.enemyPosition = map[self.arrayPosition]
        //self.adjacentRooms = map[self.enemyPosition]
        //manager.updateEnemiesListenerPosition()
        print("player pos (\(self.audio.enviroNode.listenerPosition.x),\(self.audio.enviroNode.listenerPosition.y)) at room \(manager.returnPlayerPosition())")
        return self.actualRoom()
        
    }
    
    func actualRoom()->Int{
        let coord = AudioCoordinate()
        self.audio.player3DPosition(coord.coordX(self.enemyPosition),y: coord.coordY(self.enemyPosition), z: 0)
        print("enemy pos:(\(self.audio.getPlayer3DPosition().x),\(self.audio.getPlayer3DPosition().y)) at room \(self.enemyPosition)")
        return self.enemyPosition
        
    }
    
    func playBreath(){
        self.breath.backgroundPlayer.volume = Float(3.0)
        self.breath.backgroundPlayer.numberOfLoops = -1
        self.breath.play()
    }
    func stopBreath(){
        self.breath.backgroundPlayer.stop()
    }
    
    func stopFootsteps(){
        self.audio.stopPlayer()
    }
    func playFootsteps(){
        if (!self.audio.player.playing){
            self.audio.playLoop()
        }
    }
   
    
}
