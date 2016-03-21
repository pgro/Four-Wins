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
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var playerLabel: UILabel!
    
    var currentPlayer: UIColor!
    let rows = 7
    let columns = 7
    var fields = Dictionary<UIView, FieldLocation>()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentPlayer = UIColor.redColor()
        self.playerView.backgroundColor = self.currentPlayer
        
        self.gameboardView.backgroundColor = UIColor.clearColor()
        self.createGameboard()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.view.layoutIfNeeded()
        self.layoutGameboard()
    }
    
    
    // MARK: gameboard

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
        var leftOver = CGPoint()
        let boardSize = self.gameboardView.frame.size
        if (boardSize.width < boardSize.height) {
            width = boardSize.width / CGFloat(self.rows)
            leftOver.y = boardSize.height - boardSize.width
        } else {
            width = boardSize.height / CGFloat(self.columns)
            leftOver.x = boardSize.width - boardSize.height
        }
        
        for (var x = 0; x < self.columns; ++x) {
            for (var y = 0; y < self.rows; ++y) {
                let field = self.getFieldAt(x, row: y)!
                /* Fields need to be shifted so that they are centered in the gameboard:
                 * * by "margin / 2" to respect the margin before the first and after the last field
                 * * by "leftover" to respect the board's height/width difference */
                field.frame.origin.x = CGFloat(x) * width + margin / 2 + leftOver.x / 2
                field.frame.origin.y = CGFloat(y) * width + margin / 2 + leftOver.y / 2
                field.frame.size.width  = width - margin
                field.frame.size.height = width - margin
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
                
                if self.checkForGameEnd() {
                    self.playerLabel.text = "Winner:"
                    self.playerView.backgroundColor = self.currentPlayer
                    return
                }
                
                // prepare for next player
                if (self.currentPlayer == UIColor.redColor()) {
                    self.currentPlayer = UIColor.yellowColor()
                } else {
                    self.currentPlayer = UIColor.redColor()
                }
                self.playerView.backgroundColor = self.currentPlayer
                
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
    

    
    // MARK: game end check
    
    func checkForGameEnd() -> Bool {
        /* This is a very naive check. Each field is checked in all
         * necessary directions whether the respective three neighbors
         * have the same color. */
        for (var x = 0; x < self.columns; ++x) {
            for (var y = 0; y < self.rows; ++y) {
                var northEast = self.isMatching(x, row: y)
                northEast = northEast && self.isMatching(x + 1, row: y - 1)
                northEast = northEast && self.isMatching(x + 2, row: y - 2)
                northEast = northEast && self.isMatching(x + 3, row: y - 3)
                
                var east = self.isMatching(x, row: y)
                east = east && self.isMatching(x + 1, row: y)
                east = east && self.isMatching(x + 2, row: y)
                east = east && self.isMatching(x + 3, row: y)
                
                var southEast = self.isMatching(x, row: y)
                southEast = southEast && self.isMatching(x + 1, row: y + 1)
                southEast = southEast && self.isMatching(x + 2, row: y + 2)
                southEast = southEast && self.isMatching(x + 3, row: y + 3)
                
                var south = self.isMatching(x, row: y)
                south = south && self.isMatching(x, row: y + 1)
                south = south && self.isMatching(x, row: y + 2)
                south = south && self.isMatching(x, row: y + 3)
                
                if northEast || east || southEast || south {
                    return true
                }
            }
        }
        
        return false
    }
    
    func isMatching(column:Int, row:Int) -> Bool {
        return self.getFieldAt(column, row:row)?.backgroundColor == self.currentPlayer
    }
}

