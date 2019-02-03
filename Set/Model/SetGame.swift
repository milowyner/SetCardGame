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
    private var cardsInDeck = [Card]()
    // List of cards in play
    private(set) var cardsInPlay = [Card]()
    // List of selected cards
    private(set) var selectedCards = [Card]()
    
    private(set) var selectedCardsAreASet: Bool?
    
    init() {
        // Initialize cardsInDeck to contain cards of every possible combination of properties
        for index in 0..<81 {
            let card = Card(shape: index % 3,
                            color: (index / 3) % 3,
                            shading: (index / (3 * 3)) % 3,
                            number: (index / (3 * 3 * 3)) % 3)
            cardsInDeck.append(card)
        }
        cardsInDeck.shuffle()
        
        // Initialize cardsInPlay to be the first 12 cards of cardsInDeck
        cardsInPlay = Array(cardsInDeck[0..<12])
        cardsInDeck.removeSubrange(0..<12)
    }
    
    mutating func chooseCard(_ card: Card) {
        if selectedCards.count == 3 {
            
            if selectedCardsAreASet ?? false {
                for selectedCard in selectedCards {
                    let indexOfSelectedCard = cardsInPlay.firstIndex(of: selectedCard)!
                    let replacementCard = cardsInDeck.removeFirst()
                    
                    cardsInPlay.remove(at: indexOfSelectedCard)
                    cardsInPlay.insert(replacementCard, at: indexOfSelectedCard)
                }
            }
            
            // Remove the three cards from selected cards list
            selectedCards.removeAll()
        }
        
        // Select or deselect card
        if let indexOfFoundCard = selectedCards.firstIndex(of: card) {
            selectedCards.remove(at: indexOfFoundCard)
        } else {
            selectedCards.append(card)
        }
        
        // Check to see if cards form a set
        if selectedCards.count == 3 {
            
            // TODO: Make this code a lot cleaner
            // Possibly by having some function like isASet(array:property:) that takes an array and a property as
            // arguments and returns true if the property of the elements in the array form a set
            
            // Create a swift set for each property
            let setOfShapes = Set([selectedCards[0].shape, selectedCards[1].shape, selectedCards[2].shape])
            let setOfColors = Set([selectedCards[0].color, selectedCards[1].color, selectedCards[2].color])
            let setOfShadings = Set([selectedCards[0].shading, selectedCards[1].shading, selectedCards[2].shading])
            let setOfNumbers = Set([selectedCards[0].number, selectedCards[1].number, selectedCards[2].number])
            
            // Check to see if each property forms a set
            let shapesAreASet = setOfShapes.count == 1 || setOfShapes.count == 3
            let colorsAreASet = setOfColors.count == 1 || setOfColors.count == 3
            let shadingsAreASet = setOfShadings.count == 1 || setOfShadings.count == 3
            let numbersAreASet = setOfNumbers.count == 1 || setOfNumbers.count == 3
            
            // Check to see if all properties form sets (meaning the cards form a set)
            selectedCardsAreASet = shapesAreASet && colorsAreASet && shadingsAreASet && numbersAreASet
        } else {
            selectedCardsAreASet = nil
        }
    }
}
