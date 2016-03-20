//
//  ViewController.swift
//  Four Wins
//
//  Created by Peter Großmann on 19.03.16.
//  Copyright © 2016 Peter Großmann. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var gameboardView: UIView!
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.layoutGameboard()
    }
    

    func createGameboard() {
        for (var x = 0; x < self.columns; ++x) {
            for (var y = 0; y < self.rows; ++y) {
                let field = UIView()
                field.backgroundColor = UIColor.blueColor()
                self.gameboardView.addSubview(field)
                let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("didTapField:"))
                field.addGestureRecognizer(tapRecognizer)
                
                self.fields[field] = FieldLocation(row: y, column: x)
            }
        }
    }
    
    func layoutGameboard() {
        let margin: CGFloat = 10
        var width: CGFloat = 0
        if (UIScreen.mainScreen().bounds.size.width < UIScreen.mainScreen().bounds.size.height) {
            width = self.gameboardView.frame.size.width / CGFloat(self.rows)
        } else {
            width = self.gameboardView.frame.size.height / CGFloat(self.columns)
        }
        
        for (var x = 0; x < self.columns; ++x) {
            for (var y = 0; y < self.rows; ++y) {
                let field = self.getFieldAt(x, row: y)!
                /* Fields need to be shifted by "margin / 2" so that 
                 * they are centered in the gameboard */
                field.frame = CGRectMake(CGFloat(x) * width + margin / 2,
                                         CGFloat(y) * width + margin / 2,
                                         width - margin,
                                         width - margin)
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

