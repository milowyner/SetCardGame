//
//  ViewController.swift
//  Set
//
//  Created by Milo Wyner on 1/28/19.
//  Copyright © 2019 Milo Wyner. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // List of UIButtons representing tappable cards
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBOutlet weak var dealMoreCardsButton: UIButton!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
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
    }
}

