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
        
        
        
        cardArray =  model.getCards()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
      
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
        
        
       let seconds = String(format: "%.2f", milliseconds/1000)
        
        
        timerLabel.text = "Time remaining: \(seconds)"
        
        
        if milliseconds <= 0 {
            
           
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
           
            checkGameEnded()
        }
    }
    
    // MARK:  UICollectionView Protocol Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        
        let card = cardArray[indexPath.row]
        
        
       
        cell.setCard(card)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if milliseconds <= 0 {
            return
        }
        
        
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
      
        let card  = cardArray[indexPath.row]
        
        if card.isFlipped == false  && card.isMatched == false {
            
            
            cell.flip()
            
          
            SoundManager.playSound(.flip)
            
            
            card.isFlipped = true
            
           
            if firstFlippedCardIndex == nil {
                
               
                firstFlippedCardIndex = indexPath
            }
            else {
                
                                checkForMatches(indexPath)
            }
            
        }
        
        
    }
    
    
    // MARK: Game logic Methods
    
    func checkForMatches(_ secondFlippedCardIndex: IndexPath) {
       
        
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
       
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        
        
        if cardOne.imageName == cardTwo.imageName {
            
            
            SoundManager.playSound(.match)
            
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
           
            checkGameEnded()
            
        }
        else {
            
            
            SoundManager.playSound(.nomatch)
    
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
           
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
            
        }
        
       
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        
        
        firstFlippedCardIndex = nil
        
       
        
    }
    
    func checkGameEnded() {
        
       
        var isWon = true
        
        for card in cardArray {
            
            if card.isMatched == false {
                isWon = false
                break
            }
        }
        
    
        
        var title = ""
        var message = ""
        
        
        
        
        if isWon == true {
            
            if milliseconds > 0 {
                timer?.invalidate()
            }
            
            title = "Congratulations!"
            message = "You've won!"
        }
        else {
            
            
            if milliseconds > 0 {
                return
            }
            
            title = "Game over"
            message = " You've lost"
        }
    
      
        showAlert(title, message)
        
    }
    
    func showAlert(_ title:String, _ message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: .default,handler:nil)
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
        
    }
    
} 









