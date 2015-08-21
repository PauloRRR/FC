//
//  EnemyBot.swift
//  MadnessDaze
//
//  Created by Rafael on 19/8/15.
//  Copyright (c) 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//

import UIKit

class EnemyBot: NSObject {
    
    var botId:String
    var currentRoomPosition: Int
    var lastRoom: Int
    var adjacentRooms = [Int]()
    
    
    init(botId: String, startRoom: Int, adjacentRooms: [Int])
    {
        self.botId = botId
        self.currentRoomPosition = startRoom
        self.adjacentRooms = adjacentRooms
        self.lastRoom = self.currentRoomPosition
        println("\(adjacentRooms)")
    }
    
    func moveToAdjacentRoom(){
        
        self.lastRoom = self.currentRoomPosition
        let random = Int(arc4random_uniform(UInt32(adjacentRooms.count)))
        println("random: \(random)")

        self.currentRoomPosition = adjacentRooms[random]
        self.adjacentRooms = Singleton.map(self.currentRoomPosition)
        println("\(self.botId) esta na sala \(self.currentRoomPosition)")
        println("\(adjacentRooms)")
    }
    
    func actualRoom()->Int{
        return self.currentRoomPosition
    }
   
    
}
