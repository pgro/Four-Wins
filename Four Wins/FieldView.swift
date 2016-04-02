//
//  FieldView.swift
//  Four Wins
//
//  Created by Peter Großmann on 24.03.16.
//  Copyright © 2016 Peter Großmann. All rights reserved.
//

import UIKit

class FieldView: UIView {
    convenience init() {
        self.init(frame: CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(self.contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    /** The view's actual color */
    var color = Color.neutral {
        didSet {
            self.reservedColor = color
            self.contentView.backgroundColor = color
        }
    }
    
    /** The view's future color. Means the field is already taken, but due to an animation 
      * it may not yet be colored that way. */
    var reservedColor = Color.neutral
    
    var isReserved: Bool {
        get {
            return reservedColor != Color.neutral
        }
    }
    
    override var frame: CGRect {
        didSet {
            contentView.frame.origin.x = uniformInset
            contentView.frame.origin.y = uniformInset
            contentView.frame.size.width = frame.size.width - uniformInset * 2
            contentView.frame.size.height = frame.size.height - uniformInset * 2
        }
    }
    
    private var uniformInset: CGFloat = 5;
    
    private let contentView = UIView()
}
