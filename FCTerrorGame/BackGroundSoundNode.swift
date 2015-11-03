//
//  BackGroundSoundNode.swift
//  FCTerrorGame
//
//  Created by Rafael on 13/8/15.
//  Copyright (c) 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//


import AVFoundation

class BackGroundSoundNode: NSObject {
    
    var backgroundPlayer = AVAudioPlayer()
    var lastVolume: Float = 0.0
    
    init(soundName:String,format:String) {
        super.init()
        
        print(soundName)
    
        let bgMusicURL = NSBundle.mainBundle().URLForResource(soundName, withExtension: format)
        
        backgroundPlayer = try! AVAudioPlayer(contentsOfURL: bgMusicURL!)
//        backgroundPlayer.numberOfLoops = -1
        backgroundPlayer.prepareToPlay()
        backgroundPlayer.volume = 1
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("mute"), name: "muteSound", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("normalVolume"), name: "resumeSound", object: nil)
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    
    func mute() {
        lastVolume = backgroundPlayer.volume;
        backgroundPlayer.volume = 0.0;
    }
    
    func normalVolume() {
        backgroundPlayer.volume = lastVolume;
    }
    
    
    func play(){
        backgroundPlayer.play()
        print("TOCANDO AUDIO")
    }
   
}
