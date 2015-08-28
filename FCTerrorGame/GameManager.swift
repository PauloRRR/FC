//
//  Singleton.swift
//  FCTerrorGame
//
//  Created by Rafael on 13/8/15.
//  Copyright (c) 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//

import AVFoundation
class GameManager {
    static let sharedInstance = GameManager()
    var audioArray = [AudioNode]()
    var backgroundPlayer = [BackGroundSoundNode]()
    var enviroNode = AVAudioEnvironmentNode()
    var enemies = [EnemyBot]()
    var enemiesPosition = [Int]()
    var playerPosition = 0
    var enemiesCreated = false
    var isBreathing = false
    // METHODS
    private init() {
       self.playBGSound("background", frmt: "mp3")
    }
    
     func playBGSound(sndName:String, frmt:String){
        var audio = BackGroundSoundNode(soundName: sndName, format: frmt)
        self.backgroundPlayer.append(audio)
        self.backgroundPlayer[0].play()
        
    }
    
    class func addSoundArray(sndName:String, frmt:String, x:Float, y:Float) {
        self.sharedInstance.audioArray.removeAll(keepCapacity: false)
        var audio = AudioNode(soundName: sndName,format: frmt)
        self.sharedInstance.audioArray.append(audio)
        self.sharedInstance.audioArray[0].player3DPosition(x, y: y, z: 0.0)
        self.sharedInstance.audioArray[0].playOnce()
        
    }
    
    func setListenerPosition(x:Float, y:Float){
        for (var i = 0; i < self.audioArray.count; i++){
            self.audioArray[i].listener3DPosition(x, y: y, z: 0)
        }
    }
    
    func updateEnemiesListenerPosition(){
        for (var i = 0; i < self.enemies.count; i++){
            self.enemies[i].audio.enviroNode.listenerPosition = AVAudio3DPoint(x: 0, y: Float(playerPosition * 10), z: 0)
            if(abs((self.enemies[i].currentRoomPosition - playerPosition)) <= 1){
                if(!self.isBreathing){
                   self.enemies[i].playBreath()
                    self.isBreathing = true
                }else{
                    self.isBreathing = false
                }
            }else{
                self.enemies[i].stopBreath()
            }
            
        }
    }
    
   
    
    func setPlayerPosition(room: Int){
        self.enviroNode.listenerPosition = AVAudio3DPoint(x: 0, y: Float(room * 10), z: 0)
        println(self.enviroNode.listenerPosition.y)
        println("sala \(room)")
        playerPosition = room
    }
    
    func returnPlayerPosition()->Int{
        return playerPosition
    }
    
}