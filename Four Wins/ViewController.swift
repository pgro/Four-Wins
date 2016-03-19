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
    var fields = Dictionary<UIView, FieldLocation>()
    

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
                let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("didTapField:"))
                field.addGestureRecognizer(tapRecognizer)
                
                self.fields[field] = FieldLocation(row: y, column: x)
            }
        }
    }

    
    func didTapField(recognizer:UITapGestureRecognizer) {
        let location = self.getLocationForField(recognizer.view)!
        
        for var y = self.rows - 1; y >= 0; --y {
            // find empty field in the tapped column
            let field = self.getFieldAt(location.column, row: y)!
            let isEmpty = field.backgroundColor == UIColor.blueColor()
            if isEmpty {
                // fill found field for current player
                field.backgroundColor = self.currentPlayer
                
                // prepare for next player
                if (self.currentPlayer == UIColor.redColor()) {
                    self.currentPlayer = UIColor.yellowColor()
                } else {
                    self.currentPlayer = UIColor.redColor()
                }
                
                return
            }
        }
    }

    
    func getFieldAt(column:Int, row:Int) -> UIView? {
        for entry in self.fields {
            if entry.1.column == column && entry.1.row == row {
                return entry.0
            }
        }
        
        return nil
    }
    
    func getLocationForField(field: UIView?) -> FieldLocation? {
        for entry in self.fields {
            if entry.0 == field {
                return entry.1
            }
        }
        
        return nil
    }
}

