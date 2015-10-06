//
//  AudioCoordinate.swift
//  MadnessDaze
//
//  Created by Rafael on 2/9/15.
//  Copyright (c) 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//

import UIKit

class AudioCoordinate{
    
    
    
    static var roomsJson: JSON?
    
    var playerX = Float()
    var playerY =  Float()
    var listenerX = Float()
    var listenerY = Float()
    
    init () {
        if AudioCoordinate.roomsJson == nil {
            if let filePath = NSBundle.mainBundle().pathForResource("roomMapping", ofType: "json") {
                AudioCoordinate.roomsJson =  JSON(data: NSData(contentsOfFile: filePath)!)
            }
        }

    
    }
    
    func coordX(position: Int)-> Float{
        var val: Float = 0.0;
        if let json = AudioCoordinate.roomsJson {
            val = json["rooms"][position]["x"].floatValue * 10.0
        }
        return val
    }
    
    
    func coordY(position: Int)-> Float{
        var val: Float = 0.0;
        if let json = AudioCoordinate.roomsJson {
            val = json["rooms"][position]["y"].floatValue * 10.0
        }
        return val
    }
    
    func pinpointPlayer(position: Int){
        playerX = self.coordX(position)
        playerY = self.coordY(position)
    }
    
    func pinpointListener(position: Int){
        listenerX = self.coordX(position)
        listenerY = self.coordY(position)
    }
    
    func distance()->Float{
        let dist = sqrt(powf(playerX - listenerX, 2) + powf(playerY - listenerY, 2))
        //println("distancia entre jogador e player: \(dist)")
        return dist
    }
   
}
