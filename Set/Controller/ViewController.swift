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
    @IBOutlet var cardButtonsInPlay: [UIButton]!
    
    @IBOutlet weak var dealMoreCardsButton: UIButton!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    // Set game
    var game = SetGame()
    
    // Properties for cards
    let shapes = ["▲", "●", "■"]
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
        // Call some sort of choose card method in the SetGame struct
        // game.chooseCard(sender)
        let indexOfChosenCard = cardButtons.firstIndex(of: sender)!
        let chosenCard = game.cardsInPlay[indexOfChosenCard]
        game.chooseCard(chosenCard)
        
        updateUI()
    }
    
    func updateUI() {
        let color: CGColor
        if let cardsAreASet = game.selectedCardsAreASet {
            if cardsAreASet {
                color = #colorLiteral(red: 0.1176470588, green: 0.7647058824, blue: 0.2156862745, alpha: 1)
            } else {
                color = #colorLiteral(red: 0.9607843137, green: 0.1921568627, blue: 0.1490196078, alpha: 1)
            }
        } else {
            color = #colorLiteral(red: 0, green: 0.4392156863, blue: 0.9607843137, alpha: 1)
        }
        
        for card in cardButtons {
            card.layer.borderWidth = 0.0
        }
        for selectedCard in game.selectedCards {
            let indexFromGameCards = game.cardsInPlay.firstIndex(of: selectedCard)!
            let card = cardButtons[indexFromGameCards]
            card.layer.borderWidth = 4.0
            card.layer.borderColor = color
        }
        
        for (index, cardButton) in cardButtonsInPlay.enumerated() {
            let card = game.cardsInPlay[index]
            cardButton.setTitle(shapes[card.shape], for: .normal)
            cardButton.tintColor = colors[card.color]
            cardButton.setTitle(String(repeating: cardButton.currentTitle!, count: card.number + 1), for: .normal)
        }
    }
}

