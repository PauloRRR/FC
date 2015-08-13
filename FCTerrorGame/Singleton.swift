//
//  Singleton.swift
//  FCTerrorGame
//
//  Created by Rafael on 13/8/15.
//  Copyright (c) 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//


class Singleton {
    private static let sharedInstance = Singleton()
    var audioArray = [AudioNode]()
    var backgroundPlayer = [BackGroundSoundNode]()
    // METHODS
    private init() {
       
    }
    
    class func playBGSound(sndName:String, frmt:String){
        var audio = BackGroundSoundNode(soundName: sndName, format: frmt)
        self.sharedInstance.backgroundPlayer.append(audio)
        self.sharedInstance.backgroundPlayer[0].play()
        
    }
    
    class func addSoundArray(sndName:String, frmt:String) {
        var audio = AudioNode(soundName: sndName,format: frmt)
        self.sharedInstance.audioArray.append(audio)
        self.sharedInstance.audioArray[0].playLoop()
        
    }
}