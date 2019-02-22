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
    private(set) var cardsInDeck = [Card]()
    // List of cards in play
    private (set) var cardsInPlay = [Card?]()
    // List of selected cards
    private(set) var selectedCards = [Card]()
    // Bool detecting whether or not the selected cards form a set
    private(set) var selectedCardsAreASet: Bool?
    // Number keeping track of user's score
    private(set) var score: Int {
        didSet {
            if score < 0 {
                score = 0
            }
        }
    }
    
    private var scoreFactor: Int = 100
    
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
        
        // Initialize cardsInPlay with the first 12 cards of cardsInDeck
        cardsInPlay = Array(cardsInDeck[0..<12])
        cardsInDeck.removeSubrange(0..<12)
        
        score = 0
    }
    
    mutating func chooseCard(_ card: Card) {
        // If three cards are already selected
        if selectedCards.count == 3 {
            // If those selected cards form a set
            if selectedCardsAreASet! {
                // If the chosen card is one of the selected cards
                if selectedCards.contains(card) {
                    // Replace selected cards
                    replaceMatchedSet()
                } else {
                    // Replace selected cards and then select the new card
                    replaceMatchedSet()
                    selectedCards.append(card)
                }
            } else {
                // Clear selected cards
                selectedCards.removeAll()
                // Select or deselect chosen card
                toggleSelection(for: card)
            }
        } else {
            // Select or deselect chosen card
            toggleSelection(for: card)
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
            if selectedCardsAreASet! {
                score += scoreFactor
            } else {
                score -= 5
            }
        } else {
            selectedCardsAreASet = nil
        }
    }
    
    // Deals three more cards by moving them from cardsInDeck to cardsInPlay
    mutating func dealThreeMoreCards() {
        if selectedCardsAreASet ?? false {
            replaceMatchedSet()
        }
        
        // Decrease score factor if greater than 25
        if scoreFactor > 25 {
            scoreFactor -= 25
        }
        
        // Add three more cards into play
        if cardsInDeck.count != 0 {
            cardsInPlay.append(contentsOf: Array(cardsInDeck[0..<3]))
            cardsInDeck.removeSubrange(0..<3)
        }
    }
    
    // Selects card if it was deselected; deselects card if it was selected.
    private mutating func toggleSelection(for card: Card) {
        if let indexOfFoundCard = selectedCards.firstIndex(of: card) {
            selectedCards.remove(at: indexOfFoundCard)
        } else {
            selectedCards.append(card)
        }
    }
    
    // Replaces matched set cards with new cards from the deck.
    private mutating func replaceMatchedSet() {
        for selectedCard in selectedCards {
            let indexOfSelectedCard = cardsInPlay.firstIndex(of: selectedCard)!
            
            // Remove the selected card
            cardsInPlay.remove(at: indexOfSelectedCard)
            
            // If deck isn't empty
            if cardsInDeck.count != 0 {
                // Replace with a new card from deck
                let replacementCard = cardsInDeck.removeFirst()
                cardsInPlay.insert(replacementCard, at: indexOfSelectedCard)
            }
        }
        selectedCards.removeAll()
    }
}
