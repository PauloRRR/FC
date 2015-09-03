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
    var storyP = [StorySoundNode]()
    var i = 0
    
    // METHODS
    private init() {
        self.playBGSound("storm", frmt: "mp3")
        self.initStoryArray()
    }
    
     func playBGSound(sndName:String, frmt:String){
        var audio = BackGroundSoundNode(soundName: sndName, format: frmt)
        self.backgroundPlayer.append(audio)
        self.backgroundPlayer[0].play()
        
    }
    
    func initStoryArray(){
        for (var i = 0; i < 2; i++){
            var audio = StorySoundNode(soundName: "story\(i)", format: "mp3")
            self.storyP.append(audio)
        }
        
    }
    
    
    func playStorySound(){
        if (self.i < self.storyP.count){
            self.i++
            if (i-1 == 0){
                self.storyP[self.i-1].play()
            }else if (storyP[i-2].storyPlayer.playing){
                self.storyP[i-2].storyPlayer.stop()
                self.storyP[self.i-1].play()
            }else{
                self.i--
            }
        }
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
    
    func listenerAngularPosition(yaw: Float, pitch: Float, roll: Float){
        enviroNode.listenerAngularOrientation = AVAudioMake3DAngularOrientation(yaw, pitch, roll)
    }
    
    func listenerAngularPosition(yaw: Float) {
        listenerAngularPosition(yaw,
            pitch: enviroNode.listenerAngularOrientation.pitch,
            roll: enviroNode.listenerAngularOrientation.roll)
    }
    
    func updateEnemiesListenerPosition(){
        var coord = AudioCoordinate()
        coord.pinpointListener(playerPosition)
        for (var i = 0; i < self.enemies.count; i++){
            coord.pinpointPlayer(self.enemies[i].enemyPosition)
            self.enemies[i].audio.enviroNode.listenerPosition = AVAudio3DPoint(x: coord.coordX(playerPosition), y: coord.coordY(playerPosition), z: 0)
            if(coord.distance() <= 15.0){
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