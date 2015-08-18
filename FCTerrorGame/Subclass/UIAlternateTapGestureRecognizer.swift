//
//  UIAlternateTapGestureRecognizer.swift
//  FCTerrorGame
//
//  Created by Adriano Soares on 17/08/15.
//  Copyright (c) 2015 Paulo Ricardo Ramos da Rosa. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass


@objc protocol UIAlternateTapGestureRecognizerDelegate: UIGestureRecognizerDelegate {
    optional func didTap(gesture: UIAlternateTapGestureRecognizer);
}

class UIAlternateTapGestureRecognizer: UIGestureRecognizer {
    var tapCount = 0;
    var numberOfTapsRequired = 1;
    var lastTouchPosition: CGPoint?
    
    override func touchesBegan(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        super.touchesBegan(touches, withEvent: event);

    }
    
    override func touchesMoved(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        super.touchesMoved(touches, withEvent: event);

    }

    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        super.touchesCancelled(touches, withEvent: event);
        reset();

    }
    
    override func touchesEnded(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        super.touchesEnded(touches, withEvent: event);
        tapCount++;
        /*if let delegate = self.delegate {
            if (delegate is UIAlternateTapGestureRecognizerDelegate) {
                (delegate as! UIAlternateTapGestureRecognizerDelegate).didTap!(self)
            }
        
        }*/
        if (tapCount == numberOfTapsRequired) {
            self.state = UIGestureRecognizerState.Ended;
            tapCount = 0;
        
        
        }
        
        
    }
    
    override func reset() {
        super.reset()
        tapCount = 0;
        
    }
}