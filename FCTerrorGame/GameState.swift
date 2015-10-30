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
        
        let state = NSUserDefaults.standardUserDefaults()
        if (debug || state.valueForKey("level") == nil) {
            print("🍻")
            defaultJson();
        
        }
        loadJson();
    
    }
    
    func loadJson() {
        let state = NSUserDefaults.standardUserDefaults()

        level     = state.integerForKey("level")
        room      = state.integerForKey("room")
        rotation  = state.integerForKey("rotation")

        items = state.objectForKey("items") as! [String]
        
    
    }
    
    func defaultJson () {
        let state = NSUserDefaults.standardUserDefaults()
        state.setInteger(1, forKey: "level")
        state.setInteger(0, forKey: "room")
        state.setInteger(1, forKey: "rotation")

        state.setObject([], forKey: "items");
        
        state.synchronize()
    
    }
    
    func updateState () {
        saveState();
    }
    
    func eraseJson(){
        level = 1
        room  = 0
        self.items.removeAll()
        rotation = 1
        
        saveState()
    }
    
    func saveState() {
        let state = NSUserDefaults.standardUserDefaults()
        state.setInteger(level, forKey: "level")
        state.setInteger(room, forKey: "room")
        state.setInteger(rotation, forKey: "rotation")
        state.setObject(items, forKey: "items");
        
        state.synchronize()

        
    }
    
    
    
    
}