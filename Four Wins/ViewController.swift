//
//  ViewController.swift
//  Four Wins
//
//  Created by Peter Großmann on 19.03.16.
//  Copyright © 2016 Peter Großmann. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var currentPlayer: UIColor!
    let rows = 7
    let columns = 7
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hue: 0.1111, saturation: 0.25, brightness: 0.95, alpha: 1.0)
        self.currentPlayer = UIColor.redColor()
        
        self.createGameboard()
    }
    
    
    func createGameboard() {
        var width: CGFloat = 0
        if (self.view.frame.size.width < self.view.frame.size.height) {
            width = self.view.frame.size.width / CGFloat(self.rows + 2)
        } else {
            width = self.view.frame.size.height / CGFloat(self.columns + 2)
        }
        
        for (var x = 0; x < self.columns; ++x) {
            for (var y = 0; y < self.rows; ++y) {
                let margin: CGFloat = 10
                let field = UIView(frame: CGRectMake(CGFloat(x) * (width + margin) + margin,
                                                     CGFloat(y) * (width + margin) + margin,
                                                     width,
                                                     width))
                field.backgroundColor = UIColor.blueColor()
                self.view.addSubview(field)
                let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("toggleField:"))
                field.addGestureRecognizer(tapRecognizer)
            }
        }
    }

    
    func toggleField(recognizer:UITapGestureRecognizer) {
        let field = recognizer.view
        if (field?.backgroundColor != UIColor.blueColor()) {
            return
        }
        
        field?.backgroundColor = self.currentPlayer
        
        if (self.currentPlayer == UIColor.redColor()) {
            self.currentPlayer = UIColor.yellowColor()
        } else {
            self.currentPlayer = UIColor.redColor()
        }
    }

}

