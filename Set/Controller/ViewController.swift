//
//  ViewController.swift
//  Set
//
//  Created by Milo Wyner on 1/28/19.
//  Copyright © 2019 Milo Wyner. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // List of card buttons in UI
    @IBOutlet var cardButtons: [UIButton]!

    @IBOutlet weak var dealMoreCardsButton: UIButton!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var verticalStackView: UIStackView!
    
    // Set game
    var game = SetGame()
    
    // Number of columns; updates every time updateUI() is called
    var numberOfColumns = 0
    
    // Number of rows; updates every time updateUI() is called
    var numberOfRows = 0
    
    // Aspect ratio of verticalStackView; updates every time viewDidLayoutSubviews is called
    var aspectRatio: Double = 0.0
    
    
    // Properties for cards
    let shapes: [NSAttributedString] = [NSAttributedString(string: "▲"), NSAttributedString(string: "●"), NSAttributedString(string: "■")]
    let colors = [#colorLiteral(red: 0.9108959436, green: 0.2550508642, blue: 0.2757832707, alpha: 1), #colorLiteral(red: 0.2178230739, green: 0.702655077, blue: 0.3746178072, alpha: 1), #colorLiteral(red: 0.3219855036, green: 0.2412919044, blue: 0.6032297611, alpha: 1)]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set visuals for other buttons in UI
        setVisuals(of: dealMoreCardsButton)
        setVisuals(of: newGameButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateUI()
    }
    
    override func viewDidLayoutSubviews() {
        aspectRatio = Double(verticalStackView.frame.width) / Double(verticalStackView.frame.height)
    }
    
//    @IBAction func cardPressed(_ sender: UIButton) {
//        let indexOfChosenCard = cardButtons.firstIndex(of: sender)!
//        guard let chosenCard = game.cardsInPlay[indexOfChosenCard] else {
//            fatalError("Chosen card is nil")
//        }
//        game.chooseCard(chosenCard)
//
//        updateUI()
//    }
    
    @IBAction func dealThreeMoreCardsPressed(_ sender: UIButton) {
        game.dealThreeMoreCards()
        updateUI()
    }
    
    //
    // TODO: Re-implement new game button
    //
    @IBAction func newGamePressed(_ sender: UIButton) {
        game.cardsInPlay.removeLast(3)
        updateUI()
    }
    
    // Updates UI elements and dynamically draws cards on screen.
    func updateUI() {
        // Set number of columns and rows based on the aspect ratio of the card container
        numberOfColumns = Int((Double(game.cardsInPlay.count) * aspectRatio * 0.95).squareRoot().rounded(.down))
        numberOfRows = Int((Double(game.cardsInPlay.count) / Double(numberOfColumns)).rounded(.up))
        
        // Set spacing between cells based on card cell height
        let cellHeight = Double(verticalStackView.bounds.height) / Double(numberOfRows)
        let spacing = CGFloat(cellHeight * 0.14)
        verticalStackView.spacing = spacing
        
        // Remove all card views
        for subview in verticalStackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
        
        // Add card views based on number of cards in play
        for row in 1...numberOfRows {
            // Create row horizontal stack view
            let horizontalStackView = UIStackView()
            verticalStackView.addArrangedSubview(horizontalStackView)
            
            // Set stack positioning properties
            horizontalStackView.axis = .horizontal
            horizontalStackView.alignment = .fill
            horizontalStackView.distribution = .fillEqually
            horizontalStackView.spacing = spacing
            
            // Number of cards in the row
            var cardsInRow = numberOfColumns
            // Number of empty spaces in row; used when number of cards doesn't fill row
            var emptySpacesInRow = 0
            
            // If it's the last row and the cards don't fill the last row
            if row == numberOfRows && game.cardsInPlay.count < numberOfRows * numberOfColumns {
                // Set number of empty spaces to the difference between possible card spaces and cards in play
                emptySpacesInRow = numberOfRows * numberOfColumns - game.cardsInPlay.count
                // Set number of cards in row to the remainder
                cardsInRow = numberOfColumns - emptySpacesInRow
            }
            
            // Fill row with card views
            for _ in 0..<cardsInRow {
                let cardView = SetCardView()
                horizontalStackView.addArrangedSubview(cardView)
            }
            
            // Fill rest of row with empty spaces (if there are any)
            for _ in 0..<emptySpacesInRow {
                let emptyView = UIView()
                horizontalStackView.addArrangedSubview(emptyView)
            }
            
//            if row == numberOfRows && game.cardsInPlay.count < numberOfRows * numberOfColumns {
//                for _ in cardsInRow..<numberOfColumns {
//                    let emptyView = UIView()
//                    horizontalStackView.addArrangedSubview(emptyView)
//                }
//            }
            
        }
        
//        // Draw borders around cards that are selected
//        updateBorders()
        
        // Update number of cards left in deck
        dealMoreCardsButton.setTitle("Deck: \(game.cardsInPlay.count)", for: .normal)
        
//        // Disable Deal 3 More Cards button if no more room or deck is empty
//        if numberOfCardButtonsInPlay == cardButtons.count || game.cardsInDeck.count == 0 {
//            dealMoreCardsButton.isEnabled = false
//        } else {
//            dealMoreCardsButton.isEnabled = true
//        }
        
        // Update score
//        scoreLabel.text = "Score: \(game.score)"
    }
    
    // Disables cardButton by clearing title and background and setting isEnabled to false.
    func disable(_ cardButton: UIButton) {
        cardButton.setAttributedTitle(nil, for: .normal)
        cardButton.backgroundColor = nil
        cardButton.isEnabled = false
    }
    
    // Updates cardButton based on the four properties (shape, color, shading, and number) of card.
    func updateProperties(of cardButton: UIButton, from card: Card) {
        // Assign color to the card
        cardButton.tintColor = colors[card.color]
        
        // Set the shape and repeat it based on number property
        let repeatedShapes = String(repeating: shapes[card.shape].string, count: card.number + 1)
        
        // Set the shading attributes
        var shadingAttributes: [NSAttributedString.Key: Any]
        switch card.shading {
        case 0: // Solid
            shadingAttributes = [:]
        case 1: // "Striped" (actually just slightly opaque)
            shadingAttributes = [
                NSAttributedString.Key.foregroundColor: colors[card.color].withAlphaComponent(0.25),
                NSAttributedString.Key.strokeColor: colors[card.color],
                NSAttributedString.Key.strokeWidth: -6.0
            ]
        case 2: // Outlined
            shadingAttributes = [NSAttributedString.Key.strokeWidth: 6.0]
        default:
            fatalError("There should only be 3 different shading options")
        }
        
        // Set the card button's title using the repeated shapes string and shading attributes
        let newAttributedTitle = NSAttributedString(string: repeatedShapes, attributes: shadingAttributes)
        cardButton.setAttributedTitle(newAttributedTitle, for: .normal)
        
    }
    
    // Sets the color of the selected card borders.
    func updateBorders() {
        // Set borderColor based on if selcted cards form a set
        let borderColor: CGColor
        if let cardsAreASet = game.selectedCardsAreASet {
            if cardsAreASet {
                borderColor = #colorLiteral(red: 0.1176470588, green: 0.7647058824, blue: 0.2156862745, alpha: 1)
            } else {
                borderColor = #colorLiteral(red: 0.9607843137, green: 0.1921568627, blue: 0.1490196078, alpha: 1)
            }
        } else {
            borderColor = #colorLiteral(red: 0, green: 0.4392156863, blue: 0.9607843137, alpha: 1)
        }
        // Clear all borders
        for card in cardButtons {
            card.layer.borderWidth = 0.0
        }
        // Draw borders for selected cards based on borderColor
        for selectedCard in game.selectedCards {
            let indexFromGameCards = game.cardsInPlay.firstIndex(of: selectedCard)!
            let card = cardButtons[indexFromGameCards]
            card.layer.borderWidth = 4.0
            card.layer.borderColor = borderColor
        }
    }
    
    // Sets visuals (corner radius and shadow) of a button.
    func setVisuals(of button: UIButton) {
        button.layer.cornerRadius = 8.0
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 6.0
        button.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
    }

}

