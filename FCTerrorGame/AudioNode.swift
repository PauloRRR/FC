//
//  AudioNode.swift
//  FCTerrorGame
//
//  Created by Rafael on 4/8/15.
//  Copyright (c) 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//

import UIKit
import AVFoundation

class AudioNode: NSObject {
    
    var player = AVAudioPlayerNode()
    var timePitch = AVAudioUnitTimePitch()
    var audioEngine = AVAudioEngine()
    var enviroNode = AVAudioEnvironmentNode()
    var gameManager = GameManager.sharedInstance
    var audioFileBuffer = AVAudioPCMBuffer()
    var lastVolume: Float = 0.0;

    init(soundName:String,format:String) {
        super.init()
        self.player.renderingAlgorithm = AVAudio3DMixingRenderingAlgorithm.HRTF
        //self.player.position = AVAudioMake3DPoint(0.0, 0.0, 0.0);
        //GameManager.sharedInstance.enviroNode.listenerPosition = AVAudioMake3DPoint(0.0, 0.0, 0.0);
        //enviroNode.listenerPosition = gameManager.enviroNode.listenerPosition
        

        let str =  soundName.stringByReplacingOccurrencesOfString("LANG", withString: gameManager.language)
            
        print(str)
        let filePath: String = NSBundle.mainBundle().pathForResource(str, ofType: format)!
        let fileURL: NSURL = NSURL(fileURLWithPath: filePath)
        let audioFile = try? AVAudioFile(forReading: fileURL)
        let audioFormat = audioFile!.processingFormat
        let audioFrameCount = UInt32(audioFile!.length)
        
        self.audioFileBuffer = AVAudioPCMBuffer(PCMFormat: audioFormat, frameCapacity: audioFrameCount)
        do {
            try audioFile!.readIntoBuffer(audioFileBuffer)
        } catch _ {
        }
        let mainMixer = audioEngine.mainMixerNode
        
        //timePitch.pitch = 1000
        audioEngine.attachNode(enviroNode)
        audioEngine.attachNode(player)
        audioEngine.attachNode(timePitch)
       
        audioEngine.connect(player, to: timePitch, format: audioFile!.processingFormat)
        audioEngine.connect(timePitch, to:enviroNode, format: audioFileBuffer.format)
        audioEngine.connect(enviroNode, to:mainMixer, format: nil)
        
        
        //audioEngine.startAndReturnError(nil)
        do {
            try audioEngine.start()
        } catch _ {
        }

        
        let  dap = enviroNode.distanceAttenuationParameters as AVAudioEnvironmentDistanceAttenuationParameters
        dap.distanceAttenuationModel =  AVAudioEnvironmentDistanceAttenuationModel.Inverse
        dap.referenceDistance = 10.0;
        dap.maximumDistance = 300.0;
        dap.rolloffFactor = 1.5;

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("mute"), name: "muteSound", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("normalVolume"), name: "resumeSound", object: nil)

        
        
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    func mute() {
        lastVolume = player.volume;
        player.volume = 0.0;
    }
    
    func normalVolume() {
        player.volume = lastVolume;
    }
    
    
    func playLoop(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("muffleSound"), name: "muffle", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("unmuffleSound"), name: "unmuffle", object: nil)

        self.player.scheduleBuffer(audioFileBuffer, atTime: nil, options:.Loops, completionHandler: nil)
        self.player.play()
    }
    
    func playOnce(){
        self.player.scheduleBuffer(audioFileBuffer, atTime: nil, options: [], completionHandler: nil)
        self.player.play()
    }
    
    func stopPlayer(){
        self.player.stop()
    }
    
    func player3DPosition( x:Float, y: Float, z: Float){
        self.player.position = AVAudioMake3DPoint(x, y, z)
    
    }
    
    func listener3DPosition( x:Float, y: Float, z: Float){
            self.player.position = AVAudioMake3DPoint(x, y, z)
            
    }
    
    func listenerAngularPosition(yaw: Float, pitch: Float, roll: Float){
            GameManager.sharedInstance.enviroNode.listenerAngularOrientation = AVAudioMake3DAngularOrientation(yaw, pitch, roll)
    }
    
    func getPlayer3DPosition()->AVAudio3DPoint{
        return self.player.position
    }
    
    func getListener3DPosition()->AVAudio3DPoint{
        return GameManager.sharedInstance.enviroNode.listenerPosition
    }
    
    func getListenerAngularPosition()->AVAudio3DAngularOrientation{
        return GameManager.sharedInstance.enviroNode.listenerAngularOrientation
    }
    
    func setLeftChannel(){
        self.player.pan = -1
    }
    
    func setRightChannel(){
        self.player.pan = 1
    }
    
    func setCenterChannel(){
        self.player.pan = 0
    }
    
    func setVolume(vol:Float){
        self.player.volume = vol
    }
    
    func muffleSound(){
        print(self.player.rate)
        self.player.rate = -0.5
    }
    
    func unmuffleSound(){
        self.player.rate = 1.0
    }
}
