//
//  CardModel.swift
//  Memorama
//
//  Created by Daniela Becerra Gonzalez on 17/12/19.
//  Copyright © 2019 Daniela Becerra Gonzalez. All rights reserved.
//

import Foundation

class CardModel {
    
    let MAX_CARDS:UInt32 = 13
    
    func getCards() -> [Card] {
        
        // Declare an array to store the generated cards
        var generatedCardsArray = [Card]()
        
        // Randomly generate pairs of cards
        for _ in 1...8 {
            // this function returns a number between 0-12
            // TODO: make 13 a constant of max Cards we have. no magic numbers!
            let randomNumber = arc4random_uniform(MAX_CARDS) + 1
            print("random number was \(randomNumber)")
            // First card object
            let cardOne = Card()
            cardOne.imageName = "card\(randomNumber)"
            generatedCardsArray.append(cardOne)
            // Second card object
            let cardTwo = Card()
            cardTwo.imageName = "card\(randomNumber)"
            generatedCardsArray.append(cardTwo)
            
            // TODO: verify the pairs or cards are unique (don't repeat the random number)
        }
        
        // TODO: Randomize the array
        // easier to test without randomizing
        
        // Return the array
        return generatedCardsArray
    }
    
}
