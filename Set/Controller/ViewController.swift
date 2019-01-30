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
    
    // List of selected card buttons
    var selectedCards = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set visuals of every card button
        for button in cardButtons {
            setVisuals(of: button)
        }
        // Set visuals for other buttons in UI
        setVisuals(of: dealMoreCardsButton)
        setVisuals(of: newGameButton)
    }
    
    // Sets visuals (corner radius and shadow) of a button.
    func setVisuals(of button: UIButton) {
        button.layer.cornerRadius = 8.0
        button.layer.shadowOpacity = 0.2
        button.layer.shadowRadius = 6.0
        button.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
    }

    @IBAction func cardPressed(_ sender: UIButton) {
        // Call some sort of select card method in the SetGame struct
        // game.selectCard(sender)
        
        if let foundCardIndex = selectedCards.firstIndex(of: sender) {
            selectedCards.remove(at: foundCardIndex)
        } else {
            selectedCards.append(sender)
        }
        
        updateUI()
    }
    
    func updateUI() {
        var color: CGColor
        if selectedCards.count < 3 {
            color = #colorLiteral(red: 0, green: 0.4392156863, blue: 0.9607843137, alpha: 1)
        } else if selectedCards.count > 3 {
            color = #colorLiteral(red: 0.9607843137, green: 0.1921568627, blue: 0.1490196078, alpha: 1)
        } else {
            color = #colorLiteral(red: 0.1176470588, green: 0.7647058824, blue: 0.2156862745, alpha: 1)
        }
        for card in cardButtons {
            card.layer.borderWidth = 0.0
        }
        for selectedCard in selectedCards {
            selectedCard.layer.borderWidth = 4.0
            selectedCard.layer.borderColor = color
        }
    }
}

