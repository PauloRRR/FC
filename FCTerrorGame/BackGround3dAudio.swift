//
//  BackGround3dAudio.swift
//  MadnessDaze
//
//  Created by Rafael on 30/9/15.
//  Copyright © 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//

import AVFoundation

class BackGround3dAudio: NSObject {
    
    var player = AVAudioPlayerNode()
    var timePitch = AVAudioUnitTimePitch()
    var audioEngine = AVAudioEngine()
    var enviroNode = AVAudioEnvironmentNode()
    var audioFileBuffer = AVAudioPCMBuffer()
    
    var lastVolume: Float = 0.0

    
    
    init(soundName:String,format:String) {
        super.init()
        
        self.player.renderingAlgorithm = AVAudio3DMixingRenderingAlgorithm.HRTF
        let filePath: String = NSBundle.mainBundle().pathForResource(soundName, ofType: format)!
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
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("muffleSound"), name: "muffle", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("unmuffleSound"), name: "unmuffle", object: nil)
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
        

        self.player.volume = 0.6
        self.player.rate = -0.5
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
    
    func muffleSound(){
        print("muffled")
        self.player.rate = -1.5
        
    }

    func unmuffleSound(){
        self.player.rate = -0.5
        
    }

}
