//
//  CardModel.swift
//  Match App
//
//  Created by Ioana Gadinceanu on 7/26/18.
//  Copyright © 2018 Apress. All rights reserved.
//

import Foundation
class CardModel {
    
    func getCards() -> [Card] {
        
        // Declare an array to store the numbers already generated
        
        var generatedNumbersArray = [Int]()
        
        //Declare an array to store the genereated cards
        var generatedCardsArray = [Card]()
        
        //Randomly generate pairs of cards
        while generatedNumbersArray.count < 8 {
            
            // Get a random number
           let randomNumber = arc4random_uniform(13) + 1
            
            
            // Ensure that the random number isn't one that we already have
            if generatedNumbersArray.contains(Int(randomNumber)) == false {
                
                // Log the number
                print(randomNumber)
                
                // Store the number into the generated numbers array
                generatedNumbersArray.append(Int(randomNumber))
                
                
                // Create a first card object
                let cardOne = Card()
                cardOne.imageName = "card\(randomNumber)"
                
                generatedCardsArray.append(cardOne)
                
                
                // Create a second card object
                let cardTwo = Card()
                cardTwo.imageName = "card\(randomNumber)"
                
                generatedCardsArray.append(cardTwo)
            }
            
           
        }
        //  Randomize  the array
        for i in 0...generatedCardsArray.count - 1 {
            
            // Find a random index to swap with
        let randomNumber = Int(arc4random_uniform(UInt32(generatedCardsArray.count)))
        
            // Swap the two cards
        let temporaryStorage = generatedCardsArray[i]
        generatedCardsArray[i] = generatedCardsArray[randomNumber]
        generatedCardsArray[randomNumber] = temporaryStorage
        
        }
        
        
        // Return the array
        return generatedCardsArray
        
    }
    
}
