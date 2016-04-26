//
//  StorySoundNode.swift
//  MadnessDaze
//
//  Created by Paulo Ricardo Ramos da Rosa on 8/31/15.
//  Copyright (c) 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//

import AVFoundation

class StorySoundNode : NSObject {
    
    var storyPlayer = AVAudioPlayer()
    var played = false
    var lastVolume: Float = 0.0

    
    init(soundName:String,format:String) {
        super.init()
        let bgMusicURL = NSBundle.mainBundle().URLForResource(soundName, withExtension: format)
        storyPlayer = try! AVAudioPlayer(contentsOfURL: bgMusicURL!)
        storyPlayer.numberOfLoops = 0
        storyPlayer.prepareToPlay()
        storyPlayer.volume = 1
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(StorySoundNode.mute), name: "muteSound", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(StorySoundNode.normalVolume), name: "resumeSound", object: nil)
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    
    func mute() {
        lastVolume = storyPlayer.volume;
        storyPlayer.volume = 0.0;
    }
    
    func normalVolume() {
        storyPlayer.volume = lastVolume;
    }
    func play(){
        storyPlayer.play()
    }
    
}