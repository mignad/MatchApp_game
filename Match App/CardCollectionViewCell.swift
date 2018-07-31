//
//  CardCollectionViewCell.swift
//  Match App
//
//  Created by Ioana Gadinceanu on 7/26/18.
//  Copyright © 2018 Apress. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
 
    
    @IBOutlet weak var frontImageView: UIImageView!

    @IBOutlet weak var backImageView: UIImageView!
    
    
    var card:Card?
    func setCard(_ card:Card) {
        
        //Keeps track of the card that gets passed in
        self.card = card
        
        if card.isMatched == true {
            
            // If the cards have been matched, then make the image views invisible
            backImageView.alpha = 0
            frontImageView.alpha = 0
            
            return
        }
        else {
            
            // If the cards haven't been matched, then make the image views visible
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
        
        
        frontImageView.image = UIImage(named: card.imageName)
        
        //Determine if the card is in a flipped up state of flipped down state
        if card.isFlipped == true {
        
            //Make sure the FrontImageView is on top
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }
        else {
           //Make sure the BackImageView is on top
            UIView.transition(from: frontImageView, to: backImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }
 }
    func flip() {
        
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
    }
    
    
    func flipBack() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            
             UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
            
        }

    }
    
    func remove() {
        // Remove both imagesViews from being visible
        backImageView.alpha = 0
    
        // Animated it
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            
           self.frontImageView.alpha = 0
            
        }, completion: nil)
        
        
   
        
        

        
    }
}
