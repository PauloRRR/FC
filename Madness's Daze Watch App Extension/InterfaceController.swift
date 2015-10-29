//
//  InterfaceController.swift
//  Madness's Daze Watch App Extension
//
//  Created by Tainara Specht on 9/29/15.
//  Copyright © 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
    
    @IBOutlet var labelInfo: WKInterfaceLabel!
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        let language = NSLocale.preferredLanguages()[0]
        if(language == "pt-BR"){
            labelInfo.setText("Jogue agora e desvende as loucuras de Madness's Daze!")
        }
        else{
            labelInfo.setText("Play now and uncover the insanities of Madness's Daze!")
        }
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
}
