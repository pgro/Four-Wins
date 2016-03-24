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
    var fields = Dictionary<FieldView, FieldLocation>()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentPlayer = Color.player1
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
        for x in 0...(self.columns - 1) {
            for y in 0...(self.rows - 1) {
                let field = FieldView()
                field.color = Color.neutral
                self.gameboardView.addSubview(field)
                let tapRecognizer = UITapGestureRecognizer(target: self,
                                                           action: #selector(ViewController.tryToFillField))
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
        
        for x in 0...(self.columns - 1) {
            for y in 0...(self.rows - 1) {
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

    
    //MARK: field manipulation
    
    /** Tries to fill a field in the tapped column (as low as possible).
      * Switches to next player if successful. */
    func tryToFillField(recognizer:UITapGestureRecognizer) {
        let location = self.getLocationForField(recognizer.view as? FieldView)!
        
        var y = self.rows - 1
        while y >= 0 {
            // find empty field in the tapped column
            let targetField = self.getFieldAt(location.column, row: y)!
            if !targetField.isReserved {
                self.insertFieldAnimatedly(targetField)
                
                if self.checkForGameEnd() {
                    self.playerLabel.text = "Winner:"
                    self.playerView.backgroundColor = self.currentPlayer
                    return
                }
                
                self.toggleActivePlayer()
                return
            }
            y -= 1
        }
    }

    func insertFieldAnimatedly(targetField: FieldView) {
        // store the player who triggered the animation
        let activePlayer = self.currentPlayer
        targetField.reservedColor = activePlayer
        
        let location = self.getLocationForField(targetField)!
        let topField = self.getFieldAt(location.column, row: 0)!
        // insert a dummy view (with the target color) at the top...
        let animatedField = FieldView(frame: topField.frame)
        animatedField.color = activePlayer
        self.gameboardView.addSubview(animatedField)
        
        // ...and animatedly move it to its final destination
        UIView.animateWithDuration(1.5, animations: {
            let destination = targetField.frame.origin.y - animatedField.frame.origin.y
            animatedField.transform = CGAffineTransformTranslate(animatedField.transform,
                0,
                destination)
            }, completion: { (completion) in
                animatedField.removeFromSuperview()
                targetField.color = activePlayer
        })
    }
    
    
    func getFieldAt(column:Int, row:Int) -> FieldView? {
        for entry in self.fields {
            if entry.1.column == column && entry.1.row == row {
                return entry.0
            }
        }
        
        return nil
    }
    
    func getLocationForField(field: FieldView?) -> FieldLocation? {
        for entry in self.fields {
            if entry.0 == field {
                return entry.1
            }
        }
        
        return nil
    }
    

    
    // MARK: game mechanics/rules
    
    func checkForGameEnd() -> Bool {
        /* This is a very naive check. Each field is checked in all
         * necessary directions whether the respective three neighbors
         * have the same color. */
        for x in 0...(self.columns - 1) {
            for y in 0...(self.rows - 1) {
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
        return self.getFieldAt(column, row:row)?.reservedColor == self.currentPlayer
    }
    
    
    @IBAction func startNewGame(sender: AnyObject) {
        for field in self.fields {
            field.0.color = Color.neutral
        }
        self.playerLabel.text = "Current Player:"
    }
    
    func toggleActivePlayer() {
        if (self.currentPlayer == Color.player1) {
            self.currentPlayer = Color.player2
        } else {
            self.currentPlayer = Color.player1
        }
        self.playerView.backgroundColor = self.currentPlayer
    }
}

