//
//  AudioCoordinate.swift
//  MadnessDaze
//
//  Created by Rafael on 2/9/15.
//  Copyright (c) 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//

import UIKit

class AudioCoordinate{
    
    var roomsJson: JSON!
    
    var playerX = Float()
    var playerY =  Float()
    var listenerX = Float()
    var listenerY = Float()
    
    func coordX(position: Int)-> Float{
        
        if let filePath = NSBundle.mainBundle().pathForResource("roomMapping", ofType: "json") {
            self.roomsJson =  JSON(data: NSData(contentsOfFile: filePath)!)
        }
        return self.roomsJson["rooms"][position]["x"].floatValue * 10.0
    }
    
    
    func coordY(position: Int)-> Float{
        
        if let filePath = NSBundle.mainBundle().pathForResource("roomMapping", ofType: "json") {
            self.roomsJson =  JSON(data: NSData(contentsOfFile: filePath)!)
        }
        return self.roomsJson["rooms"][position]["y"].floatValue * 10.0
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
