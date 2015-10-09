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
    var rotation = 1
    var json = JSON.nullJSON
    var debug = false;
    var godMode = false;
    
    var playerHidden = false;
    
    var actions = ["swipeLeft", "swipeUp","swipeRight", "swipeDown"]
    
    
    
    var items = [String]()
    
    
    init () {
        
        let documentDirectoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! 
        let fileDestinationUrl = documentDirectoryURL.URLByAppendingPathComponent("gameState.json")
        if let data = try? String(contentsOfURL: fileDestinationUrl, encoding: NSUTF8StringEncoding) {
            json = JSON(data: data.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
            if (json == JSON.nullJSON || debug) {
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
        json = JSON([
            "level": level,
            "room" : room,
            "items": items
        ])
        saveState();
    }
    
    func eraseJson(){
        level = 1
        room  = 0
        self.items.removeAll()
        rotation = 1
        
        
        
        json = JSON([
            "level": level,
            "room": room,
            "items": items
        ])
        
        saveState()
    }
    
    func saveState() {
        
        let documentDirectoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! 
        let fileDestinationUrl = documentDirectoryURL.URLByAppendingPathComponent("gameState.json")
        let state = json.description
        do {
            try state.writeToURL(fileDestinationUrl, atomically: true, encoding: NSUTF8StringEncoding)
        } catch _ {
        }
    }
    
    
    
    
}