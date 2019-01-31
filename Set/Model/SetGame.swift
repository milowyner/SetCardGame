//
//  SetGame.swift
//  Set
//
//  Created by Milo Wyner on 1/30/19.
//  Copyright © 2019 Milo Wyner. All rights reserved.
//

import Foundation

struct SetGame {
    // List of all card in the deck
    private let cardsInDeck: [Card]
    // List of cards in play
    private(set) var cardsInPlay = [Card]()
    // List of selected cards
    private(set) var selectedCards = [Card]()
    
    private(set) var selectedCardsAreASet: Bool?
    
    init() {
        // Initialize cardsInDeck using a temporary array
        var temporaryArrayOfCards = [Card]()
        for index in 0..<81 {
            let card = Card(shape: index % 3,
                            color: (index / 3) % 3,
                            shading: (index / (3 * 3)) % 3,
                            number: (index / (3 * 3 * 3)) % 3)
            temporaryArrayOfCards.append(card)
        }
        cardsInDeck = temporaryArrayOfCards
        
        // Initialize cardsInPlay to be the first 12 cards of cardsInDeck
        cardsInPlay = Array(cardsInDeck[0..<12])
    }
    
    mutating func chooseCard(_ card: Card) {
        if selectedCards.count == 3 {
            //remove the three cards from selected cards list
            selectedCards.removeAll()
        }
        
        // Select or deselect card
        if let indexOfFoundCard = selectedCards.firstIndex(of: card) {
            selectedCards.remove(at: indexOfFoundCard)
        } else {
            selectedCards.append(card)
        }
        
        if selectedCards.count == 3 {
            selectedCardsAreASet = true
        } else {
            selectedCardsAreASet = nil
        }
        
        print(selectedCards)
    }
}
