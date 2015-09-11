//
//  BackGroundSoundNode.swift
//  FCTerrorGame
//
//  Created by Rafael on 13/8/15.
//  Copyright (c) 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//


import AVFoundation

class BackGroundSoundNode {
    
    var backgroundPlayer = AVAudioPlayer()
    
    
    init(soundName:String,format:String) {
    
        let bgMusicURL = NSBundle.mainBundle().URLForResource(soundName, withExtension: format)
        backgroundPlayer = AVAudioPlayer(contentsOfURL: bgMusicURL, error: nil)
        backgroundPlayer.numberOfLoops = -1
        backgroundPlayer.prepareToPlay()
        backgroundPlayer.volume = 1
    }
    
    func play(){
        backgroundPlayer.play()
    }
   
}
