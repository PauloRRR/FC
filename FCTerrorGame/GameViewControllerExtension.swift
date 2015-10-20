//
//  GameViewControllerExtension.swift
//  MadnessDaze
//
//  Created by Adriano Soares on 07/10/15.
//  Copyright © 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//

import UIKit
import SpriteKit

extension GameViewController {
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
        }
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}