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
    var numberOfCardButtonsInPlay: Int = 12
    
    @IBOutlet weak var dealMoreCardsButton: UIButton!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    // Set game
    var game = SetGame()
    
    // Properties for cards
    let shapes: [NSAttributedString] = [NSAttributedString(string: "▲"), NSAttributedString(string: "●"), NSAttributedString(string: "■")]
    let colors = [#colorLiteral(red: 0.9108959436, green: 0.3638531566, blue: 0.3811461329, alpha: 1), #colorLiteral(red: 0.3175439835, green: 0.702655077, blue: 0.4420889616, alpha: 1), #colorLiteral(red: 0.4002629519, green: 0.342028439, blue: 0.6032297611, alpha: 1)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set visuals of every card button
        for button in cardButtons {
            setVisuals(of: button)
        }
        // Set visuals for other buttons in UI
        setVisuals(of: dealMoreCardsButton)
        setVisuals(of: newGameButton)
        
        updateUI()
    }
    
    // Sets visuals (corner radius and shadow) of a button.
    func setVisuals(of button: UIButton) {
        button.layer.cornerRadius = 8.0
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 6.0
        button.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
    }

    @IBAction func cardPressed(_ sender: UIButton) {
        let indexOfChosenCard = cardButtons.firstIndex(of: sender)!
        guard let chosenCard = game.cardsInPlay[indexOfChosenCard] else {
            fatalError("Chosen card is nil")
        }
        game.chooseCard(chosenCard)
        
        updateUI()
    }
    
    @IBAction func dealThreeMoreCardsPressed(_ sender: UIButton) {
        game.dealThreeMoreCards()
        // Unhide new card buttons
        numberOfCardButtonsInPlay += 3
        updateUI()
    }
    
    @IBAction func newGamePressed(_ sender: UIButton) {
        game = SetGame()
        numberOfCardButtonsInPlay = 12
        updateUI()
    }
    
    // Updates the UI to represent the card's properties and color the card borders when selected.
    func updateUI() {
        
        // Draw all visible card buttons using the properties from the model's cards
        for (index, cardButton) in cardButtons.enumerated() {
            // If the cardButton is in play
            if index < numberOfCardButtonsInPlay {
                cardButton.isHidden = false
                // If there is a card to show
                if let card = game.cardsInPlay[index] {
                    // Enable card button
                    cardButton.isEnabled = true
                    cardButton.backgroundColor = UIColor.white
                    // Update cardButton's properties based on properties of card
                    updateProperties(of: cardButton, from: card)
                } else {
                    // Create an empty space where the card button was by disabling it
                    disable(cardButton)
                }
            } else {
                // Disable and hide the card button from the UI
                disable(cardButton)
                cardButton.isHidden = true
            }
        }
        // Draw borders around cards that are selected
        updateBorders()
        
        // Disable Deal 3 More Cards button if no more room or deck is empty
        if numberOfCardButtonsInPlay == cardButtons.count || game.cardsInDeck.count == 0 {
            dealMoreCardsButton.isEnabled = false
        } else {
            dealMoreCardsButton.isEnabled = true
        }
        
        // Update score
        scoreLabel.text = "Score: \(game.score)"
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
                NSAttributedString.Key.foregroundColor: colors[card.color].withAlphaComponent(0.4),
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
        for card in cardButtons {
            card.layer.borderWidth = 0.0
        }
        for selectedCard in game.selectedCards {
            let indexFromGameCards = game.cardsInPlay.firstIndex(of: selectedCard)!
            let card = cardButtons[indexFromGameCards]
            card.layer.borderWidth = 4.0
            card.layer.borderColor = borderColor
        }
    }
}

