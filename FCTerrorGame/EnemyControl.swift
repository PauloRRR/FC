//
//  EnemyControl.swift
//  MadnessDaze
//
//  Created by Rafael on 20/8/15.
//  Copyright (c) 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//

import UIKit
import SpriteKit
class EnemyControl{
   
    var enemies = [EnemyBot]()
    var enemiesJson: JSON!
    init(){
        self.createEnemies()
    }
    
    func createEnemies(){
        if let filePath = NSBundle.mainBundle().pathForResource("Enemy", ofType: "json") {
            enemiesJson =  JSON(data: NSData(contentsOfFile: filePath)!)
            println("\(enemiesJson)")
            for(var i = 0; i < enemiesJson.count; i++){
                var enemy = EnemyBot(botId: enemiesJson[i]["id"].stringValue, startRoom: enemiesJson[i]["startRoomPosition"].intValue, adjacentRooms: Singleton.map(enemiesJson[i]["startRoomPosition"].intValue))
                self.enemies.append(enemy)
            }
        } else {
            enemiesJson = JSON.nullJSON
        }
    }
    
    func updateEnemiesPosition(){
        for(var i = 0; i < enemies.count; i++){
            enemies[i].moveToAdjacentRoom()
        }
    }
  
    
}
