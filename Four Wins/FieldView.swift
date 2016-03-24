//
//  FieldView.swift
//  Four Wins
//
//  Created by Peter Großmann on 24.03.16.
//  Copyright © 2016 Peter Großmann. All rights reserved.
//

import UIKit

class FieldView: UIView {
    /** The view's actual color */
    var color = Color.neutral {
        didSet {
            self.reservedColor = color
            self.backgroundColor = color
        }
    }
    
    /** The view's future color. Means the field is already taken, but due to an animation 
      * it is not yet colored that way. */
    var reservedColor = Color.neutral
    
    var isReserved: Bool {
        get {
            return reservedColor != Color.neutral
        }
    }

}
