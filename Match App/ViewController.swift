//
//  ViewController.swift
//  Match App
//
//  Created by Ioana Gadinceanu on 7/23/18.
//  Copyright © 2018 Apress. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timerLabel: UILabel!
    
    
    var model = CardModel()
    var cardArray = [Card]()
    
    var firstFlippedCardIndex: IndexPath?
    
    var timer: Timer?
    var milliseconds:Float = 30 * 1000 //10 sec
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Call the getCards Method for the card model
        cardArray =  model.getCards()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Create timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .commonModes)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //soundManager.playSound(.shuffle)
        SoundManager.playSound(.shuffle)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Timer Methods
    
    @objc func timerElapsed() {
        
        milliseconds -= 1
        
        // Convert to seconds
       let seconds = String(format: "%.2f", milliseconds/1000)
        
        // Set label
        timerLabel.text = "Time remaining: \(seconds)"
        
        // When the timer has reached zero
        if milliseconds <= 0 {
            
            // Stop the timer
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            // Check if there are any cards unmatched
            checkGameEnded()
        }
    }
    
    // MARK:  UICollectionView Protocol Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Get an CardCollectionViewCell object
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        //Get the card that the collection view is trying to display
        let card = cardArray[indexPath.row]
        
        
        //Set that card for the cell
        cell.setCard(card)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Check if there's any time left (stop the user selecting any cards if the time is up!)
        if milliseconds <= 0 {
            return
        }
        
        // Get the cell that the user selected
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        // Get the card that the user selected
        let card  = cardArray[indexPath.row]
        
        if card.isFlipped == false  && card.isMatched == false {
            
            // Flip the card
            cell.flip()
            
            // Play the flip sound
            SoundManager.playSound(.flip)
            
            // Set the status of the card
            card.isFlipped = true
            
            // Determine if it's the first card or second card that's flipped over
            if firstFlippedCardIndex == nil {
                
                // This is the FIRST Card being flipped
                firstFlippedCardIndex = indexPath
            }
            else {
                
                // This is the SECOND Card that is being flipped
                
                // Perform the MATCHING LOGIC
                checkForMatches(indexPath)
            }
            
        }
        
        
    } // End of the didSelectItemAt method
    
    
    // MARK: Game logic Methods
    
    func checkForMatches(_ secondFlippedCardIndex: IndexPath) {
        // We are calling this function only fot the secondFlippedCard that is matching, that means, that the firstFlippedCrad contains the indexPath and not nil
        
        // Get the CELLS for the two cards that were revealed
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // get the CARDS  for the two cards that were revealed
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        //Compare the two cards
        
        if cardOne.imageName == cardTwo.imageName {
            
            // It's a match
            
            // Play music
            SoundManager.playSound(.match)
            
            
            // Set the statuses of the cards
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            // Remove the cars from the grid
            cardOneCell?.remove()
            cardTwoCell?.remove()
            //Optinal chaining -if cardOneCell is nil it is not going to call this method
            
            // Check if are any cards unmatched
            checkGameEnded()
            
        }
        else {
            
            // It's not a match
            
            // Play music
            SoundManager.playSound(.nomatch)
    
            
            // Set the statuses of the cards
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // Flip the both cards back
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
            
        }
        
        // Tell the collectionView to reload the cell of the first card if it is nil
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        
        // Reset the property that tracks the first card flipped
        firstFlippedCardIndex = nil
        
        //If it's not a match we have to reset the cards so that the user can flip again another pair
        
    }
    
    func checkGameEnded() {
        
        // Determine if there are any cards unmatched
        
        var isWon = true
        
        for card in cardArray {
            
            if card.isMatched == false {
                isWon = false
                break
            }
        }
        
        //Messaging variables
        
        var title = ""
        var message = ""
        
        
        // If not, the user has Won, STOP the timer
        
        if isWon == true {
            
            if milliseconds > 0 {
                timer?.invalidate()
            }
            
            title = "Congratulations!"
            message = "You've won!"
        }
        else {
            
             // If there are unmatched cards, check if there's any time left
            
            if milliseconds > 0 {
                return
            }
            
            title = "Game over"
            message = " You've lost"
        }
    
        // Show Won or Lost status
        showAlert(title, message)
        
    }
    
    func showAlert(_ title:String, _ message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: .default,handler:nil)
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
        
    }
    
} // End View Controller Class









