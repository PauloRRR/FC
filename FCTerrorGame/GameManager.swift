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
    var audioRoomArray = [AudioNode]()
    var backgroundPlayer = [BackGroundSoundNode]()
    var enviroNode = AVAudioEnvironmentNode()
    var enemies = [EnemyBot]()
    var enemiesPosition = [Int]()
    var playerPosition = 0
    var enemiesCreated = false
    var isBreathing = false
    var storyP = [StorySoundNode]()
    var gameState = GameState.sharedInstance
    var i = 0
    
    var firstPlay = Bool()
    
    // METHODS
    private init() {
        firstPlay = true
        self.initStoryArray()
    }
    
    func eraseManager(){
        self.i = 0
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
    
    
     func playBGSound(sndName:String, frmt:String){
        let audio = BackGroundSoundNode(soundName: sndName, format: frmt)
        self.backgroundPlayer.append(audio)
        self.backgroundPlayer[0].play()
        
    }
    
    func initStoryArray(){
        for (var i = 0; i < 3; i++){
            let audio = StorySoundNode(soundName: "story\(i)", format: "mp3")
            self.storyP.append(audio)
        }
        
    }
    
    func removeStoryArray(){
        self.storyP.removeAll(keepCapacity: true)
    }
    
    
    func playStorySound(){
        if (self.i < self.storyP.count){
            self.storyP[self.i].play()
            self.storyP[self.i].played = true
            self.i++
        }
    }
    
    func stopStorySound(){
        for (var i = 0; i < self.i; i++) {
            self.storyP[i].storyPlayer.stop()
        }
    
    }
    
    class func addSoundArray(sndName:String, frmt:String, x:Float, y:Float) {
        self.sharedInstance.audioArray.removeAll(keepCapacity: false)
        let audio = AudioNode(soundName: sndName,format: frmt)
        audio.setVolume(5.0)
        self.sharedInstance.audioArray.append(audio)
        self.sharedInstance.audioArray[0].player3DPosition(x, y: y, z: 0.0)
        self.sharedInstance.audioArray[0].playOnce()
    }
    
    class func addRoomSoundArray(sndName:String, frmt:String, x:Float, y:Float) {
        self.sharedInstance.audioRoomArray.removeAll(keepCapacity: false)
        let audio = AudioNode(soundName: sndName,format: frmt)
        self.sharedInstance.audioRoomArray.append(audio)
        self.sharedInstance.audioRoomArray[0].player3DPosition(x, y: y, z: 0.0)
        self.sharedInstance.audioRoomArray[0].playOnce()
    }
    
    class func clearRoomSoundArray() {
        self.sharedInstance.audioRoomArray.removeAll(keepCapacity: false)
    }
    
    
    
    
    func setListenerPosition(x:Float, y:Float){
        for (var i = 0; i < self.audioArray.count; i++){
            self.audioArray[i].listener3DPosition(x, y: y, z: 0)
        }
    }
    
    func listenerAngularPosition(yaw: Float, pitch: Float, roll: Float){
        enviroNode.listenerAngularOrientation = AVAudioMake3DAngularOrientation(yaw, pitch, roll)
        updateEnemiesListenerPosition()
    }
    
    func listenerAngularPosition(roll: Float) {
        listenerAngularPosition(90.0,
            pitch: enviroNode.listenerAngularOrientation.pitch,
            roll: roll)
    }
    
    func updateEnemiesListenerPosition(){
        let coord = AudioCoordinate()
        coord.pinpointListener(playerPosition)
        for (var i = 0; i < self.enemies.count; i++){
            coord.pinpointPlayer(self.enemies[i].enemyPosition)
            self.enemies[i].audio.enviroNode.listenerPosition = AVAudio3DPoint(x: coord.coordX(playerPosition), y: coord.coordY(playerPosition), z: 0)
            self.enemies[i].audio.enviroNode.listenerAngularOrientation = enviroNode.listenerAngularOrientation

            
            if(coord.distance() <= 15.0){
                if (coord.distance() <= 0.0 && !gameState.playerHidden) {
                    print("🍺 DEATH 🍺");
                    NSNotificationCenter.defaultCenter().postNotificationName("gameOver", object: nil);
                }
                if(!self.isBreathing){
                   self.enemies[i].playBreath()
                    self.isBreathing = true
                }else{
                    self.isBreathing = false
                }
            } else {
                self.enemies[i].stopBreath()
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