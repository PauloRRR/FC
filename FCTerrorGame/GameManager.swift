//
//  Singleton.swift
//  FCTerrorGame
//
//  Created by Rafael on 13/8/15.
//  Copyright (c) 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//

import AVFoundation
import UIKit

class GameManager {
    static let sharedInstance = GameManager()
    var audioArray = [AudioNode]()
    var audioRoomArray = [AudioNode]()
    var backgroundPlayer = [BackGround3dAudio]()
    var enviroNode = AVAudioEnvironmentNode()
    var enemies = [EnemyBot]()
    var enemiesPosition = [Int]()
    var playerPosition = 0
    var enemiesCreated = false
    var isBreathing = false
    var storyP = [StorySoundNode]()
    var directionNarration = [BackGroundSoundNode]()
    var gameState = GameState.sharedInstance
    var language = "en-US"
    var shot = BackGroundSoundNode(soundName: "gunshot", format: "mp3")
    var moan = BackGroundSoundNode(soundName: "zombihoar", format: "mp3")
    var firstPlay = Bool()
    var watched39 = false
    var watched128 = false
    var watched174 = false
    var heartBeat = HeartBeatSoundControl(soundName: "heartbeat", format: "mp3")
    
    // METHODS
    private init() {
        firstPlay = true
        self.initStoryArray()
        
        
    }
    
    func eraseManager(){
        self.watched39 = false
        self.watched128 = false
        self.watched174 = false
        self.playerPosition = 0
        self.storyP.removeAll()
        self.isBreathing = false
        self.enemiesCreated = false
        self.enemiesPosition.removeAll()
        self.enemies.removeAll()
        self.backgroundPlayer.removeAll()
        self.audioRoomArray.removeAll()
        self.audioArray.removeAll()
    }
    
    func playDirectionNarration(sndName: String, frmt: String){
        if(UIAccessibilityIsVoiceOverRunning()){
            let str =  sndName.stringByReplacingOccurrencesOfString("LANG", withString: self.language)
            print(str)
            self.directionNarration.removeAll()
            let audio = BackGroundSoundNode(soundName: str, format: frmt)
            self.directionNarration.append(audio)
            self.directionNarration[0].play()
        }
    }
    
     func playBGSound(sndName:String, frmt:String){
        let audio = BackGround3dAudio(soundName: sndName, format: frmt)
        self.backgroundPlayer.append(audio)
        self.backgroundPlayer[0].playLoop()
        self.heartBeat.playLoop()
        
    }
    
    func gunshot(){
        self.shot.play()
        var zed = -1
        let coord = AudioCoordinate()
        coord.pinpointListener(playerPosition)
        for i in 0 ..< self.enemies.count{
            coord.pinpointPlayer(self.enemies[i].enemyPosition)
            if(coord.distance() <= 30.0){
                zed = i
                moan.play()
            }
            
        }
        if(zed != -1){
            enemies.removeAtIndex(zed)
            zed = -1
        }

    }
    
    func stopBGSound(){
        self.backgroundPlayer[0].stopPlayer()
        self.heartBeat.stopPlayer()
    }
    
    func initStoryArray(){
        for i in 0 ..< 5{
            let audio = StorySoundNode(soundName: "\(language)-story\(i)", format: "mp3")
            self.storyP.append(audio)
        }
        
    }
    
    func removeStoryArray(){
        self.storyP.removeAll(keepCapacity: true)
    }
    
    
    func playStorySound(index: Int){
        
            self.storyP[index].play()
            self.storyP[index].played = true
        
    }
    
    func stopStorySound(){
        for i in 0 ..< 5 {
            self.storyP[i].storyPlayer.stop()
        }
    }
    
    class func addSoundArray(sndName:String, frmt:String, x:Float, y:Float) {
        self.sharedInstance.audioArray.removeAll()
        let audio = AudioNode(soundName: sndName,format: frmt)
        audio.setVolume(1.0)
        self.sharedInstance.audioArray.append(audio)
        self.sharedInstance.audioArray[0].player3DPosition(x, y: y, z: 0.0)
        self.sharedInstance.audioArray[0].playOnce()
    }
    
    class func addRoomSoundArray(sndName:String, frmt:String, x:Float, y:Float) {
        self.sharedInstance.audioRoomArray.removeAll(keepCapacity: false)
        let audio = AudioNode(soundName: sndName,format: frmt)
        audio.player.volume = 1.0
        self.sharedInstance.audioRoomArray.append(audio)
        self.sharedInstance.audioRoomArray[0].player3DPosition(x, y: y, z: 0.0)
        self.sharedInstance.audioRoomArray[0].playOnce()
    }
    
    class func clearRoomSoundArray() {
        self.sharedInstance.audioRoomArray.removeAll(keepCapacity: false)
    }
    
    
    
    
    func setListenerPosition(x:Float, y:Float){
        for i in 0 ..< self.audioArray.count{
            self.audioArray[i].listener3DPosition(x, y: y, z: 0)
        }
    }
    
    func listenerAngularPosition(yaw: Float, pitch: Float, roll: Float){
        enviroNode.listenerAngularOrientation = AVAudioMake3DAngularOrientation(yaw, pitch, roll)
        updateEnemiesListenerPosition()
    }
    
    func listenerAngularPosition(roll: Float) {
        listenerAngularPosition(roll, pitch: 0, roll: 0)
        
    }
    
    func updateEnemiesListenerPosition(){
        let coord = AudioCoordinate()
        var nearCount = 0
        coord.pinpointListener(playerPosition)
        for i in 0 ..< self.enemies.count{
            coord.pinpointPlayer(self.enemies[i].enemyPosition)
            self.enemies[i].audio.enviroNode.listenerPosition = AVAudio3DPoint(x: coord.coordX(playerPosition), y: coord.coordY(playerPosition), z: 0)
            self.enemies[i].audio.enviroNode.listenerAngularOrientation = enviroNode.listenerAngularOrientation
            print(coord.distance())
            if(coord.distance() > 100.0){
                self.enemies[i].audio.player.volume = 0.0
            }else{
                self.enemies[i].audio.player.volume = 2.0
            }
            
            if(coord.distance() <= 15.0){
                nearCount += 1
                
                
                if (coord.distance() <= 0.0 && (!gameState.playerHidden && !gameState.godMode) ) {
                    print("🍺 DEATH 🍺");
                    NSNotificationCenter.defaultCenter().postNotificationName("gameOver", object: nil);
                }
                
            }
            if(nearCount > 0){
                self.heartBeat.speedBeat()
               //print(self.heartBeat.player.rate)
            }
            else {
                self.heartBeat.normalBeat()
                //print(self.heartBeat.player.rate)
            }
            
        }
    }
    
   
    
    func setPlayerPosition(room: Int){
        self.enviroNode.listenerPosition = AVAudio3DPoint(x: 0, y: Float(room * 10), z: 0)
        print(self.enviroNode.listenerPosition.y)
        print("sala \(room)")
        playerPosition = room
    }
    
    func returnPlayerPosition()->Int{
        return playerPosition
    }
    
}