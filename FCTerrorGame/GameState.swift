//
//  GameState.swift
//  FCTeste
//
//  Created by Adriano Soares on 04/08/15.
//  Copyright (c) 2015 bepid. All rights reserved.
//

import Foundation

class GameState {
    static let sharedInstance = GameState()
    
    var level = 1
    var room = 0
    var json = JSON.nullJSON
    
    
    var items = [String]()
    
    
    init () {
        
        let documentDirectoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as! NSURL
        let fileDestinationUrl = documentDirectoryURL.URLByAppendingPathComponent("gameState.json")
        if let data = String(contentsOfURL: fileDestinationUrl, encoding: NSUTF8StringEncoding, error: nil) {
            json = JSON(data: data.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
            if (json == JSON.nullJSON) {
                defaultJson();
            } else {
                loadJson();
            }
        } else {
           defaultJson();
        }
    
    
    }
    
    func loadJson() {
        level = json["level"].intValue
        room  = json["room"].intValue
        items = json["items"].arrayObject as! [String]
    
    }
    
    func defaultJson () {
        json = JSON([
            "level": level,
            "room" : room,
            "items": items
            ])
        saveState();
    
    }
    
    func updateState () {
    
        saveState();
    }
    
    func saveState() {
        
        let documentDirectoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as! NSURL
        let fileDestinationUrl = documentDirectoryURL.URLByAppendingPathComponent("gameState.json")
        var state = json.description
        state.writeToURL(fileDestinationUrl, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
    }
    
    
}