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

    init(soundName:String,format:String) {
        
        self.player.renderingAlgorithm = AVAudio3DMixingRenderingAlgorithm.HRTF
        //self.player.position = AVAudioMake3DPoint(0.0, 0.0, 0.0);
        //GameManager.sharedInstance.enviroNode.listenerPosition = AVAudioMake3DPoint(0.0, 0.0, 0.0);
        enviroNode.listenerPosition = gameManager.enviroNode.listenerPosition
        let filePath: String = NSBundle.mainBundle().pathForResource(soundName, ofType: format)!
        let fileURL: NSURL = NSURL(fileURLWithPath: filePath)!
        let audioFile = AVAudioFile(forReading: fileURL, error: nil)
        let audioFormat = audioFile.processingFormat
        let audioFrameCount = UInt32(audioFile.length)
        
        self.audioFileBuffer = AVAudioPCMBuffer(PCMFormat: audioFormat, frameCapacity: audioFrameCount)
        audioFile.readIntoBuffer(audioFileBuffer, error: nil)
        var mainMixer = audioEngine.mainMixerNode
        
        //timePitch.pitch = 1000
        audioEngine.attachNode(enviroNode)
        audioEngine.attachNode(player)
        audioEngine.attachNode(timePitch)
       
        audioEngine.connect(player, to: timePitch, format: audioFile.processingFormat)
        audioEngine.connect(timePitch, to:enviroNode, format: audioFileBuffer.format)
        audioEngine.connect(enviroNode, to:mainMixer, format: nil)
        audioEngine.startAndReturnError(nil)
        
        
        var  dap = enviroNode.distanceAttenuationParameters as AVAudioEnvironmentDistanceAttenuationParameters
        dap.distanceAttenuationModel =  AVAudioEnvironmentDistanceAttenuationModel.Inverse
        dap.referenceDistance = 5.0;
        dap.maximumDistance = 100.0;
        dap.rolloffFactor = 1.5;


    }
    
    func playLoop(){
        self.player.scheduleBuffer(audioFileBuffer, atTime: nil, options:.Loops, completionHandler: nil)
        self.player.play()
    }
    
    func playOnce(){
        self.player.scheduleBuffer(audioFileBuffer, atTime: nil, options: nil, completionHandler: nil)
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
    
}
